import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/tizen_styles.dart';

enum BorderPhase { idle, busy, slowing, cont }

class RainbowBorderPainter extends CustomPainter {
  final double progress;
  final double borderRadius;
  final double strokeWidth;
  final bool isProcessing;
  final double glowOpacity;
  final BorderPhase borderPhase;
  final double burstAngle;         // pre-computed start angle (radians) for slowing/cont
  final double burstOpacity;       // 1.0→0.5 during slowing, 0.5 during cont
  final double bloomWaveProgress;  // 0→1 per 9s orbit cycle
  final double bloomBreathOpacity; // 0.82→1.0 breathing

  static const Color _cyanAccent = Color(0xFF6FD0FF);
  static const Color _purpleAccent = Color(0xFFB06BFF);
  static const Color _glowCyan = Color(0xFF6FD0FF);
  static const Color _glowPurple = Color(0xFF8A5BFF);

  static const List<Color> _idleColors = [
    Color(0xFF22D3EE), Color(0xFF38BDF8), Color(0xFF2563EB),
    Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA78BFA),
    Color(0xFF6366F1), Color(0xFF2563EB), Color(0xFF22D3EE),
  ];

  // Irregular rainbow bands: cyan 0-34°, gap, purple 92-120°, gap, mint 168-196°,
  // gap, violet 254-286°, gap, cyan 344-360° — from design_02.html burstEdgeOn()
  static const List<Color> _burstColors = [
    Color(0xFF6FD0FF), Color(0xFF6FD0FF),
    Color(0x006FD0FF), Color(0x006FD0FF),
    Color(0xFF8A5BFF), Color(0xFF8A5BFF),
    Color(0x008A5BFF), Color(0x008A5BFF),
    Color(0xFF60EBCD), Color(0xFF60EBCD),
    Color(0x0060EBCD), Color(0x0060EBCD),
    Color(0xFFB06BFF), Color(0xFFB06BFF),
    Color(0x00B06BFF), Color(0x00B06BFF),
    Color(0xFF6FD0FF), Color(0xFF6FD0FF),
  ];

  static const List<double> _burstStops = [
    0.0,       34 / 360,
    34 / 360,  92 / 360,
    92 / 360,  120 / 360,
    120 / 360, 168 / 360,
    168 / 360, 196 / 360,
    196 / 360, 254 / 360,
    254 / 360, 286 / 360,
    286 / 360, 344 / 360,
    344 / 360, 1.0,
  ];

  static const List<Color> _bloomColors = [
    Color(0xFF6FD0FF), Color(0xFF8A5BFF), Color(0xFF60EBCD),
    Color(0xFFB06BFF), Color(0xFF5A9CFF), Color(0xFFFF79C6),
  ];

  const RainbowBorderPainter({
    required this.progress,
    required this.borderRadius,
    required this.isProcessing,
    this.strokeWidth = TizenStyles.focusBorderWidth,
    this.glowOpacity = 0.7,
    this.borderPhase = BorderPhase.idle,
    this.burstAngle = 0.0,
    this.burstOpacity = 1.0,
    this.bloomWaveProgress = 0.0,
    this.bloomBreathOpacity = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (borderPhase) {
      case BorderPhase.idle:
        _paintIdle(canvas, size);
      case BorderPhase.busy:
        _paintProcessing(canvas, size);
      case BorderPhase.slowing:
      case BorderPhase.cont:
        _paintBurst(canvas, size);
        _paintBloom(canvas, size);
    }
  }

  void _paintProcessing(Canvas canvas, Size size) {
    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final outerRRect = RRect.fromRectAndRadius(outerRect, Radius.circular(borderRadius));

    // Outer glow — HTML ::after box-shadow + edgepulse
    canvas.drawRRect(outerRRect, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 12)
      ..color = _glowCyan.withValues(alpha: 0.45 * glowOpacity));
    canvas.drawRRect(outerRRect, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 22)
      ..color = _glowPurple.withValues(alpha: 0.30 * glowOpacity));

    // Comet — PathMetrics-based for uniform speed on RRect
    const sw = 1.6;
    const half = sw / 2;
    final pathRect = Rect.fromLTWH(half, half, size.width - sw, size.height - sw);
    final borderPath = Path()
      ..addRRect(RRect.fromRectAndRadius(pathRect, Radius.circular(borderRadius)));

    final metric = borderPath.computeMetrics().first;
    final total = metric.length;
    final cometLen = total * (80.0 / 360.0);
    final headDist = (progress * total) % total;

    const int steps = 24;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.butt;

    for (int i = 0; i < steps; i++) {
      final t0 = i / steps;
      final t1 = (i + 1) / steps;

      final d0 = (headDist - cometLen * (1.0 - t0) + total) % total;
      final d1 = (headDist - cometLen * (1.0 - t1) + total) % total;

      final Color segColor;
      if (t0 < 0.5) {
        segColor = _cyanAccent.withValues(alpha: t0 * 2.0);
      } else {
        segColor = Color.lerp(_cyanAccent, _purpleAccent, (t0 - 0.5) * 2.0)!;
      }
      paint.color = segColor;

      final Path seg;
      if (d0 <= d1) {
        seg = metric.extractPath(d0, d1);
      } else {
        seg = metric.extractPath(d0, total);
        seg.addPath(metric.extractPath(0, d1), Offset.zero);
      }
      canvas.drawPath(seg, paint);
    }
  }

  void _paintBurst(Canvas canvas, Size size) {
    const sw = 1.6;
    const half = sw / 2;
    final rect = Rect.fromLTWH(half, half, size.width - sw, size.height - sw);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final outerRRect = RRect.fromRectAndRadius(outerRect, Radius.circular(borderRadius));

    // Outer glow with burst opacity
    canvas.drawRRect(outerRRect, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 18)
      ..color = _glowCyan.withValues(alpha: 0.55 * burstOpacity));
    canvas.drawRRect(outerRRect, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 30)
      ..color = _glowPurple.withValues(alpha: 0.35 * burstOpacity));

    // Rainbow bands — opacity applied per-color
    final adjustedColors = _burstColors
        .map((c) => c.withValues(alpha: c.a * burstOpacity))
        .toList();

    canvas.drawRRect(rRect, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..shader = SweepGradient(
        colors: adjustedColors,
        stops: _burstStops,
        startAngle: burstAngle,
        endAngle: burstAngle + 2 * math.pi,
      ).createShader(rect));
  }

  void _paintBloom(Canvas canvas, Size size) {
    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(outerRect, Radius.circular(borderRadius));
    final path = Path()..addRRect(rrect);
    final metric = path.computeMetrics().first;
    final total = metric.length;

    // Card center — used to compute outward direction per dot
    final cardCenter = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 13; i++) {
      final t = (bloomWaveProgress + i / 13) % 1.0;
      final tangent = metric.getTangentForOffset(t * total);
      if (tangent == null) continue;

      final borderPos = tangent.position;
      final color = _bloomColors[i % _bloomColors.length];

      // Push dot center 14px outside the border so blur spreads outward only,
      // matching CSS box-shadow which never bleeds into the element interior.
      final toEdge = borderPos - cardCenter;
      final dist = toEdge.distance;
      final outward = dist > 0 ? toEdge / dist : const Offset(0, -1);
      final outerPos = borderPos + outward * 14;

      canvas.drawCircle(outerPos, 4, Paint()
        ..color = color.withValues(alpha: 0.85 * bloomBreathOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18));
      canvas.drawCircle(outerPos, 10, Paint()
        ..color = color.withValues(alpha: 0.40 * bloomBreathOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28));
    }
  }

  void _paintIdle(Canvas canvas, Size size) {
    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final outerRRect = RRect.fromRectAndRadius(outerRect, Radius.circular(borderRadius));

    // Breathing outer glow — pulses with glowOpacity
    canvas.drawRRect(outerRRect, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 14)
      ..color = _glowCyan.withValues(alpha: 0.38 * glowOpacity));
    canvas.drawRRect(outerRRect, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 26)
      ..color = _glowPurple.withValues(alpha: 0.22 * glowOpacity));

    // Rotating gradient stroke
    final half = strokeWidth / 2;
    final rect = Rect.fromLTWH(half, half, size.width - strokeWidth, size.height - strokeWidth);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    canvas.drawRRect(rRect, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = SweepGradient(
        colors: _idleColors,
        startAngle: progress * 2 * math.pi,
        endAngle: progress * 2 * math.pi + 2 * math.pi,
      ).createShader(rect));
  }

  @override
  bool shouldRepaint(RainbowBorderPainter old) =>
      old.progress != progress ||
      old.isProcessing != isProcessing ||
      old.glowOpacity != glowOpacity ||
      old.borderPhase != borderPhase ||
      old.burstAngle != burstAngle ||
      old.burstOpacity != burstOpacity ||
      old.bloomWaveProgress != bloomWaveProgress ||
      old.bloomBreathOpacity != bloomBreathOpacity;
}

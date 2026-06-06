import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/tizen_styles.dart';

class RainbowBorderPainter extends CustomPainter {
  final double progress;
  final double borderRadius;
  final double strokeWidth;

  static const _colors = [
    Color(0xFF22D3EE), // cyan400
    Color(0xFF38BDF8), // sky300
    Color(0xFF2563EB), // blue600
    Color(0xFF6366F1), // indigo
    Color(0xFF8B5CF6), // violet
    Color(0xFFA78BFA), // violet300
    Color(0xFF6366F1), // indigo
    Color(0xFF2563EB), // blue600
    Color(0xFF22D3EE), // cyan400
  ];

  const RainbowBorderPainter({
    required this.progress,
    required this.borderRadius,
    this.strokeWidth = TizenStyles.focusBorderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final half = strokeWidth / 2;
    final rect = Rect.fromLTWH(half, half, size.width - half * 2, size.height - half * 2);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = SweepGradient(
        colors: _colors,
        startAngle: progress * 2 * math.pi,
        endAngle: progress * 2 * math.pi + 2 * math.pi,
      ).createShader(rect);

    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(RainbowBorderPainter old) => old.progress != progress;
}

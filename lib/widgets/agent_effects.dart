import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

enum BorderPhase { idle, busy, slowing, cont }

class AgentBackgroundEffects extends StatefulWidget {
  final bool isProcessing;
  final double borderRadius;
  final Widget child;

  const AgentBackgroundEffects({
    super.key,
    required this.isProcessing,
    required this.borderRadius,
    required this.child,
  });

  @override
  State<AgentBackgroundEffects> createState() => _AgentBackgroundEffectsState();
}

class _AgentBackgroundEffectsState extends State<AgentBackgroundEffects> {
  BorderPhase _phase = BorderPhase.idle;
  Timer? _sequenceTimer;

  @override
  void initState() {
    super.initState();
    _phase = widget.isProcessing ? BorderPhase.busy : BorderPhase.idle;
  }

  @override
  void didUpdateWidget(AgentBackgroundEffects oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isProcessing && widget.isProcessing) {
      _sequenceTimer?.cancel();
      setState(() => _phase = BorderPhase.busy);
    } else if (oldWidget.isProcessing && !widget.isProcessing) {
      _startCompletionSequence();
    }
  }

  void _startCompletionSequence() {
    // Phase 1: settle-busy (650ms)
    _sequenceTimer?.cancel();
    _sequenceTimer = Timer(const Duration(milliseconds: 650), () {
      if (!mounted) return;
      setState(() => _phase = BorderPhase.slowing);

      // Phase 2: slowing/burst (450ms)
      _sequenceTimer = Timer(const Duration(milliseconds: 450), () {
        if (!mounted) return;
        setState(() => _phase = BorderPhase.cont);
      });
    });
  }

  @override
  void dispose() {
    _sequenceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: AgentOuterGlow(
              phase: _phase,
              borderRadius: widget.borderRadius,
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: AgentBloom(phase: _phase, borderRadius: widget.borderRadius),
          ),
        ),
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AgentBorderStroke(
              phase: _phase,
              borderRadius: widget.borderRadius,
            ),
          ),
        ),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────
// 1. Outer Glow (Pulse & Fade)
// ────────────────────────────────────────────────────────────
class AgentOuterGlow extends StatefulWidget {
  final BorderPhase phase;
  final double borderRadius;
  const AgentOuterGlow({
    super.key,
    required this.phase,
    required this.borderRadius,
  });

  @override
  State<AgentOuterGlow> createState() => _AgentOuterGlowState();
}

class _AgentOuterGlowState extends State<AgentOuterGlow>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1900),
    );
    // Increase the contrast of the pulse by lowering the minimum opacity (0.3 instead of 0.6)
    _pulseOpacity = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(AgentOuterGlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Pulse continues across all phases to overlap with bloom
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        return CustomPaint(
          painter: _OuterGlowPainter(
            opacity: _pulseOpacity.value,
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }
}

class _OuterGlowPainter extends CustomPainter {
  final double opacity;
  final double borderRadius;

  _OuterGlowPainter({required this.opacity, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    // Reduced base alpha to half so it is subtler than completion state
    final cyan = const Color(0xFF6FD0FF).withValues(alpha: 0.5 * opacity);
    final purple = const Color(0xFF8A5BFF).withValues(alpha: 0.40 * opacity);

    // Using exact container bounds prevents BlurStyle.outer from creating sharp cut-offs *inside* the semi-transparent container
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 2.75)
        ..color = cyan,
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5.5)
        ..color = purple,
    );
  }

  @override
  bool shouldRepaint(_OuterGlowPainter old) => opacity != old.opacity;
}

// ────────────────────────────────────────────────────────────
// 2. Bloom Effect (13 dots scattered)
// ────────────────────────────────────────────────────────────
class AgentBloom extends StatefulWidget {
  final BorderPhase phase;
  final double borderRadius;
  const AgentBloom({
    super.key,
    required this.phase,
    required this.borderRadius,
  });

  @override
  State<AgentBloom> createState() => _AgentBloomState();
}

class _AgentBloomState extends State<AgentBloom> with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _breathController;
  late Animation<double> _breathOpacity;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
    );
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5400),
    );
    _breathOpacity = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
    _updateAnimation();
  }

  @override
  void didUpdateWidget(AgentBloom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase != widget.phase) _updateAnimation();
  }

  void _updateAnimation() {
    if (widget.phase == BorderPhase.slowing ||
        widget.phase == BorderPhase.cont) {
      if (!_waveController.isAnimating) _waveController.repeat();
      if (!_breathController.isAnimating)
        _breathController.repeat(reverse: true);
    } else {
      _waveController.stop();
      _breathController.stop();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.phase == BorderPhase.idle || widget.phase == BorderPhase.busy)
      return const SizedBox();

    return AnimatedBuilder(
      animation: Listenable.merge([_waveController, _breathController]),
      builder: (context, _) {
        return CustomPaint(
          painter: _BloomPainter(
            phase: widget.phase,
            waveProgress: _waveController.value,
            breathOpacity: _breathOpacity.value,
            borderRadius: widget.borderRadius,
          ),
        );
      },
    );
  }
}

class _BloomPainter extends CustomPainter {
  final BorderPhase phase;
  final double waveProgress;
  final double breathOpacity;
  final double borderRadius;

  static const List<Color> _gradientColors = [
    Color(0xFF6FD0FF), Color(0xFF8A5BFF), Color(0xFF60EBCD),
    Color(0xFFB06BFF), Color(0xFF5A9CFF), Color(0xFFFF79C6),
    Color(0xFF6FD0FF), // Wrap around perfectly
  ];

  _BloomPainter({
    required this.phase,
    required this.waveProgress,
    required this.breathOpacity,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Using exact bounds prevents the sharp inner cut-off from being visible *inside* the container
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final angle1 = waveProgress * 2 * math.pi;
    final angle2 = -waveProgress * 3 * math.pi;

    // Layer 1: Tight and dense
    final paint1 = Paint()
      ..style = PaintingStyle.fill
      ..shader = SweepGradient(
        colors: _gradientColors
            .map((c) => c.withValues(alpha: 1.0 * breathOpacity))
            .toList(),
        transform: GradientRotation(angle1),
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 2.75);

    // Layer 2: Wider spread
    final paint2 = Paint()
      ..style = PaintingStyle.fill
      ..shader = SweepGradient(
        colors: _gradientColors
            .map((c) => c.withValues(alpha: 0.80 * breathOpacity))
            .toList(),
        transform: GradientRotation(angle2),
      ).createShader(rect)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5.5);

    // Layer 3: Sharp, thin border line exactly matching the main outer blur's rotation and colors
    // Inflating by 0.5 with a 1.0px stroke places the line entirely *outside* the container.
    final rect3 = rect.inflate(0.5);
    final rrect3 = RRect.fromRectAndRadius(
      rect3,
      Radius.circular(borderRadius + 0.5),
    );

    final paint3 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = SweepGradient(
        colors: _gradientColors, // 100% opacity, ignoring breathOpacity
        transform: GradientRotation(angle1),
      ).createShader(rect3);

    // Draw base wider blur first, then tight dense blur
    canvas.drawRRect(rrect, paint2);
    canvas.drawRRect(rrect, paint1);

    // Only draw the sharp static border when we have fully completed (cont)
    // During 'slowing', AgentBorderStroke is animating the border filling effect
    if (phase == BorderPhase.cont) {
      canvas.drawRRect(rrect3, paint3);
    }
  }

  @override
  bool shouldRepaint(_BloomPainter old) =>
      phase != old.phase ||
      waveProgress != old.waveProgress ||
      breathOpacity != old.breathOpacity;
}

// ────────────────────────────────────────────────────────────
// 3. Border Stroke (Spinning Comet & Rainbow Bands)
// ────────────────────────────────────────────────────────────
class AgentBorderStroke extends StatefulWidget {
  final BorderPhase phase;
  final double borderRadius;
  const AgentBorderStroke({
    super.key,
    required this.phase,
    required this.borderRadius,
  });

  @override
  State<AgentBorderStroke> createState() => _AgentBorderStrokeState();
}

class _AgentBorderStrokeState extends State<AgentBorderStroke>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _burstController;
  late AnimationController _contController;

  double _burstStartAngle = 0.0;

  @override
  void initState() {
    super.initState();
    // Idle/Busy Spin (2.2s to match original HTML edgespin)
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    // Slowing (Burst)
    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    // Cont (Slow Spin)
    _contController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    );

    _updateAnimation(null);
  }

  @override
  void didUpdateWidget(AgentBorderStroke oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase != widget.phase) _updateAnimation(oldWidget.phase);
  }

  void _updateAnimation(BorderPhase? oldPhase) {
    if (widget.phase == BorderPhase.idle || widget.phase == BorderPhase.busy) {
      if (!_spinController.isAnimating) _spinController.repeat();
      _burstController.reset();
      _contController.reset();
    } else if (widget.phase == BorderPhase.slowing) {
      _burstStartAngle = _spinController.value * 2 * math.pi;
      _spinController.stop();
      _burstController.forward(from: 0);
    } else if (widget.phase == BorderPhase.cont) {
      if (oldPhase != BorderPhase.slowing) {
        // If coming directly to cont without slowing (rare), just take current angle
        _burstStartAngle = _spinController.value * 2 * math.pi;
      }
      _spinController.stop();
      _burstController.value = 1.0;
      if (!_contController.isAnimating) _contController.repeat();
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    _burstController.dispose();
    _contController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _spinController,
        _burstController,
        _contController,
      ]),
      builder: (context, _) {
        double currentAngle = 0.0;
        double burstOpacity = 1.0;

        if (widget.phase == BorderPhase.idle ||
            widget.phase == BorderPhase.busy) {
          currentAngle = _spinController.value * 2 * math.pi;
        } else if (widget.phase == BorderPhase.slowing) {
          // Burst animation: spins half a circle
          currentAngle = _burstStartAngle + (_burstController.value * math.pi);
          burstOpacity = 1.0 - (_burstController.value * 0.5); // 1.0 -> 0.5
        } else if (widget.phase == BorderPhase.cont) {
          // Cont animation: starts from burst end angle + continues slowly
          currentAngle =
              _burstStartAngle +
              math.pi +
              (_contController.value * 2 * math.pi);
          burstOpacity = 0.5;
        }

        return CustomPaint(
          painter: _BorderStrokePainter(
            phase: widget.phase,
            angle: currentAngle,
            burstProgress: widget.phase == BorderPhase.slowing
                ? _burstController.value
                : 0.0,
            borderRadius: widget.borderRadius,
            progress: _spinController.value,
          ),
        );
      },
    );
  }
}

class _BorderStrokePainter extends CustomPainter {
  final BorderPhase phase;
  final double angle;
  final double burstProgress;
  final double borderRadius;
  final double progress; // For the comet head position

  _BorderStrokePainter({
    required this.phase,
    required this.angle,
    required this.burstProgress,
    required this.borderRadius,
    required this.progress,
  });

  static const Color _cyanAccent = Color(0xFF00C8FF); // More vivid/intense cyan
  static const Color _purpleAccent = Color(
    0xFFAA00FF,
  ); // More vivid/intense purple

  static const List<Color> _idleColors = [
    Color(0xFF22D3EE),
    Color(0xFF38BDF8),
    Color(0xFF2563EB),
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFFA78BFA),
    Color(0xFF6366F1),
    Color(0xFF2563EB),
    Color(0xFF22D3EE),
  ];

  static const List<Color> _burstColors = [
    Color(0xFF6FD0FF),
    Color(0xFF6FD0FF),
    Color(0x006FD0FF),
    Color(0x006FD0FF),
    Color(0xFF8A5BFF),
    Color(0xFF8A5BFF),
    Color(0x008A5BFF),
    Color(0x008A5BFF),
    Color(0xFF60EBCD),
    Color(0xFF60EBCD),
    Color(0x0060EBCD),
    Color(0x0060EBCD),
    Color(0xFFB06BFF),
    Color(0xFFB06BFF),
    Color(0x00B06BFF),
    Color(0x00B06BFF),
    Color(0xFF6FD0FF),
    Color(0xFF6FD0FF),
  ];

  static const List<double> _burstStops = [
    0.0,
    34 / 360,
    34 / 360,
    92 / 360,
    92 / 360,
    120 / 360,
    120 / 360,
    168 / 360,
    168 / 360,
    196 / 360,
    196 / 360,
    254 / 360,
    254 / 360,
    286 / 360,
    286 / 360,
    344 / 360,
    344 / 360,
    1.0,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    const double sw = 1.0;
    const double half = sw / 2;

    // Inflate by 0.5 to match AgentBloom's Layer 3 exactly!
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final pathRect = rect.inflate(0.5);
    final rRect = RRect.fromRectAndRadius(
      pathRect,
      Radius.circular(borderRadius + 0.5),
    );

    if (phase == BorderPhase.busy || phase == BorderPhase.slowing) {
      final borderPath = Path()..addRRect(rRect);
      final metric = borderPath.computeMetrics().first;
      final total = metric.length;

      double cometLen;
      double headDist;

      if (phase == BorderPhase.busy) {
        cometLen = total * (80.0 / 360.0);
        headDist = (progress * total) % total;
      } else {
        // Slowing phase: Quickly spin around once and fill up
        // burstProgress goes from 0.0 to 1.0 in 450ms
        // It spins 1 full circle (total) and expands length to full (total)
        cometLen =
            total * (80.0 / 360.0 + (1.0 - 80.0 / 360.0) * burstProgress);
        headDist = (progress * total + burstProgress * total) % total;
      }

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

        // Calculate opacity: tail fades in over 25%, middle 50% is solid, head fades out over 25%
        double alpha;
        if (t0 < 0.25) {
          alpha = t0 * 4.0;
        } else if (t0 > 0.75) {
          alpha = (1.0 - t0) * 4.0;
        } else {
          alpha = 1.0;
        }

        // Smooth color transition from tail to head
        final Color baseColor = Color.lerp(_cyanAccent, _purpleAccent, t0)!;
        final Color cometColor = baseColor.withValues(alpha: alpha);

        if (phase == BorderPhase.busy) {
          paint.color = cometColor;
        } else {
          // During slowing, morph into AgentBloom colors
          // Let's use the static gradient colors of AgentBloom for a smooth transition
          const List<Color> bloomColors = [
            Color(0xFF6FD0FF),
            Color(0xFF8A5BFF),
            Color(0xFF60EBCD),
            Color(0xFFB06BFF),
            Color(0xFF5A9CFF),
            Color(0xFFFF79C6),
            Color(0xFF6FD0FF),
          ];

          // As burstProgress goes to 1.0, we cross-fade the comet color into the bloom gradient
          // Pick a color from bloom gradient based on position

          final double colorPos = ((d0 / total) + 1.0) % 1.0;
          final int colorIdx = (colorPos * (bloomColors.length - 1)).floor();
          final double colorFrac =
              (colorPos * (bloomColors.length - 1)) - colorIdx;
          final Color targetColor = Color.lerp(
            bloomColors[colorIdx],
            bloomColors[colorIdx + 1],
            colorFrac,
          )!;

          paint.color = Color.lerp(cometColor, targetColor, burstProgress)!;
        }

        final Path seg = d0 <= d1
            ? metric.extractPath(d0, d1)
            : (metric.extractPath(d0, total)
                ..addPath(metric.extractPath(0, d1), Offset.zero));
        canvas.drawPath(seg, paint);
      }
    } else if (phase == BorderPhase.idle) {
      canvas.drawRRect(
        rRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = sw
          ..shader = SweepGradient(
            colors: _idleColors,
            startAngle: angle,
            endAngle: angle + 2 * math.pi,
          ).createShader(pathRect),
      );
    }
  }

  @override
  bool shouldRepaint(_BorderStrokePainter old) =>
      phase != old.phase ||
      angle != old.angle ||
      burstProgress != old.burstProgress ||
      progress != old.progress;
}

import 'package:flutter/material.dart';

class TypingDotsIndicator extends StatefulWidget {
  final double dotSize;
  final double spacing;
  final Color? color;
  final Duration duration;

  const TypingDotsIndicator({
    super.key,
    this.dotSize = 6.0,
    this.spacing = 4.0,
    this.color,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<TypingDotsIndicator> createState() => _TypingDotsIndicatorState();
}

class _TypingDotsIndicatorState extends State<TypingDotsIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // design_02.html: --ease: cubic-bezier(.22, .61, .36, 1);
  static const Curve _designCurve = Cubic(0.22, 0.61, 0.36, 1.0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 기본 색상은 디자인 시안의 var(--txt-2)와 유사한 흰색 반투명으로 설정
    final color = widget.color ?? Colors.white.withValues(alpha: 0.7);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(0.0, color), // 첫 번째 도트
        SizedBox(width: widget.spacing),
        _buildDot(0.16, color), // 160ms delay (1초 기준 0.16)
        SizedBox(width: widget.spacing),
        _buildDot(0.32, color), // 320ms delay (1초 기준 0.32)
      ],
    );
  }

  Widget _buildDot(double delayRatio, Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // 현재 애니메이션 진행도(0.0 ~ 1.0)에서 딜레이를 빼서 각 도트의 시간축을 맞춤
        double t = _controller.value - delayRatio;
        if (t < 0) t += 1.0;

        // 0~50% 구간은 상승(0 -> 1), 50~100% 구간은 하강(1 -> 0)
        double progress;
        if (t <= 0.5) {
          progress = _designCurve.transform(t * 2.0);
        } else {
          progress = _designCurve.transform((1.0 - t) * 2.0);
        }

        // opacity: 0.3 -> 1.0
        final opacity = 0.3 + (0.7 * progress);
        
        // transform: translateY 0 -> -18%
        final dy = -0.18 * progress;

        return FractionalTranslation(
          translation: Offset(0, dy),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Container(
        width: widget.dotSize,
        height: widget.dotSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/tizen_styles.dart';

class TypingIndicator extends StatefulWidget {
  final String avatarInitial;
  final bool showAvatar;
  final bool showBubble;
  final double dotSize;

  const TypingIndicator({
    super.key,
    this.avatarInitial = 'T',
    this.showAvatar = true,
    this.showBubble = true,
    this.dotSize = 6.0,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animations = List.generate(3, (index) {
      final start = index * 0.2;
      final end = start + 0.6;
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.2, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.2).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 50,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: Curves.linear,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indicator = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.scale(
              scale: _animations[index].value,
              child: Container(
                width: widget.dotSize,
                height: widget.dotSize,
                margin: EdgeInsets.symmetric(horizontal: widget.dotSize / 3),
                decoration: const BoxDecoration(
                  color: TizenStyles.cyan400,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );

    if (!widget.showAvatar && !widget.showBubble) {
      return indicator;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showAvatar) ...[
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: TizenStyles.avatarSpinnerSize,
                height: TizenStyles.avatarSpinnerSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TizenStyles.cyan400.withValues(alpha: 0.8)),
                ),
              ),
              CircleAvatar(
                radius: TizenStyles.avatarRadius,
                backgroundColor: TizenStyles.slate800,
                child: Text(
                  widget.avatarInitial,
                  style: const TextStyle(fontSize: TizenStyles.avatarInitialFontSize, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(width: TizenStyles.avatarGap),
        ],
        if (widget.showBubble)
          Container(
            padding: TizenStyles.bubblePadding,
            decoration: BoxDecoration(
              color: TizenStyles.slate900.withValues(alpha: 0.4),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TizenStyles.windowBorderRadius),
                topRight: Radius.circular(TizenStyles.windowBorderRadius),
                bottomLeft: Radius.circular(TizenStyles.messageTailRadius),
                bottomRight: Radius.circular(TizenStyles.windowBorderRadius),
              ),
            ),
            child: indicator,
          )
        else
          indicator,
      ],
    );
  }
}

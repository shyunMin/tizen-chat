import 'package:flutter/material.dart';

class SpeechVisibilityAnimator extends StatefulWidget {
  final bool isVisible;
  final double slideDistance;
  final Widget Function(BuildContext context, double opacity, double slideOffset) builder;

  const SpeechVisibilityAnimator({
    super.key,
    required this.isVisible,
    required this.slideDistance,
    required this.builder,
  });

  @override
  State<SpeechVisibilityAnimator> createState() => _SpeechVisibilityAnimatorState();
}

class _SpeechVisibilityAnimatorState extends State<SpeechVisibilityAnimator>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, value: widget.isVisible ? 1.0 : 0.0);
    _slideController = AnimationController(
        vsync: this, value: widget.isVisible ? 0.0 : 1.0);
  }

  @override
  void didUpdateWidget(SpeechVisibilityAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _show();
      } else {
        _hide();
      }
    }
  }

  void _hide() {
    _slideController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
    _fadeController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _show() {
    _fadeController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
    _slideController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeController, _slideController]),
      builder: (context, child) {
        // slide offset: when slideController is 1.0, it moves UP by slideDistance (negative offset)
        final slideOffset = -_slideController.value * widget.slideDistance;
        return widget.builder(context, _fadeController.value, slideOffset);
      },
    );
  }
}

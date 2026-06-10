import 'package:flutter/material.dart';

class SpeechVisibilityAnimator extends StatefulWidget {
  final bool isVisible;
  final double slideDistance;
  final Widget? child;
  final Widget Function(BuildContext context, double opacity, double slideOffset, Widget? child) builder;

  const SpeechVisibilityAnimator({
    super.key,
    required this.isVisible,
    required this.slideDistance,
    this.child,
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
    // 항상 투명도 0.0에서 시작하여 처음 등장 시 페이드 인 효과 적용
    _fadeController = AnimationController(vsync: this, value: 0.0);
    // 첫 등장 시 슬라이딩은 생략하고 제자리(0.0)에서 페이드 인만 수행
    _slideController = AnimationController(
        vsync: this, value: widget.isVisible ? 0.0 : 1.0);

    if (widget.isVisible) {
      _fadeController.animateTo(
        1.0,
        duration: _fadeDuration,
        curve: _designCurve,
      );
    }
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

  static const Curve _designCurve = Cubic(0.22, 0.61, 0.36, 1.0);
  static const Duration _slideDuration = Duration(milliseconds: 200);
  static const Duration _fadeDuration = Duration(milliseconds: 150);

  Future<void> _hide() async {
    await _slideController.animateTo(
      1.0,
      duration: _slideDuration,
      curve: _designCurve,
    );
    if (!mounted || widget.isVisible) return;
    await _fadeController.animateTo(
      0.0,
      duration: _fadeDuration,
      curve: _designCurve,
    );
  }

  Future<void> _show() async {
    await _fadeController.animateTo(
      1.0,
      duration: _fadeDuration,
      curve: _designCurve,
    );
    if (!mounted || !widget.isVisible) return;
    await _slideController.animateTo(
      0.0,
      duration: _slideDuration,
      curve: _designCurve,
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
      child: widget.child,
      builder: (context, child) {
        // slide offset: when slideController is 1.0, it moves UP by slideDistance (negative offset)
        final slideOffset = -_slideController.value * widget.slideDistance;
        return widget.builder(context, _fadeController.value, slideOffset, child);
      },
    );
  }
}

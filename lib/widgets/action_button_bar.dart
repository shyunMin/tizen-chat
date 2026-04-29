import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActionButtonBar extends StatefulWidget {
  final List<String> buttons;
  final void Function(String) onSend;
  final VoidCallback? onArrowUp;
  final VoidCallback? onArrowDown;

  const ActionButtonBar({
    super.key,
    required this.buttons,
    required this.onSend,
    this.onArrowUp,
    this.onArrowDown,
  });

  @override
  State<ActionButtonBar> createState() => ActionButtonBarState();
}

class ActionButtonBarState extends State<ActionButtonBar> {
  final ScrollController _scrollController = ScrollController();
  List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _buildFocusNodes(widget.buttons.length);
  }

  @override
  void didUpdateWidget(ActionButtonBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.buttons.length != widget.buttons.length ||
        !_listEquals(oldWidget.buttons, widget.buttons)) {
      _disposeFocusNodes();
      _buildFocusNodes(widget.buttons.length);
    }
  }

  void _buildFocusNodes(int count) {
    _focusNodes = List.generate(count, (_) => FocusNode());
  }

  void _disposeFocusNodes() {
    for (final n in _focusNodes) n.dispose();
  }

  @override
  void dispose() {
    _disposeFocusNodes();
    _scrollController.dispose();
    super.dispose();
  }

  void focusFirstButton() {
    if (_focusNodes.isNotEmpty) {
      _focusNodes.first.requestFocus();
    }
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buttons.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 44,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: widget.buttons.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) => _ActionButton(
          label: widget.buttons[index],
          focusNode: _focusNodes[index],
          onSend: widget.onSend,
          onArrowLeft:
              index > 0 ? () => _focusNodes[index - 1].requestFocus() : null,
          onArrowRight: index < _focusNodes.length - 1
              ? () => _focusNodes[index + 1].requestFocus()
              : null,
          onArrowUp: widget.onArrowUp,
          onArrowDown: widget.onArrowDown,
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final FocusNode focusNode;
  final void Function(String) onSend;
  final VoidCallback? onArrowLeft;
  final VoidCallback? onArrowRight;
  final VoidCallback? onArrowUp;
  final VoidCallback? onArrowDown;

  const _ActionButton({
    required this.label,
    required this.focusNode,
    required this.onSend,
    this.onArrowLeft,
    this.onArrowRight,
    this.onArrowUp,
    this.onArrowDown,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rainbowController;

  @override
  void initState() {
    super.initState();
    _rainbowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
    if (widget.focusNode.hasFocus) {
      _rainbowController.repeat();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      _rainbowController.stop();
      _rainbowController.reset();
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    _rainbowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = widget.focusNode.hasFocus;
    return Focus(
      focusNode: widget.focusNode,
      onKeyEvent: (node, event) {
        if (event is! KeyDownEvent) return KeyEventResult.ignored;
        if (event.logicalKey == LogicalKeyboardKey.select ||
            event.logicalKey == LogicalKeyboardKey.enter) {
          widget.onSend(widget.label);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          widget.onArrowLeft?.call();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          widget.onArrowRight?.call();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          widget.onArrowUp?.call();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          widget.onArrowDown?.call();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: () => widget.onSend(widget.label),
        child: AnimatedBuilder(
          animation: _rainbowController,
          builder: (context, child) => CustomPaint(
            foregroundPainter: isFocused
                ? _RainbowBorderPainter(
                    progress: _rainbowController.value,
                    borderRadius: 50,
                    strokeWidth: 1.5,
                  )
                : null,
            child: child,
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(50),
              boxShadow: isFocused
                  ? [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.45),
                        blurRadius: 14,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: isFocused ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RainbowBorderPainter extends CustomPainter {
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

  const _RainbowBorderPainter({
    required this.progress,
    required this.borderRadius,
    this.strokeWidth = 1.5,
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
  bool shouldRepaint(_RainbowBorderPainter old) => old.progress != progress;
}

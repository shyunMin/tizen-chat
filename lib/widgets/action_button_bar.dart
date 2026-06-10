import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/tizen_styles.dart';
import 'chip_background_effects.dart';
import 'rainbow_border_painter.dart';
import 'agent_effects.dart';

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
    for (final n in _focusNodes) {
      n.dispose();
    }
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
      height: TizenStyles.actionBarHeight,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: TizenStyles.actionBarHorizontalPadding,
        itemCount: widget.buttons.length,
        separatorBuilder: (_, _) => const SizedBox(width: TizenStyles.actionBarItemSpacing),
        itemBuilder: (context, index) => Center(
          child: _ActionButton(
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

class _ActionButtonState extends State<_ActionButton> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
    if (widget.focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
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
        child: AgentVisibilityShadow(
          type: VisibilityShadowType.button,
          child: ChipBackgroundEffects(
          isFocused: isFocused,
          child: Container(
            alignment: Alignment.center,
            padding: TizenStyles.actionButtonPadding,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut,
              style: TextStyle(
                color: isFocused ? Colors.white.withValues(alpha: 0.95) : Colors.white.withValues(alpha: 0.8),
                fontSize: TizenStyles.tChip,
                fontWeight: isFocused ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 0.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: isFocused ? 0.6 : 0.3),
                    blurRadius: isFocused ? 4.0 : 2.0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(widget.label),
            ),
          ),
        ),
      ),
      ),
    );
  }
}


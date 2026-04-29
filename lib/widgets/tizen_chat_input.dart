import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../theme/tizen_styles.dart';

class TizenChatInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSend;

  const TizenChatInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  @override
  State<TizenChatInput> createState() => _TizenChatInputState();
}

class _TizenChatInputState extends State<TizenChatInput> {
  final FocusNode _micFocusNode = FocusNode();
  final FocusNode _sendFocusNode = FocusNode();

  @override
  void dispose() {
    _micFocusNode.dispose();
    _sendFocusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      widget.controller.text = ""; // clear
      widget.focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(10.0), // 일괄 여백 10
          decoration: BoxDecoration(color: Colors.transparent),
          child: Row(
            children: [
              Expanded(
                child: SubtleRotatingBorder(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[900]?.withValues(
                        alpha: 0.9,
                      ), // 채팅창 배경색과 동일하게 수정
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: widget.controller,
                            focusNode: widget.focusNode,
                            onSubmitted: (_) => _handleSend(),
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            showCursor: true,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: TizenStyles.baseFontSize,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(
                                color: TizenStyles.slate500,
                                fontSize: 18,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        _FocusableActionIcon(
                          icon: Icons.mic_rounded,
                          size: 24,
                          focusNode: _micFocusNode,
                          onTap: () {},
                          isEnabled: false,
                        ),
                        _FocusableActionIcon(
                          icon: Icons.send_rounded,
                          size: 22,
                          focusNode: _sendFocusNode,
                          onTap: _handleSend,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubtleRotatingBorder extends StatefulWidget {
  final Widget child;

  const SubtleRotatingBorder({super.key, required this.child});

  @override
  State<SubtleRotatingBorder> createState() => _SubtleRotatingBorderState();
}

class _SubtleRotatingBorderState extends State<SubtleRotatingBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(1.2), // 얇은 테두리
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            gradient: SweepGradient(
              center: Alignment.center,
              colors: [
                Colors.white.withValues(alpha: 0.05),
                Colors.white.withValues(alpha: 0.3),
                Colors.white.withValues(alpha: 0.05),
              ],
              transform: GradientRotation(_controller.value * math.pi * 2),
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _FocusableActionIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final FocusNode focusNode;
  final VoidCallback onTap;
  final bool isEnabled;

  const _FocusableActionIcon({
    required this.icon,
    required this.size,
    required this.focusNode,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  State<_FocusableActionIcon> createState() => _FocusableActionIconState();
}

class _FocusableActionIconState extends State<_FocusableActionIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = true);
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  void _handleTapCancel() {
    if (!widget.isEnabled) return;
    setState(() => _isPressed = false);
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      onKeyEvent: (node, event) {
        if (!widget.isEnabled) return KeyEventResult.ignored;
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter)) {
          _pressController.forward().then((_) => _pressController.reverse());
          widget.onTap();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.isEnabled ? widget.onTap : null,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedBuilder(
            animation: widget.focusNode,
            builder: (context, child) {
              final isFocused = widget.focusNode.hasFocus;
              final active = widget.isEnabled && (isFocused || _isPressed);

              Color iconColor;
              if (!widget.isEnabled) {
                iconColor = Colors.white.withValues(alpha: 0.3);
              } else if (active) {
                iconColor = Colors.white;
              } else {
                iconColor = TizenStyles.cyan400;
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: active
                      ? TizenStyles.cyan400.withValues(alpha: 0.25)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: TizenStyles.cyan400.withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(widget.icon, color: iconColor, size: widget.size),
              );
            },
          ),
        ),
      ),
    );
  }
}

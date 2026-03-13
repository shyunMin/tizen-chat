import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../theme/tizen_styles.dart';

class TizenChatInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSend;

  const TizenChatInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  void _handleSend() {
    final text = controller.text.trim();
    if (text.isNotEmpty) {
      onSend(text);
      controller.clear();
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
          ),
          child: Row(
            children: [
              Expanded(
                child: GlowInputBorder(
                  focusNode: focusNode,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: TizenStyles.slate900,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            focusNode: focusNode,
                            onSubmitted: (_) => _handleSend(),
                            autofocus: true,
                            keyboardType: TextInputType.none, // Hide virtual keyboard
                            showCursor: true, // Keep cursor visible for hardware keyboard
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: TizenStyles.baseFontSize,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(color: TizenStyles.slate500),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.sentiment_satisfied_alt,
                          color: TizenStyles.cyan400,
                          size: 22,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _handleSend,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: TizenStyles.accentGradient,
                    boxShadow: [
                      BoxShadow(
                        color: TizenStyles.cyan400.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.send_rounded, color: Colors.white, size: 22),
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

class GlowInputBorder extends StatefulWidget {
  final Widget child;
  final FocusNode focusNode;

  const GlowInputBorder({
    super.key,
    required this.child,
    required this.focusNode,
  });

  @override
  State<GlowInputBorder> createState() => _GlowInputBorderState();
}

class _GlowInputBorderState extends State<GlowInputBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    widget.focusNode.addListener(_updateAnimationSpeed);
  }

  void _updateAnimationSpeed() {
    if (widget.focusNode.hasFocus) {
      _controller.duration = const Duration(milliseconds: 3000);
    } else {
      _controller.duration = const Duration(seconds: 8);
    }
    _controller.repeat();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_updateAnimationSpeed);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9999),
            boxShadow: [
              BoxShadow(
                color: TizenStyles.cyan400.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
            gradient: SweepGradient(
              center: Alignment.center,
              startAngle: 0.0,
              endAngle: math.pi * 2,
              colors: const [
                TizenStyles.blue900,
                Color(0xFF0D9488),
                TizenStyles.cyan400,
                TizenStyles.blue900,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/dim_overlay.dart';
import '../widgets/prompt_bar.dart';

class TizenChatScreen2 extends StatefulWidget {
  const TizenChatScreen2({super.key});

  @override
  State<TizenChatScreen2> createState() => _TizenChatScreen2State();
}

class _TizenChatScreen2State extends State<TizenChatScreen2>
    with TickerProviderStateMixin {
  bool _isVisible = false;
  final FocusNode _keyboardFocusNode = FocusNode();

  void _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Focus(
        focusNode: _keyboardFocusNode,
        autofocus: true,
        onKeyEvent: (node, event) {
          if ((event is KeyDownEvent || event is KeyUpEvent) &&
              (event.logicalKey == LogicalKeyboardKey.altLeft ||
                  event.logicalKey == LogicalKeyboardKey.metaLeft)) {
            if (event is KeyDownEvent) {
              _toggleVisibility();
            }
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Stack(
          children: [
            // Dim Screen Overlay
            DimOverlay(isVisible: _isVisible),

            // Prompt Bar with Animation
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves
                  .easeOutCubic, // Changed from easeOutBack to prevent overshoot
              bottom: _isVisible ? 60 : -150, // Hide below screen
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: _isVisible ? 1.0 : 0.0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 84, // Keep vertical box size stable
                    child: PromptBar(isVisible: _isVisible),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



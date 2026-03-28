import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            Positioned.fill(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                color: _isVisible
                    ? Colors.black.withOpacity(0.5)
                    : Colors.transparent,
                child: _isVisible
                    ? Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.5),
                            ],
                          ),
                        ),
                      )
                    : null,
              ),
            ),

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

class PromptBar extends StatefulWidget {
  final bool isVisible;
  const PromptBar({super.key, required this.isVisible});

  @override
  State<PromptBar> createState() => _PromptBarState();
}

class _PromptBarState extends State<PromptBar> with TickerProviderStateMixin {
  bool _isExpanded = false;
  String _displayText = "";
  final String _fullText = "How can I help you?";
  int _charIndex = 0;
  Timer? _typingTimer;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _rotationController;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final FocusNode _micFocusNode = FocusNode();
  final FocusNode _sendFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void didUpdateWidget(PromptBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      // Trigger expansion and typing when becoming visible
      _reset();
      Future.delayed(const Duration(milliseconds: 700), () {
        // Increased delay to wait for rise + overshoot
        if (mounted) {
          setState(() => _isExpanded = true);
          _startTyping();
        }
      });
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _reset();
    }
  }

  void _reset() {
    _typingTimer?.cancel();
    setState(() {
      _isExpanded = false;
      _displayText = "";
      _charIndex = 0;
      _textController.clear();
    });
  }

  void _startTyping() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (_charIndex < _fullText.length) {
        setState(() {
          _displayText += _fullText[_charIndex];
          _charIndex++;
        });
      } else {
        _typingTimer?.cancel();
        _inputFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _glowController.dispose();
    _rotationController.dispose();
    _textController.dispose();
    _inputFocusNode.dispose();
    _micFocusNode.dispose();
    _sendFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_glowAnimation, _rotationController]),
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          width: _isExpanded ? 580 : 84,
          height: 84,
          child: Container(
            padding: const EdgeInsets.all(2), // Increased thickness
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42),
              gradient: SweepGradient(
                center: Alignment.center,
                colors: [
                  Colors.blueAccent.withOpacity(0.3),
                  Colors.cyanAccent.withOpacity(0.3),
                  Colors.purpleAccent.withOpacity(0.3),
                  Colors.blueAccent.withOpacity(0.3),
                ],
                transform: GradientRotation(
                  _rotationController.value * 2 * 3.14159,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(
                    0.5 * _glowAnimation.value,
                  ),
                  blurRadius: 25 * _glowAnimation.value,
                  spreadRadius: 3 * _glowAnimation.value,
                ),
                BoxShadow(
                  color: Colors.purpleAccent.withOpacity(
                    0.2 * _glowAnimation.value,
                  ),
                  blurRadius: 40 * _glowAnimation.value,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(
                  41,
                ), // Adjusted for 2px border
              ),
              clipBehavior: Clip.antiAlias,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 25,
                  sigmaY: 25,
                ), // Stronger blur
                child: SizedBox(
                  height: 80, // 84 - (2 * 2)
                  child: Stack(
                    children: [
                      // Continuous Icon for stability
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        left: _isExpanded ? 25 : (42 - 16),
                        top: 0,
                        bottom: 0,
                        child: const Center(
                          child: Icon(
                            Icons.auto_awesome,
                            color: Colors.blueAccent,
                            size: 32,
                          ),
                        ),
                      ),

                      // Expanded Content
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _isExpanded ? 1.0 : 0.0,
                        child: Container(
                          height: 80, // Matches inner height
                          padding: const EdgeInsets.only(
                            left: 72.0,
                            right: 25.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Transform.translate(
                                  offset: const Offset(
                                    0,
                                    -3,
                                  ), // visually centering text
                                  child: TextField(
                                    controller: _textController,
                                    focusNode: _inputFocusNode,
                                    autofocus: false,
                                    keyboardType: TextInputType.none,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.5,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      hintText: _charIndex < _fullText.length
                                          ? _displayText
                                          : _fullText,
                                      hintStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                    readOnly: _charIndex < _fullText.length,
                                  ),
                                ),
                              ),
                              if (_charIndex >= _fullText.length)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildFocusableIcon(
                                      icon: Icons.mic_rounded,
                                      size: 34,
                                      focusNode: _micFocusNode,
                                      onTap: () {
                                        // Handle Mic Tap
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    _buildFocusableIcon(
                                      icon: Icons.send_rounded,
                                      size: 30,
                                      focusNode: _sendFocusNode,
                                      onTap: () {
                                        // Handle Send Tap
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFocusableIcon({
    required IconData icon,
    required double size,
    required FocusNode focusNode,
    required VoidCallback onTap,
  }) {
    return Focus(
      focusNode: focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter)) {
          onTap();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedBuilder(
          animation: focusNode,
          builder: (context, child) {
            final isFocused = focusNode.hasFocus;
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isFocused
                    ? Colors.blueAccent.withOpacity(0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isFocused
                    ? [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                color: isFocused ? Colors.white : Colors.blueAccent,
                size: size,
              ),
            );
          },
        ),
      ),
    );
  }
}

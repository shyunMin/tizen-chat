import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PromptBar extends StatefulWidget {
  final bool isVisible;
  final bool isWaiting;
  final Function(String)? onSend;

  const PromptBar({
    super.key,
    required this.isVisible,
    this.onSend,
    this.isWaiting = false,
  });

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
      Future.delayed(const Duration(milliseconds: 200), () {
        // Starts expansion as it finishes the rise for a more fluid feel
        if (mounted) {
          setState(() => _isExpanded = true);
          _startTyping();
        }
      });
    } else if (!widget.isVisible && oldWidget.isVisible) {
      // Delay reset for fade-out period to avoid premature shrinking
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && !widget.isVisible) {
          _reset();
        }
      });
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
    _typingTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
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
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          width: _isExpanded
              ? MediaQuery.of(context).size.width * 0.7 // 채팅창 너비와 동일하게 70%로 수정
              : 84,
          height: 84,
          child: Container(
            padding: const EdgeInsets.all(2), // Increased thickness
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42),
              gradient: SweepGradient(
                center: Alignment.center,
                colors: [
                  Colors.blueAccent.withValues(alpha: 0.3),
                  Colors.cyanAccent.withValues(alpha: 0.3),
                  Colors.purpleAccent.withValues(alpha: 0.3),
                  Colors.blueAccent.withValues(alpha: 0.3),
                ],
                transform: GradientRotation(
                  _rotationController.value * 2 * 3.14159,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withValues(
                    alpha: 0.5 * _glowAnimation.value,
                  ),
                  blurRadius: 25 * _glowAnimation.value,
                  spreadRadius: 3 * _glowAnimation.value,
                ),
                BoxShadow(
                  color: Colors.purpleAccent.withValues(
                    alpha: 0.2 * _glowAnimation.value,
                  ),
                  blurRadius: 40 * _glowAnimation.value,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.85),
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
                        child: Center(
                          child: Image.asset(
                            'assets/images/bixby.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),

                      // Expanded Content
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
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
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    readOnly: _charIndex < _fullText.length || widget.isWaiting,
                                    onSubmitted: (value) {
                                      if (value.isNotEmpty &&
                                          widget.onSend != null) {
                                        widget.onSend!(value);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              if (_charIndex >= _fullText.length)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _FocusableActionIcon(
                                      icon: Icons.mic_rounded,
                                      size: 34,
                                      focusNode: _micFocusNode,
                                      isEnabled: false, // Mic is always disabled for now, but also check waiting if needed
                                      onTap: () {
                                        // Handle Mic Tap
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    _FocusableActionIcon(
                                      icon: Icons.send_rounded,
                                      size: 30,
                                      focusNode: _sendFocusNode,
                                      isEnabled: !widget.isWaiting,
                                      onTap: () {
                                        if (_textController.text.isNotEmpty &&
                                            widget.onSend != null) {
                                          widget.onSend!(_textController.text);
                                        }
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
                iconColor = Colors.blueAccent;
              }

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: active
                      ? Colors.blueAccent.withValues(alpha: 0.25)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: Colors.blueAccent.withValues(alpha: 0.4),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  widget.icon,
                  color: iconColor,
                  size: widget.size,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

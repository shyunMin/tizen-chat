import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PromptBar extends StatefulWidget {
  final bool isVisible;
  final bool isWaiting;
  final bool hasChatStarted;
  final Function(String)? onSend;
  final VoidCallback? onCancel;
  final FocusNode? outerFocusNode;
  final VoidCallback? onArrowUp;

  const PromptBar({
    super.key,
    required this.isVisible,
    this.onSend,
    this.onCancel,
    this.isWaiting = false,
    this.hasChatStarted = false,
    this.outerFocusNode,
    this.onArrowUp,
  });

  @override
  State<PromptBar> createState() => _PromptBarState();
}

class _PromptBarState extends State<PromptBar>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isKeyboardMode = false;
  String _displayText = "";
  final String _fullText = "How can I help you?";
  int _charIndex = 0;
  Timer? _typingTimer;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final FocusNode _sendFocusNode = FocusNode();
  final FocusNode _micFocusNode = FocusNode();
  FocusNode? _internalOuterFocusNode;
  FocusNode? _listenedFocusNode;

  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAlpha;

  FocusNode get _outerFocusNode =>
      widget.outerFocusNode ?? (_internalOuterFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _shimmerAlpha = Tween<double>(begin: 0.15, end: 0.65).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _listenedFocusNode = _outerFocusNode;
    _listenedFocusNode!.addListener(_onOuterFocusChange);

    _inputFocusNode.onKeyEvent = (node, event) {
      if (event is KeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          _sendFocusNode.requestFocus();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          if (_isKeyboardMode) {
            _micFocusNode.requestFocus();
          } else {
            _outerFocusNode.requestFocus();
          }
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          widget.onArrowUp?.call();
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    };
  }

  void _onOuterFocusChange() {
    if (_outerFocusNode.hasPrimaryFocus) {
      _shimmerController.repeat(reverse: true);
    } else {
      _shimmerController.stop();
      _shimmerController.reset();
    }
  }

  @override
  void didUpdateWidget(PromptBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.outerFocusNode != oldWidget.outerFocusNode) {
      _listenedFocusNode?.removeListener(_onOuterFocusChange);
      _listenedFocusNode = _outerFocusNode;
      _listenedFocusNode!.addListener(_onOuterFocusChange);
    }

    if (widget.isWaiting && !oldWidget.isWaiting) {
      if (_isKeyboardMode) {
        setState(() => _isKeyboardMode = false);
      }
    }

    if (widget.isVisible && !oldWidget.isVisible) {
      _reset();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => _isExpanded = true);
          _startTyping();
        }
      });
    } else if (!widget.isVisible && oldWidget.isVisible) {
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
      _isKeyboardMode = false;
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
      }
    });
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _listenedFocusNode?.removeListener(_onOuterFocusChange);
    _shimmerController.dispose();
    _textController.dispose();
    _inputFocusNode.dispose();
    _sendFocusNode.dispose();
    _micFocusNode.dispose();
    _internalOuterFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _outerFocusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.select ||
              event.logicalKey == LogicalKeyboardKey.enter) {
            if (_isKeyboardMode) {
              if (_charIndex >= _fullText.length) {
                _inputFocusNode.requestFocus();
              }
            } else {
              _sendFocusNode.requestFocus();
            }
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            widget.onArrowUp?.call();
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: AnimatedBuilder(
        animation: _outerFocusNode,
        builder: (context, child) {
          final isOuterFocused = _outerFocusNode.hasPrimaryFocus;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            width: _isExpanded ? MediaQuery.of(context).size.width / 2 : 64,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                child!,
                if (isOuterFocused)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, _) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: Colors.white.withValues(
                                  alpha: _shimmerAlpha.value,
                                ),
                                width: 1.5,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              left: _isExpanded ? 25 : (32 - 10),
              top: 0,
              bottom: 0,
              child: Center(
                child: _isKeyboardMode
                    ? _FocusableActionIcon(
                        icon: Icons.mic,
                        size: 24,
                        focusNode: _micFocusNode,
                        onArrowLeft: () => _outerFocusNode.requestFocus(),
                        onArrowRight: () => _inputFocusNode.requestFocus(),
                        onTap: () {
                          setState(() => _isKeyboardMode = false);
                          _outerFocusNode.requestFocus();
                        },
                      )
                    : const Icon(Icons.mic, color: Colors.white, size: 24),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isExpanded ? 1.0 : 0.0,
              child: Container(
                height: 52,
                padding: const EdgeInsets.only(left: 80.0, right: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _isKeyboardMode
                          ? TextField(
                              controller: _textController,
                              focusNode: _inputFocusNode,
                              autofocus: false,
                              keyboardType: TextInputType.text,
                              textAlignVertical: TextAlignVertical.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                letterSpacing: 0.3,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                  bottom: 3,
                                ),
                                hintText: _charIndex < _fullText.length
                                    ? _displayText
                                    : _fullText,
                                hintStyle: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              readOnly:
                                  _charIndex < _fullText.length ||
                                  widget.isWaiting,
                              onSubmitted: (value) {
                                if (value.isNotEmpty &&
                                    widget.onSend != null &&
                                    !widget.isWaiting) {
                                  setState(() => _isKeyboardMode = false);
                                  widget.onSend!(value);
                                  _textController.clear();
                                }
                              },
                            )
                          : Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "리모컨의 마이크 버튼을 누른 상태로 질문하세요",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Roboto',
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                    ),
                    if (_charIndex >= _fullText.length)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 6),
                          _FocusableActionIcon(
                            icon: _isKeyboardMode
                                ? (widget.isWaiting
                                      ? Icons.stop_rounded
                                      : Icons.send_rounded)
                                : Icons.keyboard,
                            size: 24,
                            focusNode: _sendFocusNode,
                            isEnabled: true,
                            onArrowLeft: () {
                              if (_isKeyboardMode) {
                                _inputFocusNode.requestFocus();
                              } else {
                                _outerFocusNode.requestFocus();
                              }
                            },
                            onTap: () {
                              if (_isKeyboardMode) {
                                if (widget.isWaiting) {
                                  if (widget.onCancel != null)
                                    widget.onCancel!();
                                  setState(() => _isKeyboardMode = false);
                                } else {
                                  if (_textController.text.isNotEmpty &&
                                      widget.onSend != null) {
                                    final text = _textController.text;
                                    setState(() => _isKeyboardMode = false);
                                    widget.onSend!(text);
                                    _textController.clear();
                                  }
                                }
                              } else {
                                setState(() => _isKeyboardMode = true);
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  _inputFocusNode.requestFocus();
                                });
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
    );
  }
}

class _FocusableActionIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final FocusNode focusNode;
  final VoidCallback onTap;
  final VoidCallback? onArrowLeft;
  final VoidCallback? onArrowRight;
  final bool isEnabled;

  const _FocusableActionIcon({
    required this.icon,
    required this.size,
    required this.focusNode,
    required this.onTap,
    this.onArrowLeft,
    this.onArrowRight,
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
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.select ||
              event.logicalKey == LogicalKeyboardKey.enter) {
            _pressController.forward().then((_) => _pressController.reverse());
            widget.onTap();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
              widget.onArrowLeft != null) {
            widget.onArrowLeft!();
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
              widget.onArrowRight != null) {
            widget.onArrowRight!();
            return KeyEventResult.handled;
          }
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
                child: Icon(widget.icon, color: iconColor, size: widget.size),
              );
            },
          ),
        ),
      ),
    );
  }
}

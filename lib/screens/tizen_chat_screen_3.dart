import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/dim_overlay.dart';
import '../widgets/prompt_bar.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/generative_ui_screen.dart';
import '../services/carbon_grpc_service.dart';
import '../models/chat_message.dart';
import 'chat_screen.dart'; // Import the original Chat Screen
import '../features/http_message_overlay/http_message_overlay_screen.dart';
import 'dart:async';
import '../features/http_message_overlay/http_message_bus.dart';

enum ScreenState { initial, chat, generativeUI, overlay }

class TizenChatScreen3 extends StatefulWidget {
  const TizenChatScreen3({super.key});

  @override
  State<TizenChatScreen3> createState() => _TizenChatScreen3State();
}

class _TizenChatScreen3State extends State<TizenChatScreen3>
    with TickerProviderStateMixin {
  bool _isVisible = false;
  bool _isWaiting = false;
  bool _shouldSlideDown = true;
  String _responseMessage = "";
  String _statusMessage = "";

  ScreenState _activeScreen = ScreenState.initial;
  String _currentText = "";
  final List<ChatMessage> _messages = [];

  final FocusNode _keyboardFocusNode = FocusNode();
  final CarbonGrpcService _grpcService = CarbonGrpcService.instance;
  StreamSubscription<String>? _messageBusSubscription;
  final StreamController<String> _externalMessageController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _startHttpMessageBus();

    // Ensure focus is requested after initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardFocusNode.requestFocus();
    });
  }

  Future<void> _initializeServices() async {
    // Only try once at startup as requested
    try {
      await _grpcService.connect();
    } catch (e) {
      print('DEBUG: Initial status check failed: $e');
    }
  }

  Future<void> _startHttpMessageBus() async {
    try {
      await HttpMessageBus.instance.acquire();
    } catch (e) {
      // 서버 시작 실패 → UI에 영향 없이 무시
      print('[REQ_006] HttpMessageBus acquire failed: $e');
    }
    _messageBusSubscription = HttpMessageBus.instance.stream.listen((msg) {
      if (!mounted) return;
      if (_activeScreen == ScreenState.overlay) return; // overlay가 자체 처리
      if (_activeScreen == ScreenState.initial && _isVisible) {
        // 첫 화면에서 메시지 수신 시 바로 채팅창으로 전환하며 자동 전송
        _pushScreen(
          TizenChatScreen(
            autoSendText: msg,
            externalMessageStream: _externalMessageController.stream,
          ),
        );
        return;
      }
      if (_activeScreen == ScreenState.chat) {
        _externalMessageController.add(msg);
        return;
      }
      // 그 외 상태: 무시
    });
  }

  Future<void> _handleSend(String text) async {
    // Explicitly request focus to handle keyboard events after PromptBar hides
    _keyboardFocusNode.requestFocus();

    setState(() {
      _shouldSlideDown = false; // Stay at current height
      _isVisible = false; // Trigger fade out
      _responseMessage = "";
    });

    // Wait for fade animation (200ms) before resetting position to bottom for next time
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        _shouldSlideDown = true;
      });
    }

    // Wait for PromptBar disappear timing (total 300ms feel)
    await Future.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      setState(() {
        _isWaiting = true;
      });
    }

    try {
      setState(() {
        _messages.clear();
        _messages.add(ChatMessage(text: text, type: MessageType.sent));
      });

      String accumulatedText = '';
      String? activeToolName;

      final stream = _grpcService.sendMessage(text);
      await for (final event in stream) {
        if (!mounted) break;

        switch (event) {
          case CarbonTextDelta(:final content):
            accumulatedText += content;
            // Generative UI format detect logic mock or usage
            if (accumulatedText.contains('```dart')) {
              // naive extraction if you wanted, but genui expects rawText usually
            }
            setState(() {
              _currentText = accumulatedText;
            });
            break;
          case CarbonToolUseStart(:final toolName):
            activeToolName = toolName;
            setState(() {
              _statusMessage = '🔧 $toolName 실행 중...';
            });
            break;
          case CarbonToolResult():
            setState(() {
              _statusMessage = '';
            });
            break;
          case CarbonTurnComplete():
            setState(() {
              _isWaiting = false;
              if (activeToolName == null && accumulatedText.trim().isEmpty) {
                accumulatedText = '에이전트로부터 응답을 받지 못했습니다. (Empty response)';
              }
              _currentText = accumulatedText;

              final receivedMsg = ChatMessage(
                text: _currentText,
                type: MessageType.received,
                uiCode: null,
              );
              _messages.add(receivedMsg);
            });

            _pushScreen(
              TizenChatScreen(
                initialMessages: List.from(_messages),
                externalMessageStream: _externalMessageController.stream,
              ),
            );
            return;
          case CarbonError(:final fatal, :final message):
            setState(() {
              _isWaiting = false;
              _responseMessage = '오류: $message';
            });
            if (fatal) await _grpcService.reconnect();
            _hideErrorDelay();
            return;
          case CarbonSessionEnded():
            await _grpcService.reconnect();
            return;
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isWaiting = false;
          _responseMessage = "오류 발생: ${e.toString()}";
        });
        _hideErrorDelay();
      }
    }
  }

  void _hideErrorDelay() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _responseMessage = "";
        });
      }
    });
  }

  void _toggleVisibility() {
    // Prevent toggling while waiting for server response
    if (_isWaiting) return;

    // As per user request: No prompt while TizenChatScreen is active
    if (_activeScreen == ScreenState.chat) return;

    setState(() {
      _shouldSlideDown = true;
      _isVisible = !_isVisible;
      if (_isVisible) {
        // Clear response messages when becoming visible to avoid overlap
        _responseMessage = "";
      }
    });
  }

  @override
  void dispose() {
    _messageBusSubscription?.cancel();
    _externalMessageController.close();
    HttpMessageBus.instance.release();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _pushScreen(Widget screen) {
    // Reset visibility to true so it's active when returning
    setState(() {
      _isVisible = true;
      _shouldSlideDown = true;
      if (screen is TizenChatScreen) {
        _activeScreen = ScreenState.chat;
      } else if (screen is GenerativeUIScreen) {
        _activeScreen = ScreenState.generativeUI;
      }
    });

    Navigator.of(context)
        .push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => screen,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        )
        .then((_) {
          // Clear messages when returning from the sub-screen (TizenChatScreen or GenerativeUIScreen)
          // to ensure history is deleted as requested
          if (mounted) {
            setState(() {
              _messages.clear();
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Focus(
        focusNode: _keyboardFocusNode,
        autofocus: true,
        canRequestFocus: _activeScreen != ScreenState.chat,
        descendantsAreFocusable: true,
        onKeyEvent: (node, event) {
          print(
            'DEBUG: [Key] ${event.logicalKey} (${event.runtimeType})',
          ); // 키 입력 로그 추가
          if ((event is KeyDownEvent || event is KeyUpEvent)) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              if (event is KeyDownEvent) {
                _toggleVisibility();
              }
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              if (event is KeyDownEvent) {
                // overlay push 전 상태 변경
                setState(() {
                  _activeScreen = ScreenState.overlay;
                });
                Navigator.of(context)
                    .push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const HttpMessageOverlayScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    )
                    .then((_) {
                      if (mounted) {
                        setState(() {
                          _activeScreen = ScreenState.initial;
                          _messages.clear();
                        });
                      }
                    });
              }
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: SizedBox.expand(
          child: Stack(
            children: [
              // Dim Screen Overlay
              DimOverlay(isVisible: _isVisible || _isWaiting),

              // Prompt Bar with Animation
              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                bottom: (_isVisible || !_shouldSlideDown) ? 60 : -150,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isVisible ? 1.0 : 0.0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 84,
                      child: PromptBar(
                        isVisible: _isVisible,
                        onSend: _handleSend,
                      ),
                    ),
                  ),
                ),
              ),

              // Waiting Animation or Response Message
              if (_isWaiting || _responseMessage.isNotEmpty)
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 84,
                    child: Center(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 100),
                        opacity: (_isWaiting || _responseMessage.isNotEmpty)
                            ? 1.0
                            : 0.0,
                        child: _isWaiting
                            ? const TypingIndicator(
                                showAvatar: false,
                                showBubble: false,
                                dotSize: 10.0,
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueAccent.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  _statusMessage.isNotEmpty
                                      ? _statusMessage
                                      : _responseMessage,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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

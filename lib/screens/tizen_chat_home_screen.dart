import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tizen_app_control/tizen_app_control.dart';
import 'dart:convert';
import '../widgets/dim_overlay.dart';
import '../widgets/chat_window.dart';
import '../services/carbon_grpc_service.dart';
import '../models/chat_message.dart';
import '../services/agent_response_parser.dart';
import 'dart:async';
import '../features/http_message_overlay/http_message_bus.dart';

class TizenChatHomeScreen extends StatefulWidget {
  final bool enableHttpMessageBus;
  const TizenChatHomeScreen({super.key, this.enableHttpMessageBus = true});

  @override
  State<TizenChatHomeScreen> createState() => _TizenChatHomeScreenState();
}

class _TizenChatHomeScreenState extends State<TizenChatHomeScreen>
    with TickerProviderStateMixin {
  // ── UI 상태 ──────────────────────────────────────────────────
  bool _isVisible = false;
  bool _isWaiting = false;
  bool _shouldSlideDown = true;

  // ── 대화창 상태 ──────────────────────────────────────────────
  bool _hasChatStarted = false;
  bool _isTyping = false;
  final List<ChatMessage> _messages = [];
  String _sessionTitle = '';
  final GlobalKey<ChatWindowState> _chatWindowKey = GlobalKey<ChatWindowState>();

  // ── 서비스 ───────────────────────────────────────────────────
  final FocusNode _keyboardFocusNode = FocusNode();
  final CarbonGrpcService _grpcService = CarbonGrpcService.instance;
  StreamSubscription<String>? _messageBusSubscription;

  @override
  void initState() {
    super.initState();
    AppControl.onAppControl.listen(_onAppControlReceived);

    _initializeServices();
    if (widget.enableHttpMessageBus) {
      _startHttpMessageBus();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _keyboardFocusNode.requestFocus();
      // Future.delayed(const Duration(milliseconds: 300), () {
      //   if (mounted) {
      //     setState(() => _isVisible = true);
      //   }
      // });
    });
  }

  void _onAppControlReceived(ReceivedAppControl appControl) async {
    debugPrint('[AppControl] Received! caller: ${appControl.callerAppId}');
    debugPrint('[AppControl] extraData: ${appControl.extraData}');

    try {
      final extraData = appControl.extraData;
      String? messageText;

      // 1. 직접적인 'message' 키 확인
      if (extraData.containsKey('message')) {
        final msg = extraData['message'];
        if (msg is List && msg.isNotEmpty) {
          messageText = msg.first.toString();
        } else {
          messageText = msg.toString();
        }
        debugPrint('[AppControl] Found message in direct key: $messageText');
      } 
      
      // 2. JSON 형태나 기타 키 순회 확인 (위에서 못 찾은 경우)
      if (messageText == null || messageText.isEmpty) {
        for (var entry in extraData.entries) {
          final keyStr = entry.key;
          final valStr = entry.value is List && entry.value.isNotEmpty
              ? entry.value.first.toString()
              : entry.value.toString();

          // Value가 JSON인 경우
          try {
            final decodedVal = jsonDecode(valStr);
            if (decodedVal is Map && decodedVal.containsKey('message')) {
              messageText = decodedVal['message'];
              debugPrint('[AppControl] Found message in decoded value: $messageText');
              break;
            }
          } catch (_) {}

          // Key가 JSON인 경우
          try {
            final decodedKey = jsonDecode(keyStr);
            if (decodedKey is Map && decodedKey.containsKey('message')) {
              messageText = decodedKey['message'];
              debugPrint('[AppControl] Found message in decoded key: $messageText');
              break;
            }
          } catch (_) {}
        }
      }

      if (messageText != null && messageText.isNotEmpty) {
        debugPrint('[AppControl] Proceeding to _handleSend: $messageText');
        if (mounted) {
          _handleSend(messageText!);
        }
      } else {
        debugPrint('[AppControl] No message content found in extraData.');
        // 만약 메시지는 없지만 앱이 깨어났다면, 최소한 점이라도 표시하거나 화면을 활성화할지 결정
        setState(() {
          _isVisible = true; 
        });
      }
    } catch (e) {
      debugPrint('[AppControl] Error processing extraData: $e');
    }
  }

  Future<void> _initializeServices() async {
    try {
      await _grpcService.connect();
    } catch (e) {
      print('DEBUG: Initial connect failed: $e');
    }
  }

  Future<void> _startHttpMessageBus() async {
    try {
      await HttpMessageBus.instance.acquire();
    } catch (e) {
      print('[REQ_006] HttpMessageBus acquire failed: $e');
    }
    _messageBusSubscription = HttpMessageBus.instance.stream.listen((msg) {
      if (!mounted) return;
      _handleSend(msg); // 사용자 입력과 동일하게 처리
    });
  }

  // ────────────────────────────────────────────────────────────
  // 메시지 전송 및 gRPC 스트리밍 처리
  // ────────────────────────────────────────────────────────────
  Future<void> _handleSend(String text) async {
    debugPrint('[Chat] _handleSend called with text: $text');
    if (_isWaiting) {
      debugPrint('[Chat] Already waiting, ignoring...');
      return;
    }

    // 메시지 전송 시점의 상태 갱신
    setState(() {
      if (!_hasChatStarted) {
        _hasChatStarted = true;
        _sessionTitle = text.length > 20 ? '${text.substring(0, 20)}...' : text;
        debugPrint('[Chat] First message! Session title: $_sessionTitle');
      }
      _isVisible = true;
      _isWaiting = true;
      _isTyping = true;
      _shouldSlideDown = false;
      _messages.add(ChatMessage(text: text, type: MessageType.sent));
    });
    debugPrint('[Chat] State updated. _hasChatStarted: $_hasChatStarted, _isVisible: $_isVisible');
    _scrollToBottom();

    try {
      String accumulatedText = '';
      String? activeToolName;
      int replyIndex = -1;

      final stream = _grpcService.sendMessage(text);
      await for (final event in stream) {
        if (!mounted) break;

        // 응답 말풍선이 생겼을 때 타이핑 인디케이터 중지
        if (_isTyping && replyIndex != -1) {
          setState(() => _isTyping = false);
        }

        switch (event) {
          case CarbonTextDelta(:final content):
            accumulatedText += content;
            if (replyIndex == -1) {
              replyIndex = _messages.length;
              setState(() {
                _isTyping = false;
                _messages.add(
                  ChatMessage(
                    text: accumulatedText,
                    type: MessageType.received,
                    isWaiting: true,
                  ),
                );
              });
            } else {
              setState(() {
                _messages[replyIndex] = ChatMessage(
                  text: activeToolName != null
                      ? '[🔧 $activeToolName 실행 중...]\n$accumulatedText'
                      : accumulatedText,
                  type: MessageType.received,
                  isWaiting: true,
                );
              });
            }
            _scrollToBottom();
            break;

          case CarbonToolUseStart(:final toolName):
            activeToolName = toolName;
            if (replyIndex == -1) {
              replyIndex = _messages.length;
              setState(() {
                _isTyping = false;
                _messages.add(
                  ChatMessage(
                    text: '[🔧 $toolName 실행 중...]',
                    type: MessageType.received,
                    isWaiting: true,
                  ),
                );
              });
            } else {
              setState(() {
                _messages[replyIndex] = ChatMessage(
                  text: '[🔧 $toolName 실행 중...]\n$accumulatedText',
                  type: MessageType.received,
                  isWaiting: true,
                );
              });
            }
            _scrollToBottom();
            break;

          case CarbonToolResult():
            activeToolName = null;
            break;

          case CarbonTurnComplete():
            final parsedResponse = AgentResponseParser.parse(accumulatedText);
            setState(() {
              _isWaiting = false;
              _isTyping = false;
              if (replyIndex != -1) {
                _messages[replyIndex] = ChatMessage(
                  text: parsedResponse.content,
                  displayType: parsedResponse.displayType,
                  type: MessageType.received,
                  isWaiting: false,
                  uiCode: parsedResponse.uiCode,
                );
              } else {
                _messages.add(
                  ChatMessage(
                    text: parsedResponse.content,
                    displayType: parsedResponse.displayType,
                    type: MessageType.received,
                    uiCode: parsedResponse.uiCode,
                  ),
                );
              }
            });
            _scrollToBottom();
            return;

          case CarbonError(:final fatal, :final message):
            setState(() {
              _isWaiting = false;
              _isTyping = false;
            });
            if (fatal) await _grpcService.reconnect();
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
          _isTyping = false;
        });
      }
    }
  }

  void _scrollToBottom() {
    _chatWindowKey.currentState?.scrollToBottom();
  }

  @override
  void dispose() {
    _messageBusSubscription?.cancel();
    HttpMessageBus.instance.release();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  // ────────────────────────────────────────────────────────────
  // Build
  // ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    debugPrint('[Chat] build() called. _hasChatStarted: $_hasChatStarted, _isVisible: $_isVisible, messages: ${_messages.length}');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Focus(
        focusNode: _keyboardFocusNode,
        autofocus: true,
        descendantsAreFocusable: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape ||
                event.logicalKey == LogicalKeyboardKey.goBack ||
                event.logicalKey == LogicalKeyboardKey.browserBack) {
              SystemNavigator.pop();
              return KeyEventResult.handled;
            }

            // // 리모컨 상/하 키로 스크롤 처리
            // if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            //   if (_scrollController.hasClients) {
            //     final newOffset = (_scrollController.offset - 150).clamp(
            //       0.0,
            //       _scrollController.position.maxScrollExtent,
            //     );
            //     _scrollController.animateTo(
            //       newOffset,
            //       duration: const Duration(milliseconds: 200),
            //       curve: Curves.easeOut,
            //     );
            //     return KeyEventResult.handled;
            //   }
            // }
            // if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            //   if (_scrollController.hasClients) {
            //     final newOffset = (_scrollController.offset + 150).clamp(
            //       0.0,
            //       _scrollController.position.maxScrollExtent,
            //     );
            //     _scrollController.animateTo(
            //       newOffset,
            //       duration: const Duration(milliseconds: 200),
            //       curve: Curves.easeOut,
            //     );
            //     return KeyEventResult.handled;
            //   }
            // }
          }
          return KeyEventResult.ignored;
        },
        child: SizedBox.expand(
          child: Stack(
            children: [
              // ── 0. 실시간 상태 표시 (초록색 동그라미) ─────────
              if (!_hasChatStarted)
                Positioned(
                  top: 30,
                  right: 30,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withValues(alpha: 0.6),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.mic_none,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

              // ── 1. Dim Overlay ─────────────────────────────
              if (_hasChatStarted)
                DimOverlay(isVisible: _isVisible || _isWaiting, opacity: 1.0),

              // ── 2. 대화창 (첫 메시지 전송 후 표시) ─────────
              if (_hasChatStarted)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  bottom: 138,
                  left: 0,
                  right: 0,
                  child: ChatWindow(
                    key: _chatWindowKey,
                    messages: _messages,
                    isTyping: _isTyping,
                    sessionTitle: _sessionTitle,
                  ),
                ),

              // ── 3. PromptBar ────────────────────────────────
              // AnimatedPositioned(
              //   key: const ValueKey('prompt-bar'),
              //   duration: const Duration(milliseconds: 600),
              //   curve: Curves.easeOutCubic,
              //   bottom: (_isVisible || !_shouldSlideDown) ? 60 : -150,
              //   left: 0,
              //   right: 0,
              //   child: AnimatedOpacity(
              //     duration: const Duration(milliseconds: 200),
              //     opacity: _isVisible ? 1.0 : 0.0,
              //     child: Align(
              //       alignment: Alignment.bottomCenter,
              //       child: SizedBox(
              //         height: 70,
              //         child: PromptBar(
              //           isVisible: _isVisible,
              //           isWaiting: _isWaiting,
              //           hasChatStarted: _hasChatStarted,
              //           onSend: _handleSend,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../widgets/dim_overlay.dart';
import '../widgets/prompt_bar.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/received_message.dart';
import '../widgets/sent_message.dart';
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
  final ScrollController _scrollController = ScrollController();

  // ── 서비스 ───────────────────────────────────────────────────
  final FocusNode _keyboardFocusNode = FocusNode();
  final CarbonGrpcService _grpcService = CarbonGrpcService.instance;
  StreamSubscription<String>? _messageBusSubscription;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    if (widget.enableHttpMessageBus) {
      _startHttpMessageBus();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _keyboardFocusNode.requestFocus();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() => _isVisible = true);
        }
      });
    });
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
    if (_isWaiting) return;
    _keyboardFocusNode.requestFocus();

    // 첫 메시지일 때만 세션 초기화, 이후는 대화 이어가기
    setState(() {
      if (!_hasChatStarted) {
        _sessionTitle = text.length > 20 ? '${text.substring(0, 20)}...' : text;
        _hasChatStarted = true;
      }
      _isWaiting = true;
      _isTyping = true;
      _shouldSlideDown = false;
      _messages.add(ChatMessage(text: text, type: MessageType.sent));
    });
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageBusSubscription?.cancel();
    HttpMessageBus.instance.release();
    _keyboardFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ────────────────────────────────────────────────────────────
  // Build
  // ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Focus(
        focusNode: _keyboardFocusNode,
        autofocus: true,
        descendantsAreFocusable: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.escape ||
                  event.logicalKey == LogicalKeyboardKey.goBack ||
                  event.logicalKey == LogicalKeyboardKey.browserBack)) {
            SystemNavigator.pop();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: SizedBox.expand(
          child: Stack(
            children: [
              // ── 1. Dim Overlay ─────────────────────────────
              DimOverlay(isVisible: _isVisible || _isWaiting, opacity: 1.0),

              // ── 2. 대화창 (첫 메시지 전송 후 표시) ─────────
              if (_hasChatStarted)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  bottom:
                      138, // 60(PromptBar bottom) + 70(PromptBar height) + 8(gap)
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.7,
                        maxHeight: screenHeight * 0.65,
                      ),
                      child: AnimatedSize(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[900]?.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 24,
                                spreadRadius: 2,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 세션 헤더
                              _SessionHeader(title: _sessionTitle),

                              // 메시지 목록
                              Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    4,
                                    12,
                                    12,
                                  ),
                                  itemCount:
                                      _messages.length + (_isTyping ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    // 타이핑 인디케이터
                                    if (_isTyping &&
                                        index == _messages.length) {
                                      return const Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: TypingIndicator(
                                          showAvatar: true,
                                        ),
                                      );
                                    }

                                    final message = _messages[index];
                                    Widget messageWidget;

                                    switch (message.type) {
                                      case MessageType.sent:
                                        messageWidget = SentMessage(
                                          text: message.text,
                                        );
                                        break;
                                      case MessageType.received:
                                        messageWidget = ReceivedMessage(
                                          text: message.text,
                                          avatarInitial: message.senderInitial,
                                          isWaiting: message.isWaiting,
                                          displayType: message.displayType,
                                        );
                                        break;
                                      default:
                                        messageWidget = SentMessage(
                                          text: message.text,
                                        );
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: messageWidget,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // ── 3. PromptBar ────────────────────────────────
              AnimatedPositioned(
                key: const ValueKey('prompt-bar'),
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
                      height: 70,
                      child: PromptBar(
                        isVisible: _isVisible,
                        isWaiting: _isWaiting,
                        hasChatStarted: _hasChatStarted,
                        onSend: _handleSend,
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

// ────────────────────────────────────────────────────────────────
// 세션 헤더 위젯
// 추후 세션 목록 탭으로 확장 가능하도록 title/sessionId 파라미터 분리
// ────────────────────────────────────────────────────────────────
class _SessionHeader extends StatelessWidget {
  final String title;

  const _SessionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

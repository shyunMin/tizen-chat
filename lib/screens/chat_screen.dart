import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../widgets/received_message.dart';
import '../widgets/sent_message.dart';
import '../widgets/rich_card_message.dart';
import '../widgets/typing_indicator.dart';
import '../models/chat_message.dart';
import '../services/carbon_grpc_service.dart';
import '../features/http_message_overlay/http_message_bus.dart';
import '../services/agent_response_parser.dart';

class TizenChatScreen extends StatefulWidget {
  final List<ChatMessage>? initialMessages;
  final Stream<String>? externalMessageStream;
  final String? autoSendText; // 추가: 진입 시 자동 전송할 메시지

  const TizenChatScreen({
    super.key,
    this.initialMessages,
    this.externalMessageStream,
    this.autoSendText, // 추가
  });

  @override
  State<TizenChatScreen> createState() => _TizenChatScreenState();
}

class _TizenChatScreenState extends State<TizenChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final CarbonGrpcService _grpcService = CarbonGrpcService.instance;
  final FocusNode _keyboardFocusNode = FocusNode();
  bool _isTyping = false;
  late List<ChatMessage> _messages;
  StreamSubscription<String>? _externalSubscription;

  @override
  void initState() {
    super.initState();
    _messages = widget.initialMessages != null
        ? List<ChatMessage>.from(widget.initialMessages!)
        : [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    if (widget.autoSendText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleUserMessage(widget.autoSendText!);
      });
    }

    _initMessageBus();
  }

  Future<void> _initMessageBus() async {
    try {
      await HttpMessageBus.instance.acquire();
    } catch (e) {
      print('[TizenChatScreen] HttpMessageBus acquire failed: $e');
    }

    // Listen to global bus or the passed stream.
    // Usually HttpMessageBus.instance.stream is preferred as it's the source.
    _externalSubscription = HttpMessageBus.instance.stream.listen((msg) {
      if (mounted) _handleUserMessage(msg);
    });
  }

  void _addMessage(ChatMessage message) {
    print(
      'DEBUG: [UI Message Added] type: ${message.type}, text: ${message.text.length > 20 ? "${message.text.substring(0, 20)}..." : message.text}',
    );
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
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

  // BEGIN: API LOGIC - Send message to Agent via gRPC
  Future<void> _handleUserMessage(String text) async {
    if (_isTyping) return; // Prevent duplicate sending while already processing

    _addMessage(ChatMessage(text: text, type: MessageType.sent));

    // Show typing indicator momentarily until the stream starts
    setState(() {
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      String accumulatedText = '';
      String? activeToolName;

      // 자리 마련을 위한 빈 응답 메시지는 스트림 시작 직전이 아닌,
      // 실제 텍스트 데이터(delta)가 올 때 생성하도록 로직 변경
      int replyIndex = -1;

      final stream = _grpcService.sendMessage(text);

      await for (final event in stream) {
        if (!mounted) break;

        // 실제 화면에 메시지 말풍선이 생겼을 때만 타이핑 인디케이터 중지
        if (_isTyping && replyIndex != -1) {
          setState(() {
            _isTyping = false;
          });
        }

        switch (event) {
          case CarbonTextDelta(:final content):
            accumulatedText += content;
            if (replyIndex == -1) {
              // 첫 데이터 수신 시점에 메시지 객체 생성
              replyIndex = _messages.length;
              _addMessage(
                ChatMessage(
                  text: accumulatedText,
                  type: MessageType.received,
                  isWaiting: true,
                ),
              );
              setState(() {
                _isTyping = false;
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
              // 도구 실행 시작 시점에 메시지 객체 생성 (아무런 텍스트가 없을 때 대응)
              replyIndex = _messages.length;
              _addMessage(
                ChatMessage(
                  text: '[🔧 $activeToolName 실행 중...]',
                  type: MessageType.received,
                  isWaiting: true,
                ),
              );
              setState(() {
                _isTyping = false;
              });
            } else {
              setState(() {
                _messages[replyIndex] = ChatMessage(
                  text: '[🔧 $activeToolName 실행 중...]\n$accumulatedText',
                  type: MessageType.received,
                  isWaiting: true,
                );
              });
            }
            _scrollToBottom();
            break;
          case CarbonToolResult():
            activeToolName = null;
            if (replyIndex != -1) {
              setState(() {
                _messages[replyIndex] = ChatMessage(
                  text: accumulatedText.isNotEmpty
                      ? accumulatedText
                      : '도구 실행을 완료했습니다.',
                  type: MessageType.received,
                  isWaiting: true,
                );
              });
            }
            break;
          case CarbonTurnComplete():
            setState(() {
              if (activeToolName == null && accumulatedText.trim().isEmpty) {
                accumulatedText = '에이전트로부터 응답을 받지 못했습니다. (Empty response)';
              }

              // [NEW] 에이전트 응답 파싱
              final parsedResponse = AgentResponseParser.parse(accumulatedText);
              print(
                'DEBUG: [TizenChatScreen] Response Complete. display_type: ${parsedResponse.displayType}',
              );

              if (replyIndex != -1) {
                _messages[replyIndex] = ChatMessage(
                  text: parsedResponse.content,
                  displayType: parsedResponse.displayType,
                  type: MessageType.received,
                  isWaiting: false,
                  uiCode: parsedResponse.uiCode,
                );
              } else {
                // 한 번도 데이터가 안 왔을 경우 예외 처리
                _addMessage(
                  ChatMessage(
                    text: parsedResponse.content,
                    displayType: parsedResponse.displayType,
                    type: MessageType.received,
                    uiCode: parsedResponse.uiCode,
                  ),
                );
              }
              _isTyping = false; // Turn 종료 시 타이핑 상태 해제
            });
            _scrollToBottom();
            break;
          case CarbonError(:final message, :final fatal):
            setState(() {
              if (replyIndex != -1) {
                _messages[replyIndex] = ChatMessage(
                  text: 'Error: $message',
                  type: MessageType.received,
                  isWaiting: false,
                );
              } else {
                _addMessage(
                  ChatMessage(
                    text: 'Error: $message',
                    type: MessageType.received,
                  ),
                );
              }
            });
            if (fatal) await _grpcService.reconnect();
            _scrollToBottom();
            break;
          case CarbonSessionEnded():
            await _grpcService.reconnect();
            return;
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
        _addMessage(
          ChatMessage(
            text: 'Error: Failed to get response from agent. $e',
            type: MessageType.received,
          ),
        );
      }
    }
  }
  // END: API LOGIC

  @override
  void dispose() {
    _externalSubscription?.cancel();
    HttpMessageBus.instance.release();
    _keyboardFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          // 뒤로가기 및 종료
          if (event.logicalKey == LogicalKeyboardKey.escape ||
              event.logicalKey == LogicalKeyboardKey.goBack ||
              event.logicalKey == LogicalKeyboardKey.browserBack) {
            if (event is KeyDownEvent) SystemNavigator.pop();
            return KeyEventResult.handled;
          }

          // 상하 키로 스크롤
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                (_scrollController.offset - 100).clamp(
                  0,
                  _scrollController.position.maxScrollExtent,
                ),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              );
            }
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                (_scrollController.offset + 100).clamp(
                  0,
                  _scrollController.position.maxScrollExtent,
                ),
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              );
            }
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0), // 하단 여백 30
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7, // 너비 70%
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[900]?.withValues(
                    alpha: 0.95,
                  ), // 짙은 회색, 투명도 80
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
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      // Chat Content
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          padding: const EdgeInsets.all(10.0), // 일괄 여백 10
                          itemCount: _messages.length + (_isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Show typing indicator at the end
                            if (_isTyping && index == _messages.length) {
                              return const Padding(
                                padding: EdgeInsets.only(
                                  bottom: 10.0,
                                ), // 불필요한 여백 축소
                                child: TypingIndicator(showAvatar: true),
                              );
                            }

                            final message = _messages[index];
                            Widget messageWidget;

                            switch (message.type) {
                              case MessageType.sent:
                                messageWidget = SentMessage(text: message.text);
                                break;
                              case MessageType.received:
                                messageWidget = ReceivedMessage(
                                  text: message.text,
                                  avatarInitial: message.senderInitial,
                                  uiCode: message.uiCode,
                                  isWaiting: message.isWaiting,
                                  displayType: message.displayType,
                                );
                                break;
                              case MessageType.richCard:
                                messageWidget = RichCardMessage(
                                  imageUrl: message.imageUrl ?? '',
                                  title: message.title ?? '',
                                  subtitle: message.subtitle ?? '',
                                  avatarInitial: message.senderInitial,
                                );
                                break;
                            }

                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10.0,
                              ), // 불필요한 여백 축소
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
      ),
    );
  }
}


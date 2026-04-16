import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../widgets/received_message.dart';
import '../widgets/sent_message.dart';
import '../widgets/rich_card_message.dart';
import '../widgets/tizen_chat_input.dart';
import '../widgets/typing_indicator.dart';
import '../models/chat_message.dart';
import '../theme/tizen_styles.dart';
import '../services/carbon_grpc_service.dart';

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
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
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
      // Use a small delay to ensure the screen is fully pushed before requesting focus
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    });

    if (widget.autoSendText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleUserMessage(widget.autoSendText!);
      });
    }

    _externalSubscription = widget.externalMessageStream?.listen((msg) {
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

        if (_isTyping) {
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
                ChatMessage(text: accumulatedText, type: MessageType.received),
              );
            } else {
              setState(() {
                _messages[replyIndex] = ChatMessage(
                  text: activeToolName != null
                      ? '[🔧 $activeToolName 실행 중...]\n$accumulatedText'
                      : accumulatedText,
                  type: MessageType.received,
                );
              });
            }
            _scrollToBottom();
            break;
          case CarbonToolUseStart(:final toolName):
            activeToolName = toolName;
            if (replyIndex != -1) {
              setState(() {
                _messages[replyIndex] = ChatMessage(
                  text: '[🔧 $activeToolName 실행 중...]\n$accumulatedText',
                  type: MessageType.received,
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
                  text: accumulatedText,
                  type: MessageType.received,
                );
              });
            }
            break;
          case CarbonTurnComplete():
            setState(() {
              if (activeToolName == null && accumulatedText.trim().isEmpty) {
                accumulatedText = '에이전트로부터 응답을 받지 못했습니다. (Empty response)';
              }
              if (replyIndex != -1) {
                _messages[replyIndex] = ChatMessage(
                  text: accumulatedText,
                  type: MessageType.received,
                );
              } else {
                // 한 번도 데이터가 안 왔을 경우 예외 처리
                _addMessage(
                  ChatMessage(
                    text: accumulatedText,
                    type: MessageType.received,
                  ),
                );
              }
            });
            _scrollToBottom();
            break;
          case CarbonError(:final message, :final fatal):
            setState(() {
              if (replyIndex != -1) {
                _messages[replyIndex] = ChatMessage(
                  text: 'Error: $message',
                  type: MessageType.received,
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
    _controller.dispose();
    _focusNode.dispose();
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
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.escape ||
                event.logicalKey == LogicalKeyboardKey.goBack ||
                event.logicalKey == LogicalKeyboardKey.browserBack)) {
          Navigator.of(context).pop();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Scaffold(
        backgroundColor: TizenStyles.slate950,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: TizenStyles.slate950,
          child: SafeArea(
            child: Column(
              children: [
                // Custom Header
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  child: Center(
                    child: GradientText(
                      'Tizen AI',
                      style: TizenStyles.headerText,
                    ),
                  ),
                ),
                // Chat Content
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 20.0,
                    ),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show typing indicator at the end
                      if (_isTyping && index == _messages.length) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 24.0),
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
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: messageWidget,
                      );
                    },
                  ),
                ),

                // Chat Input
                TizenChatInput(
                  controller: _controller,
                  focusNode: _focusNode,
                  onSend: _handleUserMessage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const GradientText(this.text, {super.key, required this.style});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          TizenStyles.headerGradient.createShader(bounds),
      child: Text(text, style: style),
    );
  }
}

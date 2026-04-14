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
// import '../services/chat_service.dart';
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
  // final ChatService _chatService = ChatService();
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
      // 진입 시 자동 전송 요청이 있으면 처리
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleUserMessage(widget.autoSendText!);
      });
    }

    _externalSubscription = widget.externalMessageStream?.listen((msg) {
      if (mounted) _handleUserMessage(msg);
    });
  }

  void _addMessage(ChatMessage message) {
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
    _addMessage(ChatMessage(text: text, type: MessageType.sent));

    // Show typing indicator momentarily until the stream starts
    setState(() {
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      String accumulatedText = '';
      String? activeToolName;
      
      // 예약 시점 저장 후 빈 응답 메시지로 자리 마련
      int replyIndex = _messages.length;
      setState(() {
         _messages.add(ChatMessage(text: '', type: MessageType.received));
      });

      final stream = _grpcService.sendMessage(text);

      await for (final event in stream) {
        if (!mounted) break;

        if (_isTyping) {
            setState(() { _isTyping = false; });
        }

        switch (event) {
          case CarbonTextDelta(:final content):
            accumulatedText += content;
            setState(() {
              _messages[replyIndex] = ChatMessage(
                text: activeToolName != null ? '[🔧 $activeToolName 실행 중...]\n$accumulatedText' : accumulatedText,
                type: MessageType.received,
              );
            });
            _scrollToBottom();
            break;
          case CarbonToolUseStart(:final toolName):
            activeToolName = toolName;
            setState(() {
              _messages[replyIndex] = ChatMessage(
                text: '[🔧 $activeToolName 실행 중...]\n$accumulatedText',
                type: MessageType.received,
              );
            });
            _scrollToBottom();
            break;
          case CarbonToolResult():
            activeToolName = null;
            setState(() {
              _messages[replyIndex] = ChatMessage(
                text: accumulatedText,
                type: MessageType.received,
              );
            });
            break;
          case CarbonTurnComplete():
            setState(() {
              if (activeToolName == null && accumulatedText.trim().isEmpty) {
                 accumulatedText = '에이전트로부터 응답을 받지 못했습니다. (Empty response)';
              }
              _messages[replyIndex] = ChatMessage(
                text: accumulatedText,
                type: MessageType.received,
              );
            });
            _scrollToBottom();
            return;
          case CarbonError(:final message, :final fatal):
            setState(() {
               _messages[replyIndex] = ChatMessage(
                text: 'Error: $message',
                type: MessageType.received,
              );
            });
            if (fatal) await _grpcService.reconnect();
            _scrollToBottom();
            return;
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
    return KeyboardListener(
      focusNode: _keyboardFocusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.escape ||
                event.logicalKey == LogicalKeyboardKey.goBack ||
                event.logicalKey == LogicalKeyboardKey.browserBack)) {
          Navigator.of(context).pop();
        }
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
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  child: Center(
                    child: Text('Tizen AI', style: TizenStyles.headerText),
                  ),
                ),
                // Chat Content
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20.0),
                    itemCount: _messages.length + 1 + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: TizenStyles.slate800.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'TODAY',
                                  style: TizenStyles.dateText,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      }

                      // Show typing indicator at the end
                      if (_isTyping && index == _messages.length + 1) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 24.0),
                          child: TypingIndicator(),
                        );
                      }

                      final message = _messages[index - 1];
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

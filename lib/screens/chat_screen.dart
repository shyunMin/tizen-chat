import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/received_message.dart';
import '../widgets/sent_message.dart';
import '../widgets/rich_card_message.dart';
import '../widgets/tizen_chat_input.dart';
import '../widgets/typing_indicator.dart';
import '../models/chat_message.dart';
import '../theme/tizen_styles.dart';
import '../services/chat_service.dart';

class TizenChatScreen extends StatefulWidget {
  final List<ChatMessage>? initialMessages;

  const TizenChatScreen({super.key, this.initialMessages});

  @override
  State<TizenChatScreen> createState() => _TizenChatScreenState();
}

class _TizenChatScreenState extends State<TizenChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  bool _isTyping = false;
  bool _isServerReady = false;
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = widget.initialMessages != null
        ? List<ChatMessage>.from(widget.initialMessages!)
        : [];

    _checkServerConnection();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      // Use a small delay to ensure the screen is fully pushed before requesting focus
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    });
  }

  Future<void> _checkServerConnection() async {
    try {
      final info = await _chatService.connect();
      if (mounted) {
        setState(() {
          _isServerReady = info['can_chat'] ?? false;
        });
        if (_isServerReady && widget.initialMessages == null) {
          _addMessage(
            ChatMessage(
              text: info['message'] ?? 'Connected to Tizen Home Agent.',
              type: MessageType.received,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isServerReady = false;
        });
        _addMessage(
          ChatMessage(
            text:
                '⚠️ Connection Failed: ${e.toString().replaceAll('Exception: ', '')}\n\n'
                'Please verify:\n'
                '1. The chat server is running on the host PC.\n'
                '2. Port forwarding exists: "sdb reverse tcp:9090 tcp:9090"',
            type: MessageType.received,
          ),
        );
      }
    }
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

  // BEGIN: API LOGIC - Send message to Agent
  Future<void> _handleUserMessage(String text) async {
    _addMessage(ChatMessage(text: text, type: MessageType.sent));

    // Show typing indicator
    setState(() {
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final response = await _chatService.sendMessage(text);
      if (mounted) {
        setState(() {
          _isTyping = false;
        });

        // Extract text response with multiple fallback keys for stability
        final String rawText;
        if (response['text'] != null && response['text'].toString().isNotEmpty) {
          rawText = response['text'].toString();
        } else if (response['response'] != null &&
            response['response'].toString().isNotEmpty) {
          rawText = response['response'].toString();
        } else if (response['content'] != null &&
            response['content'].toString().isNotEmpty) {
          rawText = response['content'].toString();
        } else if (response['message'] != null &&
            response['message'].toString().isNotEmpty) {
          rawText = response['message'].toString();
        } else if (response['response_text'] != null &&
            response['response_text'].toString().isNotEmpty) {
          rawText = response['response_text'].toString();
        } else {
          rawText = '에이전트로부터 응답을 받지 못했습니다. (Empty response)';
        }

        final dynamic rawUiCode = response['ui_code'];
        String? uiCodeStr;
        if (rawUiCode != null) {
          if (rawUiCode is Map || rawUiCode is List) {
            uiCodeStr = jsonEncode(rawUiCode);
          } else {
            uiCodeStr = rawUiCode.toString();
          }
        }

        _addMessage(
          ChatMessage(
            text: rawText,
            type: MessageType.received,
            uiCode: uiCodeStr,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
        _addMessage(
          ChatMessage(
            text: 'Error: Failed to get response from agent.',
            type: MessageType.received,
          ),
        );
      }
    }
  }
  // END: API LOGIC

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(), // Temporary node to catch global key events
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.escape ||
                event.logicalKey == LogicalKeyboardKey.goBack)) {
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

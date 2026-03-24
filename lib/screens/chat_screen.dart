import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/received_message.dart';
import '../widgets/sent_message.dart';
import '../widgets/rich_card_message.dart';
import '../widgets/tizen_chat_input.dart';
import '../widgets/typing_indicator.dart';
import '../models/chat_message.dart';
import '../theme/tizen_styles.dart';
import '../services/chat_service.dart';


class TizenChatScreen extends StatefulWidget {
  const TizenChatScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    _checkServerConnection();
  }

  Future<void> _checkServerConnection() async {
    try {
      final info = await _chatService.connect();
      if (mounted) {
        setState(() {
          _isServerReady = info['can_chat'] ?? false;
        });
        if (_isServerReady) {
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

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          'Welcome to the Tizen OS developer portal. How can we help you innovate today?',
      type: MessageType.received,
    ),
    ChatMessage(
      text:
          "I'm looking for the Tizen SDK 10 Release Notes. Can you provide a link?",
      type: MessageType.sent,
    ),
    ChatMessage(
      text:
          'Certainly. The Tizen SDK 10 includes new features for VStudio extensions and improved emulator performance.',
      type: MessageType.received,
    ),
    ChatMessage(
      text: 'View the full release notes for 2024 updates.',
      type: MessageType.richCard,
      title: 'SDK Documentation',
      subtitle: 'View the full release notes for 2024 updates.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC7YfU4xqiYxcEtCIU54kYFOUWpL8eawB77azl5R_4K1XwgAFWi986TaRXC-jByh4zxp4vW4JS5T_p4m4gvhUXNMx9KxZiu4SLcKj40VRkfBk7AUb8UbqfySoJWy-WOv3RXkBewWD0mHHGRD6GObhvWlF2XUZGxxQkRkj4lBWiZXSmaPfFpeBmVhZe8O5H2T4FzVLOd5CLmnYilxZ_2tjeoOa8WggEdSvdvO0V1SdyF5-rEX1svGDi3MSLtPkk71SRlvvIssJhki4Ao',
    ),
    ChatMessage(
      text: 'View the full release notes for 2024 updates.',
      type: MessageType.richCard,
      title: 'SDK Documentation',
      subtitle: 'View the full release notes for 2024 updates.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC7YfU4xqiYxcEtCIU54kYFOUWpL8eawB77azl5R_4K1XwgAFWi986TaRXC-jByh4zxp4vW4JS5T_p4m4gvhUXNMx9KxZiu4SLcKj40VRkfBk7AUb8UbqfySoJWy-WOv3RXkBewWD0mHHGRD6GObhvWlF2XUZGxxQkRkj4lBWiZXSmaPfFpeBmVhZe8O5H2T4FzVLOd5CLmnYilxZ_2tjeoOa8WggEdSvdvO0V1SdyF5-rEX1svGDi3MSLtPkk71SRlvvIssJhki4Ao',
    ),
    ChatMessage(
      text: '웹뷰 렌더링 정상 작동 확인을 위한 샘플입니다.',
      type: MessageType.received,
      uiCode: '''
<!DOCTYPE html>
<html>
  <body style="background-color: #2D3748; margin: 0; padding: 16px; font-family: sans-serif; color: white;">
    <div style="background: #1E293B; border-radius: 12px; padding: 20px; border: 1px solid #4DA8DA; box-shadow: 0 4px 6px rgba(0,0,0,0.3);">
      <h3 style="margin-top: 0; color: #4DA8DA; display: flex; align-items: center;">
        <span style="margin-right: 8px;">🚀</span> Tizen WebView Test
      </h3>
      <p style="line-height: 1.5; color: #e0e0e0; font-size: 14px;">
        이 영역은 <b>webview_flutter_tizen</b>을 통해 렌더링된 <code>HTML</code> 코드입니다.
      </p>
      <div style="margin-top: 15px;">
        <button onclick="alert('버튼 클릭 이벤트가 정상 작동합니다!')" style="background: #4DA8DA; color: white; border: none; padding: 12px 20px; border-radius: 8px; cursor: pointer; font-weight: bold; width: 100%;">
          작동 테스트
        </button>
      </div>
    </div>
  </body>
</html>
      ''',
    ),

  ];

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
            text: response['text'] ?? 'No response from agent.',
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: TizenStyles.slate900,
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Center(
                  child: Text(
                    'Tizen AI',
                    style: TizenStyles.headerText,
                  ),
                ),
              ),
              // Chat Content
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
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

import 'package:flutter/material.dart';
import '../widgets/received_message.dart';
import '../widgets/sent_message.dart';
import '../widgets/rich_card_message.dart';
import '../widgets/tizen_chat_input.dart';
import '../widgets/typing_indicator.dart';
import '../models/chat_message.dart';
import '../theme/tizen_styles.dart';

class TizenChatScreen extends StatefulWidget {
  const TizenChatScreen({super.key});

  @override
  State<TizenChatScreen> createState() => _TizenChatScreenState();
}

class _TizenChatScreenState extends State<TizenChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Welcome to the Tizen OS developer portal. How can we help you innovate today?',
      type: MessageType.received,
    ),
    ChatMessage(
      text: "I'm looking for the Tizen SDK 10 Release Notes. Can you provide a link?",
      type: MessageType.sent,
    ),
    ChatMessage(
      text: 'Certainly. The Tizen SDK 10 includes new features for VStudio extensions and improved emulator performance.',
      type: MessageType.received,
    ),
    ChatMessage(
      text: 'View the full release notes for 2024 updates.',
      type: MessageType.richCard,
      title: 'SDK Documentation',
      subtitle: 'View the full release notes for 2024 updates.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC7YfU4xqiYxcEtCIU54kYFOUWpL8eawB77azl5R_4K1XwgAFWi986TaRXC-jByh4zxp4vW4JS5T_p4m4gvhUXNMx9KxZiu4SLcKj40VRkfBk7AUb8UbqfySoJWy-WOv3RXkBewWD0mHHGRD6GObhvWlF2XUZGxxQkRkj4lBWiZXSmaPfFpeBmVhZe8O5H2T4FzVLOd5CLmnYilxZ_2tjeoOa8WggEdSvdvO0V1SdyF5-rEX1svGDi3MSLtPkk71SRlvvIssJhki4Ao',
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

  // BEGIN: TEST LOGIC - Echo Message
  void _handleUserMessage(String text) {
    _addMessage(ChatMessage(text: text, type: MessageType.sent));

    // Show typing indicator
    setState(() {
      _isTyping = true;
    });
    _scrollToBottom();

    // 2-second delay before response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
        });
        _addMessage(ChatMessage(
          text: 'Received: $text',
          type: MessageType.received,
          senderInitial: 'T',
        ));
      }
    });
  }
  // END: TEST LOGIC

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
        decoration: const BoxDecoration(
          gradient: TizenStyles.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom Header
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
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
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _messages.length + 1 + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: TizenStyles.slate800.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('TODAY', style: TizenStyles.dateText),
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
      shaderCallback: (bounds) => TizenStyles.headerGradient.createShader(bounds),
      child: Text(text, style: style),
    );
  }
}

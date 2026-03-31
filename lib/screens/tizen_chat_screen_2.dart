import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/dim_overlay.dart';
import '../widgets/prompt_bar.dart';
import '../widgets/typing_indicator.dart';
import '../widgets/generative_ui_screen.dart';
import '../services/chat_service.dart';
import '../models/chat_message.dart';
import 'chat_screen.dart'; // Import the original Chat Screen

enum ScreenState { initial, chat, generativeUI }

class TizenChatScreen2 extends StatefulWidget {
  const TizenChatScreen2({super.key});

  @override
  State<TizenChatScreen2> createState() => _TizenChatScreen2State();
}

class _TizenChatScreen2State extends State<TizenChatScreen2>
    with TickerProviderStateMixin {
  bool _isVisible = false;
  bool _isWaiting = false;
  bool _shouldSlideDown = true;
  String _responseMessage = "";

  ScreenState _activeScreen = ScreenState.initial;
  String _currentText = "";
  String _currentUiCode = "";
  final List<ChatMessage> _messages = [];

  final FocusNode _keyboardFocusNode = FocusNode();
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _chatService.connect();
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
      final response = await _chatService.sendMessage(text);
      if (mounted) {
        // Set data first
        // final rawText = response['text'] ?? '';
        final rawText = response['response'] ?? '';
        final dynamic rawUiCode = response['ui_code'];

        // Clear history to keep only the latest pair for the next screen launch
        _messages.clear();

        // Add user message to history
        _messages.add(ChatMessage(text: text, type: MessageType.sent));

        setState(() {
          _isWaiting = false;
          _currentText = rawText;

          if (rawUiCode != null && rawUiCode.toString().isNotEmpty) {
            _currentUiCode = rawUiCode.toString();
            final chatMsg = ChatMessage(
              text: _currentText,
              type: MessageType.received,
              uiCode: _currentUiCode,
            );
            _messages.add(chatMsg);

            // Push Generative UI Screen
            _pushScreen(
              GenerativeUIScreen(text: _currentText, uiCode: _currentUiCode),
            );
          } else {
            final chatMsg = ChatMessage(
              text: _currentText,
              type: MessageType.received,
            );
            _messages.add(chatMsg);

            // Push Chat Screen with only the current pair
            _pushScreen(TizenChatScreen(initialMessages: List.from(_messages)));
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isWaiting = false;
          _responseMessage = "오류 발생: ${e.toString()}";
        });

        // Hide error message after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _responseMessage = "";
            });
          }
        });
      }
    }
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
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  void _pushScreen(Widget screen) {
    // Reset visibility to true so it's active when returning
    setState(() {
      _isVisible = true;
      _shouldSlideDown = true;
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
          if ((event is KeyDownEvent || event is KeyUpEvent) &&
              (event.logicalKey == LogicalKeyboardKey.altLeft ||
                  event.logicalKey == LogicalKeyboardKey.altRight ||
                  event.logicalKey == LogicalKeyboardKey.metaLeft)) {
            if (event is KeyDownEvent) {
              _toggleVisibility();
            }
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
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
                                _responseMessage,
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/chat_message.dart';
import 'typing_indicator.dart';
import 'received_message.dart';
import 'sent_message.dart';

class ChatWindow extends StatefulWidget {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String sessionTitle;
  final VoidCallback? onHeaderTap;
  final FocusNode? focusNode;
  final VoidCallback? onScrolledToBottomDown;

  const ChatWindow({
    super.key,
    required this.messages,
    required this.isTyping,
    required this.sessionTitle,
    this.onHeaderTap,
    this.focusNode,
    this.onScrolledToBottomDown,
  });

  @override
  State<ChatWindow> createState() => ChatWindowState();
}

class ChatWindowState extends State<ChatWindow>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  FocusNode? _internalFocusNode;

  late final AnimationController _shimmerController;
  late final Animation<double> _shimmerAlpha;

  FocusNode get _scrollFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  static const double _scrollStep = 120.0;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _shimmerAlpha = Tween<double>(begin: 0.15, end: 0.65).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
    _scrollFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_scrollFocusNode.hasFocus) {
      _shimmerController.repeat(reverse: true);
    } else {
      _shimmerController.stop();
      _shimmerController.reset();
    }
  }

  /// 부모에서 호출: 리스트 최하단으로 스크롤
  void scrollToBottom() {
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

  void _scrollUp() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      (_scrollController.offset - _scrollStep).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
  }

  void _scrollDown() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      (_scrollController.offset + _scrollStep).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_scrollController.hasClients && _scrollController.offset > 0.0) {
        _scrollUp();
      }
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 0.1) {
          widget.onScrolledToBottomDown?.call();
        } else {
          _scrollDown();
        }
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _scrollFocusNode.removeListener(_onFocusChange);
    _shimmerController.dispose();
    _scrollController.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final itemCount = widget.messages.length + (widget.isTyping ? 1 : 0);

    return Focus(
      focusNode: _scrollFocusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth / 2,
            maxHeight: screenHeight - 110,
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _scrollFocusNode,
              builder: (context, child) {
                final isFocused = _scrollFocusNode.hasFocus;
                return Stack(
                  children: [
                    child!,
                    if (isFocused)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedBuilder(
                            animation: _shimmerController,
                            builder: (context, _) => DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white
                                      .withValues(alpha: _shimmerAlpha.value),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
              child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(18),
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
                  _SessionHeader(
                    title: widget.sessionTitle,
                    onTap: widget.onHeaderTap,
                  ),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        if (widget.isTyping &&
                            index == widget.messages.length) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: TypingIndicator(showAvatar: true),
                          );
                        }

                        final message = widget.messages[index];
                        final Widget messageWidget;

                        switch (message.type) {
                          case MessageType.sent:
                            messageWidget = SentMessage(text: message.text);
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
                            messageWidget = SentMessage(text: message.text);
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
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
  );
  }
}

class _SessionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _SessionHeader({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
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
      ),
    );
  }
}

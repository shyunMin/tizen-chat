import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/chat_message.dart';
import 'typing_indicator.dart';
import 'received_message.dart';
import 'sent_message.dart';

// ──────────────────────────────────────────────────────────────────────────
// ChatWindow
//
// 대화창 전체를 담당하는 독립 위젯.
//  - messages / isTyping / sessionTitle: 부모에서 주입
//  - ScrollController: 내부 소유 (scrollToBottom() 메서드 제공)
// ──────────────────────────────────────────────────────────────────────────
class ChatWindow extends StatefulWidget {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String sessionTitle;
  final VoidCallback? onHeaderTap; // 세션 헤더 탭 콜백 (추후 세션 목록 연결)

  const ChatWindow({
    super.key,
    required this.messages,
    required this.isTyping,
    required this.sessionTitle,
    this.onHeaderTap,
  });

  @override
  State<ChatWindow> createState() => ChatWindowState();
}

class ChatWindowState extends State<ChatWindow> {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _scrollFocusNode = FocusNode();

  static const double _scrollStep = 120.0;

  @override
  void initState() {
    super.initState();
    // 채팅창이 표시될 때 자동으로 포커스 획득
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _scrollFocusNode.requestFocus();
      }
    });
  }

  /// 부모에서 호웘: 리스트 최하단으로 스크롤
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
        if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 0.1) {
          FocusScope.of(context).focusInDirection(TraversalDirection.down);
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
    _scrollController.dispose();
    _scrollFocusNode.dispose();
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
            maxHeight: screenHeight,
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
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
                  // ── 세션 헤더 ────────────────────────────────
                  _SessionHeader(
                    title: widget.sessionTitle,
                    onTap: widget.onHeaderTap,
                  ),

                  // ── 메시지 목록 ──────────────────────────────
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        // 타이핑 인디케이터
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
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────
// _SessionHeader
// ──────────────────────────────────────────────────────────────────────────
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
            // 세션 목록 접근 힌트 아이콘 (추후 취함)
            // Icon(
            //   Icons.expand_more,
            //   size: 14,
            //   color: Colors.white.withValues(alpha: 0.3),
            // ),
          ],
        ),
      ),
    );
  }
}

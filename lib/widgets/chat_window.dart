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
  final void Function(String text)? onSendMessage;

  const ChatWindow({
    super.key,
    required this.messages,
    required this.isTyping,
    required this.sessionTitle,
    this.onHeaderTap,
    this.focusNode,
    this.onScrolledToBottomDown,
    this.onSendMessage,
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

    // 자식 위젯(메시지 내부 버튼 등)이 포커스를 가지고 있는 경우
    // 현재 포커스가 _scrollFocusNode 자체가 아니라 그 자손 위젯에 있는지 확인합니다.
    final isChildFocused =
        node.hasFocus && FocusManager.instance.primaryFocus != node;

    if (isChildFocused) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        // 1. 현재 뷰포트 내에서 아래 방향으로 이동 시도
        final moved =
            _scrollFocusNode.focusInDirection(TraversalDirection.down);
        if (!moved) {
          // 2. 이동 실패 시, 리스트를 아래로 스크롤하여 새로운 요소 노출 시도
          if (_scrollController.hasClients &&
              _scrollController.offset <
                  _scrollController.position.maxScrollExtent - 10) {
            _scrollDown();
            return KeyEventResult.handled;
          }
          // 3. 리스트 끝이면 PromptBar로 전이
          widget.onScrolledToBottomDown?.call();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored; // 포커스 매니저가 처리하게 둠
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        // 위로 이동 시도
        final moved = _scrollFocusNode.focusInDirection(TraversalDirection.up);
        if (!moved) {
          // 위로 이동 실패 시 리스트 상단 스크롤 시도
          if (_scrollController.hasClients && _scrollController.offset > 10) {
            _scrollUp();
            return KeyEventResult.handled;
          }
          return KeyEventResult.handled; // 상단 도달 시 유지
        }
        return KeyEventResult.ignored;
      } else if (event.logicalKey == LogicalKeyboardKey.escape ||
          event.logicalKey == LogicalKeyboardKey.goBack) {
        // 뒤로가기 시 버튼 포커스 해제하고 다시 ChatWindow(스크롤 모드)로 복귀
        _scrollFocusNode.requestFocus();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    // Browse Mode (ChatWindow 자체가 포커스를 가진 상태)
    if (event.logicalKey == LogicalKeyboardKey.select ||
        event.logicalKey == LogicalKeyboardKey.enter) {
      // 확인 키 누르면 내부 버튼으로 진입.
      // 단순히 nextFocus()를 쓰면 PromptBar로 튈 수 있으므로,
      // 채팅창 상단(Header) 근처에서 아래 방향으로 탐색을 시작하여 자식으로 유도합니다.
      _scrollFocusNode.focusInDirection(TraversalDirection.down);

      // 만약 여전히 ChatWindow가 포커스를 가지고 있다면 (자식 진입 실패),
      // 강제로 다음 포커스를 시도합니다.
      if (_scrollFocusNode.hasFocus) {
        _scrollFocusNode.nextFocus();
      }
      return KeyEventResult.handled;
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
                    child: FocusTraversalGroup(
                      policy: WidgetOrderTraversalPolicy(),
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
                               onCommand: widget.onSendMessage,
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

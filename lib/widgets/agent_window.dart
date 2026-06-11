import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/chat_message.dart';
import '../theme/tizen_styles.dart';
import 'agent_effects.dart';
import 'received_message.dart';
import 'sent_message.dart';
import 'typing_dots_indicator.dart';

class AgentWindow extends StatefulWidget {
  final List<ChatMessage> messages;
  final bool isThreadInFlight;
  final bool isConnecting;
  final String? typingLabel;
  final DateTime? requestStartTime;
  final FocusNode? focusNode;
  final VoidCallback? onScrolledToBottomDown;

  const AgentWindow({
    super.key,
    required this.messages,
    required this.isThreadInFlight,
    this.isConnecting = false,
    this.typingLabel,
    this.requestStartTime,
    this.focusNode,
    this.onScrolledToBottomDown,
  });

  @override
  State<AgentWindow> createState() => AgentWindowState();
}

class AgentWindowState extends State<AgentWindow> {
  final ScrollController _scrollController = ScrollController();
  FocusNode? _internalFocusNode;

  FocusNode get _scrollFocusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  static const double _scrollStep = 96.0;



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
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 0.1) {
          widget.onScrolledToBottomDown?.call();
        } else {
          _scrollDown();
        }
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _scrollFocusNode,
      onKeyEvent: _handleKeyEvent,
      child: Align(
        alignment: Alignment.centerLeft,
        heightFactor: 1.0, // Force Align to shrink-wrap vertically
        widthFactor: 1.0, // Force Align to shrink-wrap horizontally
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: TizenStyles.colMax),
          child: AgentVisibilityShadow(
            type: VisibilityShadowType.window,
            child: AgentBackgroundEffects(
              isProcessing: widget.isThreadInFlight,
              borderRadius: TizenStyles.windowCardRadius,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    TizenStyles.windowCardRadius,
                  ),
                  boxShadow: const [TizenStyles.windowShadow],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    TizenStyles.windowCardRadius,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF141822).withValues(alpha: 0.6),
                    ),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.bottomLeft,
                      clipBehavior: Clip.hardEdge,
                      child: widget.isThreadInFlight
                          ? _LoadingItem(
                              label: widget.typingLabel ?? '분석 중',
                              startTime:
                                  widget.requestStartTime ?? DateTime.now(),
                            )
                          : widget.isConnecting
                          ? const _ConnectingItem()
                          : widget.messages.isEmpty
                          ? const _WelcomeItem()
                          : IntrinsicHeight(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 11.5,
                                ),
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 22.0,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                      widget.messages.length,
                                      (index) {
                                        final message = widget.messages[index];
                                        final Widget messageWidget;

                                        switch (message.type) {
                                          case MessageType.sent:
                                            messageWidget = SentMessage(
                                              text: message.text,
                                              isWaiting: message.isWaiting,
                                            );
                                            break;
                                          case MessageType.received:
                                            messageWidget = ReceivedMessage(
                                              text: message.text,
                                              isWaiting: message.isWaiting,
                                              displayType: message.displayType,
                                              phaseTitle: message.phaseTitle,
                                              tools: message.tools,
                                              validationPassed:
                                                  message.validationPassed,
                                              currentToolIndicator:
                                                  message.currentToolIndicator,
                                              elapsedSeconds:
                                                  message.elapsedSeconds,
                                            );
                                            break;
                                        }

                                        final isLast =
                                            index == widget.messages.length - 1;
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: isLast
                                                ? 0.0
                                                : TizenStyles.messageSpacing,
                                          ),
                                          child: messageWidget,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
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

class _LoadingItem extends StatefulWidget {
  final String label;
  final DateTime startTime;

  const _LoadingItem({required this.label, required this.startTime});

  @override
  State<_LoadingItem> createState() => _LoadingItemState();
}

class _LoadingItemState extends State<_LoadingItem> {
  Timer? _timer;
  bool _showLabel = false;

  @override
  void initState() {
    super.initState();
    _checkElapsedTime();
  }

  void _checkElapsedTime() {
    final elapsed = DateTime.now().difference(widget.startTime);
    if (elapsed.inSeconds >= 5) {
      _showLabel = true;
    } else {
      _timer = Timer(const Duration(seconds: 5) - elapsed, () {
        if (mounted) {
          setState(() {
            _showLabel = true;
          });
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant _LoadingItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startTime != widget.startTime) {
      _timer?.cancel();
      _showLabel = false;
      _checkElapsedTime();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49.0,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_showLabel)
            Text(
              widget.label,
              style: TizenStyles.bodyText.copyWith(
                color: const Color(0xFF8F8F8F),
                fontSize: TizenStyles.tProcBusy,
              ),
            )
          else ...[
            Text(
              '\u200b',
              style: TizenStyles.bodyText.copyWith(
                fontSize: TizenStyles.tProcBusy,
              ),
            ), // 높이 고정용 Zero-width space
            const TypingDotsIndicator(),
          ],
        ],
      ),
    );
  }
}

class _ConnectingItem extends StatefulWidget {
  const _ConnectingItem();

  @override
  State<_ConnectingItem> createState() => _ConnectingItemState();
}

class _ConnectingItemState extends State<_ConnectingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49.0,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '연결 중',
            style: TizenStyles.bodyText.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: TizenStyles.tProcBusy,
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeItem extends StatelessWidget {
  const _WelcomeItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 49.0,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '무엇을 도와 드릴까요?',
            style: TizenStyles.bodyText.copyWith(
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

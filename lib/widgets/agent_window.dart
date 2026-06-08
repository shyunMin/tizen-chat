import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/elapsed_timer.dart';
import '../models/chat_message.dart';
import '../theme/tizen_styles.dart';
import 'agent_effects.dart';
import 'received_message.dart';
import 'sent_message.dart';

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

  static const double _scrollStep = 120.0;



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
    }

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
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
    _scrollController.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Focus(
      focusNode: _scrollFocusNode,
      onKeyEvent: _handleKeyEvent,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth / 2,
            maxHeight: screenHeight - TizenStyles.agentWindowHeightReserved,
          ),
          child: AgentBackgroundEffects(
            isProcessing: widget.isThreadInFlight,
            borderRadius: TizenStyles.windowCardRadius,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(TizenStyles.windowCardRadius),
                  boxShadow: const [TizenStyles.windowShadow],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Flexible(
                      child: widget.isThreadInFlight
                          ? _LoadingItem(
                              label: widget.typingLabel ?? '생각 중이에요...',
                              startTime: widget.requestStartTime ?? DateTime.now(),
                            )
                          : widget.isConnecting
                              ? const _ConnectingItem()
                              : widget.messages.isEmpty
                                  ? const _WelcomeItem()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      controller: _scrollController,
                                      padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
                                      itemCount: widget.messages.length,
                                      itemBuilder: (context, index) {
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
                                      validationPassed: message.validationPassed,
                                      currentToolIndicator:
                                          message.currentToolIndicator,
                                      elapsedSeconds: message.elapsedSeconds,
                                    );
                                    break;
                                }

                                final isLast = index == widget.messages.length - 1;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: isLast ? 0.0 : TizenStyles.messageSpacing,
                                  ),
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

class _LoadingItem extends StatefulWidget {
  final String label;
  final DateTime startTime;

  const _LoadingItem({required this.label, required this.startTime});

  @override
  State<_LoadingItem> createState() => _LoadingItemState();
}

class _LoadingItemState extends State<_LoadingItem> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
      child: Text(
        '${widget.label}\nWorking · ${ElapsedTimer.format(widget.startTime)}',
        style: TizenStyles.bodyText.copyWith(color: Colors.white.withValues(alpha: 0.5)),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
      child: Text(
        '연결 중이에요...',
        style: TizenStyles.bodyText.copyWith(color: Colors.white.withValues(alpha: 0.7)),
      ),
    );
  }
}

class _WelcomeItem extends StatelessWidget {
  const _WelcomeItem();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
      child: Text(
        '무엇을 도와 드릴까요?',
        style: TizenStyles.bodyText.copyWith(
          color: Colors.white.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

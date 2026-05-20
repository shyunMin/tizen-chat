import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/elapsed_timer.dart';
import '../models/chat_message.dart';
import '../theme/tizen_styles.dart';
import 'received_message.dart';
import 'sent_message.dart';

class ChatWindow extends StatefulWidget {
  final List<ChatMessage> messages;
  final bool isThreadInFlight;
  final bool isConnecting;
  final String? typingLabel;
  final DateTime? requestStartTime;
  final FocusNode? focusNode;
  final VoidCallback? onScrolledToBottomDown;

  const ChatWindow({
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

    return Focus(
      focusNode: _scrollFocusNode,
      onKeyEvent: _handleKeyEvent,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: screenWidth / 2,
            maxHeight: screenHeight - TizenStyles.chatWindowHeightReserved,
          ),
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
                                borderRadius: BorderRadius.circular(TizenStyles.windowBorderRadius),
                                border: Border.all(
                                  color: Colors.white.withValues(
                                    alpha: _shimmerAlpha.value,
                                  ),
                                  width: TizenStyles.focusBorderWidth,
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
                  borderRadius: BorderRadius.circular(TizenStyles.windowBorderRadius),
                  boxShadow: const [TizenStyles.windowShadow],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
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
                                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
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
                                      avatarInitial: message.senderInitial,
                                      isWaiting: message.isWaiting,
                                      displayType: message.displayType,
                                      phaseTitle: message.phaseTitle,
                                      tools: message.tools,
                                      validationPassed: message.validationPassed,
                                      currentToolIndicator:
                                          message.currentToolIndicator,
                                    );
                                    break;
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: TizenStyles.messageSpacing,
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

class _LoadingItemState extends State<_LoadingItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _shimmer.repeat();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _shimmer.dispose();
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: TizenStyles.avatarSpinnerSize,
                height: TizenStyles.avatarSpinnerSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    TizenStyles.cyan400.withValues(alpha: 0.8),
                  ),
                ),
              ),
              CircleAvatar(
                radius: TizenStyles.avatarRadius,
                backgroundColor: TizenStyles.slate800,
                child: const Text(
                  'T',
                  style: TextStyle(
                    fontSize: TizenStyles.avatarInitialFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: TizenStyles.avatarGap),
          Flexible(
            child: AnimatedBuilder(
              animation: _shimmer,
              builder: (context2, child2) {
                final p = _shimmer.value;
                return ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (Rect bounds) {
                    final x = -1.5 + 3.5 * p;
                    return LinearGradient(
                      begin: Alignment(x - 0.8, 0),
                      end: Alignment(x + 0.8, 0),
                      colors: [
                        Colors.white.withValues(alpha: 0.45),
                        Colors.white.withValues(alpha: 0.95),
                        Colors.white.withValues(alpha: 0.45),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    '${widget.label}\nWorking · ${ElapsedTimer.format(widget.startTime)}',
                    style: TizenStyles.bodyText.copyWith(color: Colors.white),
                  ),
                );
              },
            ),
          ),
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

class _ConnectingItemState extends State<_ConnectingItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: TizenStyles.avatarRadius,
            backgroundColor: TizenStyles.slate800,
            child: const Text(
              'T',
              style: TextStyle(
                fontSize: TizenStyles.avatarInitialFontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: TizenStyles.avatarGap),
          Flexible(
            child: AnimatedBuilder(
              animation: _shimmer,
              builder: (context, child) {
                final p = _shimmer.value;
                return ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (Rect bounds) {
                    final x = -1.5 + 3.5 * p;
                    return LinearGradient(
                      begin: Alignment(x - 0.8, 0),
                      end: Alignment(x + 0.8, 0),
                      colors: [
                        Colors.white.withValues(alpha: 0.15),
                        Colors.white.withValues(alpha: 0.65),
                        Colors.white.withValues(alpha: 0.15),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ).createShader(bounds);
                  },
                  child: Text(
                    '연결 중이에요...',
                    style: TizenStyles.bodyText.copyWith(color: Colors.white),
                  ),
                );
              },
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: TizenStyles.avatarRadius,
            backgroundColor: TizenStyles.slate800,
            child: const Text(
              'T',
              style: TextStyle(
                fontSize: TizenStyles.avatarInitialFontSize,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: TizenStyles.avatarGap),
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

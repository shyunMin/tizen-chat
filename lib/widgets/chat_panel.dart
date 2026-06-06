import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../theme/tizen_styles.dart';
import 'action_button_bar.dart';
import 'chat_window.dart';

/// 사용자 요청 라벨 + ChatWindow + ActionBar를 하나로 묶은 화면 단위.
/// ActionBar는 [actionButtons]가 비어 있으면 숨겨진다.
class ChatPanel extends StatelessWidget {
  final String? lastSentText;
  final GlobalKey<ChatWindowState> chatWindowKey;
  final FocusNode focusNode;
  final VoidCallback? onScrolledToBottomDown;
  final List<ChatMessage> messages;
  final bool isConnecting;
  final bool isThreadInFlight;
  final String typingLabel;
  final DateTime? requestStartTime;

  final List<String> actionButtons;
  final void Function(String) onSend;
  final GlobalKey<ActionButtonBarState> actionBarKey;
  final VoidCallback? onArrowUp;
  final VoidCallback? onArrowDown;

  static const double _panelHorizontalMargin = TizenStyles.promptBarLeft;
  static const double _actionBarGap = TizenStyles.promptBarLeft;

  const ChatPanel({
    super.key,
    required this.lastSentText,
    required this.chatWindowKey,
    required this.focusNode,
    this.onScrolledToBottomDown,
    required this.messages,
    required this.isConnecting,
    required this.isThreadInFlight,
    required this.typingLabel,
    this.requestStartTime,
    required this.actionButtons,
    required this.onSend,
    required this.actionBarKey,
    this.onArrowUp,
    this.onArrowDown,
  });

  @override
  Widget build(BuildContext context) {
    final showActionBar = actionButtons.isNotEmpty;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _panelHorizontalMargin),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (lastSentText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Text(
                    '"$lastSentText"',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TizenStyles.bodyText.copyWith(
                      color: Colors.white,
                      fontSize: TizenStyles.baseFontSize * 0.9,
                    ),
                  ),
                ),
              ChatWindow(
                key: chatWindowKey,
                focusNode: focusNode,
                onScrolledToBottomDown: onScrolledToBottomDown,
                messages: messages,
                isConnecting: isConnecting,
                isThreadInFlight: isThreadInFlight,
                typingLabel: typingLabel,
                requestStartTime: requestStartTime,
              ),
            ],
          ),
        ),
        if (showActionBar) ...[
          const SizedBox(height: _actionBarGap),
          ActionButtonBar(
            key: actionBarKey,
            buttons: actionButtons,
            onSend: onSend,
            onArrowUp: onArrowUp,
            onArrowDown: onArrowDown,
          ),
        ],
      ],
    );
  }
}

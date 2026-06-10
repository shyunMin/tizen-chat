import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../theme/tizen_styles.dart';
import 'action_button_bar.dart';
import 'agent_window.dart';
import 'agent_effects.dart';

/// 사용자 요청 라벨 + AgentWindow + ActionBar를 하나로 묶은 화면 단위.
/// ActionBar는 [actionButtons]가 비어 있으면 숨겨진다.
class AgentPanel extends StatelessWidget {
  final String? lastSentText;
  final GlobalKey<AgentWindowState> agentWindowKey;
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

  static const double _panelHorizontalMargin = 0.0;
  static const double _verticalGap = 14.4;

  const AgentPanel({
    super.key,
    required this.lastSentText,
    required this.agentWindowKey,
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
    final screenHeight = MediaQuery.of(context).size.height;
    
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: screenHeight / 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _panelHorizontalMargin),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                if (lastSentText != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: _verticalGap),
                  child: AgentVisibilityShadow(
                    type: VisibilityShadowType.text,
                    child: Text(
                      '"$lastSentText"',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TizenStyles.bodyText.copyWith(
                        color: Colors.white,
                        fontSize: TizenStyles.tAskSaid,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          const Shadow(color: Color(0xD9000000), offset: Offset(0, 1), blurRadius: 2.5),
                          const Shadow(color: Color(0xB3000000), offset: Offset(0, 2), blurRadius: 8),
                          const Shadow(color: Color(0x99000000), offset: Offset(0, 0), blurRadius: 2),
                        ],
                      ),
                    ),
                  ),
                ),
              Flexible(
                child: AgentWindow(
                  key: agentWindowKey,
                  focusNode: focusNode,
                  onScrolledToBottomDown: onScrolledToBottomDown,
                  messages: messages,
                  isConnecting: isConnecting,
                  isThreadInFlight: isThreadInFlight,
                  typingLabel: typingLabel,
                  requestStartTime: requestStartTime,
                ),
              ),
                ],
              ),
            ),
          ),
          if (showActionBar) ...[
            const SizedBox(height: _verticalGap),
            ActionButtonBar(
              key: actionBarKey,
              buttons: actionButtons,
              onSend: onSend,
              onArrowUp: onArrowUp,
              onArrowDown: onArrowDown,
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../theme/tizen_styles.dart';

class TypingIndicator extends StatelessWidget {
  final String avatarInitial;
  final bool showAvatar;
  final bool showBubble;
  final String label;

  const TypingIndicator({
    super.key,
    this.avatarInitial = 'T',
    this.showAvatar = true,
    this.showBubble = true,
    this.label = '생각 중이에요...',
  });

  @override
  Widget build(BuildContext context) {
    final labelWidget = Text(
      label,
      style: TizenStyles.bodyText.copyWith(
        color: Colors.white.withValues(alpha: 0.6),
      ),
    );

    if (!showAvatar && !showBubble) return labelWidget;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showAvatar) ...[
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
                child: Text(
                  avatarInitial,
                  style: const TextStyle(
                    fontSize: TizenStyles.avatarInitialFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: TizenStyles.avatarGap),
        ],
        if (showBubble)
          Container(
            padding: TizenStyles.bubblePadding,
            decoration: BoxDecoration(
              color: TizenStyles.slate900.withValues(alpha: 0.4),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(TizenStyles.windowBorderRadius),
                topRight: Radius.circular(TizenStyles.windowBorderRadius),
                bottomLeft: Radius.circular(TizenStyles.messageTailRadius),
                bottomRight: Radius.circular(TizenStyles.windowBorderRadius),
              ),
            ),
            child: labelWidget,
          )
        else
          labelWidget,
      ],
    );
  }
}

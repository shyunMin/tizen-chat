import 'package:flutter/material.dart';
import '../theme/tizen_styles.dart';

class TypingIndicator extends StatelessWidget {
  final String avatarInitial;
  final bool showAvatar;
  final String label;

  const TypingIndicator({
    super.key,
    this.avatarInitial = 'T',
    this.showAvatar = true,
    this.label = '분석 중',
  });

  @override
  Widget build(BuildContext context) {
    final labelWidget = Text(
      label,
      style: TizenStyles.bodyText.copyWith(
        color: const Color(0xFF8F8F8F),
      ),
    );

    if (!showAvatar) return labelWidget;

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
        labelWidget,
      ],
    );
  }
}

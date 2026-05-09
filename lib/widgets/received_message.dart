import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../theme/tizen_styles.dart';

class ReceivedMessage extends StatelessWidget {
  final String text;
  final String avatarInitial;
  final bool isWaiting;
  final String displayType;

  const ReceivedMessage({
    super.key,
    required this.text,
    required this.avatarInitial,
    this.isWaiting = false,
    this.displayType = 'text',
  });

  Color _getAvatarColor() {
    switch (displayType) {
      case 'ui':
        return Colors.deepPurpleAccent;
      case 'text':
        return Colors.blueAccent;
      case 'device_control':
        return Colors.orangeAccent;
      case 'hidden':
        return Colors.tealAccent;
      case 'fallback':
      default:
        return TizenStyles.slate800;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (isWaiting)
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
              backgroundColor: _getAvatarColor(),
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
        Flexible(
          child: MarkdownBody(
            data: text,
            styleSheet: MarkdownStyleSheet(
              p: TizenStyles.bodyText,
              strong: TizenStyles.bodyText.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              em: TizenStyles.bodyText.copyWith(
                fontStyle: FontStyle.italic,
              ),
              listBullet: TizenStyles.bodyText,
              code: TizenStyles.bodyText.copyWith(
                fontFamily: 'monospace',
                backgroundColor: Colors.black.withValues(alpha: 0.3),
              ),
              codeblockDecoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(TizenStyles.codeBorderRadius),
              ),
              h1: TizenStyles.headerText,
              h2: TizenStyles.headerText.copyWith(fontSize: TizenStyles.headerFontSize),
              h3: TizenStyles.headerText.copyWith(fontSize: TizenStyles.subheaderFontSize),
            ),
          ),
        ),
        const SizedBox(width: TizenStyles.receivedMessageRightSpacing),
      ],
    );
  }
}

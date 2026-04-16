import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../theme/tizen_styles.dart';
import '../screens/generative_web_view.dart';

class ReceivedMessage extends StatelessWidget {
  final String text;
  final String avatarInitial;
  final String? uiCode;
  final bool isWaiting;

  const ReceivedMessage({
    super.key,
    required this.text,
    required this.avatarInitial,
    this.uiCode,
    this.isWaiting = false,
  });

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
                width: 38,
                height: 38,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(TizenStyles.cyan400.withValues(alpha: 0.8)),
                ),
              ),
            CircleAvatar(
              radius: 16,
              backgroundColor: TizenStyles.slate800,
              child: Text(
                avatarInitial,
                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MarkdownBody(
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
                    borderRadius: BorderRadius.circular(4),
                  ),
                  h1: TizenStyles.headerText,
                  h2: TizenStyles.headerText.copyWith(fontSize: 17),
                  h3: TizenStyles.headerText.copyWith(fontSize: 16),
                ),
              ),
              if (uiCode != null && uiCode!.isNotEmpty) ...[
                const SizedBox(height: 12),
                GenerativeWebView(uiCode: uiCode!, isInline: true),
              ],
            ],
          ),
        ),
        const SizedBox(width: 100),
      ],
    );
  }
}

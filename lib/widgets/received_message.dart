import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../theme/tizen_styles.dart';

class ReceivedMessage extends StatelessWidget {
  final String text;
  final String avatarInitial;

  const ReceivedMessage({
    super.key,
    required this.text,
    required this.avatarInitial,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: TizenStyles.slate800,
          child: Text(
            avatarInitial,
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: MarkdownBody(
            data: text,
            styleSheet: MarkdownStyleSheet(
              p: TizenStyles.bodyText,
              strong: TizenStyles.bodyText.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              em: TizenStyles.bodyText.copyWith(fontStyle: FontStyle.italic),
              listBullet: TizenStyles.bodyText,
              code: TizenStyles.bodyText.copyWith(
                fontFamily: 'monospace',
                backgroundColor: Colors.black.withOpacity(0.3),
              ),
              codeblockDecoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              h1: TizenStyles.headerText,
              h2: TizenStyles.headerText.copyWith(fontSize: 17),
              h3: TizenStyles.headerText.copyWith(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 100), // Right margin increased to 100
      ],
    );
  }
}

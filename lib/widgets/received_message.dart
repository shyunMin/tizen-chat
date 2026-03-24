import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../theme/tizen_styles.dart';
import '../screens/webview_full_screen.dart';

class ReceivedMessage extends StatelessWidget {
  final String text;
  final String avatarInitial;
  final String? uiCode;
  final ValueChanged<String>? onViewUiCode;

  const ReceivedMessage({
    super.key,
    required this.text,
    required this.avatarInitial,
    this.uiCode,
    this.onViewUiCode,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('#############################################uiCode: $uiCode ');
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
              if (uiCode != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: InkWell(
                    onTap: () {
                      if (onViewUiCode != null) {
                        onViewUiCode!(uiCode!);
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WebViewExample(uiCode: uiCode!),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: TizenStyles.accentGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: TizenStyles.cyan400.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'View Agent UI',
                            style: TizenStyles.bodyText.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 100), // Right margin increased to 100
      ],
    );
  }
}

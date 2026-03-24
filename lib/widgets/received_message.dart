import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../theme/tizen_styles.dart';
import '../screens/webview_full_screen.dart';

class ReceivedMessage extends StatefulWidget {
  final String text;
  final String avatarInitial;
  final String? uiCode;

  const ReceivedMessage({
    super.key,
    required this.text,
    required this.avatarInitial,
    this.uiCode,
  });

  @override
  State<ReceivedMessage> createState() => _ReceivedMessageState();
}

class _ReceivedMessageState extends State<ReceivedMessage> {
  bool _showWebView = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('#############################################uiCode: ${widget.uiCode}, showWebView: $_showWebView');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: TizenStyles.slate800,
          child: Text(
            widget.avatarInitial,
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
                data: widget.text,
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
              if (widget.uiCode != null) ...[
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    setState(() {
                      _showWebView = !_showWebView;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: _showWebView 
                          ? LinearGradient(colors: [TizenStyles.slate900, TizenStyles.slate800])
                          : TizenStyles.accentGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: (_showWebView ? TizenStyles.slate900 : TizenStyles.cyan400).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showWebView ? Icons.close : Icons.auto_awesome,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _showWebView ? 'Close Agent UI' : 'View Agent UI',
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
                if (_showWebView) ...[
                  const SizedBox(height: 12),
                  Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: TizenStyles.cyan400.withOpacity(0.3)),
                    ),
                    child: WebViewExample(
                      uiCode: widget.uiCode!,
                      isInline: true,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
        const SizedBox(width: 100),
      ],
    );
  }
}

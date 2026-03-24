import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../theme/tizen_styles.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_tizen/webview_flutter_tizen.dart';

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
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    if (widget.uiCode != null) {
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white) // Use white for testing visibility
        ..tizenEnginePolicy = true
        ..loadHtmlString(widget.uiCode!, baseUrl: 'http://localhost');
    }
  }

  @override
  void didUpdateWidget(ReceivedMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.uiCode != oldWidget.uiCode) {
      if (widget.uiCode == null) {
        _webViewController = null;
      } else if (oldWidget.uiCode == null) {
        _initController();
      } else {
        _webViewController?.loadHtmlString(widget.uiCode!, baseUrl: 'http://localhost');
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('#############################################uiCode: ${widget.uiCode} ');
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
              if (widget.uiCode != null && _webViewController != null)
                Container(
                  height: 350,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8),
                  child: WebViewWidget(
                    key: ValueKey(widget.uiCode),
                    controller: _webViewController!,
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

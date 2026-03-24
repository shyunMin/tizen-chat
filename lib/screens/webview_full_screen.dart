import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_tizen/webview_flutter_tizen.dart';
import '../theme/tizen_styles.dart';

class WebViewExample extends StatefulWidget {
  final String uiCode;
  final String title;
  final VoidCallback? onClose;
  final bool isInline;

  const WebViewExample({
    super.key,
    required this.uiCode,
    this.title = 'Generated UI',
    this.onClose,
    this.isInline = false,
  });

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    final PlatformWebViewControllerCreationParams params = const PlatformWebViewControllerCreationParams();

    debugPrint('//////////// ${widget.uiCode}');

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF111827)) // Deep background
      ..tizenEnginePolicy = true
      ..loadHtmlString(widget.uiCode);
  }

  @override
  void didUpdateWidget(WebViewExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uiCode != widget.uiCode) {
      _controller.loadHtmlString(widget.uiCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isInline) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: WebViewWidget(controller: _controller),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TizenStyles.headerText.copyWith(fontSize: 18),
        ),
        backgroundColor: TizenStyles.slate900,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            if (widget.onClose != null) {
              widget.onClose!();
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}

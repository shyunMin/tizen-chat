import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_tizen/webview_flutter_tizen.dart';
import '../theme/tizen_styles.dart';

class GenerativeWebView extends StatefulWidget {
  final String uiCode;
  final String title;
  final VoidCallback? onClose;
  final bool isInline;

  const GenerativeWebView({
    super.key,
    required this.uiCode,
    this.title = 'Generated UI',
    this.onClose,
    this.isInline = false,
  });

  @override
  State<GenerativeWebView> createState() => _GenerativeWebViewState();
}

class _GenerativeWebViewState extends State<GenerativeWebView> {
  late final WebViewController _controller;
  double _contentHeight = 200; // Default initial height

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    final PlatformWebViewControllerCreationParams params =
        const PlatformWebViewControllerCreationParams();

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(TizenStyles.slate950)
      ..tizenEnginePolicy = true
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _controller.runJavaScript('''
              document.body.style.backgroundColor = '#020617';
              document.documentElement.style.backgroundColor = '#020617';
            ''');
            _updateHeight();
          },
        ),
      )
      ..addJavaScriptChannel(
        'HeightChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final height = double.tryParse(message.message);
          if (height != null && mounted) {
            setState(() {
              _contentHeight = height;
            });
          }
        },
      )
      ..loadHtmlString(widget.uiCode);
  }

  void _updateHeight() {
    _controller.runJavaScript('''
      function sendHeight() {
        if (window.HeightChannel) {
          HeightChannel.postMessage(document.documentElement.scrollHeight.toString());
        }
      }
      sendHeight();
      setTimeout(sendHeight, 500);
      setTimeout(sendHeight, 1000);
    ''');
  }

  @override
  void didUpdateWidget(GenerativeWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uiCode != widget.uiCode) {
      _controller.loadHtmlString(widget.uiCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isInline) {
      // For chat bubbles: Use height calculation
      return SizedBox(
        height: _contentHeight,
        child: WebViewWidget(controller: _controller),
      );
    }

    // For Full Screen or Generative UI (takes whole available space)
    return WebViewWidget(controller: _controller);
  }
}

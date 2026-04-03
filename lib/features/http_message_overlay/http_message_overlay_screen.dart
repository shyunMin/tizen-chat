import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'http_message_bus.dart';

class HttpMessageOverlayScreen extends StatefulWidget {
  const HttpMessageOverlayScreen({super.key});

  @override
  State<HttpMessageOverlayScreen> createState() =>
      _HttpMessageOverlayScreenState();
}

class _HttpMessageOverlayScreenState extends State<HttpMessageOverlayScreen> {
  StreamSubscription<String>? _subscription;
  String _currentMessage = "HTTP 메시지를 기다리는 중...";
  final FocusNode _keyboardFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _subscription = HttpMessageBus.instance.stream.listen((msg) {
      if (mounted) {
        setState(() => _currentMessage = msg);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Focus(
        focusNode: _keyboardFocusNode,
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.escape ||
               event.logicalKey == LogicalKeyboardKey.goBack ||
               event.logicalKey == LogicalKeyboardKey.browserBack ||
               event.logicalKey == LogicalKeyboardKey.arrowDown)) {
            Navigator.of(context).pop();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: SizedBox.expand(
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              margin: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                _currentMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

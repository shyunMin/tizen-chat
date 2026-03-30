import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/tizen_styles.dart';
import '../screens/webview_full_screen.dart';

class GenerativeUIScreen extends StatefulWidget {
  final String text;
  final String uiCode;

  const GenerativeUIScreen({
    super.key,
    required this.text,
    required this.uiCode,
  });

  @override
  State<GenerativeUIScreen> createState() => _GenerativeUIScreenState();
}

class _GenerativeUIScreenState extends State<GenerativeUIScreen> {
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.escape ||
                event.logicalKey == LogicalKeyboardKey.goBack)) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: TizenStyles.slate950,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: TizenStyles.slate950,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Response Text Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // WebView Area
                  Expanded(
                    child: WebViewExample(
                      uiCode: widget.uiCode,
                      isInline: false, // Takes whole remaining space (no internal height limit)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

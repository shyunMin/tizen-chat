import 'screens/tizen_chat_home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('FLUTTER ERROR: ${details.exception}');
  };
  runApp(const TizenChatApp());
}

class TizenChatApp extends StatelessWidget {
  const TizenChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tizen-Inspired Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Solid dark grey
        canvasColor: Colors.black,
      ),
      home: const TizenChatHomeScreen(),
    );
  }
}

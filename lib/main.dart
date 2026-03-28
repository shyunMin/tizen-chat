import 'package:flutter/material.dart';
import 'screens/tizen_chat_screen_2.dart';

void main() {
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
        scaffoldBackgroundColor: Colors.transparent,
        canvasColor: Colors.transparent,
      ),
      home: const TizenChatScreen2(),
    );
  }
}

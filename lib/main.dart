import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

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
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const TizenChatScreen(),
    );
  }
}

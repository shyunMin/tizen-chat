import 'package:flutter/services.dart';
import 'screens/tizen_chat_home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    print('FLUTTER ERROR: ${details.exception}');
  };
  runApp(const TizenChatApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TizenChatApp extends StatelessWidget {
  const TizenChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Tizen-Inspired Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212), // Solid dark grey
        canvasColor: Colors.black,
      ),
      home: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final state = navigatorKey.currentState;
          if (state != null && state.canPop()) {
            state.pop();
          } else {
            await SystemNavigator.pop();
          }
        },
        child: const TizenChatHomeScreen(),
      ),
    );
  }
}

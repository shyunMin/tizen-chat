import 'package:flutter/services.dart';
import 'screens/tizen_chat_home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  const bool enableHttpBus = bool.fromEnvironment(
    'ENABLE_HTTP_BUS',
    defaultValue: true,
  );
  const bool enablePerfLog = bool.fromEnvironment(
    'ENABLE_PERF_LOG',
    defaultValue: false,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('FLUTTER ERROR: ${details.exception}');
  };
  runApp(
    TizenChatApp(
      enableHttpMessageBus: enableHttpBus,
      enablePerfLog: enablePerfLog,
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TizenChatApp extends StatelessWidget {
  final bool enableHttpMessageBus;
  final bool enablePerfLog;
  const TizenChatApp({
    super.key,
    this.enableHttpMessageBus = true,
    this.enablePerfLog = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    debugPrint('[Screen] width:$width, height: $height');
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
        child: TizenChatHomeScreen(
          enableHttpMessageBus: enableHttpMessageBus,
          enablePerfLog: enablePerfLog,
        ),
      ),
    );
  }
}

import 'package:flutter/services.dart';

class WindowFocusService {
  static const _channel = MethodChannel('app/window_focus');

  // Back 키는 App.cs OnCreate에서 Exclusive grab으로 상시 유지.
  // 여기서는 나머지 네비게이션 키를 상태에 따라 grab/ungrab한다.
  static const _navigationKeys = [
    // 'XF86BTVoice',
    'Return',
    'Left',
    'Right',
    'Up',
    'Down',
  ];

  static Future<void> grabNavigationKeys() async {
    for (final key in _navigationKeys) {
      try {
        await _channel.invokeMethod('grabKey', key);
      } catch (_) {}
    }
  }

  static Future<void> ungrabNavigationKeys() async {
    for (final key in _navigationKeys) {
      try {
        await _channel.invokeMethod('ungrabKey', key);
      } catch (_) {}
    }
  }

  static Future<void> setFocusable(bool focusable) async {
    try {
      await _channel.invokeMethod('setFocusable', focusable);
    } catch (_) {}
  }
}

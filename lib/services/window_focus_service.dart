import 'package:flutter/services.dart';

class WindowFocusService {
  static const _channel = MethodChannel('app/window_focus');

  static Future<void> setFocusable(bool focusable) async {
    try {
      await _channel.invokeMethod('setFocusable', focusable);
    } catch (_) {
      // non-Tizen 환경(리눅스 데스크탑 등)에서는 채널이 없으므로 무시
    }
  }
}

# REQ_006 — HTTP 메시지 서버 앱 전체 라이프사이클 및 화면 상태별 라우팅

## 요구사항 분석

### 현재 상태

- `HttpMessageBus`는 현재 `HttpMessageOverlayScreen`의 `initState`/`dispose`에서 `acquire`/`release`를 호출하여 화면이 활성화될 때만 서버가 시작됨
- 화면 상태에 따른 메시지 라우팅 로직이 없음

### 개선 목표

1. **서버 시작점 이동**: 7777 포트 HTTP 서버를 앱 실행 시점(`TizenChatScreen2.initState`)에 시작, 앱 전체 수명 동안 유지. 서버 시작 실패 시 UI는 영향받지 않음.

2. **화면 상태별 메시지 라우팅** (외부 HTTP로 메시지 수신 시):
   - **상태 A - 첫 화면(initial) + 프롬프트 표시 중(`_isVisible == true`)**: 수신된 메시지를 `_handleSend(msg)` 로 처리 → 채팅 서버에 전송하고 결과를 채팅창으로 표시
   - **상태 B - 오버레이 화면 활성화 중**: 기존처럼 `HttpMessageOverlayScreen` 내부에서 메시지를 표시 (변경 없음)
   - **상태 C - 채팅창(`TizenChatScreen`) 표시 중**: 채팅창 하단 프롬프트에 사용자가 직접 입력한 것과 동일하게 `_handleUserMessage(msg)` 처리
   - **그 외 상태 (오버레이 없이 초기화면, waiting 중, generativeUI 등)**: 수신된 메시지 무시

---

## 설계 개요

### 핵심 변경 사항

#### 1. `HttpMessageBus` 개선 — 서버 영구 시작

`TizenChatScreen2.initState`에서:
```dart
await HttpMessageBus.instance.acquire(); // 서버 시작 (실패해도 예외 무시)
```
`TizenChatScreen2.dispose`에서:
```dart
HttpMessageBus.instance.release(); // 앱 종료 시 정리
```
- `HttpMessageBus`의 `acquire`/`release`는 ref-count 기반이므로 이미 구현되어 있음
- `HttpMessageOverlayScreen`은 **서버를 별도로 acquire/release 하지 않음** (이미 서버가 떠있으므로)

#### 2. 화면 상태 추적 강화 — `ScreenState` 확장

현재 enum `ScreenState { initial, chat, generativeUI }` 에 **`overlay`** 상태 추가:
```dart
enum ScreenState { initial, chat, generativeUI, overlay }
```
- `HttpMessageOverlayScreen` push 전: `_activeScreen = ScreenState.overlay`
- pop 콜백(`.then(...)`)에서: `_activeScreen = ScreenState.initial`로 복원

#### 3. 메시지 라우팅 로직 — `TizenChatScreen2`

`initState`에서 `HttpMessageBus.instance.stream`을 구독:

```dart
_messageBusSubscription = HttpMessageBus.instance.stream.listen((msg) {
  if (!mounted) return;

  if (_activeScreen == ScreenState.overlay) {
    // 상태 B: overlay가 떠있음 → 무시 (overlay screen이 자체 처리)
    return;
  }

  if (_activeScreen == ScreenState.initial && _isVisible) {
    // 상태 A: 첫 화면 + 프롬프트 표시 중 → 채팅 에이전트 전송
    _handleSend(msg);
    return;
  }

  if (_activeScreen == ScreenState.chat) {
    // 상태 C: 채팅창 표시 중 → TizenChatScreen에 메시지 라우팅
    _externalMessageController.add(msg);
    return;
  }

  // 그 외: 무시
});
```

#### 4. `TizenChatScreen`과의 연결 — `StreamController` 방식

`TizenChatScreen2`에서 `StreamController<String>`을 채팅창으로 전달:
```dart
final StreamController<String> _externalMessageController = StreamController<String>.broadcast();
```
`TizenChatScreen` push 시:
```dart
_pushScreen(TizenChatScreen(
  initialMessages: List.from(_messages),
  externalMessageStream: _externalMessageController.stream,
));
```

`TizenChatScreen`에서:
- 생성자에 `Stream<String>? externalMessageStream` 파라미터 추가
- `initState`에서 구독:
```dart
_externalSubscription = widget.externalMessageStream?.listen((msg) {
  if (mounted) _handleUserMessage(msg);
});
```
- `dispose`에서 `_externalSubscription?.cancel()`

---

## AI 구현 프롬프트

### PROMPT START

You are a Flutter developer. Modify existing files to implement HTTP message routing per app screen state.

#### DO NOT modify `pubspec.yaml` or `http_message_bus.dart`.

---

### 수정 파일 1: `lib/screens/tizen_chat_screen_2.dart`

#### 1-A. import 추가
```dart
import 'dart:async';
import '../features/http_message_overlay/http_message_bus.dart';
```

#### 1-B. `ScreenState` enum 확장
```dart
enum ScreenState { initial, chat, generativeUI, overlay }
```

#### 1-C. `_TizenChatScreen2State` 필드 추가
```dart
StreamSubscription<String>? _messageBusSubscription;
final StreamController<String> _externalMessageController =
    StreamController<String>.broadcast();
```

#### 1-D. `initState` 변경
기존 `_chatService.connect()` 호출에 더하여:
```dart
@override
void initState() {
  super.initState();
  _chatService.connect();
  _startHttpMessageBus();
}

Future<void> _startHttpMessageBus() async {
  try {
    await HttpMessageBus.instance.acquire();
  } catch (e) {
    // 서버 시작 실패 → UI에 영향 없이 무시
    print('[REQ_006] HttpMessageBus acquire failed: $e');
  }
  _messageBusSubscription = HttpMessageBus.instance.stream.listen((msg) {
    if (!mounted) return;
    if (_activeScreen == ScreenState.overlay) return; // overlay가 자체 처리
    if (_activeScreen == ScreenState.initial && _isVisible) {
      _handleSend(msg);
      return;
    }
    if (_activeScreen == ScreenState.chat) {
      _externalMessageController.add(msg);
      return;
    }
    // 그 외 상태: 무시
  });
}
```

#### 1-E. `dispose` 변경
```dart
@override
void dispose() {
  _messageBusSubscription?.cancel();
  _externalMessageController.close();
  HttpMessageBus.instance.release();
  _keyboardFocusNode.dispose();
  super.dispose();
}
```

#### 1-F. `_pushScreen` 내 HttpMessageOverlayScreen push 처리 수정

기존 `_pushScreen(const HttpMessageOverlayScreen())` 호출 부분을 아래로 교체:
```dart
// overlay push 전 상태 변경
setState(() {
  _activeScreen = ScreenState.overlay;
});
Navigator.of(context).push(
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const HttpMessageOverlayScreen(),
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  ),
).then((_) {
  if (mounted) {
    setState(() {
      _activeScreen = ScreenState.initial;
      _messages.clear();
    });
  }
});
```

> **Note**: 기존 `_pushScreen`은 일반 화면 전환용으로 유지. overlay push는 `onKeyEvent`의 `arrowDown` 처리 블록에서 inline으로 위 코드를 직접 사용한다.

#### 1-G. `TizenChatScreen` push 시 `externalMessageStream` 전달

`_pushScreen(TizenChatScreen(initialMessages: ...))` 호출 위치를 찾아 아래로 교체:
```dart
_pushScreen(TizenChatScreen(
  initialMessages: List.from(_messages),
  externalMessageStream: _externalMessageController.stream,
));
```

---

### 수정 파일 2: `lib/screens/chat_screen.dart`

#### 2-A. import 추가
```dart
import 'dart:async';
```

#### 2-B. `TizenChatScreen` 위젯 파라미터 추가
```dart
class TizenChatScreen extends StatefulWidget {
  final List<ChatMessage>? initialMessages;
  final Stream<String>? externalMessageStream; // 추가

  const TizenChatScreen({
    super.key,
    this.initialMessages,
    this.externalMessageStream, // 추가
  });
  ...
}
```

#### 2-C. `_TizenChatScreenState` 필드 추가
```dart
StreamSubscription<String>? _externalSubscription;
```

#### 2-D. `initState` 내 구독 추가
기존 코드 하단에:
```dart
_externalSubscription = widget.externalMessageStream?.listen((msg) {
  if (mounted) _handleUserMessage(msg);
});
```

#### 2-E. `dispose`에 취소 추가
```dart
_externalSubscription?.cancel();
```

---

### 수정 파일 3: `lib/features/http_message_overlay/http_message_overlay_screen.dart`

`acquire()`/`release()` 호출을 **제거**한다. 서버는 `TizenChatScreen2`가 관리하므로 이 화면은 스트림 구독만 담당한다.

```dart
@override
void initState() {
  super.initState();
  // acquire() 제거 — 서버는 TizenChatScreen2가 열었을 때 이미 시작됨
  _subscription = HttpMessageBus.instance.stream.listen((msg) {
    if (mounted) setState(() => _currentMessage = msg);
  });
}

@override
void dispose() {
  _subscription?.cancel();
  // release() 제거
  _keyboardFocusNode.dispose();
  super.dispose();
}
```

---

### Constraints

- `pubspec.yaml`은 수정하지 않는다.
- `http_message_bus.dart`는 수정하지 않는다.
- 서버 시작 실패 시 앱 UI에는 어떤 영향도 없어야 한다 (try/catch 필수).
- `TizenChatScreen`은 `externalMessageStream`이 null일 때도 정상 동작해야 한다.
- 기존 `_pushScreen` 메서드의 시그니처는 변경하지 않으며, `overlay` push만 별도 인라인 처리한다.

### PROMPT END

---

## 검증 시나리오

| 화면 상태 | HTTP 메시지 수신 시 예상 동작 |
|---|---|
| 초기화면 + 프롬프트 숨김 | 무시 |
| 초기화면 + 프롬프트 표시 | `_handleSend` 호출 → 채팅창 전환 |
| HttpMessageOverlayScreen 표시 중 | overlay가 메시지를 화면에 표시 |
| TizenChatScreen 표시 중 | `_handleUserMessage` 호출 → 대화 이어짐 |
| GenerativeUIScreen 표시 중 | 무시 |
| _isWaiting 중 | 무시 (initial이지만 `_isVisible=false`이므로) |

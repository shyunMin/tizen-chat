# HTTP → PromptBar 연동 — 요구사항 & AI 구현 프롬프트

## 요구사항 요약

메인 화면(`TizenChatScreen2`)에서:
- 기존 키보드 입력(`PromptBar`) 동작은 그대로 유지
- 동시에 HTTP 서버(포트 7777)를 상시 실행
- HTTP로 메시지가 들어오면 → `_handleSend(message)` 를 직접 호출
  - 즉, 사람이 PromptBar에 타이핑해서 전송한 것과 완전히 동일하게 처리

---

## 변경 대상 파일 분석

### 현재 구조 (변경 전)

```
TizenChatScreen2
├── initState()
│   └── _chatService.connect()
├── _handleSend(text)   ← PromptBar.onSend 콜백으로만 호출됨
└── dispose()
    └── _keyboardFocusNode.dispose()
```

### 목표 구조 (변경 후)

```
TizenChatScreen2
├── initState()
│   ├── _chatService.connect()
│   └── _httpServer.start() + messageStream.listen → _handleSend()
├── _handleSend(text)   ← PromptBar.onSend 또는 HTTP 서버 양쪽에서 호출
└── dispose()
    ├── _keyboardFocusNode.dispose()
    ├── _httpSubscription.cancel()
    └── _httpServer.stop()
```

---

## AI 구현 프롬프트

### PROMPT START

You are a Flutter developer working on a Tizen-based Flutter project (`lib/screens/tizen_chat_screen_2.dart`).

**Goal**: Integrate the existing `HttpMessageServer` into `TizenChatScreen2` so that HTTP messages received on port 7777 are processed exactly like manual PromptBar text submissions.

---

#### Context: existing classes

- `HttpMessageServer` is already implemented at `lib/features/http_message_overlay/http_message_server.dart`.
  - Key API:
    - `Future<void> start()` — starts the server on `localhost:7777`
    - `Future<void> stop()` — stops the server and closes the stream
    - `Stream<String> get messageStream` — emits a string every time `POST /message` is received
- `_handleSend(String text)` in `_TizenChatScreen2State` is the method that processes user input (sends to AI, updates UI, etc.).
- `PromptBar` widget already calls `widget.onSend!(value)` which maps to `_handleSend`.

---

#### Modification: `lib/screens/tizen_chat_screen_2.dart`

Make the **minimum, surgical changes** to this file only:

**Step 1 — Add import** (at the top, after existing imports):
```dart
import 'dart:async';
import '../features/http_message_overlay/http_message_server.dart';
```
Note: `dart:async` may already be present — add only if missing.

**Step 2 — Add two new fields** inside `_TizenChatScreen2State`:
```dart
final HttpMessageServer _httpServer = HttpMessageServer();
StreamSubscription<String>? _httpSubscription;
```

**Step 3 — Modify `initState()`**:

The current `initState` is:
```dart
@override
void initState() {
  super.initState();
  _chatService.connect();
}
```

Replace it with:
```dart
@override
void initState() {
  super.initState();
  _chatService.connect();

  // Start HTTP server and wire incoming messages to _handleSend
  _httpServer.start().then((_) {
    _httpSubscription = _httpServer.messageStream.listen((text) {
      if (mounted && !_isWaiting) {
        _handleSend(text);
      }
    });
  });
}
```

**Step 4 — Modify `dispose()`**:

The current `dispose` is:
```dart
@override
void dispose() {
  _keyboardFocusNode.dispose();
  super.dispose();
}
```

Replace it with:
```dart
@override
void dispose() {
  _httpSubscription?.cancel();
  _httpServer.stop();
  _keyboardFocusNode.dispose();
  super.dispose();
}
```

**That's all.** Do NOT change any other files. Do NOT change `PromptBar`, `HttpMessageServer`, `HttpMessageOverlayScreen`, or any other file.

---

#### Constraints

- Do NOT add or modify `pubspec.yaml`.
- Do NOT add test files.
- Do NOT change the `HttpMessageServer` class.
- Only `tizen_chat_screen_2.dart` should be modified.
- The guard `if (mounted && !_isWaiting)` is important — skip incoming HTTP messages while the app is already waiting for an AI response to prevent race conditions.

### PROMPT END

---

## 검증 방법

앱이 실행된 상태에서 PromptBar가 보이든 안 보이든 아래 curl 명령을 실행하면
AI 응답 흐름이 자동으로 시작됩니다:

```bash
curl -X POST http://localhost:7777/message \
  -H "Content-Type: application/json" \
  -d '{"text": "지금 몇 시야?"}'
```

또는 일반 텍스트:

```bash
curl -X POST http://localhost:7777/message \
  -H "Content-Type: text/plain" \
  -d "오늘 날씨 알려줘"
```

---

## 주요 고려사항

| 항목 | 설명 |
|------|------|
| 경쟁 조건 방지 | `_isWaiting` 체크로 이미 응답 대기 중일 때 HTTP 입력 무시 |
| 서버 생명주기 | `initState`에서 시작, `dispose`에서 정지. 화면이 살아있는 동안만 동작 |
| 포트 충돌 | `HttpMessageOverlayScreen`도 동일 포트를 사용하므로, 그 화면을 push하려면 기존 ArrowUp 키 핸들러 제거 또는 포트 분리 필요 |
| 기존 키보드 입력 | 변경 없음. PromptBar → `_handleSend` 흐름은 그대로 유지 |

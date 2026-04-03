# HTTP Message Overlay Widget — 요구사항 분석 & AI 구현 프롬프트

## 1. 요구사항 분석

### 1-1. 동작 개요

현재 `TizenChatScreen2`(첫 화면)에서 **위쪽 화살표 키(ArrowUp)** 를 누르면  
새로운 `HttpMessageOverlayScreen` 위젯을 `Navigator.push`로 전환한다.

해당 위젯은:
- 화면 전체를 차지하는 풀스크린 위젯
- **배경이 투명** (기존 화면이 비쳐 보임)
- 내장 **HTTP 서버**를 실행하여 외부에서 메시지를 수신
- 수신된 텍스트를 **화면 정중앙**에 표시
- 새 메시지가 오면 **실시간으로 갱신**
- 위젯이 pop 될 때 서버를 **자동으로 종료**

---

### 1-2. 키 입력 조건 (기존 코드 분석 기반)

현재 `tizen_chat_screen_2.dart`에서 키 이벤트 처리 방식:

```dart
// 현재: Alt/Meta 키 → toggleVisibility()
event.logicalKey == LogicalKeyboardKey.altLeft || ...
```

**추가할 키**: `LogicalKeyboardKey.arrowUp` → `_pushHttpMessageOverlay()` 호출  
- `KeyDownEvent` 시점에 처리
- 기존 `_isWaiting` 상태에서는 무시

---

### 1-3. 폴더 구조 (격리된 개발 구역)

```
lib/
└── features/
    └── http_message_overlay/
        ├── http_message_overlay_screen.dart   # 메인 위젯 (풀스크린, 투명 배경)
        └── http_message_server.dart           # 내장 HTTP 서버 서비스
```

---

### 1-4. HTTP 서버 스펙

| 항목 | 내용 |
|------|------|
| 포트 | `7777` (상수로 처리) |
| 엔드포인트 | `POST /message` |
| 요청 형식 A | `Content-Type: application/json` + `{"text": "표시할 메시지"}` |
| 요청 형식 B | `Content-Type: text/plain` + body 전체를 메시지로 사용 |
| 응답 | `200 OK` + `{"status": "ok"}` |
| 기술 | `dart:io` 의 `HttpServer` (외부 패키지 추가 불필요) |

---

### 1-5. 위젯 UI 스펙

| 항목 | 내용 |
|------|------|
| 배경 | `Colors.transparent` |
| 레이아웃 | `Center` → `Text` |
| 텍스트 스타일 | 흰색, fontSize 36, bold |
| 초기 문구 | `"HTTP 메시지를 기다리는 중..."` |
| 업데이트 | `setState`로 `_currentMessage` 변경 |

---

## 2. AI 구현 프롬프트

아래 프롬프트를 코딩 에이전트에게 그대로 전달하세요.

---

### PROMPT START

You are a Flutter developer working on a Tizen-based Flutter project.
The project uses Dart, Flutter, and runs on Tizen TV devices.

**Task**: Implement a new isolated feature called `http_message_overlay`.
This consists of **2 new files** and **1 modification** to an existing file.

---

#### File 1: `lib/features/http_message_overlay/http_message_server.dart`

Create a Dart class `HttpMessageServer`:

- Constant: `const int kHttpMessagePort = 7777;`
- Field: `StreamController<String> _controller = StreamController<String>.broadcast();`
- Getter: `Stream<String> get messageStream => _controller.stream;`
- `Future<void> start()`:
  - Binds `HttpServer` to `InternetAddress.loopbackIPv4`, port `kHttpMessagePort`.
  - For each request:
    - Add header `Access-Control-Allow-Origin: *` to every response.
    - If method is `POST` and uri path is `/message`:
      - Read body bytes, decode as UTF-8.
      - If `Content-Type` contains `application/json`, parse JSON and extract `["text"]`.
      - Otherwise use raw body as the message.
      - Add message string to `_controller`.
      - Respond HTTP 200, `Content-Type: application/json`, body `{"status":"ok"}`.
    - Else: respond HTTP 404.
    - Wrap request handling in try/catch, print errors to console.
- `Future<void> stop()`:
  - Close the `HttpServer` and `_controller`. Safe to call if not started.

---

#### File 2: `lib/features/http_message_overlay/http_message_overlay_screen.dart`

Create a Flutter `StatefulWidget` named `HttpMessageOverlayScreen`:

- In `initState`:
  - Instantiate `HttpMessageServer`, store in `_server`.
  - Call `_server.start()` (use `Future` without awaiting or use `then`).
  - `_subscription = _server.messageStream.listen((msg) { setState(() { _currentMessage = msg; }); });`
- In `dispose`:
  - `_subscription.cancel()` then `_server.stop()`.
- UI structure:
  ```
  Scaffold(backgroundColor: Colors.transparent)
    └── SizedBox.expand()
          └── Center()
                └── Container(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _currentMessage,
                        style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    )
  ```
- Initial `_currentMessage = "HTTP 메시지를 기다리는 중...";`
- Handle key events: if `LogicalKeyboardKey.escape` or `LogicalKeyboardKey.goBack` is pressed (KeyDownEvent), call `Navigator.of(context).pop()`.

---

#### File 3: Modify `lib/screens/tizen_chat_screen_2.dart`

1. Add import at top:
```dart
import '../features/http_message_overlay/http_message_overlay_screen.dart';
```

2. Add method inside `_TizenChatScreen2State`:
```dart
void _pushHttpMessageOverlay() {
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const HttpMessageOverlayScreen(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
}
```

3. In the existing `onKeyEvent` callback, add the following block **before** the existing Alt/Meta check:
```dart
// Arrow Up → push HTTP Message Overlay
if (event is KeyDownEvent &&
    event.logicalKey == LogicalKeyboardKey.arrowUp) {
  if (!_isWaiting) {
    _pushHttpMessageOverlay();
  }
  return KeyEventResult.handled;
}
```

---

#### Constraints

- Do NOT modify `pubspec.yaml`. Use only `dart:io`, `dart:convert`, `dart:async`, and Flutter built-ins.
- Do NOT add test files.
- The server MUST be stopped in `dispose()` to prevent port conflicts on re-entry.

### PROMPT END

---

## 3. 검증 방법 (curl)

```bash
# JSON 형식
curl -X POST http://localhost:7777/message \
  -H "Content-Type: application/json" \
  -d '{"text": "안녕하세요! 테스트입니다."}'

# Plain text 형식
curl -X POST http://localhost:7777/message \
  -H "Content-Type: text/plain" \
  -d "Hello from HTTP!"
```

---

## 4. 주요 고려사항

| 항목 | 설명 |
|------|------|
| 포트 충돌 | `dispose()`에서 반드시 서버 종료. 재진입 시 포트 재사용 오류 방지 |
| Tizen 네트워크 | Tizen에서 loopbackIPv4 = `127.0.0.1`. 외부 PC에서 접근 시 SDB 포트포워딩 필요 |
| 스레드 안전성 | `HttpServer`는 단일 이벤트 루프에서 동작 — 별도 isolate 불필요 |
| 투명 배경 | 부모 Scaffold가 이미 투명이므로 위젯도 투명 유지 시 정상 동작 |

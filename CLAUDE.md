# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Run (Tizen device)
```bash
flutter-tizen run
```

### Build
```bash
flutter-tizen build tpk          # Tizen package
flutter build linux               # Linux desktop (for local testing)
```

### Lint & Analyze
```bash
flutter analyze
```

### Tests
```bash
flutter test                      # all tests
flutter test test/widget_test.dart  # single file
```

### Regenerate Protobuf (after modifying .proto files)
```bash
# proto 소스 파일은 lib/generated/carbon/v1/ 에 직접 편집하거나
# protoc --dart_out=grpc:lib/generated -I proto proto/carbon/v1/agent.proto
```
> Generated files live in `lib/generated/`. Do not edit them manually.

### HTTP Message Bus (external injection)
```bash
# 앱 실행 중 외부에서 메시지 주입 (포트 7777)
curl -X POST http://localhost:7777/message \
  -H "Content-Type: application/json" \
  -d '{"text": "안녕하세요"}'
```

---

## Architecture

### Entry Point & State Management
The app uses no state management library — all state lives in `StatefulWidget` classes. The single entry point is `lib/main.dart`, which passes `enableHttpMessageBus` (compile-time `--dart-define=ENABLE_HTTP_BUS=false` to disable) to the root widget.

### Screen Structure
Everything lives in one screen: **`TizenChatHomeScreen`** (`lib/screens/tizen_chat_home_screen.dart`).

- On first launch: only `PromptBar` is visible (blue glow effect).
- After the first message: a chat overlay slides up above the `PromptBar`, containing `SentMessage` / `ReceivedMessage` / `TypingIndicator` widgets.
- No `Navigator.push` is used. The entire chat flow is an in-place overlay within a `Stack`.

Layout constants (hardcoded in `build()`):
- `PromptBar` bottom: `60px`
- `PromptBar` height: `70px`
- Chat overlay bottom: `138px` (= 60 + 70 + 8)
- Chat overlay max height: `65%` of screen height
- Chat overlay max width: `70%` of screen width

### gRPC Communication (`lib/services/carbon_grpc_service.dart`)
- **Singleton** (`CarbonGrpcService.instance`) — single bidirectional gRPC stream to Carbon agent.
- Connects via Unix domain socket: `/run/user/5001/carbon/carbon.sock`
- Uses a `StreamController.broadcast()` to fan out server events to the current active `sendMessage()` call.
- `sendMessage()` returns `Stream<CarbonEvent>`. The caller (`_handleSend` in `TizenChatHomeScreen`) processes these sealed-class events:
  - `CarbonTextDelta` — streaming text chunk
  - `CarbonToolUseStart` / `CarbonToolResult` — tool call lifecycle
  - `CarbonTurnComplete` — end of turn (triggers `AgentResponseParser`)
  - `CarbonError` / `CarbonSessionEnded` — error/reconnect

### Response Parsing (`lib/services/agent_response_parser.dart`)
After `CarbonTurnComplete`, the accumulated raw text is parsed by `AgentResponseParser.parse()`. It extracts a JSON block delimited by ` ```json ` fences, yielding:
- `display_type`: `"text"` | `"ui"` | `"device_control"` | `"hidden"` | `"fallback"`
- `content`: text shown in the message bubble
- `ui_code`: HTML string for webview rendering (currently unused/commented out)

The `displayType` is forwarded to `ReceivedMessage`, which uses it to color the avatar.

### HTTP Message Bus (`lib/features/http_message_overlay/`)
`HttpMessageBus` is a singleton HTTP server on port `7777`. It accepts `POST /message` (plain text or `{"text":"..."}` JSON) and emits to a broadcast stream. `TizenChatHomeScreen` subscribes and routes incoming messages through `_handleSend()`, identical to user input.

### Design System (`lib/theme/tizen_styles.dart`)
All colors, font sizes, and `TextStyle` constants are in `TizenStyles`. Use these instead of inline values. Key palette: `slate*` grays, `cyan400` (`#22D3EE`), `blue600` (`#2563EB`).

### Webview (`lib/screens/generative_web_view.dart`)
Uses `webview_flutter` + `webview_flutter_tizen`. On Tizen/RPi4: always use `loadRequest` with a Base64 Data URI (not `loadHtmlString`) to avoid blank screen bugs. Ensure `<meta charset="UTF-8">` in HTML. `ClipRRect` causes crashes on Tizen — avoid it around webviews. Dynamic height is measured via `JavaScriptChannel`.

---

## Key Conventions

- **`chat_screen.dart` is legacy**: `TizenChatScreen` in `lib/screens/chat_screen.dart` is the old standalone chat screen. Active logic has been merged into `TizenChatHomeScreen`. Do not add new features there.
- **New sessions reset history**: each `_handleSend()` call clears `_messages` and starts a fresh conversation (by design — see REQ_016).
- **RPi4 constraints**: avoid GPU-intensive effects (blur, `ShaderMask`, `hw-acceleration`). Prefer solid backgrounds over gradients/glassmorphism inside message lists.
- **`req/` directory**: requirement specs (REQ_NNN_*.md) document design decisions. `.antigravity/current_req` tracks the currently active requirement.


# Language & Identity Guidelines
- 모든 요청에 대한 설명, 분석, 답변은 반드시 **한국어(Korean)**를 사용한다.
- 한국어로 답변하되, 기술적인 용어(Tizen, Flutter, Interface 등)는 필요한 경우 영문을 병기할 수 있다.
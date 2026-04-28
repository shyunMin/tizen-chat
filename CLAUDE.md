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
No state management library — all state lives in `StatefulWidget` classes. Entry point: `lib/main.dart`. Passes `enableHttpMessageBus` (compile-time `--dart-define=ENABLE_HTTP_BUS=false` to disable) to the root widget.

### Screen Structure
Everything lives in one screen: **`TizenChatHomeScreen`** (`lib/screens/tizen_chat_home_screen.dart`).

**Current input model (migrate-carbon branch):** `PromptBar` is commented out. Input arrives only via:
1. **`AppControl.onAppControl`** — Tizen app control; extraData is parsed for a `"message"` key (direct, or nested in JSON-encoded key/value).
2. **HTTP Message Bus** — POST to port 7777.

Both routes call `_handleSend()` identically.

After the first message, a `ChatWindow` slides into view. No `Navigator.push` is used.

**Layout:** `ChatWindow` is `Positioned(bottom: 40, left: 10)`.

### ChatWindow (`lib/widgets/chat_window.dart`)
Owns its own `ScrollController` and `FocusNode`. Exposes `scrollToBottom()` via a `GlobalKey<ChatWindowState>` held by the parent. Arrow-up/down key events are handled inside `ChatWindow` for remote-control scrolling (120 px per step). Renders `SentMessage`, `ReceivedMessage`, and `TypingIndicator` in a `ListView.builder`.

### gRPC Communication (`lib/services/carbon_grpc_service.dart`)
- **Singleton** (`CarbonGrpcService.instance`) — single bidirectional gRPC stream to Carbon agent.
- Connects via Unix domain socket: `/run/user/5001/carbon/carbon.sock`
- `CreateSessionRequest` config: `product: "claw"`, `workspace: {appSupportDir}/tizen_ai`, `session: <date>`, `session_date: <date>`.
- Uses a `StreamController.broadcast()` to fan out server events.
- `sendMessage()` returns `Stream<CarbonEvent>`. Sealed-class events:
  - `CarbonTextDelta` — streaming text chunk
  - `CarbonToolUseStart` / `CarbonToolResult` — tool call lifecycle
  - `CarbonTurnComplete` — end of turn (triggers `AgentResponseParser`)
  - `CarbonError` / `CarbonSessionEnded` — error/reconnect
- `_isTurnActive` bool acts as a mutex; overlapping `sendMessage()` calls busy-wait.

### Session Management (`lib/services/session_repository.dart`)
`SessionRepository` (singleton) manages a local list of sessions stored in `{appSupportDir}/session_list.json`. Sessions use `YYYY-MM-DD` as both `name` and `title`. `ensureTodaySession()` is called at init — it creates a today entry if absent and returns the date string used as the Carbon session name.

### Response Parsing (`lib/services/agent_response_parser.dart`)
After `CarbonTurnComplete`, `AgentResponseParser.parse()` extracts a ` ```json ` fenced block from raw text, yielding:
- `display_type`: `"text"` | `"ui"` | `"device_control"` | `"hidden"` | `"fallback"`
- `content`: text shown in the bubble
- `uiCode`: HTML string (field exists but rendering is commented out)

`displayType` colors the avatar in `ReceivedMessage`: blueAccent (text), deepPurpleAccent (ui), orangeAccent (device_control), tealAccent (hidden), slate800 (fallback).

### HTTP Message Bus (`lib/features/http_message_overlay/`)
`HttpMessageBus` is a singleton HTTP server on port 7777. Accepts `POST /message` (plain text or `{"text":"..."}` JSON). `TizenChatHomeScreen` subscribes and routes to `_handleSend()`.

### Design System (`lib/theme/tizen_styles.dart`)
All colors, font sizes, and `TextStyle` constants live in `TizenStyles`. Key palette: `slate*` grays, `cyan400` (`#22D3EE`), `blue600` (`#2563EB`).

### Webview (`lib/screens/generative_web_view.dart`)
Uses `webview_flutter` + `webview_flutter_tizen`. On Tizen/RPi4: always use `loadRequest` with a Base64 Data URI (not `loadHtmlString`). Ensure `<meta charset="UTF-8">`. `ClipRRect` causes crashes on Tizen — avoid it around webviews.

---

## Key Conventions

- **`chat_screen.dart` is legacy**: `TizenChatScreen` is the old standalone screen. Do not add features there.
- **No persistent history per turn**: `_messages` is not cleared between messages in the same session, but a new app launch starts fresh (new gRPC session).
- **RPi4 constraints**: avoid GPU-intensive effects (blur, `ShaderMask`, hardware acceleration). Prefer solid backgrounds.
- **`req/` directory**: requirement specs (`REQ_NNN_*.md`) document design decisions. `.antigravity/current_req` tracks the currently active requirement.

# Language & Identity Guidelines
- 모든 요청에 대한 설명, 분석, 답변은 반드시 **한국어(Korean)**를 사용한다.
- 한국어로 답변하되, 기술적인 용어(Tizen, Flutter, Interface 등)는 필요한 경우 영문을 병기할 수 있다.

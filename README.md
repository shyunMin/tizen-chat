# Tizen AI Chat

Tizen OS 환경에서 Agent Runtime(Carbon 또는 Argot)과 대화하는 Flutter 기반 채팅 애플리케이션입니다.

## 주요 기능

- **Backend 선택**: `AGENT_RUNTIME=argot|carbon` 빌드 변수로 런타임 backend 교체
- **gRPC 기반 실시간 스트리밍**: 선택된 runtime과 Unix 소켓을 통해 스트리밍 통신
- **온보딩 어댑터**: Carbon은 기존 설정 RPC를 사용하고, Argot v1은 설정 RPC 미지원으로 no-op 처리
- **멀티 입력 채널**: Tizen AppControl 및 HTTP Message Bus(포트 7777)를 통한 외부 메시지 수신
- **단일 턴 스트리밍 UX**: `ChatStream` 기반으로 텍스트/도구 이벤트를 실시간 표시
- **액션 버튼**: 에이전트 응답에 포함된 선택지를 버튼으로 표시하여 리모컨으로 조작 가능
- **포커스 제어**: 응답 대기 중 윈도우 포커스를 낮추고 완료 후 복원

---

## 커맨드

### 실행 (Tizen 디바이스)
```bash
flutter-tizen run --dart-define=AGENT_RUNTIME=argot
flutter-tizen run --dart-define=AGENT_RUNTIME=carbon
```

### 빌드
```bash
flutter-tizen build tpk          # Tizen 패키지
flutter build linux               # 로컬 테스트용 Linux 빌드
```

`AGENT_RUNTIME` 기본값은 `argot`입니다. Carbon을 쓰려면 `--dart-define=AGENT_RUNTIME=carbon`을 붙입니다.

### 분석
```bash
flutter analyze
```

### 외부 메시지 주입 (HTTP)
```bash
# 앱 실행 중 포트 7777로 메시지 주입
curl -X POST http://localhost:7777/message \
  -H "Content-Type: application/json" \
  -d '{"text": "안녕하세요"}'
```

---

## 아키텍처

### 진입점 및 상태 관리

상태 관리 라이브러리 없이 `StatefulWidget` 내부에서 모든 상태를 관리합니다.

- **`lib/main.dart`**: `TizenChatApp` 루트 위젯. `ENABLE_HTTP_BUS` 컴파일 변수로 HTTP Bus 활성화 여부 제어.
- **`lib/screens/tizen_chat_home_screen.dart`**: 앱의 단일 메인 화면. 메시지 상태, gRPC 이벤트, 입력 채널, 초기화 흐름을 총괄.

### 초기화 흐름 (`_initializeServices`)

앱 시작 시 다음 순서로 초기화가 진행됩니다.

```
1. _checkOnboarding()     — 선택된 backend의 온보딩 상태 확인
2. _todayKey()            — 세션 이름(YYYY-MM-DD) 동기 계산
3. _isVisible = true      — PromptBar 표시 (gRPC 연결 전, 비활성 상태)
4. grpcService.connect()  — 선택된 backend socket 연결
5. _isGrpcReady = true    — PromptBar 활성화
6. _initCompleter.complete — AppControl 대기 중인 핸들러 해제
```

AppControl이 있는 경우(`_hasPendingAppControl = true`), 3번 표시와 5번 활성화는 AppControl 처리 코드에서 담당합니다.

### 온보딩 (`lib/services/agent_onboarding_service.dart`, `lib/screens/onboarding_screen.dart`)

`AgentOnboardingService`가 backend별 설정 흐름을 감쌉니다.

- Carbon backend는 기존 `OnboardingGrpcService`와 QR 설정 UI를 사용합니다.
- Argot v1 backend는 현재 `Chat` / `ChatStream`만 제공하므로 설정 읽기/쓰기를 no-op으로 처리하고 `ready=true`를 반환합니다. 실제 설정은 디바이스에서 `argot onboard`로 수행합니다.

### 입력 채널

메시지는 두 경로를 통해 진입하며 모두 `_handleSend()`로 합류합니다.

| 채널 | 설명 |
|------|------|
| `AppControl.onAppControl` | Tizen 앱 간 호출. `extraData`의 `"message"` 키 또는 JSON 내 `"message"` 필드를 파싱 |
| HTTP Message Bus | `POST /message` (평문 또는 `{"text":"..."}` JSON), 포트 7777 |

AppControl은 `_initCompleter` 완료를 기다린 후 처리되므로 온보딩·gRPC 연결이 끝난 뒤 메시지가 전송됩니다.

### 화면 구조 (Stack 레이아웃)

`TizenChatHomeScreen.build()`는 `Stack`으로 세 레이어를 쌓습니다.

```
┌─────────────────────────────────┐
│  ChatWindow (bottom: 98~418)    │  ← 대화창, 첫 메시지 이후 슬라이드 인
│  ActionButtonBar (bottom: 98)   │  ← 에이전트 응답의 액션 버튼
│  PromptBar (bottom: 10)         │  ← 입력창 (연결 중 / 마이크 / 키보드 모드)
└─────────────────────────────────┘
```

`ChatWindow`는 `_hasChatStarted = true` 이전까지 `bottom: -screenHeight`로 화면 밖에 위치합니다.

### ChatWindow (`lib/widgets/chat_window.dart`)

- 자체 `ScrollController`와 `FocusNode`를 가짐
- `scrollToBottom()`을 `GlobalKey<ChatWindowState>`로 부모에서 호출
- 리모컨 상/하 키로 120px 단위 스크롤
- 포커스 시 shimmer 테두리 애니메이션 표시
- `SentMessage`, `ReceivedMessage`, `TypingIndicator`를 `ListView.builder`로 렌더링

### PromptBar (`lib/widgets/prompt_bar.dart`)

세 가지 상태를 가집니다.

| 상태 | 조건 | 표시 |
|------|------|------|
| 연결 중 | `isConnecting = true` | "연결 중..." 텍스트, 입력 비활성 |
| 마이크 모드 | 기본 | 리모컨 마이크 안내 텍스트 |
| 키보드 모드 | 키보드 아이콘 선택 후 | `TextField` 활성화, 전송 버튼 |

- `isWaiting` 상태에서는 전송 아이콘이 정지(Stop) 아이콘으로 전환
- 포커스 시 shimmer 테두리 애니메이션 표시

### gRPC 통신 (`lib/services/agent_runtime_service.dart`)

- **싱글턴** (`AgentGrpcService.instance`) — 선택된 backend adapter
- **Argot 소켓**: `ARGOT_SOCKET_PATH`, `$XDG_RUNTIME_DIR/argot.sock`, 또는 `/tmp/argot-$USER.sock`
- **Carbon 소켓**: `CARBON_SOCKET_PATH`, `$XDG_RUNTIME_DIR/carbon/carbon.sock`, 또는 `/run/user/{uid}/carbon/carbon.sock`
- `StreamController.broadcast()`로 이벤트 팬아웃
- `sendPrompt()`: backend별 submit/chat RPC 호출, 미연결 시 내부에서 `connect()` 호출

**sealed class 이벤트:**

| 이벤트 | 설명 |
|--------|------|
| `AgentTextDelta` | 스트리밍 텍스트 청크 |
| `AgentToolUseStart` / `AgentToolResult` | 도구 호출 라이프사이클 |
| `AgentTurnComplete` | 턴 종료 (응답 파싱 트리거) |
| `AgentError` | 에러 (fatal 시 reconnect) |
| `AgentSessionEnded` | 세션 종료 (reconnect) |
| `AgentToolApprovalRequest` | 도구 승인 요청. Argot v1에서는 no-op adapter가 로그만 남김 |

### Backend별 차이

- Carbon은 기존 `Submit`/`Subscribe` 기반 lifecycle, steer/queue, approval, interrupt 경로를 사용합니다.
- Argot v1은 `ChatStream` 기반이며 thread/turn started, steer/queue, approval, remote interrupt RPC가 없습니다. 지원되지 않는 기능은 interface를 유지하고 로그/no-op으로 처리합니다.

```
_handleSend(text)
  ├─ idle → backend sendPrompt()
  └─ busy → Carbon은 steer/queue, Argot은 로그 후 무시

_handleAgentEvent (broadcast 구독)
  ├─ AgentTextDelta      → _appendDelta()
  ├─ AgentToolUseStart   → _recordToolStart()
  ├─ AgentTurnComplete   → _finalizeActiveReply() → AgentResponseParser.parse()
  └─ AgentError / AgentSessionEnded → 에러 처리 / reconnect
```

### 응답 파싱 (`lib/services/agent_response_parser.dart`)

`AgentTurnComplete` 수신 후 `AgentResponseParser.parse()`가 실행됩니다.

- ` ```json ` 펜스 블록에서 구조화 데이터 추출
- `display_type`: `"text"` | `"ui"` | `"device_control"` | `"hidden"` | `"fallback"`
- `content`: 말풍선에 표시할 텍스트
- `action_buttons`: 액션 버튼 라벨 배열

`displayType`에 따라 `ReceivedMessage`의 아바타 색상이 달라집니다.

### 윈도우 포커스 (`lib/services/window_focus_service.dart`)

메시지 전송 시 `setFocusable(false)`, 턴 완료 또는 에러 시 `setFocusable(true)`.

---

## 디렉토리 구조

```
lib/
├── main.dart
├── features/
│   └── http_message_overlay/
│       └── http_message_bus.dart         # HTTP 서버 싱글턴 (포트 7777)
├── models/
│   └── chat_message.dart                 # ChatMessage 모델 (sent/received)
├── screens/
│   ├── onboarding_screen.dart            # QR 코드 설정 화면
│   └── tizen_chat_home_screen.dart       # 메인 화면
├── services/
│   ├── agent_response_parser.dart        # 에이전트 응답 파싱
│   ├── agent_runtime_service.dart        # Carbon/Argot backend facade
│   ├── agent_onboarding_service.dart     # Carbon/Argot 온보딩 facade
│   ├── argot_grpc_service.dart           # Argot gRPC adapter
│   ├── argot_onboarding_service.dart     # Argot 설정 no-op adapter
│   ├── carbon_grpc_service.dart          # Carbon gRPC adapter
│   ├── onboarding_grpc_service.dart      # Carbon 설정 adapter
│   └── window_focus_service.dart         # 윈도우 포커스 제어
├── theme/
│   └── tizen_styles.dart                 # 색상, 폰트 상수
├── widgets/
│   ├── action_button_bar.dart            # 에이전트 응답 액션 버튼
│   ├── chat_window.dart                  # 대화창 (스크롤, 포커스)
│   ├── prompt_bar.dart                   # 입력창 (연결 중/마이크/키보드 모드)
│   ├── received_message.dart             # 수신 메시지 버블
│   ├── sent_message.dart                 # 발신 메시지 버블
│   └── typing_indicator.dart             # 타이핑 인디케이터
└── generated/
    ├── argot/v1/                        # Argot protoc 생성 파일
    └── carbon/v*/                       # Carbon protoc 생성 파일
```

---

## 디자인 시스템 (`lib/theme/tizen_styles.dart`)

모든 색상, 폰트 크기, `TextStyle` 상수는 `TizenStyles`에 정의되어 있습니다.

- **팔레트**: `slate*` 계열 회색, `cyan400` (`#22D3EE`), `blue600` (`#2563EB`)
- RPi4 GPU 제약으로 blur, ShaderMask, 하드웨어 가속 효과 사용 지양

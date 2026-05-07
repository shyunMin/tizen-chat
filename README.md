# Tizen AI Chat

Tizen OS 환경에서 Carbon AI 에이전트와 대화하는 Flutter 기반 채팅 애플리케이션입니다.

## 주요 기능

- **gRPC 기반 실시간 스트리밍**: Carbon 에이전트와 Unix 소켓을 통해 양방향 스트리밍 통신
- **멀티 입력 채널**: Tizen AppControl 및 HTTP Message Bus(포트 7777)를 통한 외부 메시지 수신
- **Steer 기반 UX**: 응답 중에도 새 메시지를 전송하면 진행 중인 에이전트 버블에 자연스럽게 이어짐
- **마크다운 렌더링**: 에이전트 응답을 `flutter_markdown_plus`로 렌더링
- **액션 버튼**: 에이전트 응답에 포함된 선택지를 버튼으로 표시하여 리모컨으로 조작 가능
- **포커스 제어**: 응답 대기 중 윈도우 포커스를 낮추고 완료 후 복원

---

## 커맨드

### 실행 (Tizen 디바이스)
```bash
flutter-tizen run
```

### 빌드
```bash
flutter-tizen build tpk          # Tizen 패키지
flutter build linux               # 로컬 테스트용 Linux 빌드
```

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

- **`lib/main.dart`**: `TizenChatApp` 루트 위젯. `ENABLE_HTTP_BUS` 컴파일 변수를 통해 HTTP Bus 활성화 여부 제어.
- **`lib/screens/tizen_chat_home_screen.dart`**: 앱의 단일 화면(`TizenChatHomeScreen`). 메시지 상태, gRPC 이벤트, 입력 채널을 총괄.

### 입력 채널

메시지는 두 경로를 통해 진입하며 모두 `_handleSend()`로 합류합니다.

| 채널 | 설명 |
|------|------|
| `AppControl.onAppControl` | Tizen 앱 간 호출. `extraData`의 `"message"` 키 또는 JSON 내 `"message"` 필드를 파싱 |
| HTTP Message Bus | `POST /message` (평문 또는 `{"text":"..."}` JSON), 포트 7777 |

### 화면 구조 (Stack 레이아웃)

`TizenChatHomeScreen.build()`는 `Stack`으로 세 레이어를 쌓습니다.

```
┌─────────────────────────────────┐
│  ChatWindow (bottom: 98~418)    │  ← 대화창, 키보드/대기 상태에 따라 위치 조정
│  ActionButtonBar (bottom: 98)   │  ← 에이전트 응답의 액션 버튼
│  PromptBar (bottom: 10)         │  ← 입력창 (마이크/키보드 모드 전환)
└─────────────────────────────────┘
```

### ChatWindow (`lib/widgets/chat_window.dart`)

- 자체 `ScrollController`와 `FocusNode`를 가짐
- `scrollToBottom()`을 `GlobalKey<ChatWindowState>`로 부모에서 호출
- 리모컨 상/하 키로 120px 단위 스크롤
- 포커스 시 shimmer 테두리 애니메이션 표시
- `SentMessage`, `ReceivedMessage`, `TypingIndicator`를 `ListView.builder`로 렌더링

### PromptBar (`lib/widgets/prompt_bar.dart`)

- **마이크 모드** (기본): 리모컨 마이크 버튼 안내 텍스트 표시
- **키보드 모드**: 키보드 아이콘 탭 시 `TextField` 활성화, Enter/전송 아이콘으로 전송
- 대기 중(`isWaiting`)에는 전송 아이콘이 정지(Stop) 아이콘으로 전환
- 포커스 시 shimmer 테두리 애니메이션 표시

### gRPC 통신 (`lib/services/carbon_grpc_service.dart`)

- **싱글턴** (`CarbonGrpcService.instance`) — 단일 양방향 스트림
- **소켓**: `/run/user/5001/carbon/carbon.sock` (Unix 도메인)
- **세션 설정**: `product: "claw"`, workspace는 `{appSupportDir}/tizen_ai`
- `StreamController.broadcast()`로 이벤트 팬아웃

**sealed class 이벤트:**

| 이벤트 | 설명 |
|--------|------|
| `CarbonTextDelta` | 스트리밍 텍스트 청크 |
| `CarbonToolUseStart` / `CarbonToolResult` | 도구 호출 라이프사이클 |
| `CarbonTurnComplete` | 턴 종료 (응답 파싱 트리거) |
| `CarbonError` | 에러 (fatal 시 reconnect) |
| `CarbonSessionEnded` | 세션 종료 (reconnect) |
| `CarbonToolApprovalRequest` | 도구 실행 승인 요청 (자동 승인) |

### Steer 기반 메시지 흐름

Carbon은 `steer: true`로 항상 전송 → 데몬이 진행 중인 턴에 inject하거나 새 턴을 시작.  
클라이언트는 round 경계를 구분할 수 없으므로 에이전트 응답 버블을 **하나로 유지**하며 모든 delta를 누적합니다.

```
_handleSend(text)
  ├─ _activeReplyIndex != null (진행 중)
  │   → 사용자 버블을 에이전트 버블 위에 insert, _activeReplyIndex += 1
  └─ _activeReplyIndex == null
      → 사용자 버블을 리스트 끝에 append

_handleAgentEvent (broadcast 구독)
  ├─ CarbonTextDelta  → _appendDelta()
  ├─ CarbonToolUseStart → _markToolUse()
  ├─ CarbonTurnComplete → _finalizeActiveReply() → AgentResponseParser.parse()
  └─ CarbonError / CarbonSessionEnded → 에러 처리 / reconnect
```

### 세션 관리 (`lib/services/session_repository.dart`)

`SessionRepository` (싱글턴)는 `{appSupportDir}/session_list.json`에 세션 목록을 저장합니다.  
세션 이름은 `YYYY-MM-DD` 형식이며, 앱 시작 시 `ensureTodaySession()`으로 오늘 세션을 확보합니다.

### 응답 파싱 (`lib/services/agent_response_parser.dart`)

`CarbonTurnComplete` 수신 후 `AgentResponseParser.parse()`가 실행됩니다.

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
│   ├── chat_message.dart                 # ChatMessage 모델 (sent/received)
│   └── session_meta.dart                 # 세션 메타데이터 모델
├── screens/
│   └── tizen_chat_home_screen.dart       # 메인 화면
├── services/
│   ├── agent_response_parser.dart        # 에이전트 응답 파싱
│   ├── carbon_grpc_service.dart          # gRPC 통신 싱글턴
│   ├── session_repository.dart           # 세션 목록 영속화
│   └── window_focus_service.dart         # 윈도우 포커스 제어
├── theme/
│   └── tizen_styles.dart                 # 색상, 폰트 상수
├── widgets/
│   ├── action_button_bar.dart            # 에이전트 응답 액션 버튼
│   ├── chat_window.dart                  # 대화창 (스크롤, 포커스)
│   ├── prompt_bar.dart                   # 입력창 (마이크/키보드 모드)
│   ├── received_message.dart             # 수신 메시지 버블
│   ├── sent_message.dart                 # 발신 메시지 버블
│   └── typing_indicator.dart             # 타이핑 인디케이터
└── generated/
    └── carbon/v1/                        # protoc 생성 파일 (수동 편집 금지)
        ├── agent.pb.dart
        ├── agent.pbenum.dart
        ├── agent.pbgrpc.dart
        └── agent.pbjson.dart
```

---

## 디자인 시스템 (`lib/theme/tizen_styles.dart`)

모든 색상, 폰트 크기, `TextStyle` 상수는 `TizenStyles`에 정의되어 있습니다.

- **팔레트**: `slate*` 계열 회색, `cyan400` (`#22D3EE`), `blue600` (`#2563EB`)
- RPi4 GPU 제약으로 blur, ShaderMask, 하드웨어 가속 효과 사용 지양

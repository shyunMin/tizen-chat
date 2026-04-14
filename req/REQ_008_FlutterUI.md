# REQ_001: Flutter UI Client for Carbon Daemon (Tizen/Linux)

## 1. 개요 (Overview)
본 명세서는 Tizen 및 Linux 환경에서 실행 중인 `carbon-daemon`과 통신하여 AI 에이전트 서비스를 제공하는 Flutter 기반 채팅 UI 애플리케이션의 구현 가이드를 제공합니다.

- **목적**: `carbon-daemon`의 gRPC 인터페이스를 연동하여 실시간 AI 채팅 및 도구 실행 현황 시각화.
- **통신 방식**: gRPC over Unix Domain Socket (UDS).

## 2. 통신 규약 (Communication Protocol)

### 2.1 전송 계층 (Transport)
- **방식**: Unix Domain Socket (UDS), **TCP가 아님**.
- **소켓 경로**: `$XDG_RUNTIME_DIR/carbon/carbon.sock`
  - `XDG_RUNTIME_DIR`이 미설정 시 기본값: `/tmp/carbon/carbon.sock`
  - Tizen 실기기에서 데몬을 `/run` 기준으로 실행한 경우: `/run/carbon/carbon.sock`
- **보안**: 인증 없음 (Insecure 채널 사용).

### 2.2 gRPC 서비스 정의
- **Proto 파일**: `carbon-proto/proto/carbon/v1/agent.proto`
- **패키지**: `carbon.v1`
- **서비스명**: `AgentService`
- **유일한 메소드**: `rpc Session(stream ClientMessage) returns (stream ServerEvent);`
  - 이것은 **양방향(Bidirectional) 스트리밍**입니다.
  - 클라이언트가 먼저 `ClientChannel`을 열고 스트림을 시작해야 합니다.

### 2.3 메시지 시퀀스 (Message Sequence) — 가장 중요

#### Step 1: 세션 생성 (Connection 후 첫 번째 메시지로 필수)
```
Client → Server: ClientMessage { create_session: CreateSessionRequest { product: "claw" } }
Server → Client: ServerEvent { session_created: SessionCreated { session_id: "uuid-..." } }
```
- `product` 필드는 반드시 `"claw"` 로 지정해야 합니다.
- 선택적 `config` 맵에 다음 값을 전달할 수 있습니다:
  - `"model"`: 사용할 모델명 (예: `"gemini-2.0-flash-thinking-exp"`)
  - `"workspace"`: 도구가 실행될 작업 디렉토리 절대 경로

#### Step 2: 사용자 메시지 전송 — ★중요: UserMessage가 아닌 IngressInput 사용
```
Client → Server: ClientMessage { ingress_input: IngressInput {
    session_id: "<Step 1에서 받은 session_id>",
    intent: INGRESS_INTENT_RUN_TURN (= 1),
    source: "my-flutter-app",
    content: { text: "사용자가 입력한 텍스트" }
} }
```
- **주의**: `UserMessage`가 proto에 정의되어 있으나, 실제 `carbon-claw` 구현체는 `IngressInput`을 사용합니다. `IngressInput`을 사용하십시오.
- `intent`는 반드시 `INGRESS_INTENT_RUN_TURN (1)` 으로 설정해야 에이전트 루프가 시작됩니다.

#### Step 3: 서버 이벤트 수신 (스트리밍)
아래 이벤트들을 순서대로 수신합니다. `TurnComplete` 또는 fatal `ErrorEvent`가 올 때까지 루프를 유지하십시오.

| 이벤트 | 의미 | UI 처리 방법 |
|---|---|---|
| `TextDelta { content }` | 응답 텍스트 조각 (스트리밍) | 채팅 말풍선에 실시간으로 텍스트를 append |
| `ToolUseStart { tool_name, tool_call_id, arguments_json }` | 도구 실행 시작 | "🔧 bash 실행 중..." 등 상태 표시 |
| `ToolResult { tool_call_id, output, is_error }` | 도구 실행 결과 | 상태 표시 제거 또는 결과 표시 (선택) |
| `TurnComplete { usage_json }` | 응답 완료 | 입력창 활성화, 완료 처리 |
| `ErrorEvent { code, message, fatal }` | 에러 발생 | 에러 메시지 표시. `fatal=true`면 세션 종료 |
| `SessionEnded { reason }` | 세션 종료됨 | 세션 종료 처리 및 재연결 시도 |

### 2.4 UDS gRPC 연결 구현 — ★핵심 기술 난제

Flutter/Dart의 `grpc` 패키지는 기본적으로 TCP만 지원합니다. Unix Domain Socket 연결을 위해 다음 방법 중 하나를 선택하십시오.

#### 옵션 A: dart:io의 Socket 클래스 활용 (권장)
```dart
import 'dart:io';

// Dart의 grpc 패키지는 ClientChannel에 socketAddress 연결을 지원합니다.
final channel = ClientChannel(
  InternetAddress('/run/carbon/carbon.sock', type: InternetAddressType.unix),
  port: 0,
  options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
);
```
- `dart:io`의 `InternetAddressType.unix`는 Dart 2.x 이상에서 지원됩니다.
- Flutter on Linux는 지원되나, **Tizen에서의 지원 여부는 반드시 빌드 테스트를 통해 확인하십시오.**

#### 옵션 B: TCP 브릿지 사용 (UDS가 안 될 경우 fallback)
`socat`이나 프록시를 사용해 TCP 포트 → UDS 소켓으로 중계합니다.  
이 경우 앱은 `localhost:50051`로 TCP 접속합니다.

### 2.5 Proto 파일 전문 (agent.proto 요약)

```protobuf
service AgentService {
  rpc Session(stream ClientMessage) returns (stream ServerEvent);
}

message ClientMessage {
  oneof message {
    CreateSessionRequest create_session = 1;
    UserMessage user_message = 2;        // 현재 미사용 (IngressInput 사용)
    IngressInput ingress_input = 7;      // ★ 실제 사용하는 메시지 타입
    CancelSessionRequest cancel_session = 4;
  }
}

message IngressInput {
  string session_id = 1;
  IngressIntent intent = 2;             // 1 = RUN_TURN
  string source = 3;                    // 앱 식별자
  oneof content {
    string text = 10;                   // 텍스트 메시지
  }
}
```

## 3. 구현 요구사항 (Requirements)

### 3.1 기능 요구사항
- [ ] gRPC over UDS 채널 연결 구현 (`InternetAddressType.unix`).
- [ ] `agent.proto` 기반 Dart 클라이언트 스터브(Stub) 생성 (`protoc` + `protoc-gen-dart`).
- [ ] 실시간 스트리밍 대화 UI (텍스트 append).
- [ ] 에이전트 상태 표시 ("생각 중...", "🔧 bash 실행 중...").
- [ ] `TurnComplete` 이벤트 수신 시 입력창 활성화.
- [ ] `SessionEnded` 또는 연결 끊김 시 자동 재연결 로직.
- [ ] 세션 ID 유지 (재연결 시 기존 대화 이어가기 가능).

### 3.2 기술 스택
- **grpc**: `grpc: ^4.0.0` (pub.dev)
- **protobuf**: `protobuf: ^3.1.0`
- **코드 생성**: `protoc-gen-dart` 플러그인으로 `agent.proto`를 Dart로 변환
- **Proto 파일 위치**: `carbon-proto/proto/carbon/v1/agent.proto`

## 4. 참고용 Rust 구현 요약 (carbon-claw/src/main.rs)

아래는 기존 CLI 클라이언트(`carbon-claw`)의 핵심 로직을 Dart로 변환 시 참고해야 할 사항입니다.

### 연결 흐름
```
1. UnixStream::connect(socket_path)     → UDS 소켓 연결
2. client.session(outbound_stream)      → 양방향 스트림 시작
3. tx.send(CreateSessionRequest)        → 세션 생성 요청
4. inbound.message() 로 SessionCreated 수신 후 session_id 저장
5. tx.send(IngressInput(text: ...))     → 사용자 메시지 전송
6. inbound.message() 루프로 TextDelta, TurnComplete 등 수신
```

### 세션 재사용 동작
- `carbon-daemon`은 `$HOME/.carbonclaw/workspace/sessions/` 하위에 JSONL 파일로 대화 기록을 저장합니다.
- 데몬 재시작 후에도 기존 세션이 있으면 대화 기록(history)을 자동으로 복원합니다 (`messages=N` 로그 확인).
- 클라이언트는 매번 `CreateSessionRequest`를 보내도 괜찮으며, 서버가 기존 세션을 감지해 재사용합니다.

## 5. 전달 사항 (Instruction for AI)
1. `carbon-proto/proto/carbon/v1/agent.proto` 파일을 읽고 `protoc`로 Dart 클라이언트 코드를 생성하십시오.
2. gRPC 연결은 TCP가 아닌 **Unix Domain Socket**으로 구현해야 합니다. `dart:io`의 `InternetAddressType.unix`를 우선 시도하십시오.
3. 사용자 메시지 전송 시 `UserMessage`가 아닌 반드시 **`IngressInput`** (intent=RUN_TURN)을 사용하십시오.
4. `TextDelta` 이벤트를 받을 때마다 채팅 버블에 실시간으로 텍스트를 append하고, `TurnComplete`가 오면 응답 완료로 처리하십시오.
5. 채팅 UI는 **Material 3** 가이드라인을 준수하며 프리미엄급 디자인을 지향하십시오.
6. Tizen 환경에서의 빌드 가능성을 고려하여, `dart:ffi`나 플랫폼 채널이 필요한 경우를 대비한 fallback 구조를 설계하십시오.

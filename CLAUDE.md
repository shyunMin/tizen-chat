# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

Tizen OS 환경에서 Agent Runtime(Argot 또는 Carbon)과 대화하는 Flutter 기반 채팅 앱. 주 타겟은 Tizen TV이며, Linux 빌드로 로컬 개발을 병행한다.

## 커맨드

### 실행 (Tizen 디바이스)
```bash
flutter-tizen run --dart-define=AGENT_RUNTIME=argot
flutter-tizen run --dart-define=AGENT_RUNTIME=carbon
```

### 빌드
```bash
flutter-tizen build tpk          # Tizen 패키지 빌드
flutter build linux               # 로컬 Linux 빌드 (개발/디버깅용)
```

`AGENT_RUNTIME` 기본값은 `argot`. Carbon을 쓰려면 `--dart-define=AGENT_RUNTIME=carbon` 추가.

### 테스트
```bash
flutter test                              # 전체 테스트
flutter test test/agent_response_parser_test.dart  # 단일 파일 테스트
```

Linux에서 테스트 실행 시 Tizen 전용 플러그인 호출을 건너뛰도록 `--dart-define=IS_TIZEN=false` 필요.

### 정적 분석
```bash
flutter analyze
```

### Proto 코드 생성 (Argot 쪽만)
```bash
scripts/gen-proto.sh <argot-repo-path>
# 예: scripts/gen-proto.sh ../argo-tizen
```
- 사전 조건: `protoc` 및 `protoc-gen-dart` (dart pub global activate protoc_plugin)
- Carbon stubs는 in-tree로 관리되며 이 스크립트로 갱신하지 않음

### 외부 메시지 주입 (HTTP)
```bash
curl -X POST http://localhost:7777/message \
  -H "Content-Type: application/json" \
  -d '{"text": "안녕하세요"}'
```

## 빌드 변수 (`--dart-define`)

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `AGENT_RUNTIME` | `argot` | 런타임 백엔드 선택 (`argot` / `carbon`) |
| `IS_TIZEN` | `true` | Tizen 전용 API 활성화 여부. Linux/테스트에서는 `false` |
| `ENABLE_HTTP_BUS` | `true` | 포트 7777 HTTP 메시지 버스 활성화 |
| `ENABLE_PERF_LOG` | `false` | 요청 성능 로깅 활성화 |
| `BUBBLE_MODE` | `single` | 응답 버블 레이아웃 (`single` / `multi`) |

## 아키텍처

### Backend 이중화 패턴

`AgentGrpcService` (추상 클래스, `lib/services/agent_runtime_service.dart`)가 backend 간 공통 인터페이스. 빌드 시 `AGENT_RUNTIME` 값에 따라 `_ArgotAgentGrpcService` 또는 `_CarbonAgentGrpcService`가 싱글턴으로 생성됨.

```
AgentGrpcService.instance
  ├─ Argot  → _ArgotAgentGrpcService  → ArgotGrpcService (lib/services/argot_grpc_service.dart)
  └─ Carbon → _CarbonAgentGrpcService → CarbonGrpcService (lib/services/carbon_grpc_service.dart)
```

각 adapter는 backend 고유 이벤트 타입을 공통 `AgentEvent` sealed class로 매핑. 새 이벤트 타입 추가 시 `_mapArgotEvent` / `_mapCarbonEvent` 양쪽 모두 수정 필요.

### 이벤트 타입 (sealed class)

`AgentTextDelta`, `AgentToolUseStart`, `AgentToolResult`, `AgentTurnComplete`, `AgentError`, `AgentSessionEnded`, `AgentToolApprovalRequest`, `AgentTurnStarted`, `AgentThreadComplete` 등. 스트림은 `StreamController.broadcast()`로 팬아웃.

### 초기화 순서

`TizenChatHomeScreen._initializeServices()`에서 순서가 중요:
1. `_checkOnboarding()` → backend 온보딩 상태 확인
2. 세션 이름 계산 (YYYY-MM-DD)
3. PromptBar 표시 (gRPC 연결 전, 비활성)
4. `grpcService.connect()` → 선택된 backend Unix 소켓 연결
5. PromptBar 활성화
6. `_initCompleter.complete()` → AppControl 대기 핸들러 해제

AppControl이 대기 중이면 3·5번 단계를 AppControl 처리 코드가 담당.

### 입력 채널

두 채널 모두 `_handleSend()`로 합류:
- **Tizen AppControl**: `extraData["message"]` 또는 JSON의 `"message"` 필드
- **HTTP Message Bus** (`lib/features/http_message_overlay/http_message_bus.dart`): `POST /message` 포트 7777, 평문 또는 `{"text":"..."}` JSON

### 온보딩

`AgentOnboardingService`가 backend별 설정 흐름을 감쌈:
- **Carbon**: `OnboardingGrpcService` + QR 코드 설정 UI (`OnboardingScreen`)
- **Argot v1**: 설정 RPC 미지원 → no-op으로 `ready=true` 반환. 실제 설정은 디바이스에서 `argot onboard` 명령으로 수행

### 응답 파싱

`AgentTurnComplete` 수신 후 `AgentResponseParser.parse()` 실행. `` ```json `` 펜스 블록에서 구조화 데이터 추출:
- `display_type`: `"text"` | `"ui"` | `"device_control"` | `"hidden"` | `"fallback"`
- `content`: 버블에 표시할 텍스트
- `action_buttons`: 액션 버튼 라벨 배열
- JSON 없거나 파싱 실패 시 원문을 `fallback`으로 반환

### 소켓 경로

- **Argot**: `ARGOT_SOCKET_PATH` 환경변수 → `$XDG_RUNTIME_DIR/argot.sock` → `/tmp/argot-$USER.sock`
- **Carbon**: `CARBON_SOCKET_PATH` 환경변수 → `$XDG_RUNTIME_DIR/carbon/carbon.sock` → `/run/user/{uid}/carbon/carbon.sock`

### Carbon vs Argot 기능 차이

- Carbon: `Submit`/`Subscribe` lifecycle, steer/queue, approval, remote interrupt, validation 지원
- Argot v1: `ChatStream` 기반, steer/queue/approval/interrupt 없음. 지원하지 않는 기능은 interface를 유지하고 no-op 또는 로그 처리

### 디자인 시스템

모든 색상·폰트·스타일 상수는 `lib/theme/tizen_styles.dart`의 `TizenStyles` 클래스에서 관리. RPi4 GPU 제약으로 blur, ShaderMask, 하드웨어 가속 효과 사용 금지.

## Proto 생성 파일

`lib/generated/` 하위 파일은 자동 생성이므로 직접 수정하지 않는다:
- `argot/v1/` — Argot proto에서 생성 (`scripts/gen-proto.sh`로 갱신)
- `carbon/v1/`, `carbon/v2/` — Carbon proto에서 생성 (in-tree 관리)

## carbon-onboarding-bridge

`carbon-onboarding-bridge/` 는 Rust로 작성된 별도 데몬. Carbon 온보딩용 `ConfigService`와 `SetupService`를 Unix 소켓으로 제공하는 임시 gRPC 브리지 서비스이며, Flutter 앱과는 독립적으로 빌드/패키징된다.

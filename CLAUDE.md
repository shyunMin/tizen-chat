# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

Tizen OS 환경에서 Argot Agent Runtime과 대화하는 Flutter 기반 채팅 앱. 주 타겟은 Tizen TV이며, Linux 빌드로 로컬 개발을 병행한다.

## 커맨드

### 실행 (Tizen 디바이스)
```bash
flutter-tizen run
```

### 빌드
```bash
flutter-tizen build tpk          # Tizen 패키지 빌드
flutter build linux               # 로컬 Linux 빌드 (개발/디버깅용)
```

### 테스트
```bash
# Linux에서는 반드시 IS_TIZEN=false 필요 (Tizen 플러그인 호출 방지)
flutter test --dart-define=IS_TIZEN=false
flutter test test/agent_response_parser_test.dart --dart-define=IS_TIZEN=false
```

### 정적 분석
```bash
flutter analyze
```
`lib/generated/` 하위는 `analysis_options.yaml`에서 제외되어 있어 분석 대상이 아님.

### Proto 코드 생성 (Argot 쪽만)
```bash
scripts/gen-proto.sh <argot-repo-path>
# 예: scripts/gen-proto.sh ../argo-tizen
```
- 사전 조건: `protoc` 및 `protoc-gen-dart` (`dart pub global activate protoc_plugin`)

### 외부 메시지 주입 (HTTP)
```bash
curl -X POST http://localhost:7777/message \
  -H "Content-Type: application/json" \
  -d '{"text": "안녕하세요"}'
```

## 빌드 변수 (`--dart-define`)

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `IS_TIZEN` | `true` | Tizen 전용 API 활성화 여부. Linux/테스트에서는 `false` |
| `IS_TIZEN` | `true` | Tizen 전용 API 활성화 여부. Linux/테스트에서는 `false` |
| `ENABLE_HTTP_BUS` | `true` | 포트 7777 HTTP 메시지 버스 활성화 |
| `ENABLE_PERF_LOG` | `false` | 요청 성능 로깅 활성화 |
| `LAYOUT_MODE` | `single` | 응답 레이아웃 모드 (`single` / `multi`) |



## 아키텍처

### 아키텍처 패턴

`AgentGrpcService` (추상 클래스, `lib/services/agent_runtime_service.dart`)가 공통 인터페이스. `_ArgotAgentGrpcService`가 싱글턴으로 생성됨.

```
AgentGrpcService.instance → _ArgotAgentGrpcService → ArgotGrpcService (lib/services/argot_grpc_service.dart)
```

Argot 이벤트 타입을 공통 `AgentEvent` sealed class로 매핑. 새 이벤트 타입 추가 시 `_mapArgotEvent` 수정.

### 이벤트 타입 (sealed class)

`lib/services/agent_runtime_service.dart`에 정의된 공통 이벤트:

| 이벤트 | 설명 |
|--------|------|
| `AgentTextDelta` | 스트리밍 텍스트 조각 |
| `AgentMessageFinalized` | 어시스턴트 메시지 블록 완료 (`phase`: 1=Commentary, 2=FinalAnswer) |
| `AgentToolUseStart` | 도구 호출 시작 |
| `AgentToolResult` | 도구 호출 결과 |
| `AgentTurnComplete` | 전체 턴 완료 |
| `AgentTurnStarted` | 턴 시작 (Argot v1 미지원 — phase는 항상 null) |
| `AgentThreadComplete` | 스레드 완료 |
| `AgentError` | 에러 (`fatal=true`이면 재연결 필요) |
| `AgentSessionEnded` | 세션 종료 |
| `AgentToolApprovalRequest` | 도구 승인 요청 |
| `AgentSteerApplied/Failed` | mid-turn 스티어 결과 |
| `AgentSubmitQueued/Steered` | submit 큐/스티어 상태 |
| `AgentValidationStarted/Completed` | 검증 단계 |
| `AgentContinuationRequested` | 연속 실행 요청 |

스트림은 `StreamController.broadcast()`로 팬아웃.

### AgentTurnPhase 계층

`AgentTurnStarted`에 포함되어 버블 헤더 타이틀을 결정:

- `AgentTurnPhasePrompt` → "💬 Prompt"
- `AgentTurnPhaseStep(stepId, stepText, stepIndex, planStepCount)` → "🛠 Step N/M · 텍스트"
- `AgentTurnPhaseValidation(attempt)` → 타이틀 없음
- `AgentTurnPhaseRecovery` → "⚠️ Recovery"
- `AgentTurnPhaseFree` → "💭 Free"
- `AgentTurnPhaseUnknown` → 타이틀 없음

Argot v1은 `TurnStarted`를 발행하지 않으므로 phase는 항상 null.

### 응답 레이아웃 모드 (`LAYOUT_MODE`)

- **`single`(기본)**: 턴당 응답 항목 하나. 처리 중 텍스트/툴 인디케이터가 누적되고, `TurnComplete` 시점에 최종 답변으로 교체. `_activeReplyIndex`로 동일 항목을 계속 갱신.
- **`multi`**: `MessageFinalized`마다 항목을 봉인하고 새 항목 생성. 한 턴에 여러 항목 체인.

### ChatMessage / TurnToolEntry 구조

`lib/models/chat_message.dart`의 `ChatMessage`는 버블 UI 상태를 모두 담음:

- `phaseTitle`: 버블 상단 헤더(단계 제목). null = 헤더 없음.
- `tools: List<TurnToolEntry>`: 턴 중 사용된 도구 목록. 툴 이름 + 인자 미리보기 + 결과 미리보기.
- `validationPassed`: `AgentValidationCompleted(passed=true)` 수신 시 true → 아바타 옆 ✓ 표시.
- `currentToolIndicator`: 현재 실행 중인 툴 이름(텍스트 영역 위에 렌더). `ToolResult` 수신 또는 `TurnComplete`에서 null로 초기화.

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

`AgentOnboardingService`가 `ArgotOnboardingService`를 감쌈. Argot v1은 설정 RPC 미지원 → no-op으로 `ready=true` 반환. 실제 설정은 디바이스에서 `argot onboard` 명령으로 수행

### 응답 파싱

`AgentTurnComplete` 수신 후 `AgentResponseParser.parse()` 실행(`lib/services/agent_response_parser.dart`).

`` ```json `` 펜스 블록 처리 로직:
1. `content` 또는 `display_type` 키가 있으면 **canonical envelope**로 처리 (마지막 것 우선)
2. `plan` 배열만 있으면 메타데이터로 간주, 체크리스트로 렌더
3. 나머지 산문(prose) 텍스트가 있으면 `fallback`으로 반환
4. JSON 없거나 파싱 실패 시 원문을 `fallback`으로 반환

`display_type` 값: `"text"` | `"ui"` | `"device_control"` | `"hidden"` | `"fallback"`

**액션 버튼**: `content` 텍스트 내 `<a>내용</a>` 태그로 지정. `_extractButtons()`가 추출하고 `_removeAnchors()`로 태그를 제거한 텍스트를 버블에 표시.

### 소켓 경로

- **Argot**: `ARGOT_SOCKET_PATH` 환경변수 → `$XDG_RUNTIME_DIR/argot.sock` → `/tmp/argot-$USER.sock`

알려진 제한 사항은 `TODOS.md` 참조.

### 디자인 시스템

모든 색상·폰트·스타일 상수는 `lib/theme/tizen_styles.dart`의 `TizenStyles` 클래스에서 관리. RPi4 GPU 제약으로 blur, ShaderMask, 하드웨어 가속 효과 사용 금지.

## Proto 생성 파일

`lib/generated/` 하위 파일은 자동 생성이므로 직접 수정하지 않는다:
- `argot/v1/` — Argot proto에서 생성 (`scripts/gen-proto.sh`로 갱신)

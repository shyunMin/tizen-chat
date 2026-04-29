# Carbon 동시 요청 처리 분석 및 앱 대응 방안

> 분석 기준: `carbon-0424` / `ai-chat` (migrate-carbon 브랜치)

---

## 1. Carbon 서버의 동시 요청 처리 구조

### 1.1 MailboxPolicy

Carbon은 에이전트별로 설정 가능한 `MailboxPolicy`로 동시 요청을 처리한다.

| 정책 | 동작 | 기본값 |
|---|---|---|
| `Serialize` | 진행 중인 turn이 끝날 때까지 새 요청을 큐에 대기 | ✅ 기본값 |
| `DropIfBusy` | 진행 중인 turn이 있으면 새 요청을 즉시 버리고 `busy` 이벤트 전송 | — |

**핵심 코드:**
- `crates/core/runtime/src/agent_main.rs` L211–237
- `crates/core/runtime/src/config.rs` L469–481

```rust
match policy {
    MailboxPolicy::Serialize => {
        // 현재 turn 완료까지 블로킹 대기 후 처리
        if let Some((restored_session, _)) = restore_rx.recv().await { ... }
    }
    MailboxPolicy::DropIfBusy => {
        // 즉시 "busy" 이벤트 전송 후 다음 메시지로 진행
        egress_tx.send(EgressMessage { event_type: "busy", ... }).await;
        continue;
    }
}
```

### 1.2 IngressInput.source 기반 응답 라우팅

클라이언트가 `IngressInput.source`에 고유 식별자를 설정하면, Carbon은 해당 turn의 모든 응답 이벤트를 그 source로 라우팅한다.

```protobuf
// agent.proto
message IngressInput {
  string session_id = 1;
  IngressIntent intent = 2;
  string source = 3;   // 요청 식별자 — 응답 라우팅 키
  string text = 4;
  bool steer = 6;      // true면 진행 중인 turn에 입력 주입
}
```

- source 미지정 시 daemon이 `"grpc:connection-uuid"` 자동 할당
- 같은 source로 요청하면 같은 gRPC 연결로 응답

**핵심 코드:** `crates/infra/daemon/src/service.rs` L374–391

### 1.3 TurnStarted 브로드캐스트

새 turn이 시작될 때 `TurnStarted` 이벤트가 **모든 연결된 포트에 브로드캐스트**된다. turn 경계를 클라이언트가 감지하는 유일한 수단.

```protobuf
message TurnStarted {
  string source = 1;  // 요청을 보낸 source
  string prompt = 2;  // 유저 입력 요약
}
```

**핵심 코드:** `crates/core/runtime/src/agent_main.rs` L185–203  
**브로드캐스트 로직:** `crates/infra/daemon/src/service.rs` L252–260

### 1.4 이벤트에 turn_id 없음

`ServerEvent`에 `turn_id` 또는 `request_id` 필드가 **없다**. turn 간 이벤트 구분은 `TurnStarted` / `TurnComplete` 이벤트 경계로만 가능하다.

```protobuf
message ServerEvent {
  string session_id = 1;   // 세션 구분만 가능
  oneof event {
    TurnStarted turn_started = 15;
    TextDelta text_delta = 3;
    TurnComplete turn_complete = 6;
    // turn_id 없음
  }
}
```

### 1.5 Steer 메커니즘

진행 중인 turn에 새 입력을 주입할 수 있는 기능. `IngressInput.steer = true`로 설정하면 현재 turn의 다음 라운드 경계에서 처리된다.

**핵심 코드:** `crates/core/runtime/src/agent_main.rs` L170–181, L306

---

## 2. 현재 앱의 대응 상태

### 2.1 동시 요청 처리 — 이중 직렬화 (정상 동작 중)

Carbon의 Serialize 정책과 앱의 `_isTurnActive` busy-wait이 독립적으로 직렬화한다.

```
앱: Request A 전송
        ↓
앱: _isTurnActive = true (busy-wait으로 B 차단)
Carbon: Turn A 처리 → TurnComplete
        ↓
앱: _isTurnActive = false
앱: Request B 전송
Carbon: Turn B 처리 → TurnComplete
```

현재는 섞임 없이 동작하지만, Carbon 레벨 직렬화에만 의존하거나 앱 레벨만 의존해도 충분한 상황에서 두 레이어가 중복 동작 중.

**코드 위치:**
- UI 차단: `lib/screens/tizen_chat_home_screen.dart:169` (`_isWaiting` 체크)
- gRPC 차단: `lib/services/carbon_grpc_service.dart:317` (`_isTurnActive` busy-wait)

### 2.2 source 고정값 사용 — 라우팅 미활용

```dart
// carbon_grpc_service.dart:329
ingressInput: IngressInput(
  sessionId: _sessionId,
  source: "ai-chat-flutter",  // 모든 요청이 동일 source
  text: text,
),
```

요청마다 고유한 source를 설정하지 않아 Carbon의 per-request 응답 라우팅 기능을 활용하지 못하고 있다.

### 2.3 busy 이벤트 핸들러 없음

Carbon이 `DropIfBusy` 설정이거나 예외 상황에서 `busy` 이벤트를 보낼 경우 앱이 처리하지 못한다.

```dart
// carbon_grpc_service.dart — _handleServerEvent에 busy 케이스 없음
void _handleServerEvent(ServerEvent event) {
  if (event.hasTextDelta()) { ... }
  else if (event.hasTurnComplete()) { ... }
  // busy 이벤트 처리 없음
}
```

### 2.4 TurnStarted 수신만, 활용 없음

`TurnStarted` 이벤트를 받아도 로그 출력만 하고 turn 경계 감지에 활용하지 않는다.

```dart
// carbon_grpc_service.dart:242
} else if (event.hasTurnStarted()) {
  print('DEBUG: [CarbonGrpc] Event -> TurnStarted: ${event.turnStarted.source}');
  // 활용 없음
}
```

---

## 3. 현재 상태 요약

| 항목 | Carbon 서버 | 현재 앱 | 상태 |
|---|---|---|---|
| 동시 요청 직렬화 | Serialize (큐잉) | `_isTurnActive` busy-wait | ✅ 정상 동작 (중복) |
| 응답 라우팅 | source 기반 | 미활용 (고정 source) | ℹ️ 단일 클라이언트에선 실익 없음 |
| turn 경계 감지 | TurnStarted / TurnComplete | TurnComplete만 사용 | ⚠️ 부분 활용 |
| busy 이벤트 | DropIfBusy 시 전송 | 핸들러 없음 | ❌ 미처리 |
| turn_id | 없음 | 없음 | — |
| Steer 입력 주입 | 지원 | 미구현 | — (미사용) |

---

## 4. 앱에 추가되어야 하는 부분

### 4.1 [필수] busy 이벤트 처리

Carbon이 busy 이벤트를 보낼 때 앱이 적절히 대응해야 한다.

```dart
// _handleServerEvent에 추가
} else if (event.hasError() && event.error.code == 'busy') {
  _eventController.add(CarbonError('busy', 'Agent is busy', false));
}
```

앱 UI에서는 "잠시 후 다시 시도해주세요" 메시지 또는 재시도 로직으로 처리.

### 4.2 [참고] 요청별 고유 source 설정 — 병렬 처리와 무관

Carbon의 Serialize 정책은 **세션 단위**로 직렬화된다. 하나의 세션 안에서는 source를 고유하게 설정하더라도 선행 turn이 완료되기 전까지 다음 turn이 실행되지 않는다.

```
Session 1: [Request A (10초)] → [Request B (1초)]  ← B는 11초 후 완료
```

따라서 고유 source는 **병렬 실행을 제공하지 않는다.** 실익이 있는 경우는 여러 기기/앱 인스턴스가 동일 세션에 동시 접속한 멀티 클라이언트 환경에서, 응답이 올바른 연결로 라우팅되도록 보장할 때뿐이다.

**진짜 병렬 처리가 필요한 경우**: 세션을 분리해야 한다. 세션마다 독립적인 에이전트 루프를 가지므로 두 세션은 동시 실행된다. 단, 세션이 다르면 대화 컨텍스트(히스토리)도 분리되므로 현재 앱의 날짜 기반 단일 세션 구조와는 맞지 않는다.

**현재 앱(단일 클라이언트, 단일 세션)에서는 source 고유화 실익 없음.**

### 4.3 [권장] TurnStarted 이벤트 활용

`TurnStarted`를 turn 경계 신호로 활용하면 응답 스트림 상태를 더 명확히 관리할 수 있다.

```dart
} else if (event.hasTurnStarted()) {
  // 새 turn 시작 — 이전 응답 버퍼 초기화, UI 상태 전환 등
  _eventController.add(CarbonTurnStarted(source: event.turnStarted.source));
}
```

### 4.4 [선택] `_isTurnActive` busy-wait 제거

Carbon이 이미 Serialize 정책으로 큐잉하므로, 앱 레벨의 busy-wait은 중복이다. 제거하면 Carbon에 요청을 빠르게 전달하고 Carbon의 큐가 처리하도록 위임할 수 있다. 단, 브로드캐스트 스트림에서 turn 경계 구분 로직(4.3)이 먼저 갖춰져야 안전하게 제거 가능.

---

*작성일: 2026-04-29*

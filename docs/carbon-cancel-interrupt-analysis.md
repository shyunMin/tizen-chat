# Carbon 취소/인터럽트 동작 분석 및 앱 대응

> 분석 기준: `carbon-0424` / `ai-chat` (migrate-carbon 브랜치)

---

## 1. Carbon의 취소(Cancel) 메커니즘

### 1.1 InterruptTurnRequest 처리 흐름

앱이 `InterruptTurnRequest`를 전송하면 Carbon은 아래 흐름으로 처리한다.

```
앱: ClientMessage { interrupt_turn: { session_id } } 전송
        ↓
Carbon daemon: 해당 세션의 CancellationToken에 신호 전달
        ↓
Carbon agent_loop: 다음 await 체크포인트에서 취소 감지
        ↓
Carbon: Error { code: "cancelled", fatal: true } 전송
```

**핵심 코드:**
- `crates/infra/daemon/src/service.rs` — `InterruptTurnRequest` 수신 시 `cancel_token.cancel()` 호출
- `crates/core/runtime/src/agent_main.rs` — `tokio::select!` 내부에서 `cancel_token.cancelled()` 체크

### 1.2 취소가 즉시 반영되지 않는 이유

취소 신호는 **CancellationToken**을 통해 비동기로 전달된다. 에이전트 루프는 특정 await 지점에서만 토큰을 확인한다.

```
[취소 요청]
    ↓
LLM API 호출 중 → 취소 감지 불가 (I/O 대기 중)
    ↓
LLM 응답 완료 → 응답 처리 시작
    ↓
다음 await 체크포인트 도달 → 취소 감지
    ↓
Error { code: "cancelled", fatal: true } 전송
```

**결과:** 취소 요청 시점에 LLM이 이미 응답을 생성 중이라면, 해당 응답은 **그대로 클라이언트에 전달**된다. 취소는 다음 라운드 진입 전에 적용된다.

이는 Carbon의 설계상 한계가 아니라 비동기 취소의 일반적인 특성이다.

---

## 2. 잔여 이벤트(Leftover Events) 문제

### 2.1 발생 원인

```
앱: interruptTurn() 호출
앱: _eventController에 CarbonError("cancelled", ..., fatal: true) 즉시 emit
앱: sendMessage()의 await for 루프가 종료됨 (_isTurnActive = false)

[시간차 발생]

Carbon: 취소 감지 전에 TextDelta, TurnComplete 등 이벤트 계속 전송
앱: _handleServerEvent()가 이를 _eventController에 그대로 emit
```

앱이 로컬에서 즉시 `cancelled` 에러를 emit해 현재 `sendMessage()` 루프를 종료하더라도, Carbon이 비동기로 완료한 이전 턴의 잔여 이벤트는 **broadcast 스트림에 계속 투입**된다.

### 2.2 잔여 이벤트가 다음 요청을 오염시키는 시나리오

```
Time 0:  sendMessage("A") → _isTurnActive = true
Time 1:  interruptTurn() → CarbonError("cancelled") emit
Time 2:  sendMessage() 루프 종료 → _isTurnActive = false
Time 3:  sendMessage("B") → _isTurnActive = true
Time 3+: Carbon이 A 턴 잔여 이벤트(TextDelta, TurnComplete) 도착
Time 3+: B의 sendMessage()가 A 턴 이벤트를 자신의 응답으로 소비
```

B 요청이 A 요청의 응답을 받는 오염(contamination)이 발생한다.

### 2.3 잔여 이벤트 폐기가 의미 있는 이유

Carbon은 취소 이후 추가 LLM 호출을 시작하지 않는다. 잔여 이벤트는 **이미 완료된 마지막 LLM 응답의 꼬리 부분**이다. 무한히 이벤트가 쏟아지는 것이 아니라 유한한 tail이므로, 폐기 처리로 실질적으로 오염을 방지할 수 있다.

---

## 3. 앱의 대응 — 두 가지 버그 수정

### 3.1 [버그 수정] `_isConnected = false` 오처리

Carbon은 취소 완료 시 `Error { code: "cancelled", fatal: true }`를 전송한다. `fatal: true`였기 때문에 앱이 이를 연결 끊김으로 오해했다.

```dart
// 수정 전 — 취소 시 연결이 끊어졌다고 잘못 판단
if (event.error.fatal) _isConnected = false;

// 수정 후 — cancelled는 연결 유지
if (event.error.fatal && event.error.code != 'cancelled') _isConnected = false;
```

**영향:** 수정 전에는 취소 후 다음 `sendMessage()` 시 재연결이 불필요하게 발생했다.

### 3.2 [버그 수정] `_discardingOldTurnEvents` 플래그

잔여 이벤트가 다음 `sendMessage()`를 오염시키는 문제를 해결한다.

```dart
// carbon_grpc_service.dart

bool _discardingOldTurnEvents = false;

void _handleServerEvent(ServerEvent event) {
  if (_discardingOldTurnEvents) {
    if (event.hasTurnStarted()) {
      _discardingOldTurnEvents = false;
      // 새 턴 시작 — 정상 처리로 복귀
    } else if (event.hasSessionEnded() ||
        (event.hasError() && event.error.fatal)) {
      // 연결/세션 종료 이벤트는 항상 통과
    } else {
      return; // 이전 턴 잔여 이벤트 폐기
    }
  }
  // ... 정상 이벤트 처리
}

void interruptTurn() {
  // ... InterruptTurnRequest 전송
  _eventController.add(CarbonError("cancelled", "interrupted by user", true));
  _discardingOldTurnEvents = true; // 다음 TurnStarted까지 폐기 모드
}
```

**폐기 종료 시점:** Carbon이 다음 턴을 시작할 때 보내는 `TurnStarted` 이벤트를 수신하면 폐기 모드를 해제한다. `TurnStarted`는 새 입력에 대한 처리가 실제로 시작됐음을 나타내는 공식 경계 신호다.

---

## 4. 세션 분리로 근본적 해결 가능 여부

### 4.1 현재 구조의 한계

현재 앱은 단일 gRPC 스트림에서 모든 이벤트를 broadcast로 팬아웃한다. 취소와 잔여 이벤트 문제는 이 단일 스트림 구조에서 비롯된다.

```
단일 스트림: [A 잔여] [B 응답] [A 잔여] → 순서 보장 불가
```

### 4.2 세션 분리 시 개선

Carbon에서 세션은 독립적인 에이전트 루프를 가진다. 세션을 분리하면 각 요청이 **독립된 스트림**을 통해 응답을 받는다.

```
Session 1 스트림: [A 응답만] → 오염 없음
Session 2 스트림: [B 응답만] → 오염 없음
```

잔여 이벤트가 다른 세션 스트림으로 유출되지 않으므로 `_discardingOldTurnEvents` 같은 방어 로직이 불필요해진다.

### 4.3 세션 분리의 트레이드오프

| 항목 | 현재 (단일 세션) | 세션 분리 |
|---|---|---|
| 대화 컨텍스트 | 연속됨 | 세션마다 독립 (공유 불가) |
| 이벤트 오염 | 방어 코드 필요 | 구조적으로 없음 |
| 병렬 처리 | 직렬화됨 | 실제 병렬 가능 |
| 구현 복잡도 | 낮음 | 세션 생성/관리 오버헤드 |

현재 앱의 날짜 기반 단일 세션 구조에서는 대화 연속성이 중요하므로 세션 분리 도입 시 컨텍스트 관리 전략을 별도로 설계해야 한다.

---

## 5. 현재 상태 요약

| 항목 | 상태 |
|---|---|
| `InterruptTurnRequest` 전송 | ✅ 구현됨 |
| 로컬 즉시 cancelled 에러 emit (UI 피드백) | ✅ 구현됨 |
| `_isConnected` 오처리 버그 | ✅ 수정됨 (`code != 'cancelled'` 가드) |
| 잔여 이벤트 오염 방지 | ✅ 구현됨 (`_discardingOldTurnEvents`) |
| LLM 처리 중 즉시 중단 | ❌ 불가능 (비동기 취소 한계) |
| 세션 분리로 구조적 해결 | — 미구현 (컨텍스트 관리 전략 필요) |

---

*작성일: 2026-04-29*

# Carbon 세션 관리 분석

> 분석 기준: carbon-0425 (`tizen_aios` 브랜치), ai-chat Flutter 클라이언트

---

## 1. 아키텍처 개요

Carbon 데몬과 Flutter 클라이언트는 단일 gRPC 양방향 스트림으로 통신합니다.
세션은 스트림 수명과 동일하며, 첫 메시지로 `CreateSessionRequest`를 보내야 합니다.

```
Flutter App                         Carbon Daemon (Unix socket)
───────────                         ──────────────────────────
gRPC 스트림 오픈
── CreateSessionRequest ──────────> alias 도출 → 세션 조회/생성
<─ SessionCreated(session_id) ──────
── IngressInput(text) ────────────> 에이전트 턴 실행
<─ TextDelta / TurnComplete ────────
── CancelSessionRequest ──────────> 세션 종료
<─ SessionEnded ────────────────────
```

**소켓 경로**: `/run/user/5001/carbon/carbon.sock`

---

## 2. 세션 Alias 메커니즘

### 공식 (`session.rs:91-98`)

```
alias = "session:" + <product> + ":" + base64url(<workspace>) + ":" + base64url(<session_name>)
```

- `session_name`이 비어있으면 `"main"`으로 정규화 (`normalize_session_name`)
- base64는 URL-safe, no-padding 인코딩

### 예시

```
product:      "claw"
workspace:    "/home/owner/.carbon/workspace"
session_name: "main"

→ alias: "session:claw:L2hvbWUvb3duZXIvLmNhcmJvbi93b3Jrc3BhY2U:bWFpbg"
```

### 동작 (`service.rs:145-196`)

```
CreateSessionRequest 수신
        │
        ├─ alias 도출
        │
        ├─ get_by_alias(alias) → 살아있는 세션 있음?
        │       ├─ YES: 기존 세션 재연결 (대화 히스토리 유지)
        │       └─ NO:  새 세션 spawn
        │
        └─ SessionCreated(session_id) 반환
```

> **주의**: `get_by_alias()`는 데몬 메모리 내 살아있는 세션만 조회합니다.
> 데몬이 재시작되면 alias가 같아도 새 세션이 생성됩니다.

---

## 3. Proto 메시지 정의 (`agent.proto`)

### 클라이언트 → 서버

```protobuf
message CreateSessionRequest {
  string product = 1;                  // "claw"
  map<string, string> config = 2;      // 아래 config 키 참고
}

message CancelSessionRequest {
  string session_id = 1;               // 세션 종료
}

message InterruptTurnRequest {
  string session_id = 1;               // 현재 턴만 중단, 세션 유지
}
```

### 지원되는 `config` 키

| 키 | 설명 | 예시 |
|----|------|------|
| `workspace` | 툴 실행 기준 디렉토리 | `"/home/owner/.carbon/workspace"` |
| `session` | 세션 이름 (alias 도출에 사용) | `"main"`, `"project-a"` |
| `model` | LLM 모델 오버라이드 | `"claude-sonnet-4-6"` |
| `provider` | LLM 프로바이더 오버라이드 | `"anthropic"`, `"gemini"` |
| `approval_mode` | 툴 승인 정책 | `"strict"`, `"normal"`, `"permissive"`, `"off"` |

### 서버 → 클라이언트

```protobuf
message SessionCreated {
  string session_id = 1;   // 새 세션 또는 재연결된 세션의 UUID
}

message SessionEnded {
  string reason = 1;
}
```

> 클라이언트는 새 세션인지 기존 세션 재연결인지 구분할 수 없습니다.
> 데몬 내부에서만 구분합니다.

---

## 4. 현재 Flutter 앱 구현 현황

**파일**: `lib/services/carbon_grpc_service.dart`

### 구현된 것

- gRPC 싱글톤 + 자동 재연결
- `CreateSessionRequest` 전송 (연결 즉시)
- `SessionCreated` 수신 → `_sessionId` 저장
- `IngressInput`으로 텍스트 전송
- 이벤트 broadcast (`StreamController`)

### 현재 요청 코드 (`carbon_grpc_service.dart:125-132`)

```dart
CreateSessionRequest(
  product: "claw",
  config: {"workspace": workspacePath},
)
```

### 누락된 것

| 항목 | 설명 |
|------|------|
| `config["session"]` 미사용 | 항상 `"main"`으로 처리됨 |
| session 이름 로컬 저장 없음 | 앱 재시작 시 의도적 세션 선택 불가 |
| 세션 목록 관리 없음 | `ListSessions` RPC 자체가 없음 |

---

## 5. 구현 가이드

### 새 세션 시작

```dart
Future<void> createNewSession({String? sessionName}) async {
  final name = sessionName ?? DateTime.now().millisecondsSinceEpoch.toString();

  // 로컬 저장 (SharedPreferences 등)
  await _prefs.setString('active_session', name);

  await _sendMessage(ClientMessage(
    createSession: CreateSessionRequest(
      product: "claw",
      config: {
        "workspace": workspacePath,
        "session": name,
      },
    ),
  ));
}
```

### 이전 세션 이어가기

```dart
Future<void> resumeSession(String sessionName) async {
  await _sendMessage(ClientMessage(
    createSession: CreateSessionRequest(
      product: "claw",
      config: {
        "workspace": workspacePath,
        "session": sessionName,  // 저장해둔 이름과 동일하게
      },
    ),
  ));
}
```

### 앱 시작 시 자동 복원

```dart
Future<void> connectAndRestore() async {
  await connect();

  final saved = _prefs.getString('active_session');
  if (saved != null) {
    await resumeSession(saved);
  } else {
    await createNewSession();
  }
}
```

### 세션 목록 로컬 관리

`ListSessions` RPC가 없으므로 Flutter 앱이 직접 관리해야 합니다.

```dart
Future<void> saveSessionMeta(String name, String title) async {
  final sessions = _prefs.getStringList('session_list') ?? [];
  sessions.add(jsonEncode({
    'name': name,
    'title': title,
    'createdAt': DateTime.now().toIso8601String(),
  }));
  await _prefs.setStringList('session_list', sessions);
}

List<Map<String, dynamic>> listSessions() {
  return (_prefs.getStringList('session_list') ?? [])
      .map((s) => jsonDecode(s) as Map<String, dynamic>)
      .toList()
      ..sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
}
```

---

## 6. 세션 재연결 가능 조건

| 상황 | 결과 |
|------|------|
| 데몬 실행 중 + 동일 session 이름 | ✅ 기존 세션 재연결 (대화 이어가기) |
| 데몬 실행 중 + 다른 session 이름 | 🆕 새 세션 생성 |
| 데몬 재시작 후 + 동일 session 이름 | 🆕 새 세션 생성 (alias 매칭 실패) |
| config["session"] 미설정 | ✅ workspace당 "main" 세션으로 항상 동일 alias |

---

## 7. 관련 소스 파일

| 파일 | 위치 | 역할 |
|------|------|------|
| `agent.proto` | `carbon-0425/crates/core/proto/proto/carbon/v1/` | gRPC 메시지 정의 |
| `session.rs` | `carbon-0425/crates/core/runtime/src/` | alias 도출 로직 (L91-98) |
| `service.rs` | `carbon-0425/crates/infra/daemon/src/` | 세션 생성/재연결 분기 (L145-196) |
| `session_manager.rs` | `carbon-0425/crates/infra/daemon/src/` | SessionHandle, get_by_alias |
| `carbon_grpc_service.dart` | `ai-chat/lib/services/` | Flutter gRPC 클라이언트 |
| `agent.pb.dart` | `ai-chat/lib/generated/carbon/v1/` | 생성된 proto Dart 바인딩 |

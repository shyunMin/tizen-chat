# REQ_017 | SessionManagement — 날짜 기반 세션 관리

## 개요

앱 시작 시 오늘 날짜로 Carbon 세션을 자동 생성/재연결하고,
세션 목록을 앱 로컬에 파일로 관리한다.
`_SessionHeader`는 탭 가능한 UI로 변경하되, 실제 세션 로드는 추후 구현한다.

---

## 0. 현재 상태 파악

| 항목 | 현황 |
|------|------|
| `CreateSessionRequest.config` | `{"workspace": path}` 만 전달 — `session` 키 없음 |
| 세션 이름 | 항상 Carbon 기본값 `"main"` |
| 앱 세션 목록 | 없음 |
| `_SessionHeader` | StatelessWidget, 클릭 불가 |

---

## 1. 데이터 흐름

```
앱 시작
  └─ SessionRepository.init()
        ├─ 오늘 날짜(2025-04-25) → 세션 이름 도출
        ├─ 로컬 세션 목록 파일 조회
        │     ├─ 오늘 날짜 항목 있음 → 기존 세션 이름 사용
        │     └─ 없음 → 새 항목 추가 후 저장
        └─ CarbonGrpcService.connect(sessionName: "2025-04-25")
              └─ CreateSessionRequest { config: { "workspace": ..., "session": "2025-04-25", "session_date": "2025-04-25" } }
```

---

## 2. 신규 파일 및 역할

### 2-1. `lib/models/session_meta.dart` (신규)

세션 목록 파일의 각 항목 모델.

```dart
class SessionMeta {
  final String name;       // "2025-04-25"  (Carbon session 이름 = 날짜)
  final String title;      // 화면에 표시할 타이틀 = name과 동일
  final String createdAt;  // ISO 8601

  SessionMeta({required this.name, required this.title, required this.createdAt});

  Map<String, dynamic> toJson() => {'name': name, 'title': title, 'createdAt': createdAt};
  factory SessionMeta.fromJson(Map<String, dynamic> json) => SessionMeta(
    name: json['name'],
    title: json['title'],
    createdAt: json['createdAt'],
  );
}
```

---

### 2-2. `lib/services/session_repository.dart` (신규)

세션 목록 파일 I/O + 오늘 날짜 세션 결정 로직.

#### 저장 경로

```
{getApplicationSupportDirectory()}/session_list.json
```

> Tizen 실경로: `/opt/usr/home/owner/apps_rw/org.tizen.chat-ui/data/session_list.json`

#### 파일 형식 (JSON 배열)

```json
[
  { "name": "2025-04-24", "title": "2025-04-24", "createdAt": "2025-04-24T08:00:00.000Z" },
  { "name": "2025-04-25", "title": "2025-04-25", "createdAt": "2025-04-25T09:00:00.000Z" }
]
```

#### 주요 메서드

```dart
class SessionRepository {
  static final SessionRepository instance = SessionRepository._();

  /// 오늘 날짜 세션을 보장하고 세션 이름(날짜 문자열)을 반환
  Future<String> ensureTodaySession() async { ... }

  /// 목록 전체 반환
  Future<List<SessionMeta>> listSessions() async { ... }

  // -- 내부 --
  Future<List<SessionMeta>> _load() async { ... }
  Future<void> _save(List<SessionMeta> sessions) async { ... }
  String _todayKey() => "${now.year.toString().padLeft(4,'0')}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}";
}
```

**`ensureTodaySession()` 로직:**

```
1. _load() → sessions
2. today = _todayKey()          // "2025-04-25"
3. sessions에 today 항목 있음?
     있음 → return today
     없음 → sessions.add(SessionMeta(name: today, title: today, ...))
             _save(sessions)
             return today
```

> intl 패키지 의존성 없이 String 포매팅으로 날짜 도출

---

## 3. 기존 파일 수정

### 3-1. `lib/services/carbon_grpc_service.dart`

#### `connect()` 시그니처 변경

```dart
// 변경 전
Future<void> connect() async { ... }

// 변경 후
Future<void> connect({String? sessionName}) async { ... }
```

#### 내부에 `_sessionName` 필드 추가

```dart
String? _sessionName;
```

#### `CreateSessionRequest` 변경

```dart
CreateSessionRequest(
  product: "claw",
  config: {
    "workspace": workspacePath,
    if (_sessionName != null) "session": _sessionName!,
    if (_sessionName != null) "session_date": _sessionName!,
  },
)
```

#### `reconnect()` 변경

```dart
Future<void> reconnect() async {
  await disconnect();
  await connect(sessionName: _sessionName);  // 기존 세션 이름 유지
}
```

---

### 3-2. `lib/screens/tizen_chat_home_screen.dart`

#### `_initializeServices()` 변경

```dart
Future<void> _initializeServices() async {
  try {
    // 1. 오늘 세션 확보 + 로컬 목록에 기록
    final sessionName = await SessionRepository.instance.ensureTodaySession();

    // 2. UI 타이틀 설정
    if (mounted) setState(() => _sessionTitle = sessionName);

    // 3. 세션 이름으로 gRPC 연결
    await _grpcService.connect(sessionName: sessionName);
  } catch (e) {
    debugPrint('[Init] Error: $e');
  }
}
```

#### import 추가

```dart
import '../services/session_repository.dart';
```

---

### 3-3. `lib/widgets/chat_window.dart`

#### `ChatWindow` 파라미터 추가

```dart
class ChatWindow extends StatefulWidget {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String sessionTitle;
  final VoidCallback? onHeaderTap;   // 추가

  const ChatWindow({
    super.key,
    required this.messages,
    required this.isTyping,
    required this.sessionTitle,
    this.onHeaderTap,
  });
}
```

#### `_SessionHeader` — GestureDetector 래핑 및 아이콘 추가

```dart
class _SessionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const _SessionHeader({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        ...
        child: Row(
          children: [
            // 기존 파란 점
            // 기존 타이틀 Text
            // 추가: 오른쪽 아이콘 힌트
            Icon(Icons.expand_more, size: 14, color: Colors.white.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}
```

내부에서 `_SessionHeader`에 `onTap` 전달:

```dart
_SessionHeader(title: widget.sessionTitle, onTap: widget.onHeaderTap)
```

#### `HomeScreen`에서 `ChatWindow` 호출 시 콜백 전달

```dart
ChatWindow(
  key: _chatWindowKey,
  messages: _messages,
  isTyping: _isTyping,
  sessionTitle: _sessionTitle,
  onHeaderTap: () {
    // TODO: 세션 목록 팝업 (추후 구현)
    debugPrint('[SessionHeader] tapped — session picker not yet implemented');
  },
)
```

---

## 4. 세션 데이터 저장 위치 (Carbon 서버 관리, 참고용)

앱은 직접 읽고 쓰지 않음.

```
{getApplicationSupportDirectory()}/tizen_ai/sessions/<session_id>.jsonl
```

Tizen 실경로 예시:
```
/opt/usr/home/owner/apps_rw/org.tizen.chat-ui/data/tizen_ai/sessions/2d8bb183-....jsonl
```

JSONL 형식: `session_data_sample.jsonl` 참고.

---

## 5. 구현 순서

1. `lib/models/session_meta.dart` 신규 생성
2. `lib/services/session_repository.dart` 신규 생성
3. `lib/services/carbon_grpc_service.dart` — `connect({sessionName})` + `_sessionName` 필드 수정
4. `lib/widgets/chat_window.dart` — `onHeaderTap` 파라미터 + `_SessionHeader` GestureDetector 추가
5. `lib/screens/tizen_chat_home_screen.dart` — `_initializeServices()` 수정, ChatWindow 콜백 전달
6. 빌드 에러 없는지 확인

---

## 6. 구현 프롬프트 (`/impl 017` 또는 `/impl SessionManagement`)

위 설계를 기반으로 다음을 구현하라:

1. `lib/models/session_meta.dart` — `SessionMeta` 모델 (toJson/fromJson 포함)
2. `lib/services/session_repository.dart` — `SessionRepository` 싱글톤
   - `ensureTodaySession()`: 오늘 날짜 키로 목록 조회, 없으면 추가 후 저장
   - `listSessions()`: 전체 목록 반환
   - 저장 경로: `{appSupportDir}/session_list.json`
   - `intl` 패키지 없이 날짜 포매팅 처리
3. `lib/services/carbon_grpc_service.dart` 수정
   - `connect({String? sessionName})` — config에 `"session"`, `"session_date"` 추가
   - `_sessionName` 필드 저장 및 `reconnect()`에서 재사용
4. `lib/widgets/chat_window.dart` 수정
   - `ChatWindow.onHeaderTap: VoidCallback?` 파라미터 추가
   - `_SessionHeader`에 `GestureDetector` 래핑, `onTap` 연결
   - 헤더 오른쪽에 `Icons.expand_more` 아이콘 추가
5. `lib/screens/tizen_chat_home_screen.dart` 수정
   - `_initializeServices()`: `SessionRepository.ensureTodaySession()` → `_sessionTitle` 설정 → `connect(sessionName: ...)` 호출
   - `ChatWindow`에 `onHeaderTap` 콜백 전달 (본문은 `debugPrint`만)
6. 빌드 에러 없는지 확인

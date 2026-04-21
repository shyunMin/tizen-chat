# REQ_016: TizenChatHomeScreen 인라인 채팅 오버레이

## 1. 분석 (Analysis)

### 목표
- 최초 진입: 프롬프트바만 보임 (현재와 동일, 파란 glow 효과)
- 첫 메시지 전송 후: 프롬프트바 **위로** 대화창이 위쪽 방향으로 펼쳐지며 나타남
- 대화창 출현 이후: 프롬프트바 스타일이 대화창과 룩앤필이 일치하도록 단순한 테마로 전환
- 대화가 누적될수록 대화창이 위로 길어짐 (최대 높이 제한 후 스크롤)
- 별도 화면 전환(Navigator.push) 없이 홈화면 안에서 모든 것이 처리됨

### 현재 구조 분석
- `TizenChatHomeScreen`: 프롬프트바+배경컨테이너 렌더링. 메시지 전송 로직 있으나 단발성(스트리밍 없음)
- `TizenChatScreen` (chat_screen.dart): 완전한 gRPC 스트리밍 대화 로직 + 메시지 목록 UI
- `PromptBar`: `_hasSentOnce` 내부 상태로 전송 후 자동으로 파란 glow → 흰색 subtle 전환 (**이미 구현됨, 외부 param 불필요**)
- `ReceivedMessage`, `SentMessage`, `TypingIndicator`: 재사용 가능한 독립 위젯으로 분리되어 있음
- 배경 컨테이너: `bottom: 60`, 너비 70%, glassmorphism 스타일

### 핵심 발견
- `PromptBar._hasSentOnce`는 이미 `onSend` 호출 시 내부에서 `true`로 전환됨
  → 파란 glow → 단순 흰색 테두리 전환은 **자동으로 동작**
- `TizenChatScreen.build()`의 `AnimatedSize(alignment: Alignment.bottomCenter, ...)`가 목표하는 "위로 팽창" 패턴의 정확한 구현체임 → 그대로 차용
- 배경 컨테이너(glassmorphism box): 대화창 출현 후 **숨기거나** 대화창 하단과 시각적으로 연결

---

## 2. 설계 (Design)

### 상태 변수 추가 (`_TizenChatHomeScreenState`)
```dart
// 기존 유지
bool _isVisible;
bool _isWaiting;
bool _shouldSlideDown;

// 신규 추가
bool _hasChatStarted = false;       // 대화 시작 여부 (대화창 노출 트리거)
bool _isTyping = false;             // 타이핑 인디케이터
List<ChatMessage> _messages = [];   // 전체 대화 메시지
final ScrollController _scrollController = ScrollController();
```

### 위젯 트리 구조
```
Scaffold
└── Stack
    ├── DimOverlay
    │
    ├── [NEW] 대화창 영역 (AnimatedPositioned)
    │   └── AnimatedSize(alignment: Alignment.bottomCenter)
    │       └── Container (어두운 배경, ChatScreen 스타일 동일)
    │           └── ListView (SentMessage / ReceivedMessage / TypingIndicator)
    │
    ├── 배경 컨테이너 (AnimatedPositioned) ← _hasChatStarted 시 숨김
    │   └── AnimatedContainer (glassmorphism)
    │
    └── PromptBar (AnimatedPositioned)
```

### 레이아웃 좌표 계산
- PromptBar `bottom`: `60px` (기존 유지)
- PromptBar `height`: `70px`
- 대화창 `bottom`: `60 + 70 + 8 = 138px` (PromptBar 바로 위 8px 간격)
- 대화창 `maxHeight`: `MediaQuery.height * 0.65`
- 대화창 `width`: `MediaQuery.width * 0.7` (PromptBar와 동일)

### 대화창 Container 스타일 (ChatScreen과 동일)
```dart
decoration: BoxDecoration(
  color: Colors.grey[900]?.withValues(alpha: 0.95),
  borderRadius: BorderRadius.circular(24),
  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 24, ...)],
),
```

### 대화창 출현 애니메이션
- `_hasChatStarted = true` → `AnimatedSize`가 `height: 0 → content height`로 자동 애니메이션
- `AnimatedPositioned`로 `bottom: 60 → 138`으로 동시에 이동 (배경 컨테이너가 위로 올라가는 효과)
- `duration: 400ms`, `curve: Curves.easeOutCubic`

### 대화 로직 (`_handleSend` 완전 교체)
`TizenChatScreen._handleUserMessage()`를 그대로 포팅:
1. `_messages`에 sent 메시지 추가
2. `_hasChatStarted = true` 설정
3. gRPC stream 수신 → `CarbonTextDelta`, `CarbonToolUseStart`, `CarbonToolResult`, `CarbonTurnComplete`, `CarbonError` 처리
4. `_isTyping` 상태로 `TypingIndicator` 표시
5. 메시지 수신 시 `_scrollToBottom()` 호출

---

## 3. 수정 파일 목록

| 파일 | 변경 유형 | 내용 |
|---|---|---|
| `lib/screens/tizen_chat_home_screen.dart` | 수정 | 상태 추가, `_handleSend` 교체, 대화창 위젯 추가 |

> `chat_screen.dart`, `PromptBar`, 메시지 위젯들은 **수정 없이 재사용**

---

## 4. 구현 프롬프트 (Implementation Prompt)

```
아래 명세대로 `lib/screens/tizen_chat_home_screen.dart`를 수정해줘.

### 목표
- 첫 메시지 전송 시 프롬프트바 위에 대화창이 위로 펼쳐지는 애니메이션으로 나타남
- 이후 대화가 쌓이면 위로 길어지고, 최대 높이 도달 후 내부 스크롤
- PromptBar는 그대로 유지 (내부적으로 _hasSentOnce가 자동 처리됨)

### 상태 추가
`_TizenChatHomeScreenState`에 다음 추가:
- `bool _hasChatStarted = false`
- `bool _isTyping = false`
- `List<ChatMessage> _messages = []`
- `final ScrollController _scrollController = ScrollController()`
- `void _scrollToBottom()` 메서드 (ChatScreen과 동일하게)

### `_handleSend()` 전면 교체
기존 간단한 로직을 `chat_screen.dart`의 `_handleUserMessage()` 로직으로 완전 교체:
1. 첫 줄에서 `_hasChatStarted = true` 설정
2. `_messages`에 sent 메시지 추가 후 `_scrollToBottom()`
3. `_isTyping = true` 설정
4. gRPC stream (`_grpcService.sendMessage(text)`) 수신 처리
   - `CarbonTextDelta`: 텍스트 누적, 첫 delta 시 received 메시지 객체 생성 후 갱신
   - `CarbonToolUseStart`: 도구 실행 텍스트 표시
   - `CarbonToolResult`: 도구 완료
   - `CarbonTurnComplete`: `AgentResponseParser.parse()` 후 최종 메시지 확정, `_isTyping = false`
   - `CarbonError`: 오류 메시지 / `CarbonSessionEnded`: 재연결
5. 각 단계에서 `_scrollToBottom()` 호출

### `build()` 수정 - Stack에 대화창 추가
기존 배경 컨테이너와 PromptBar 사이(또는 그 위)에 다음 추가:

```dart
// 대화창 (PromptBar 위, _hasChatStarted일 때 표시)
if (_hasChatStarted)
  Positioned(
    bottom: 138, // 60(bottom) + 70(PromptBar height) + 8(gap)
    left: 0,
    right: 0,
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 24, spreadRadius: 2, offset: Offset(0, 8),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TypingIndicator(showAvatar: true),
                  );
                }
                final message = _messages[index];
                Widget widget;
                switch (message.type) {
                  case MessageType.sent:
                    widget = SentMessage(text: message.text);
                    break;
                  case MessageType.received:
                    widget = ReceivedMessage(
                      text: message.text,
                      avatarInitial: message.senderInitial,
                      isWaiting: message.isWaiting,
                      displayType: message.displayType,
                    );
                    break;
                  default:
                    widget = SentMessage(text: message.text);
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: widget,
                );
              },
            ),
          ),
        ),
      ),
    ),
  ),
```

### 배경 컨테이너 수정
`_hasChatStarted`가 `true`이면 배경 컨테이너를 숨김:
- `AnimatedOpacity(opacity: _hasChatStarted ? 0.0 : 1.0, ...)`로 감싸거나
- `if (!_hasChatStarted)` 조건부 렌더링

### import 추가
`../widgets/received_message.dart`, `../widgets/sent_message.dart`, `../widgets/typing_indicator.dart` 확인 (이미 있을 수 있음)

### dispose 수정
`_scrollController.dispose()` 추가
```

---

## 5. 확정된 결정사항 (Decisions)

| # | 항목 | 결정 |
|---|---|---|
| 1 | ESC/뒤로가기 | **앱 종료** (대화창 유무 관계없이) |
| 2 | 새 메시지 전송 시 | **세션 초기화 후 새 대화 시작**. `_messages` 초기화, gRPC 새 세션 오픈. 대화창 상단에 세션 제목 표시 (추후 세션 선택 UI로 확장 가능하도록 별도 위젯으로 격리) |
| 3 | 외부 메시지(HttpMessageBus) | **사용자 입력과 동일하게 처리** → `_handleSend(msg)` 호출, 대화창 자동 오픈 |
| 4 | 배경 glassmorphism 컨테이너 | **완전 삭제** |

---

## 6. 세션 헤더 설계 (Session Header)

대화창 최상단에 고정되는 헤더 영역:

```
┌─────────────────────────────────────────┐
│  ● 세션 제목 (입력 텍스트 앞 20자)      │  ← _SessionHeader 위젯
├─────────────────────────────────────────┤
│  메시지 목록...                         │
└─────────────────────────────────────────┘
```

- **위젯명**: `_SessionHeader` (private, 동일 파일 내 정의)
- **표시 내용**: 사용자 최초 입력 텍스트 기반으로 제목 생성 (20자 초과 시 `...` 처리)
- **스타일**: 좌측 작은 돌기(●), 회색 텍스트, 하단 구분선
- **확장성**: `sessionId`, `title`을 파라미터로 받아 추후 세션 목록 탭으로 발전 가능하도록 인터페이스 정의

```dart
class _SessionHeader extends StatelessWidget {
  final String title;
  const _SessionHeader({required this.title});
  // ...
}
```

---

## 7. 최종 구현 프롬프트 (Final Implementation Prompt)

```
`lib/screens/tizen_chat_home_screen.dart`를 아래 명세대로 전면 수정해줘.

### 확정 동작
- ESC: 상태 무관 앱 종료
- 새 메시지 전송: 항상 대화 초기화 후 새 세션 시작 (이전 히스토리 삭제)
- HttpMessageBus 외부 메시지: _handleSend() 와 동일 처리, 대화창 자동 오픈
- 기존 glassmorphism 배경 컨테이너: 완전 삭제

### 상태 추가
```dart
bool _hasChatStarted = false;
bool _isTyping = false;
List<ChatMessage> _messages = [];
String _sessionTitle = '';
final ScrollController _scrollController = ScrollController();
```

### dispose() 수정
`_scrollController.dispose()` 추가

### _scrollToBottom() 메서드 추가
```dart
void _scrollToBottom() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });
}
```

### _handleSend() 완전 교체
chat_screen.dart의 _handleUserMessage() 로직 기반으로 교체:

```dart
Future<void> _handleSend(String text) async {
  if (_isWaiting) return;
  _keyboardFocusNode.requestFocus();

  // 새 세션 시작: 항상 초기화
  setState(() {
    _messages.clear();
    _hasChatStarted = true;
    _isWaiting = true;
    _isTyping = true;
    _sessionTitle = text.length > 20 ? '${text.substring(0, 20)}...' : text;
    _messages.add(ChatMessage(text: text, type: MessageType.sent));
  });
  _scrollToBottom();

  try {
    String accumulatedText = '';
    String? activeToolName;
    int replyIndex = -1;

    final stream = _grpcService.sendMessage(text);
    await for (final event in stream) {
      if (!mounted) break;
      if (_isTyping && replyIndex != -1) {
        setState(() => _isTyping = false);
      }
      switch (event) {
        case CarbonTextDelta(:final content):
          accumulatedText += content;
          if (replyIndex == -1) {
            replyIndex = _messages.length;
            setState(() {
              _isTyping = false;
              _messages.add(ChatMessage(text: accumulatedText, type: MessageType.received, isWaiting: true));
            });
          } else {
            setState(() {
              _messages[replyIndex] = ChatMessage(
                text: activeToolName != null ? '[🔧 $activeToolName 실행 중...]\n$accumulatedText' : accumulatedText,
                type: MessageType.received, isWaiting: true,
              );
            });
          }
          _scrollToBottom();
          break;
        case CarbonToolUseStart(:final toolName):
          activeToolName = toolName;
          if (replyIndex == -1) {
            replyIndex = _messages.length;
            setState(() {
              _isTyping = false;
              _messages.add(ChatMessage(text: '[🔧 $toolName 실행 중...]', type: MessageType.received, isWaiting: true));
            });
          } else {
            setState(() {
              _messages[replyIndex] = ChatMessage(
                text: '[🔧 $toolName 실행 중...]\n$accumulatedText',
                type: MessageType.received, isWaiting: true,
              );
            });
          }
          _scrollToBottom();
          break;
        case CarbonToolResult():
          activeToolName = null;
          break;
        case CarbonTurnComplete():
          final parsedResponse = AgentResponseParser.parse(accumulatedText);
          setState(() {
            _isWaiting = false;
            _isTyping = false;
            if (replyIndex != -1) {
              _messages[replyIndex] = ChatMessage(
                text: parsedResponse.content,
                displayType: parsedResponse.displayType,
                type: MessageType.received,
                isWaiting: false,
                uiCode: parsedResponse.uiCode,
              );
            } else {
              _messages.add(ChatMessage(
                text: parsedResponse.content,
                displayType: parsedResponse.displayType,
                type: MessageType.received,
                uiCode: parsedResponse.uiCode,
              ));
            }
          });
          _scrollToBottom();
          return;
        case CarbonError(:final fatal, :final message):
          setState(() { _isWaiting = false; _isTyping = false; });
          if (fatal) await _grpcService.reconnect();
          return;
        case CarbonSessionEnded():
          await _grpcService.reconnect();
          return;
      }
    }
  } catch (e) {
    if (mounted) setState(() { _isWaiting = false; _isTyping = false; });
  }
}
```

### HttpMessageBus 처리 수정 (_startHttpMessageBus)
외부 메시지 수신 시 _handleSend() 직접 호출:
```dart
_messageBusSubscription = HttpMessageBus.instance.stream.listen((msg) {
  if (!mounted) return;
  _handleSend(msg); // 항상 _handleSend로 통일 처리
});
```

### build() 수정

Stack 내 위젯 구성:
1. DimOverlay (기존 유지)
2. [신규] 대화창 (glassmorphism 배경 컨테이너 삭제 후 대체)
3. PromptBar AnimatedPositioned (기존 레이아웃 유지, bottom: 60)

**대화창 위젯** (Positioned, bottom: 138):
```dart
if (_hasChatStarted)
  Positioned(
    bottom: 138, // 60 + 70 + 8
    left: 0,
    right: 0,
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900]?.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 24, spreadRadius: 2, offset: Offset(0, 8))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SessionHeader(title: _sessionTitle),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_isTyping && index == _messages.length) {
                        return const Padding(padding: EdgeInsets.only(bottom: 10), child: TypingIndicator(showAvatar: true));
                      }
                      final message = _messages[index];
                      Widget widget;
                      switch (message.type) {
                        case MessageType.sent:
                          widget = SentMessage(text: message.text);
                          break;
                        case MessageType.received:
                          widget = ReceivedMessage(
                            text: message.text,
                            avatarInitial: message.senderInitial,
                            isWaiting: message.isWaiting,
                            displayType: message.displayType,
                          );
                          break;
                        default:
                          widget = SentMessage(text: message.text);
                      }
                      return Padding(padding: const EdgeInsets.only(bottom: 10), child: widget);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
```

### _SessionHeader 위젯 추가 (파일 하단)
```dart
class _SessionHeader extends StatelessWidget {
  final String title;
  const _SessionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
```

### import 확인 및 추가
파일 상단에 누락된 import 추가:
- `../widgets/received_message.dart`
- `../widgets/sent_message.dart`
- `../widgets/typing_indicator.dart`
- `../models/chat_message.dart` (이미 있음)

### 기존 코드 정리
- `ScreenState` enum 및 `_activeScreen` 변수 삭제 (더 이상 사용 안 함)
- `_responseMessage`, `_statusMessage`, `_currentText` 상태 삭제
- `_pushScreen()` 메서드 전체 삭제
- `externalMessageController` 관련 코드 정리 (HttpMessageBus 직접 호출로 대체)
- `_hideErrorDelay()` 삭제
```


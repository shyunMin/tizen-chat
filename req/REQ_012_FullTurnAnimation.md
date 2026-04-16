# [REQ_012] FullTurnAnimation: Continuous Progress until TurnComplete

## 1. 개요
에이전트가 텍스트를 생성하거나 도구(Tools)를 실행하는 전체 과정 동안 아바타 테두리의 회전 애니메이션이 유지되도록 개선합니다. 하단 도트 애니메이션(`TypingIndicator`)은 메시지가 생성되는 즉시 사라지더라도, 아바타의 회전은 `TurnComplete` 시점까지 지속됩니다.

## 2. 분석 및 설계
### 2.1 대상 객체
- `lib/models/chat_message.dart`: 메시지 상태(`isWaiting`)를 저장합니다.
- `lib/widgets/received_message.dart`: `isWaiting` 값에 따라 아바타 테두리 애니메이션을 렌더링합니다.
- `lib/screens/chat_screen.dart`: 스트림 이벤트를 처리하며 메시지의 `isWaiting` 상태를 관리합니다.

### 2.2 수정 사항
1. **ChatMessage**: `bool isWaiting` 필드를 추가하고 생성자에서 초기화합니다.
2. **ReceivedMessage**: 
   - 생성자 파라미터에 `bool isWaiting = false`를 추가합니다.
   - 아바타를 `Stack`으로 감싸고 `isWaiting`이 `true`일 때 `CircularProgressIndicator`를 보여줍니다.
3. **TizenChatScreen**:
   - 도구 실행이나 텍스트 수신으로 메시지 객체를 만들 때 `isWaiting: true`로 설정합니다.
   - `TurnComplete` 또는 `Error` 발생 시 해당 메시지의 `isWaiting`을 `false`로 변경합니다.

## 3. 구현 단계
1. 모델 정의 수정.
2. 위젯 UI 로직 적용.
3. 화면 컨트롤러 이벤트 루프 수정.

## 4. 구현용 프롬프트
```markdown
다음 파일들을 순차적으로 수정해줘:

1. `lib/models/chat_message.dart`: `bool isWaiting` 필드 추가 (기본값 false).
2. `lib/widgets/received_message.dart`:
   - 생성자 파라미터에 `bool isWaiting` 추가.
   - 아바타 주변에 `CircularProgressIndicator`를 그리는 로직 추가 (isWaiting이 true일 때만).
3. `lib/screens/chat_screen.dart`:
   - `_handleUserMessage` 내에서 응답 메시지 생성 시 `isWaiting: true` 적용.
   - `CarbonTurnComplete` 및 `CarbonError` 시 해당 메시지의 `isWaiting`을 `false`로 업데이트.
```

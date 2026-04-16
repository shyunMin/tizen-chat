# [REQ_011] ChatScreen Styling & PromptBar Loading Indicator

## 1. 개요
홈 화면에서 프롬프트 바 입력 후 대기(Waiting) 상태일 때 애니메이션이 프롬프트 바 상단에 나타나도록 개선하고 프롬프트 바를 비활성화합니다. 또한 표시되는 채팅창(`TizenChatScreen`)의 UI(둥근 모서리, 패딩, 그림자)를 세련되게 다듬습니다.

## 2. 분석 및 설계
### 2.1 대상 객체 
- `TizenChatHomeScreen`: 대기 애니메이션 위치 이동 및 프롬프트 바 비활성화 상태 전달.
- `PromptBar`: 입력 및 버튼 인터랙션 비활성화 처리.
- `TizenChatScreen`: 컨테이너 외곽 둥근 처리, 외부 패딩 및 그림자 적용.

### 2.2 수정 사항
1. **대기(Waiting) 상태 프롬프트 바 처리**:
   - 메시지 전송 후 서버 응답을 대기 중일 때(`_isWaiting == true`), 기존처럼 프롬프트 바와 동일한 위치가 아닌 **프롬프트 바 바로 위쪽**에 렌더링되게 `bottom` 위치를 올립니다.
   - 대기 중인 동안 사용자가 프롬프트 바를 조작하지 못하도록 `PromptBar` 위젯에 `isWaiting` 값을 전달하여 텍스트 필드와 버튼을 시각/기능적으로 비활성화(disabled) 상태로 만듭니다.
2. **ChatScreen 스타일링 개선**:
   - `chat_screen.dart`의 채팅창 본문이 되는 `Container` 밖을 상하좌우 20의 `Padding`으로 띄워줍니다.
   - 채팅창의 모든 모서리가 둥글게 깎이도록 `BorderRadius.circular(24)`를 적용합니다.
   - 배경에서 떠 있는 듯한 입체감을 위해 `BoxShadow` 속성을 추가합니다.

---

## 3. 구현 가이드 (Step-by-Step)

### Step 1: PromptBar 비활성화 로직 구현
- 위치: `lib/widgets/prompt_bar.dart`
- 내용: 
  - `PromptBar` 생성자에 `final bool isWaiting` 속성 추가 (기본값 false).
  - 텍스트 필드의 `readOnly` 상태를 `_charIndex < _fullText.length || widget.isWaiting`으로 업데이트.
  - 마이크와 전송 등 `_FocusableActionIcon` 버튼들의 `isEnabled`을 `!widget.isWaiting` 조건과 AND 연산하여 비활성화.
  - 필요시 전체 opacity 조절.

### Step 2: TizenChatHomeScreen의 대기 애니메이션 위치 변경 및 속성 전달
- 위치: `lib/screens/tizen_chat_home_screen.dart` 내 `build` 메소드
- 내용:
  - `PromptBar` 호출 시 `isWaiting: _isWaiting` 인자 전달.
  - `if (_isWaiting || _responseMessage.isNotEmpty)` 안의 `Positioned` 위젯의 `bottom` 속성을 기존 `60`에서 프롬프트 바의 높이(약 84)를 고려해 `150`정도로 올려서 프롬프트 바 위에 나타나도록 변경.

### Step 3: ChatScreen 둥근 사각형 및 여백, 그림자 추가
- 위치: `lib/screens/chat_screen.dart`의 본문 `Align` 내부 `Container`
- 내용:
  - `Container`를 여백 확보용 `Padding(padding: const EdgeInsets.all(20.0))`으로 감쌉니다.
  - `Container`의 `BoxDecoration`에서 `borderRadius: BorderRadius.circular(24)`로 설정하여 사방을 둥글게 깎습니다.
  - 동일한 `BoxDecoration` 배 안에 그림자(`BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5)`)를 부여합니다.

---

## 4. 구현용 프롬프트 (Implementation Prompt)

```markdown
다음 파일들을 명세대로 수정해줘:

1. `lib/widgets/prompt_bar.dart`:
   - 생성자에 `bool isWaiting = false` 추가.
   - 내부 `TextField`의 `readOnly` 특성에 `widget.isWaiting`을 포함시키고, 액션 버튼(_FocusableActionIcon)들의 `isEnabled`에 `!widget.isWaiting` 조건을 추가하여 비활성화 처리한다.

2. `lib/screens/tizen_chat_home_screen.dart`:
   - `build` 메소드 내 `PromptBar` 호출시 `isWaiting: _isWaiting` 옵션을 넘긴다.
   - `Waiting Animation or Response Message` 주석 아래의 `Positioned` 위젯 `bottom` 속성을 기존 60에서 150(프롬프트바 위쪽)으로 상향 조정한다.

3. `lib/screens/chat_screen.dart`:
   - 본문 `Align(alignment: Alignment.bottomCenter)`의 자식 `Container`를 `Padding(padding: const EdgeInsets.all(20.0))`으로 감싼다.
   - 해당 `Container`의 `BoxDecoration` 내 `borderRadius`를 전체를 다 깎는 `BorderRadius.circular(24)`로 수정한다.
   - 같은 `BoxDecoration`의 `boxShadow` 리스트에 `BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 24, spreadRadius: 2, offset: Offset(0, 8))` 등 그림자 효과를 넣는다. (참고: API가 허락할 경우 `withValues(alpha: 0.5)` 권장)
```

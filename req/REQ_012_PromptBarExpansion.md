# [REQ_012] PromptBar Transition & Context Expansion

## 1. 개요
홈 화면에서의 프롬프트 바 사용 경험을 개선합니다. 사용자 입력이 발생해도 프롬프트 바가 바로 사라지지 않고 채팅창의 입력창 크기로 자연스럽게 확장되며, 대기 애니메이션이 해당 바 위가 아닌 '내부/중첩'된 느낌으로 표시되도록 변경합니다.

## 2. 분석 및 설계
### 2.1 대상 객체 
- `TizenChatHomeScreen`: 프롬프트 바의 확장 여부를 결정하는 상태 관리 및 레이아웃 배치 수정.
- `PromptBar`: `isWaiting` 상태에 따른 너비 확장 애니메이션 추가.

### 2.2 수정 사항
1. **프롬프트 바 확장 로직**:
   - `isWaiting` 상태가 되었을 때, 프롬프트 바가 기존 고정 너비(`580`)에서 화면의 가로 너비(양측 여백 제외)만큼 늘어나도록 설정합니다.
   - 이는 채팅창(`ChatScreen`)으로 전환되기 전, 시각적 연속성을 제공하기 위함입니다.
2. **대기 애니메이션 위치 변경**:
   - 기존에는 프롬프트 바 위(`bottom: 150`)에 별도의 레이어로 떠 있었으나, 이제 프롬프트 바 자체가 확장되므로 **프롬프트 바가 위치한 그 영역**에 대기 중임을 알리는 애니메이션이나 상태 메시지가 겹쳐 보이도록 배치합니다.
3. **전환 시점 조정**:
   - `_handleSend`에서 API 응답을 받은 후 `_pushScreen`을 수행할 때까지 프롬프트 바가 유지되어야 합니다. (이미 `isWaiting` 상태에서 처리 중)

---

## 3. 구현 가이드 (Step-by-Step)

### Step 1: PromptBar 너비 가변 처리
- 위치: `lib/widgets/prompt_bar.dart`
- 내용: 
  - `build` 메소드 내 `AnimatedContainer`의 `width` 설정 수정.
  - `widget.isWaiting`이 `true`일 경우, `MediaQuery.of(context).size.width - 40` (양쪽 패딩 20씩 고려) 정도로 확장되도록 변경.

### Step 2: TizenChatHomeScreen 레이아웃 재배치
- 위치: `lib/screens/tizen_chat_home_screen.dart`
- 내용:
  - `Positioned` (Waiting Animation 용)의 `bottom` 위치를 프롬프트 바와 겹치거나 바로 위가 아닌, 확장된 프롬프트 바 내부 혹은 의도적인 디자인적 겹침 위치로 수정. 
  - 사용자가 "애니메이션은 그 프롬프트 위에서 보이게 수정"하라고 요청했으므로, `Positioned`의 `bottom`을 프롬프트 바의 `bottom` 값과 일치시키거나 프롬프트 바를 감싸는 `Stack` 내에서 레이어 순서를 조정하여 시각적으로 정합성을 맞춤.

### Step 3: 시각적 효과 강화
- 프롬프트 바가 확장될 때 내부의 텍스트 필드는 `readOnly` 상태를 유지하며 자연스럽게 넓어진 공간을 차지하도록 함.

---

## 4. 구현용 프롬프트 (Implementation Prompt)

```markdown
다음 파일들을 명세대로 수정해줘:

1. `lib/widgets/prompt_bar.dart`:
   - `AnimatedContainer`의 `width`를 결정하는 로직을 수정한다. 
   - `_isExpanded`가 false일 때는 `84`, true일 때 기본은 `580`이지만, `widget.isWaiting`이 true라면 `MediaQuery.of(context).size.width - 40`으로 가변적으로 늘어나게 한다.

2. `lib/screens/tizen_chat_home_screen.dart`:
   - `Waiting Animation or Response Message`를 위한 `Positioned` 위젯의 `bottom` 값을 기존 `150`에서 `60`으로 되돌린다 (프롬프트 바와 같은 높이).
   - `Stack` 안에서 이 `Positioned` 위젯을 `PromptBar`를 감싸는 `AnimatedPositioned` 위젯 **보다 아래에(나중에)** 배치하여, 프롬프트 바 영역 위에 대기 애니메이션이나 상태 메시지가 겹쳐서 보이도록 한다 (Z-index 처리).
   - 대기 애니메이션(`TypingIndicator`) 컨테이너의 배경을 투명하게 하거나 적절히 조절하여 프롬프트 바 내부가 비쳐 보이게 하거나 조화롭게 만든다.
```

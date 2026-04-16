# [REQ_013] ChatScreen Entry & Growth Animations

## 1. 개요
채팅창(`TizenChatScreen`)의 진입과 사용 중 경험을 더욱 생동감 있게 개선합니다. 화면 진입 시 하단에서 위로 슬라이드되며 나타나는 효과를 추가하고, 메시지가 추가됨에 따라 채팅창의 전체 높이가 위로 부드럽게 늘어나는 애니메이션을 적용합니다.

## 2. 분석 및 설계
### 2.1 대상 객체 
- `TizenChatHomeScreen`: 화면 전환 시 `SlideTransition` 적용.
- `TizenChatScreen`: 내용물 증가에 따른 높이 변화를 `AnimatedSize` 혹은 `AnimatedContainer`로 처리.

### 2.2 수정 사항
1. **진입 애니메이션 (Slide Up)**:
   - `TizenChatHomeScreen`의 `_pushScreen` 메소드에서 `FadeTransition` 대신 (혹은 함께) `SlideTransition`을 사용합니다.
   - `begin: Offset(0, 1), end: Offset.zero` 설정을 통해 아래에서 위로 올라오는 효과를 줍니다.
2. **높이 성장 애니메이션 (Grows Upwards)**:
   - `ChatScreen`의 `Align` 자식인 `Container`를 `AnimatedSize` 위젯으로 감싸거나, `Container` 자체의 레이아웃 변화가 애니메이션되도록 처리합니다.
   - `shrinkWrap: true`인 `ListView`의 크기가 변할 때, 이를 감싸는 부모 컨테이너의 크기 변화가 '부드럽게' 렌더링되도록 `duration`과 `curve`를 설정합니다.

---

## 3. 구현 가이드 (Step-by-Step)

### Step 1: SlideTransition 적용
- 위치: `lib/screens/tizen_chat_home_screen.dart`의 `_pushScreen`
- 내용: 
  - `transitionsBuilder`에서 `SlideTransition`을 정의.
  - `position`에 `Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation)`를 연결.

### Step 2: 채팅창 높이 애니메이션 적용
- 위치: `lib/screens/chat_screen.dart`의 `build` 메소드
- 내용:
  - `Align` 내부의 `Container`를 `AnimatedSize` 위젯으로 감쌉니다.
  - `duration: const Duration(milliseconds: 300)`, `curve: Curves.easeOut` 정도로 설정하여 메시지가 추가될 때 창이 위로 슥 올라가는 느낌을 줍니다.
  - (주의) `AnimatedSize`는 내부 위젯의 크기 변화를 감지하여 부드럽게 크기를 변경합니다.

---

## 4. 구현용 프롬프트 (Implementation Prompt)

```markdown
다음 파일들을 명세대로 수정해줘:

1. `lib/screens/tizen_chat_home_screen.dart`:
   - `_pushScreen`의 `transitionsBuilder`를 수정하여 `FadeTransition`과 `SlideTransition`을 중첩해서 적용한다.
   - `SlideTransition`의 `position`은 `Offset(0, 1)`에서 `Offset.zero`로 이동하는 애니메이션을 사용한다.

2. `lib/screens/chat_screen.dart`:
   - `Align(alignment: Alignment.bottomCenter)`의 자식인 `Padding` 위젯 혹은 그 내부의 `Container`를 `AnimatedSize` 위젯으로 감싼다.
   - `AnimatedSize`에 `duration: const Duration(milliseconds: 300)`과 `curve: Curves.easeOutCubic`을 적용하여 메시지가 늘어날 때 전체 창 크기가 부드럽게 확장되도록 한다.
```

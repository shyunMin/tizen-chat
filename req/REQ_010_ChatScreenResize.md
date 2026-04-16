# [REQ_010] ChatScreen Resize and Transparent Background

## 1. 개요
현재 전체 화면으로 띄워지는 채팅창(`TizenChatScreen`)을 전체 화면이 아닌 내용물 크기(텍스트 필드 + 메시지 리스트)에 맞춰지도록 변경합니다. 
단행될 주요 변경 사항은 다음과 같습니다.
- 채팅창의 높이는 기본적으로 내용물 크기이며, 메시지 리스트가 길어지면 최대 전체 화면의 3/4 높이까지만 커집니다.
- 채팅창의 뒷배경을 투명하게 설정하여, 그 뒤에 있는 메인 화면(홈 화면)이 보이도록 합니다.

## 2. 분석 및 설계
### 2.1 대상 객체 및 관계
- `TizenChatHomeScreen`: `_pushScreen`을 통해 `TizenChatScreen`으로 이동시키는 네비게이션 주체.
- `TizenChatScreen`: 실제 채팅 UI 화면을 구성하는 위젯 단위.

### 2.2 수정 사항
1. **`TizenChatHomeScreen` (`_pushScreen` 메소드)**:
   - `Navigator.push`시에 사용하는 `PageRouteBuilder`에 `opaque: false`를 추가하여 라우트의 뒷배경이 투명하게 투과되도록 만듭니다.
2. **`TizenChatScreen`**:
   - `Scaffold` 레벨의 `backgroundColor`를 `Colors.transparent`로 변경합니다.
   - 화면 구성 영역이 전체 크기를 갖지 않도록 `SafeArea` 외부 또는 내부를 최하단 정렬(`Align(alignment: Alignment.bottomCenter)`) 기반으로 감쌉니다.
   - 화면 내용(배경색이 그려지는 영역)에 `BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75)`를 적용하여 최대 높이를 전체 높이의 3/4로 제한합니다.
   - 내용을 다루는 `ListView.builder`에 `shrinkWrap: true`를 적용하고, `Expanded` 부모를 `Flexible` (기본값 loose)로 변경하여 아이템 개수에 맞게 레이아웃이 줄어들 수 있도록 합니다.
   - **자동 스크롤 유지 보장**: 메시지가 추가될 때마다 늘어나는 과정과, 최대 높이(`0.75`) 도달 후의 스크롤 작동이 매끄럽게 지속되어야 합니다. (현재의 `_scrollToBottom` 로직인 `maxScrollExtent`로 이동하는 기존 코드가 제 기능을 하는지, 필요하다면 `addPostFrameCallback` 등과 마찰이 없는지 검토합니다.)

---

## 3. 구현 가이드 (Step-by-Step)

### Step 1: Navigating Route의 opaque 속성 수정
- 위치: `lib/screens/tizen_chat_home_screen.dart` 내의 `_pushScreen` 메소드
- 내용: `PageRouteBuilder`에 `opaque: false` 속성 추가.

### Step 2: ChatScreen 최상단 투명도 및 Layout 정렬
- 위치: `lib/screens/chat_screen.dart`의 `build` 메소드
- 내용: `Scaffold`의 `backgroundColor`를 투명으로.
- 그 내부의 `Container` (기존 `width: double.infinity, height: double.infinity`)를 `Align(alignment: Alignment.bottomCenter)`로 감싸고, `height` 값 제한을 제거하며 `constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75)`를 부여합니다.
- 채팅 영역 박스가 될 해당 컨테이너에만 `TizenStyles.slate950` 배경색과 필요시 상단 모서리 둥글게 처리를 적용합니다.

### Step 3: ListView를 Flexible 및 shrinkWrap으로 변경
- 위치: `lib/screens/chat_screen.dart` (본문 ListView 부분)
- 내용: `Expanded`를 `Flexible`로 교체. (또는 `Expanded`를 유지하되 전체 박스크기가 줄어들면서 내부도 적절히 수용해야 함. 그러나 높이가 가변적이려면 `Flexible(fit: FlexFit.loose)` 또는 `shrinkWrap: true`를 갖춘 묶음을 사용)
- `ListView.builder` 내부에 `shrinkWrap: true` 속성 부여.

---

## 4. 구현용 프롬프트 (Implementation Prompt)

```markdown
다음 두 파일을 명세대로 수정해줘:

1. `lib/screens/tizen_chat_home_screen.dart`:
   - `_pushScreen` 함수의 `PageRouteBuilder`에 `opaque: false` 파라미터를 추가하여 투명 라우팅이 가능하게 한다.

2. `lib/screens/chat_screen.dart`:
   - `Scaffold`의 `backgroundColor`를 `Colors.transparent`로 변경.
   - `Scaffold`의 `body` 최상위를 `Align(alignment: Alignment.bottomCenter)`로 수정하여 내용이 하단에 붙도록 만든다.
   - `Align` 하위에 들어가는 `Container`의 기존 `height: double.infinity`를 제거하고, `constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75)`를 부여하여 최대 높이가 75%가 되게 제한한다.
   - 해당 `Container`의 내부 `color`는 유지하거나 `BoxDecoration`을 통해 둥근 외곽 및 배경색(`TizenStyles.slate950`)으로 렌더링한다.
   - 내부의 `ListView.builder`에 `shrinkWrap: true` 속성을 추가하고, 해당 `ListView`를 감싸고 있던 `Expanded` 위젯을 `Flexible` 위젯(기본 fit은 loose)으로 교체한다.
   - 새 메시지가 수신/생성될 때마다 리스트가 늘어나거나 스크롤되는 액션이 깨지지 않고 최하단 텍스트를 따라가는 기존의 `_scrollToBottom()` 작동 방식이 원활하게 유지되는지 확인한다 (shrinkWrap 특성상 컨테이너가 커질 때는 자동으로 내용물이 보이며, 최대 높이에 도달한 이후에는 기존 로직대로 maxScrollExtent로 잘 스크롤 된다).
```

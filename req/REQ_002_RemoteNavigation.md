# REQ_002: Remote Navigation for Chat Interface (TV Optimized)

## 1. 개요
Tizen TV 리모컨 사용자가 채팅창의 메시지 및 버튼을 원활하게 탐색하고 선택할 수 있도록 포커스 및 자동 스크롤 로직을 고도화한다.

## 2. 분석
- **현상**: `ChatWindow`가 전체 포커스를 점유하여 상/하 키로 스크롤만 가능하며, 메시지 내부의 버튼(<a> 태그)으로 포커스가 진입하지 못함.
- **목표**: 
    1. '확인(Enter)' 키로 메시지 버튼 탐색 모드 진입.
    2. 버튼 간 이동 시 해당 버튼이 보이도록 자동 스크롤.
    3. 마지막 버튼에서 아래로 이동 시 `PromptBar`로 포커스 전이.
    4. 첫 번째 버튼에서 위로 이동 시 이동 중지.

## 3. 설계

### 3.1 포커스 흐름 (Focus Flow)
1. **Browse Mode**: `ChatWindow`가 포커스를 가짐.
   - `ArrowUp/Down`: 리스트 전체 스크롤 (기존 로직).
   - `Select/Enter`: 첫 번째 가용 버튼으로 포커스 이동 (Interaction Mode 진입).
2. **Interaction Mode**: 메시지 내부 버튼이 포커스를 가짐.
   - `ArrowUp/Down`: 버튼 간 이동 + 해당 위치로 `ensureVisible`.
   - `ArrowDown` (마지막 버튼에서): `PromptBar`로 포커스 이동.
   - `ArrowUp` (첫 번째 버튼에서): 무시 (이동 안함).
   - `Back/ESC`: 버튼에서 포커스를 해제하고 다시 `ChatWindow` (Browse Mode)로 복귀.

### 3.2 자동 스크롤 로직
- 각 버튼을 `Focus` 위젯으로 래핑.
- `onFocusChange`에서 `isFocused == true`인 경우 `Scrollable.ensureVisible(context)` 호출.

### 3.3 경계 처리
- `FocusTraversalPolicy`를 커스텀하거나, 각 버튼의 `onKeyEvent`에서 경계를 감지하여 부모에게 알림.

## 4. 구현 가이드

### 4.1 lib/widgets/received_message.dart
- `_ButtonLinkBuilder`의 버튼을 `Focus` 위젯으로 감싸기.
- `onFocusChange`에서 `Scrollable.ensureVisible` 적용.
- 포커스 시 배경색 변경 등 시각적 피드백 강화.

### 4.2 lib/widgets/chat_window.dart
- `_handleKeyEvent` 수정:
    - `Select` 키 입력 시 `FocusScope.of(context).nextFocus()` 등으로 자식에게 포커스 위임.
    - 자식이 포커스를 가진 경우(Interaction Mode)에는 `ChatWindow` 자체의 상/하 스크롤 로직을 건너뜀 (bubble up 허용).

### 4.3 lib/screens/tizen_chat_home_screen.dart
- `ChatWindow`와 `PromptBar` 간의 포커스 노드 연결 확인.
- `PromptBar` 상단에서 `ArrowUp` 시 `ChatWindow`로 포커스 복귀 로직 확인.

## 5. 검증 계획
1. 리모컨 상/하로 대화창 전체가 스크롤되는지 확인.
2. 대화창 포커스 상태에서 'Enter' 클릭 시 버튼으로 포커스가 가는지 확인.
3. 버튼 간 이동 시 스크롤이 자동으로 따라오는지 확인.
4. 마지막 버튼에서 아래 클릭 시 프롬프트 바로 포커스가 가는지 확인.
5. 첫 번째 버튼에서 위 클릭 시 포커스가 유지되는지 확인.

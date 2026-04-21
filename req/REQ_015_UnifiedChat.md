# REQ_015: Unified Chat Interface 리팩토링

## 1. 분석 (Analysis)
현재 분리되어 있는 `TizenChatHomeScreen`(진입점)과 `TizenChatScreen`(대화창)을 하나의 화면으로 통합합니다. 사용자가 처음 앱에 들어왔을 때는 프롬프트바만 보이다가, 입력을 전송하면 그 자리에서 대화창이 위로 펼쳐지며 스타일이 전환되는 "Seamless"한 사용자 경험을 제공하는 것이 목표입니다.

### 주요 변경 사항
- **화면 통합**: `TizenChatHomeScreen`을 기반으로 `TizenChatScreen`의 기능을 흡수.
- **스타일 전이**: 프롬프트바의 디자인이 전송 전(Home)과 후(Chat)가 다름.
- **애니메이션**: 대화 목록이 생성될 때 위로 솟아오르는 확장 애니메이션 구현.
- **구조 최적화**: 불필요한 헤더("Tizen AI") 제거 및 위젯 재사용.

## 2. 설계 (Design)

### 위젯 구조
- `TizenChatUnifiedScreen` (StatefulWidget)
  - `AnimatedContainer` (전체 컨테이너: 높이 및 스타일 애니메이션 담당)
    - `Column`
      - `Expanded` + `ListView` (메시지 목록: `_isChatActive`가 true일 때만 데이터 노출)
      - `TizenChatInput` (통합 입력창: 모드에 따라 내부 스타일 가변 처리)

### 상태 정의 (`_TizenChatUnifiedScreenState`)
- `bool _isChatActive`: 첫 메시지를 보냈는지 여부.
- `List<ChatMessage> _messages`: 현재 대화 내역.
- `double _containerHeight`: 컨테이너의 현재 높이 (0 -> 75% height).

### 스타일 규칙 (TizenChatInput 수정 필요)
- **Home Mode**: 
  - `SubtleRotatingBorder` 활성화
  - 강한 파란색 그림자 및 글로우 효과 적용
- **Chat Mode**:
  - `SubtleRotatingBorder` 비활성화 또는 불투명도 대폭 축소
  - 테두리 색상을 `TizenChatScreen`의 텍스트 필드 색상(차분한 회색/흰색 등)으로 변경
  - 그림자 효과 축소

## 3. 구현 계획 (Implementation Plan)

### Step 1: TizenChatInput 위젯 고도화
- `isChatMode` 속성을 추가하여 모드별 디자인 분기 처리.
- `Chat Mode` 시 테두리 두께 및 색상을 사용자가 지정한 스타일로 변경할 수 있도록 `BoxDecoration` 로직 수정.

### Step 2: TizenChatUnifiedScreen 생성 (또는 HomeScreen 수정)
- `TizenChatHomeScreen.dart`를 기반으로 `TizenChatScreen`의 로직(gRPC 통신 등)을 이식.
- `AnimatedSize` 혹은 `AnimatedContainer`를 사용하여 메시지 목록이 추가될 때 화면이 확장되는 로직 구현.
- 헤더 제거 및 하단 고정 레이아웃 유지.

### Step 3: 애니메이션 동기화
- 메시지 전송 버튼 클릭 -> `setState` -> `_isChatActive = true` 변경 -> 프롬프트바 스타일 변경 애니메이션과 동시에 `ListView`가 확장되며 메시지 노출.

### Step 4: 메인 라우팅 변경
- `main.dart`에서 시작 화면을 `TizenChatUnifiedScreen`으로 변경.

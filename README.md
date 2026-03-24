# Tizen AI Chat
Tizen OS 디자인 가이드라인을 준수한 Flutter 기반 채팅 애플리케이션입니다.

## 주요 기능
- **Tizen 스타일 디자인**: 글라스모피즘, 다크 모드, 네온 글로우 효과 적용
- **실시간 대화**: 메시지 전송 및 Tizen AI의 응답 시뮬레이션
- **애니메이션**: 텍스트 입력창 글로우 효과 및 타이핑 인디케이터
- **반응형 레이아웃**: Tizen 디바이스에 최적화된 화면 구성

## 실행 방법
`flutter-tizen run`

## 스크린샷
![Tizen AI Chat Screenshot](screenshot.png)

## 업데이트 내역
- **2026-03-24**: 
  - Tizen 전용 `tizenEnginePolicy` 적용 및 `ValueKey`를 통한 리빌드 시 초기화 오류(LateInitializationError) 방지 로직 추가
  - RPi4 등 저사양 Tizen 환경을 위해 샘플 HTML의 불필요한 GPU 연산(blur) 제거 및 단색 배경 적용
  - Tizen 웹뷰 빈 화면 출력 버그 해결을 위해 `loadRequest`에 Base64 Data URI 방식 적용, `ClipRRect` 제거 및 배경색 명시 적용
  - `flutter_inappwebview` 대신 Tizen을 공식 지원하는 `webview_flutter` 및 `webview_flutter_tizen` 플러그인으로 마이그레이션하여 웹뷰 렌더링 정상화
  - `chat_screen.dart`의 구문 오류(오타로 인한 `ChatMessage(` 잔존) 수정 및 빌드 안정화
  - Gen UI 렌더링을 제거하고 웹뷰를 통해 서버의 HTML 응답(`ui_code`)을 렌더링하도록 수정
  - 테스트 용도로 초기 `_messages` 목록에 샘플 HTML 코드가 포함된 환영 메시지 추가
- **2026-03-23**: `chat_service`에서 API 요청 시 payload로 `{prompt, session_id}`를 `body`에 담아 보내도록 수정

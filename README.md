# Tizen AI Chat
Tizen OS 디자인 가이드라인을 준수한 Flutter 기반 채팅 애플리케이션입니다.

## 주요 기능
- **Tizen 스타일 디자인**: 글라스모피즘, 다크 모드, 네온 글로우 효과 적용
- **실시간 대화**: 메시지 전송 및 Tizen AI의 응답 시뮬레이션
- **HTML 코드 렌더링**: 서버의 HTML 응답(uiCode)을 웹뷰로 메시지 창 내부에 직접 렌더링
- **애니메이션**: 텍스트 입력창 글로우 효과 및 타이핑 인디케이터
- **반응형 레이아웃**: Tizen 디바이스에 최적화된 화면 구성

## 시스템 아키텍처 (System Architecture)

본 프로젝트는 Tizen OS 환경에서 최적화된 사용자 경험을 제공하기 위해 각 기능을 독립적인 모듈로 구분한 계층형 정적 구조(Static View)를 가집니다.

```mermaid
graph TB
    subgraph "Tizen AI Chat - System Architecture"
        direction TB

        subgraph "UI 레이어 (User Interface Layer)"
            PUI[PromptUI: 입력 인터페이스 컨트롤러]
            GVU[GenUIView: 에이전트 생성 UI 컨텐츠 가시화]
            CUI[ChatUI: 기존 텍스트 기반 대화 창]
            UM[UIManager: 전체 화면 상태 및 시각 요소 총괄 제어]
        end

        subgraph "서비스 레이어 (Service Layer)"
            CS[ChatService: AI 에이전트와의 API 통신 관리]
            VC[VoiceController: 음성 캡처 및 녹음 상태 제어]
            SP[STTProvider: 음성 인식 엔진 연동 인터페이스]
            SM[SessionManager: 대화 세션 및 기록 관리]
        end

        subgraph "인프라 레이어 (Infrastructure Layer)"
            SE[STTEngine: 로컬/클라우드 음성 인식 처리 엔진]
            TNB[TizenNativeBridge: 플랫폼 SDK 연동 및 하드웨어 가속]
        end
    end
```

### 각 모듈별 상세 설명

#### 1. UI 레이어 (User Interface Layer)
*   **PromptUI**: 사용자의 텍스트 입력 및 마이크 버튼 이벤트를 처리하는 입력 인터페이스입니다.
*   **GenUIView**: AI 에이전트의 응답(HTML/JS)을 웹뷰 환경에서 최적화하여 보여주는 전용 뷰입니다.
*   **ChatUI**: 전송 및 수신된 메시지를 리스트 형태로 시각화하여 대화의 흐름을 보여줍니다.
*   **UIManager**: 화면의 오버레이 상태와 포커스 제어 등 전체적인 시각 요소를 총괄 관리하는 중앙 컨트롤러입니다.

#### 2. 서비스 레이어 (Service Layer)
*   **ChatService**: AI 에이전트 서버와의 HTTP 통신 및 전송 데이터 처리를 담당합니다.
*   **VoiceController**: 오디오 장치 제어 및 실시간 음성 캡처의 수명 주기를 관리합니다.
*   **STTProvider**: 내부/외부 엔진을 추상화하여 음성 데이터를 텍스트로 치환하는 중계 포인트입니다.
*   **SessionManager**: 대화 기록 보존 및 세션 초기화 등 비즈니스 규칙에 따른 세션 상태를 유지합니다.

#### 3. 인프라 레이어 (Infrastructure Layer)
*   **STTEngine**: 음성 원천 데이터를 실제 텍스트 결과값으로 변환(Inference)하는 핵심 엔진입니다.
*   **TizenNativeBridge**: Tizen 플랫폼 전용 네이티브 플러그인 연동 및 렌더링 최적화를 수행합니다.

## 최근 수정 사항
- **2026-03-24**: 
    - gen ui 로직 제거 및 HTML 코드 응답 웹뷰(webview_flutter) 연동
    - `loadHtmlString` 및 `<meta charset="UTF-8">` 추가로 웹뷰 내 한글 깨짐 현상 해결
    - `pubspec.lock` 오류 해결을 위한 패키지 재설치 및 `webview_flutter_tizen` 버전 최적화
    - **웹뷰 컨텐츠 높이 자동 조절**: `JavaScriptChannel`을 통해 컨텐츠 크기에 맞춰 웹뷰 높이가 동적으로 변하도록 개선
    - **웹뷰 디자인 최적화**: 웹뷰의 테두리 선을 제거하고 배경을 투명하게 설정하여 채팅 UI와 자연스럽게 어우러지도록 개선
    - **버그 수정**: 쉐이더 장식 제거 시 `Container`에서 발생하던 `clipBehavior` 관련 어설션 오류 해결
    - **자동 스크롤**: 초기화 시 대화 목록의 맨 하단으로 자동 스크롤되도록 개선

## 실행 방법
`flutter-tizen run`

## 스크린샷
![Tizen AI Chat Screenshot](screenshot.png)

## 업데이트 내역
- **2026-03-24**: 
  - RPi4 환경의 렌더링 안정성을 위해 `tizen-manifest.xml`에서 `hw-acceleration="on"` 옵션 제거
  - `TizenChatScreen`의 배경 그라데이션 및 `ShaderMask`(글로우 효과)를 단색 배경 및 일반 텍스트로 간소화하여 리소스 부하 경감
  - Tizen 웹뷰 빈 화면 또는 크래시 방지를 위해 `WebViewExample`에서 `loadHtmlString` 대신 Base64 Data URI 기반 `loadRequest` 사용하도록 수정 및 `ClipRRect` 제거
  - `ReceivedMessage` 위젯에 디버그 로그 (`showWebView` 상태값) 추가
  - `WebViewExample`을 채팅창 옆 분할 방식이 아니라, 대화 흐름 내에서 인라인(`inline`)으로 그려지도록 수정
  - `ReceivedMessage` 위젯을 `StatefulWidget`으로 변환하여 개별 메시지별로 웹뷰 표시 여부를 토글할 수 있는 기능 추가
  - 임베디드 웹뷰의 렌더링 에러 해결을 위해 별도의 전체 화면 페이지(`WebViewFullScreen`)로 분리 및 진입 버튼 추가
  - Tizen 전용 `tizenEnginePolicy` 적용 및 `ValueKey`를 통한 리빌드 시 초기화 오류(LateInitializationError) 방지 로직 추가
  - RPi4 등 저사양 Tizen 환경을 위해 샘플 HTML의 불필요한 GPU 연산(blur) 제거 및 단색 배경 적용
  - Tizen 웹뷰 빈 화면 출력 버그 해결을 위해 `loadRequest`에 Base64 Data URI 방식 적용, `ClipRRect` 제거 및 배경색 명시 적용
  - `flutter_inappwebview` 대신 Tizen을 공식 지원하는 `webview_flutter` 및 `webview_flutter_tizen` 플러그인으로 마이그레이션하여 웹뷰 렌더링 정상화
  - `chat_screen.dart`의 구문 오류(오타로 인한 `ChatMessage(` 잔존) 수정 및 빌드 안정화
  - Gen UI 렌더링을 제거하고 웹뷰를 통해 서버의 HTML 응답(`ui_code`)을 렌더링하도록 수정
  - 테스트 용도로 초기 `_messages` 목록에 샘플 HTML 코드가 포함된 환영 메시지 추가
- **2026-03-23**: `chat_service`에서 API 요청 시 payload로 `{prompt, session_id}`를 `body`에 담아 보내도록 수정

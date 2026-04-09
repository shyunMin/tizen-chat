# REQ_007: MessageOverlayGenUI

## 1. 분석 (Analysis)
- **현재 상태**: `HttpMessageOverlayScreen`은 `HttpMessageBus`를 통해 전달받은 문자열을 화면 중앙에 단순 `Text` 위젯으로 표시함.
- **요구사항**: 
    - 텍스트 메시지 표시 위치를 화면 상단으로 이동.
    - 아래쪽에 다양한 위젯을 그릴 수 있는 영역(빈 위젯) 추가.
    - 입력 메시지가 `genui` 렌더링 포맷(JSON, `version: v0.9`)인 경우, `genui` 패키지를 사용하여 해당 영역에 동적 UI 렌더링.
- **기술적 배경 및 가이드**:
    - `genui` 패키지는 `/home/jay/github/genui/packages/genui`에 위치한 로컬 패키지임.
    - `SurfaceController`와 `Catalog`를 사용하여 `A2uiMessage`를 처리함.
    - **핵심 개발 가이드**: 상세 프로젝트 구조 및 위젯 구현 방식은 [genui_app_development_guide.md](../../dev_guide/genui_app_development_guide.md)를 반드시 참고함.

## 2. 설계 (Design)

### 2.1 의존성 추가
- `pubspec.yaml`에 `genui` 패키지를 로컬 경로로 추가.
```yaml
dependencies:
  genui:
    path: /home/jay/github/genui/packages/genui
```

### 2.2 클래스 멤버 및 초기화
- `_HttpMessageOverlayScreenState`에 다음 필드 추가:
    - `late final SurfaceController _controller`: GenUI 제어용.
    - `Catalog _catalog`: 기본 컴포넌트 카탈로그 (`BasicCatalogItems.asCatalog()`).
    - `static const String _surfaceId = 'overlay_surface'`: 고정된 Surface ID.
    - `bool _isGenUIActive = false`: 현재 GenUI 메시지 처리 중인지 여부.

### 2.3 메시지 처리 로직 (`initState`)
- `HttpMessageBus.instance.stream.listen` 로직 변경:
    1. 수신된 `msg`가 JSON 형태인지 확인 (Try parse).
    2. JSON이고 `version == 'v0.9'`를 포함하면 `A2uiMessage.fromJson(json)` 시도.
    3. 성공 시 `_controller.handleMessage(a2uiMsg)` 호출 및 `_isGenUIActive = true`.
    4. 실패하거나 일반 텍스트면 `_currentMessage` 업데이트 및 `_isGenUIActive = false`.

### 2.4 UI 구조 (`build`)
- `SizedBox.expand` -> `Padding` -> `Column` 구조로 변경.
- **상단부 (Text 영역)**:
    - `Container` 내부에 `Text(_currentMessage)` 배치.
    - 상단 여백 및 투명도 조절.
- **하단부 (GenUI 영역)**:
    - `Expanded` 위젯 사용.
    - `_isGenUIActive`가 `true`일 때 `Surface` 위젯 렌더링.
    - `surfaceContext`는 `_controller.contextFor(_surfaceId)` 사용.
    - `_isGenUIActive`가 `false`일 때는 `SizedBox.shrink()` 또는 최소한의 메시지 표시.

## 3. 구현 가이드 (Implementation Prompt)

**중요**: 구현 전 반드시 `dev_guide/genui_app_development_guide.md`의 내용을 숙지하고 이를 준수하세요.

1. `pubspec.yaml`에 `genui` 의존성을 추가하세요 (경로: `/home/jay/github/genui/packages/genui`).
2. `lib/features/http_message_overlay/http_message_overlay_screen.dart`를 수정하세요.
3. `genui` 관련 클래스들을 임포트하세요 (`package:genui/genui.dart`).
4. `_HttpMessageOverlayScreenState`에 `SurfaceController`를 초기화하고 `dispose`에서 해제하세요.
5. `BasicCatalogItems.asCatalog()`를 사용하여 카탈로그를 생성하고 `SurfaceController`에 전달하세요.
6. 메시지 수신 시 JSON 파싱 및 `A2uiMessage` 처리를 수행하는 `_handleIncomingMessage(String msg)` 메서드를 만드세요.
7. 화면 구성을 `Column`으로 변경하여 상단에는 텍스트, 하단(`Expanded`)에는 `Surface` 위젯이 나오도록 하세요.
8. 배경은 투명하게 유지하되, 메시지 영역은 식별 가능하도록 스타일링하세요.

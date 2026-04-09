# 📱 GenUI 앱 개발 가이드 (Client Side)
이 문서는 GenUI 프레임워크를 사용하여 Flutter 클라이언트 애플리케이션을 개발할 때의 표준 절차를 안내합니다.
## 1. 프로젝트 참고 필수 파일 (Must-Read)
AI에게 개발을 지시할 때 반드시 아래 파일들을 읽고 분석하도록 명령하세요:
- **위젯 정의 방식**: `/home/jay/github/genui/examples/travel_app/lib/src/catalog/travel_carousel.dart`
  - 스키마와 위젯 빌더가 어떻게 한 세트로 구성되는지 보여주는 표준 예시입니다.
- **전체 통합 방식**: `/home/jay/github/genui/examples/travel_app/lib/src/travel_planner_page.dart`
  - `SurfaceController` 초기화 및 `genui`의 `Conversation` 위젯 연결 방법을 담고 있습니다.
## 2. 개발 워크플로우
### [1단계] CatalogItem 디자인
각 위젯은 `CatalogItem` 객체로 정의되어야 합니다.
- **데이터 스키마**: `json_schema_builder`를 사용하여 AI가 보내줄 데이터의 규격을 명확히 정의하세요.
- **위젯 빌더**: `itemContext`로부터 `data`를 추출하여 실제 Flutter 위젯을 반환하는 함수를 작성하세요.
### [2단계] Catalog 구성
`BasicCatalogItems`와 커스텀 위젯들을 결합하여 전체 카탈로그를 만듭니다.
```dart
final myCatalog = Catalog([
  BasicCatalogItems.image,
  customProductCard,
], catalogId: 'https://a2ui.org/specification/v0_9/standard_catalog.json');
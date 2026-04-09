# 🤖 GenUI 에이전트 개발 가이드 (Agent/AI Side)
이 문서는 LLM이 GenUI 앱을 제어하기 위해 올바른 JSON 메시지를 생성하도록 지시하는 에이전트 개발 지침입니다.
## 1. 프로젝트 참고 필수 파일 (Must-Read)
AI에게 에이전트 로직 개발을 지시할 때 반드시 아래 파일을 읽도록 하세요:
- **프롬프트 조립**: `/home/jay/github/genui/examples/travel_app/lib/src/ai_client/google_generative_ai_client.dart`
  - `PromptBuilder`를 사용하여 AI에게 보낼 최종 시스템 지시문을 동적으로 구성하는 방법을 보여줍니다.
## 2. 시스템 프롬프트 구성 (System Instruction)
AI 모델이 "화면 설계자"로서 동작하게 하려면 다음 정보가 프롬프트에 실시간으로 주입되어야 합니다.
### [1단계] 상세 설계도 (JSON Schema) 주입
단순한 URL 식별자만 보내지 말고, `A2uiMessage.a2uiMessageSchema(catalog).toJson()`을 통해 추출된 **전체 JSON 스키마 텍스트**를 프롬프트 상단에 명시하세요.
### [2단계] 동작 제약 조건 설정
- "반드시 ```json ... ``` 블록으로 응답하라."
- "항상 `v0.9` 버전을 명시하라."
- "모든 필수 속성(Required Properties)을 포함하라."
### [3단계] A2UI v0.9 프로토콜 준수
AI가 출력할 JSON은 다음과 같은 형태여야 합니다:
- **`createSurface`**: 앱 화면 식별용.
- **`updateComponents`**: 실제 위젯 배치용 (`id: "root"` 필수).
## 3. 데이터 동기화
클라이언트 앱에 변경 사항(위젯 추가 등)이 생기면 항상 해당 카탈로그 정보를 다시 추출하여 에이전트의 시스템 프롬프트를 갱신해야 합니다.
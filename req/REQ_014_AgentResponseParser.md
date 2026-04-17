# [ID: 014 | 별칭: AgentResponseParser]

## 1. 개요
* **목적:** Carbon Agent 런타임의 응답 취합기(Response Synthesizer) 스킬 적용에 따른 응답 포맷 변경에 대응.
* **주요 변경 사항:** 일반 텍스트가 아닌, `display_type`과 `content`를 포함한 Markdown JSON 블록 구조의 응답을 파싱 및 처리할 수 있도록 개발.
* **하위 호환성:** 기존처럼 JSON 블록이 없는 일반 텍스트 응답이 들어올 경우에도 문제없이 처리할 수 있도록 Fallback(예외 처리) 로직 구현. (JSON 파싱이 실패하면 받은 내용 전체를 일반 텍스트로 간주)

## 2. 요구사항 분석
1. **JSON 정규식 파싱:** 전체 텍스트에서 ```json 과 ``` 사이의 JSON 텍스트를 파싱한다.
2. **응답 데이터 포맷팅:** 파싱된 JSON을 Map 형태로 변환(`display_type`, `content`).
3. **Fallback 처리:** JSON 형식이 없거나 파싱에 실패하면 원본 문자열을 일반 텍스트(`text` 타입)로 인식하여 `content`로 반환. (마크다운 태그가 남아있다면 제거)
4. **UI 분기 처리:** 
   - `text`: 일반 텍스트 답변 (기본 채팅).
   - `ui`: 외부 위젯 렌더링.
   - `hidden`: 화면에는 보여주지 않고 백그라운드 액션만 수행.
5. **스트리밍 대응 조건 분석:** 파싱은 글자가 1글자씩 들어오는 스트리밍 단위가 아니라, 턴 단위 응답이 완성된 후 1회 호출되어야 한다.

## 3. 구현 설계
### 3.1. 응답 파서 유틸리티 구현
* 문자열을 주입받아 Map 형태 혹은 새로운 Entity 모델(AgentResponse)을 반환하는 유틸리티 혹은 확장 메서드를 구현한다.
* 정규표현식을 `RegExp(r'```json\s*(\{.*?\})\s*```', dotAll: true)` 형태로 구성한다.

### 3.2. 메시지 수신부 분기 혹은 표시
* gRPC/Provider 쪽 응답 처리 서비스 로직에서 응답이 완료되었을 때 파서 유틸리티를 호출.
* `hidden` 상태에 대한 처리: 메시지 리스트에 아예 추가하지 않거나 `SizedBox.shrink()` 처리.
* `ui` 및 `text`에 대한 적절한 타입 할당(또는 기존 메시지 구조 속성 추가).

## 4. 참고 코드 (프롬프트용 가이드라인)

```dart
import 'dart:convert';

/// 에이전트 응답을 파싱하여 [디스플레이 타입, 실제 컨텐츠] 형태로 반환하는 함수
Map<String, dynamic> parseAgentResponse(String rawText) {
  // 정규식: ```json 과 ``` 사이의 텍스트(알맹이) 추출
  final RegExp jsonRegex = RegExp(
    r'```json\s*(\{.*?\})\s*```',
    dotAll: true, // 줄바꿈 무시하고 전체 텍스트 검색
  );
  final match = jsonRegex.firstMatch(rawText);
  String targetJsonStr = match != null ? match.group(1)! : rawText;
  try {
    final parsedMap = jsonDecode(targetJsonStr) as Map<String, dynamic>;
    
    return {
      "display_type": parsedMap["display_type"] ?? "text",
      "content": parsedMap["content"] ?? "",
    };
  } catch (e) {
    // LLM 에러 등으로 JSON 형식을 맞추지 못한 경우의 Fallback
    print("Warning: Failed to parse Agent JSON response - $e");
    return {
      "display_type": "text", // 폴백은 무조건 text
      "content": rawText.replaceAll('```json', '').replaceAll('```', '').trim(),
    };
  }
}
```

## 5. 실행 명령
사용자는 아래 명령을 통해 해당 문서를 구현 단계로 넘길 수 있습니다.
```bash
/impl 014
```

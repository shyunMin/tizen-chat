import 'dart:convert';

class AgentResponse {
  final String displayType;
  final String content;
  final String? uiCode;

  AgentResponse({
    required this.displayType,
    required this.content,
    this.uiCode,
  });
}

class AgentResponseParser {
  static AgentResponse parse(String rawText) {
    final RegExp jsonRegex = RegExp(r'```json\s*(\{.*?\})\s*```', dotAll: true);
    final match = jsonRegex.firstMatch(rawText);

    if (match == null) {
      String fallbackContent = rawText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();

      return AgentResponse(displayType: "fallback", content: fallbackContent);
    }

    String targetJsonStr = match.group(1)!;
    try {
      final parsedMap = jsonDecode(targetJsonStr) as Map<String, dynamic>;
      String content = parsedMap["content"] ?? "";
      String? uiCode = '';
      String displayType = parsedMap["display_type"] ?? "text";

      // 만약 UI 타입인데 설명 텍스트가 명시적으로 없다면 기본 문구 제공
      if (displayType == 'ui' && content.trim().isEmpty) {
        content = "요청하신 정보를 화면으로 구성했습니다.";
      }

      return AgentResponse(
        displayType: displayType,
        content: content,
        uiCode: uiCode,
      );
    } catch (e) {
      print("Warning: Failed to decode Agent JSON content - $e");

      return AgentResponse(displayType: "fallback", content: rawText.trim());
    }
  }
}

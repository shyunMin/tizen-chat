import 'dart:convert';

class AgentResponse {
  final String displayType;
  final String content;
  final String? uiCode;
  final List<String> actionButtons;

  AgentResponse({
    required this.displayType,
    required this.content,
    this.uiCode,
    this.actionButtons = const [],
  });
}

class AgentResponseParser {
  static final _anchorRegex = RegExp(r'<a>(.*?)</a>');

  static AgentResponse parse(String rawText) {
    final RegExp jsonRegex = RegExp(r'```json\s*(\{.*?\})\s*```', dotAll: true);
    final match = jsonRegex.firstMatch(rawText);

    if (match == null) {
      final fallbackContent = rawText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      final buttons = _extractButtons(fallbackContent);
      final cleanContent = _removeAnchors(fallbackContent);
      return AgentResponse(
        displayType: "fallback",
        content: cleanContent,
        actionButtons: buttons,
      );
    }

    String targetJsonStr = match.group(1)!;
    try {
      final parsedMap = jsonDecode(targetJsonStr) as Map<String, dynamic>;
      String content = parsedMap["content"] ?? "";
      String displayType = parsedMap["display_type"] ?? "text";

      if (displayType == 'ui' && content.trim().isEmpty) {
        content = "요청하신 정보를 화면으로 구성했습니다.";
      }

      final buttons = _extractButtons(content);
      final cleanContent = _removeAnchors(content);

      return AgentResponse(
        displayType: displayType,
        content: cleanContent,
        actionButtons: buttons,
      );
    } catch (e) {
      print("Warning: Failed to decode Agent JSON content - $e");
      return AgentResponse(displayType: "fallback", content: rawText.trim());
    }
  }

  static List<String> _extractButtons(String text) =>
      _anchorRegex
          .allMatches(text)
          .map((m) => m.group(1)!.trim())
          .where((s) => s.isNotEmpty)
          .toList();

  static String _removeAnchors(String text) =>
      text.replaceAll(_anchorRegex, '').trim();
}

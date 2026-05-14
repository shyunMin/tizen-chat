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
    // Match a ```json ... ``` fence and grab the WHOLE body (not just the
    // first nested `{...}`). The previous `\{.*?\}` non-greedy match
    // collapsed onto the first inner object, so a steer-based plan
    // payload like `{"plan":[{...}, ...]}` was decoded as just its first
    // step — producing a parsedMap without `content`, hence an empty
    // bubble. We grab everything between the fences and rely on JSON
    // decode to reject malformed payloads.
    final RegExp fenceRegex = RegExp(r'```json\s*([\s\S]*?)\s*```');
    final match = fenceRegex.firstMatch(rawText);

    if (match == null) {
      final fallbackContent = rawText.trim();
      return AgentResponse(
        displayType: "fallback",
        content: _removeAnchors(fallbackContent),
        actionButtons: _extractButtons(fallbackContent),
      );
    }

    final String targetJsonStr = match.group(1)!.trim();
    try {
      final parsedMap = jsonDecode(targetJsonStr) as Map<String, dynamic>;

      // Canonical chat-response shape: {content, display_type, ui_code}.
      if (parsedMap.containsKey('content') ||
          parsedMap.containsKey('display_type')) {
        String content = (parsedMap['content'] ?? '').toString();
        String displayType = (parsedMap['display_type'] ?? 'text').toString();
        if (displayType == 'ui' && content.trim().isEmpty) {
          content = '요청하신 정보를 화면으로 구성했습니다.';
        }
        return AgentResponse(
          displayType: displayType,
          content: _removeAnchors(content),
          actionButtons: _extractButtons(content),
          uiCode: parsedMap['ui_code']?.toString(),
        );
      }

      // Steer-based plan tracker shape: {plan: [{id, step, status, ...}, ...]}.
      // Render as a readable checklist so the bubble carries useful info
      // even though the agent didn't emit prose around the JSON.
      if (parsedMap['plan'] is List) {
        final plan = parsedMap['plan'] as List<dynamic>;
        final buf = StringBuffer();
        for (var i = 0; i < plan.length; i++) {
          final step = plan[i];
          if (step is! Map<String, dynamic>) continue;
          final status = (step['status'] ?? 'pending').toString();
          final desc = (step['step'] ?? step['id'] ?? '').toString();
          final icon = switch (status) {
            'done' || 'completed' => '✅',
            'in_progress' || 'running' => '⏳',
            'failed' || 'error' => '❌',
            _ => '⬜',
          };
          if (buf.isNotEmpty) buf.write('\n');
          buf.write('$icon ${i + 1}. $desc');
        }
        return AgentResponse(
          displayType: 'fallback',
          content: buf.isEmpty ? targetJsonStr : buf.toString(),
        );
      }

      // Unrecognized JSON shape — last-resort fallback shows raw text
      // (minus the code fences) so the bubble isn't empty.
      final cleaned = rawText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      return AgentResponse(displayType: 'fallback', content: cleaned);
    } catch (e) {
      print('Warning: Failed to decode Agent JSON content - $e');
      return AgentResponse(displayType: 'fallback', content: rawText.trim());
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

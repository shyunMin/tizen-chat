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
  static final _anchorRegex = RegExp(r'<a>(.*?)</a>', dotAll: true);

  static AgentResponse parse(String rawText) {
    final RegExp fenceRegex = RegExp(r'```json\s*([\s\S]*?)\s*```');

    // Walk every ```json … ``` fence: a single turn may emit plan tracker
    // JSON before/after the natural-language answer, plus may emit a
    // canonical {content, display_type} envelope. Strip plan-tracker
    // fences (they're metadata, not the user-visible answer) and surface
    // any canonical envelope. Prose surrounding the fences becomes the
    // displayed answer.
    final canonicalCandidates = <Map<String, dynamic>>[];
    final strippedBuf = StringBuffer();
    int cursor = 0;
    for (final m in fenceRegex.allMatches(rawText)) {
      strippedBuf.write(rawText.substring(cursor, m.start));
      cursor = m.end;
      final body = m.group(1)!.trim();
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('content') ||
              decoded.containsKey('display_type')) {
            canonicalCandidates.add(decoded);
            continue; // drop the fence; envelope takes over
          }
          if (decoded['plan'] is List) {
            continue; // drop plan-tracker JSON from the displayed text
          }
        }
      } catch (_) {
        // Malformed JSON — fall through and keep the fence in prose.
      }
      strippedBuf.write(rawText.substring(m.start, m.end));
    }
    strippedBuf.write(rawText.substring(cursor));

    if (canonicalCandidates.isNotEmpty) {
      final parsedMap = canonicalCandidates.last;
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

    final prose = strippedBuf.toString().trim();
    if (prose.isNotEmpty) {
      return AgentResponse(
        displayType: 'fallback',
        content: _removeAnchors(prose),
        actionButtons: _extractButtons(prose),
      );
    }

    // Pure plan-tracker output (no surrounding prose) — render the last
    // plan as a checklist so the response isn't empty mid-execution.
    for (final m in fenceRegex.allMatches(rawText).toList().reversed) {
      try {
        final decoded = jsonDecode(m.group(1)!.trim());
        if (decoded is Map<String, dynamic> && decoded['plan'] is List) {
          final plan = decoded['plan'] as List<dynamic>;
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
          if (buf.isNotEmpty) {
            return AgentResponse(
              displayType: 'fallback',
              content: buf.toString(),
            );
          }
        }
      } catch (_) {}
    }

    return AgentResponse(displayType: 'fallback', content: rawText.trim());
  }

  static List<String> _extractButtons(String text) => _anchorRegex
      .allMatches(text)
      .map((m) => m.group(1)!.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  static String _removeAnchors(String text) =>
      text.replaceAll(_anchorRegex, '').trim();
}

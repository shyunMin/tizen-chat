import 'package:flutter_test/flutter_test.dart';
import 'package:ai_chat/services/agent_response_parser.dart';

void main() {
  group('AgentResponseParser', () {
    test('canonical {content, display_type} JSON parses content', () {
      final raw = '''
```json
{"content": "안녕하세요", "display_type": "text"}
```
''';
      final r = AgentResponseParser.parse(raw);
      expect(r.displayType, equals('text'));
      expect(r.content, equals('안녕하세요'));
    });

    test('plan tracker JSON renders as checklist (not empty)', () {
      // Reproduces the live-test bug where the agent emits a steer-based
      // plan in JSON form and the previous parser returned content="" →
      // empty bubble. The new parser must render plan steps as text.
      final raw = '''
```json
{"plan":[
  {"id":"step_1","step":"Run pwd","status":"done"},
  {"id":"step_2","step":"List /tmp","status":"in_progress"},
  {"id":"step_3","step":"Print date","status":"pending"}
]}
```
''';
      final r = AgentResponseParser.parse(raw);
      expect(r.content, isNotEmpty,
          reason: 'plan-shape JSON must produce visible content');
      expect(r.content, contains('Run pwd'));
      expect(r.content, contains('List /tmp'));
      expect(r.content, contains('Print date'));
      expect(r.content, contains('✅'));
      expect(r.content, contains('⏳'));
    });

    test('nested-object JSON inside fences is fully extracted', () {
      // Old regex was \{.*?\} non-greedy → collapsed onto the first inner
      // `}`. New regex captures the whole fence body so jsonDecode sees
      // the outer wrapper.
      final raw = '''
```json
{"content": "outer", "display_type": "text", "extras": {"nested": "value"}}
```
''';
      final r = AgentResponseParser.parse(raw);
      expect(r.content, equals('outer'));
    });

    test('plain text with no JSON fence falls through to fallback', () {
      final r = AgentResponseParser.parse('그냥 일반 텍스트 응답');
      expect(r.displayType, equals('fallback'));
      expect(r.content, equals('그냥 일반 텍스트 응답'));
    });

    test('unrecognized JSON shape falls back to raw text (not empty)', () {
      final raw = '''
```json
{"some_random_key": "value", "another": 42}
```
''';
      final r = AgentResponseParser.parse(raw);
      expect(r.content, isNotEmpty,
          reason: 'unknown shape must not produce empty bubble');
    });

    test('malformed JSON inside fence falls back to raw text', () {
      final raw = '```json\n{not really json}\n```';
      final r = AgentResponseParser.parse(raw);
      expect(r.displayType, equals('fallback'));
      expect(r.content, isNotEmpty);
    });
  });
}

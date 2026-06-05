import 'package:flutter_test/flutter_test.dart';

import 'package:ai_chat/generated/argot/v1/types.pb.dart' as argot_types;
import 'package:ai_chat/services/argot_grpc_service.dart';

void main() {
  late ArgotGrpcService svc;

  setUp(() async {
    svc = ArgotGrpcService.instance;
    await svc.disconnect();
    svc.debugSetReady(true);
    svc.debugSetSessionId('test-session');
  });

  test(
    'maps streamed text, tool calls, tool results, and done events',
    () async {
      final events = <ArgotEvent>[];
      final sub = svc.events.listen(events.add);

      try {
        svc.debugSetCurrentTurnId('turn-1');
        svc.debugHandleChatEvent(
          argot_types.ChatEvent(delta: argot_types.MessageDelta(text: 'hello')),
          turnId: 'turn-1',
        );
        svc.debugHandleChatEvent(
          argot_types.ChatEvent(
            toolCall: argot_types.ToolCall(
              id: 'call-1',
              name: 'search',
              argumentsJson: '{"query":"tizen"}',
            ),
          ),
          turnId: 'turn-1',
        );
        svc.debugHandleChatEvent(
          argot_types.ChatEvent(
            toolResult: argot_types.ToolResult(
              callId: 'call-1',
              outputJson: '{"ok":true}',
            ),
          ),
          turnId: 'turn-1',
        );
        svc.debugHandleChatEvent(
          argot_types.ChatEvent(completed: argot_types.Completed()),
          turnId: 'turn-1',
        );

        await Future.delayed(Duration.zero);

        expect(events.whereType<ArgotTextDelta>().single.content, 'hello');
        expect(events.whereType<ArgotToolUseStart>().single.toolName, 'search');
        expect(events.whereType<ArgotToolResult>().single.toolCallId, 'call-1');
        expect(events.whereType<ArgotMessageFinalized>(), hasLength(1));
        expect(events.whereType<ArgotTurnComplete>().single.turnId, 'turn-1');
        expect(
          events.whereType<ArgotThreadComplete>().single.threadId,
          'test-session',
        );
        expect(svc.debugCurrentTurnId, isNull);
      } finally {
        await sub.cancel();
      }
    },
  );

  test('uses Completed.text when no deltas were streamed', () async {
    final deltas = <ArgotTextDelta>[];
    final sub = svc.events.listen((event) {
      if (event is ArgotTextDelta) deltas.add(event);
    });

    try {
      svc.debugSetCurrentTurnId('turn-2');
      svc.debugHandleChatEvent(
        argot_types.ChatEvent(
          completed: argot_types.Completed(text: 'final answer'),
        ),
        turnId: 'turn-2',
      );

      await Future.delayed(Duration.zero);

      expect(deltas.single.content, 'final answer');
      expect(svc.debugCurrentTurnId, isNull);
    } finally {
      await sub.cancel();
    }
  });

  test(
    'uses Completed.text when only whitespace deltas were streamed',
    () async {
      final deltas = <ArgotTextDelta>[];
      final sub = svc.events.listen((event) {
        if (event is ArgotTextDelta) deltas.add(event);
      });

      try {
        svc.debugSetCurrentTurnId('turn-2b');
        svc.debugHandleChatEvent(
          argot_types.ChatEvent(delta: argot_types.MessageDelta(text: '\n\n')),
          turnId: 'turn-2b',
        );
        svc.debugHandleChatEvent(
          argot_types.ChatEvent(
            completed: argot_types.Completed(text: 'final answer'),
          ),
          turnId: 'turn-2b',
        );

        await Future.delayed(Duration.zero);

        expect(deltas.map((e) => e.content), ['\n\n', 'final answer']);
        expect(svc.debugCurrentTurnId, isNull);
      } finally {
        await sub.cancel();
      }
    },
  );

  test('interruptTurn keeps the adapter surface and cancels locally', () async {
    final events = <ArgotEvent>[];
    final sub = svc.events.listen(events.add);

    try {
      svc.debugSetCurrentTurnId('turn-stop');
      svc.interruptTurn();

      await Future.delayed(Duration.zero);

      expect(events.whereType<ArgotError>().single.code, 'cancelled');
      expect(events.whereType<ArgotTurnComplete>().single.turnId, 'turn-stop');
      expect(events.whereType<ArgotThreadComplete>(), hasLength(1));
      expect(svc.debugCurrentTurnId, isNull);
    } finally {
      await sub.cancel();
    }
  });

  test('approveToolCall remains as a no-op compatibility adapter', () {
    expect(
      () => svc.approveToolCall('approval-1', ArgotApprovalDecision.approve),
      returnsNormally,
    );
  });
}

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

  test('maps agent progress events with stable phase/source labels', () async {
    final events = <ArgotEvent>[];
    final sub = svc.events.listen(events.add);

    try {
      svc.debugSetCurrentTurnId('turn-progress');
      svc.debugHandleChatEvent(
        argot_types.ChatEvent(
          progress: argot_types.AgentProgress(
            phase: argot_types.Phase.PHASE_TOOL_EXECUTING,
            statusId: 'agent-status-tool-executing',
            toolName: 'bash_run',
            source: argot_types.ProgressSource.PROGRESS_SOURCE_AGENT_STATUS,
            agentPath: const ['root', 'sub'],
          ),
        ),
        turnId: 'turn-progress',
      );
      svc.debugHandleChatEvent(
        argot_types.ChatEvent(
          progress: argot_types.AgentProgress(
            phase: argot_types.Phase.PHASE_THINKING,
          ),
        ),
        turnId: 'turn-progress',
      );

      await Future.delayed(Duration.zero);

      final progress = events.whereType<ArgotAgentProgress>().toList();
      expect(progress, hasLength(2));
      expect(progress.first.phase, 'tool_executing');
      expect(progress.first.toolName, 'bash_run');
      expect(progress.first.statusId, 'agent-status-tool-executing');
      expect(progress.first.source, 'agent_status');
      expect(progress.first.agentPath, ['root', 'sub']);
      expect(progress.first.displayLabel, 'running bash_run');
      expect(progress[1].phase, 'thinking');
      expect(progress[1].displayLabel, 'thinking');
      // Progress is live-only: it must not terminate the turn.
      expect(events.whereType<ArgotTurnComplete>(), isEmpty);
      expect(svc.debugCurrentTurnId, 'turn-progress');
    } finally {
      await sub.cancel();
    }
  });

  test('suppresses streaming/done/unspecified progress display labels', () async {
    final events = <ArgotEvent>[];
    final sub = svc.events.listen(events.add);

    try {
      svc.debugSetCurrentTurnId('turn-suppress');
      for (final phase in [
        argot_types.Phase.PHASE_STREAMING,
        argot_types.Phase.PHASE_DONE,
        argot_types.Phase.PHASE_UNSPECIFIED,
      ]) {
        svc.debugHandleChatEvent(
          argot_types.ChatEvent(
            progress: argot_types.AgentProgress(phase: phase),
          ),
          turnId: 'turn-suppress',
        );
      }

      await Future.delayed(Duration.zero);

      final progress = events.whereType<ArgotAgentProgress>().toList();
      expect(progress, hasLength(3));
      expect(progress.every((p) => p.displayLabel == null), isTrue);
    } finally {
      await sub.cancel();
    }
  });

  test('summarizer message wins over the coarse phase label', () async {
    final events = <ArgotEvent>[];
    final sub = svc.events.listen(events.add);

    try {
      svc.debugSetCurrentTurnId('turn-summary');
      svc.debugHandleChatEvent(
        argot_types.ChatEvent(
          progress: argot_types.AgentProgress(
            phase: argot_types.Phase.PHASE_SUMMARY,
            message: 'Reading turn.rs',
            source: argot_types
                .ProgressSource.PROGRESS_SOURCE_AGENT_PROGRESS_SUMMARY,
          ),
        ),
        turnId: 'turn-summary',
      );

      await Future.delayed(Duration.zero);

      final p = events.whereType<ArgotAgentProgress>().single;
      expect(p.phase, 'summary');
      expect(p.source, 'agent_progress_summary');
      expect(p.displayLabel, 'Reading turn.rs');
    } finally {
      await sub.cancel();
    }
  });
}

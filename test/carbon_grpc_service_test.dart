// Regression tests for the v1→v2 wire migration. These are the four paths
// that, if broken, produce silently-wrong behavior (cancel doesn't cancel,
// approval keys mismatch, dropped requests look like hangs, multi-prompt
// turns leak between each other). The 12 other coverage gaps from the
// /plan-eng-review diagram are deferred — see TODOS.md #3.

import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc.dart';

import 'package:ai_chat/services/carbon_grpc_service.dart';
import 'package:ai_chat/generated/carbon/v2/event_service.pb.dart'
    as event_v2;
import 'package:ai_chat/generated/carbon/v2/ingress_service.pb.dart'
    as ingress_v2;
import 'package:ai_chat/generated/carbon/v2/ingress_service.pbenum.dart'
    as ingress_enum;
import 'package:ai_chat/generated/carbon/v2/ingress_service.pbgrpc.dart'
    as ingress_grpc;

/// Captures the ApproveTool and InterruptTurn calls the service makes so
/// tests can assert on the actual gRPC request payload (Codex's #10 point:
/// the test strategy must verify request CONSTRUCTION, not just dispatch).
class _CapturingIngressClient extends ingress_grpc.IngressServiceClient {
  ingress_v2.ApproveToolRequest? lastApproveRequest;
  ingress_v2.InterruptTurnRequest? lastInterruptRequest;

  _CapturingIngressClient()
      : super(
          ClientChannel(
            'localhost',
            port: 0,
            options: const ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          ),
        );

  @override
  ResponseFuture<ingress_v2.ApproveToolResponse> approveTool(
    ingress_v2.ApproveToolRequest request, {
    CallOptions? options,
  }) {
    lastApproveRequest = request;
    // Delegate to the dead-channel super — call returns a ResponseFuture
    // that errors asynchronously when the unix-socket dial fails. The
    // production code attaches .catchError() so the failure is swallowed.
    // We only care about what the request CONTAINED (assert synchronously
    // on lastApproveRequest after the call returns).
    return super.approveTool(request, options: options);
  }

  @override
  ResponseFuture<ingress_v2.InterruptTurnResponse> interruptTurn(
    ingress_v2.InterruptTurnRequest request, {
    CallOptions? options,
  }) {
    lastInterruptRequest = request;
    return super.interruptTurn(request, options: options);
  }
}

void main() {
  late CarbonGrpcService svc;
  late _CapturingIngressClient ingressMock;

  setUp(() {
    // Reuse the singleton — disconnect first to wipe state from any prior
    // test. The service is intentionally process-singleton in production.
    svc = CarbonGrpcService.instance;
    svc.disconnect();
    ingressMock = _CapturingIngressClient();
    svc.debugSetSessionId('test-session');
    svc.debugSetReady(true);
    svc.debugSetIngressClient(ingressMock);
  });

  test(
    'REGRESSION #1: approveToolCall uses approval_id, NOT tool_call_id',
    () async {
      // The v1→v2 contract change. v1 keyed approvals on tool_call_id;
      // v2 introduces a daemon-issued approval_id and tool_call_id is now
      // a non-routing display field. If we send tool_call_id here the
      // daemon either ignores us (silent hang) or, worse, matches a
      // different pending approval.
      svc.approveToolCall(
        'approval-xyz',
        ingress_enum.ApprovalDecision.APPROVAL_DECISION_APPROVE,
      );
      // give the catchError microtask a moment to settle so we don't race
      await Future.delayed(Duration.zero);
      expect(ingressMock.lastApproveRequest, isNotNull);
      expect(ingressMock.lastApproveRequest!.approvalId, equals('approval-xyz'));
      expect(
        ingressMock.lastApproveRequest!.decision,
        equals(ingress_enum.ApprovalDecision.APPROVAL_DECISION_APPROVE),
      );
    },
  );

  test(
    'REGRESSION #2: interruptTurn uses tracked _currentTurnId, not session-only',
    () async {
      // v1 only needed sessionId. v2 makes interrupt race-safe by requiring
      // the turn_id of the turn-to-cancel; if it doesn't match the
      // in-flight turn the daemon no-ops. So the client MUST track the
      // current turn_id and pass it on cancel.

      // Simulate the daemon assigning a turn via SubmitResponse (the
      // authoritative source — see /plan-eng-review T1).
      final resp = ingress_v2.SubmitResponse(
        disposition: ingress_enum.Disposition.DISPOSITION_STARTED_NOW,
        turnId: 'turn-abc',
        clientRequestId: 'req-1',
      );
      svc.debugHandleSubmitResponse(resp);
      expect(svc.debugCurrentTurnId, equals('turn-abc'));

      svc.interruptTurn();
      await Future.delayed(Duration.zero);

      expect(ingressMock.lastInterruptRequest, isNotNull);
      expect(ingressMock.lastInterruptRequest!.turnId, equals('turn-abc'));
      expect(
        ingressMock.lastInterruptRequest!.mode,
        equals(ingress_enum.InterruptMode.INTERRUPT_MODE_HARD),
      );
    },
  );

  test(
    'REGRESSION #2b: interruptTurn with no in-flight turn is a guarded no-op',
    () {
      // Codex #14 — refuse to send InterruptTurn when we don't know a
      // turn_id. Daemon would no-op anyway but a guard saves a pointless
      // RPC and avoids the "looks like nothing happened" confusion.
      // _currentTurnId is null after fresh setUp().
      expect(svc.debugCurrentTurnId, isNull);
      svc.interruptTurn();
      expect(
        ingressMock.lastInterruptRequest,
        isNull,
        reason: 'should not send when no turn is in flight',
      );
    },
  );

  test(
    'REGRESSION #3: DROPPED disposition emits CarbonError synchronously',
    () async {
      // Codex T2 — DROPPED lives on the synchronous SubmitResponse, not in
      // the event stream. If we waited for an event that never arrives,
      // the UI would spin forever.
      final errors = <CarbonError>[];
      final sub = svc.events.listen((e) {
        if (e is CarbonError) errors.add(e);
      });
      try {
        svc.debugHandleSubmitResponse(
          ingress_v2.SubmitResponse(
            disposition: ingress_enum.Disposition.DISPOSITION_DROPPED,
            clientRequestId: 'req-drop',
          ),
        );
        // microtask boundary so the broadcast stream delivers
        await Future.delayed(Duration.zero);
        expect(errors, hasLength(1));
        expect(errors.first.code, equals('DROPPED'));
        // And critically: _currentTurnId stays null — no turn was ever
        // assigned, so a subsequent interruptTurn() must not target a
        // stale id.
        expect(svc.debugCurrentTurnId, isNull);
      } finally {
        await sub.cancel();
      }
    },
  );

  test(
    'REGRESSION #4: client_request_id correlation is populated from '
    'SubmitResponse, cleared on TurnCompleted',
    () async {
      // The new isolation fix (D3/T1). When SubmitResponse arrives with
      // disposition that assigns a turn_id, the {client_request_id ->
      // turn_id} mapping must be populated immediately — not deferred to
      // TurnStarted — so a fast follow-up Submit doesn't race the map.
      // And the entry must vacate when its turn completes (D7).

      svc.debugHandleSubmitResponse(
        ingress_v2.SubmitResponse(
          disposition: ingress_enum.Disposition.DISPOSITION_STARTED_NOW,
          turnId: 'turn-1',
          clientRequestId: 'req-a',
        ),
      );
      svc.debugHandleSubmitResponse(
        ingress_v2.SubmitResponse(
          disposition: ingress_enum.Disposition.DISPOSITION_STEERED,
          turnId: 'turn-1', // same in-flight turn
          clientRequestId: 'req-b',
        ),
      );
      expect(svc.debugCorrelation['req-a'], equals('turn-1'));
      expect(svc.debugCorrelation['req-b'], equals('turn-1'));

      // TurnCompleted event arrives → both entries should be dropped.
      final turnDone = event_v2.Event(
        body: event_v2.EventBody(
          turnCompleted: event_v2.TurnCompleted(turnId: 'turn-1'),
        ),
      );
      svc.debugHandleEvent(turnDone);
      expect(svc.debugCorrelation, isEmpty);
      expect(svc.debugCurrentTurnId, isNull);
    },
  );

  test(
    'REGRESSION #4b: correlation entries cleared on SessionEnded too (T3)',
    () {
      svc.debugHandleSubmitResponse(
        ingress_v2.SubmitResponse(
          disposition: ingress_enum.Disposition.DISPOSITION_STARTED_NOW,
          turnId: 'turn-x',
          clientRequestId: 'req-x',
        ),
      );
      expect(svc.debugCorrelation, isNotEmpty);

      svc.debugHandleEvent(
        event_v2.Event(
          body: event_v2.EventBody(
            sessionEnded: event_v2.SessionEnded(reason: 'test'),
          ),
        ),
      );
      expect(svc.debugCorrelation, isEmpty);
      expect(svc.debugCurrentTurnId, isNull);
    },
  );

  // ──────────────────────────────────────────────────────────────────
  // Proxy-gap pin tests.
  //
  // chat-ui currently leans on a handful of proxies because v2 carbon
  // hasn't shipped its full disposition/event feedback layer yet
  // (RFC 0007 task `v2-ingress-runtime-disposition-feedback`). When
  // that work lands and chat-ui drops the proxies, these tests
  // become the regression guard. Today each one is EXPECTED TO FAIL —
  // they pin the daemon contract we want, not the workarounds we
  // shipped.
  //
  // To verify the proxies are gone:
  //   flutter test test/carbon_grpc_service_test.dart
  // — failing tests below = proxy still in use.
  // ──────────────────────────────────────────────────────────────────

  test(
    'PROXY GAP #1: wire SteerApplied event surfaces on the broadcast stream',
    () async {
      // Today: `_handleEvent` has no `body.hasSteerApplied()` branch —
      // SteerApplied wire events are silently dropped. The UI's
      // pending-slot release ends up keyed on the NEXT TurnCompleted
      // (a proxy, not the real signal). When carbon's agent_loop
      // starts emitting SteerApplied, chat-ui should add a
      // `CarbonSteerApplied` variant and dispatch it here.
      final events = <CarbonEvent>[];
      final sub = svc.events.listen(events.add);
      try {
        svc.debugHandleEvent(
          event_v2.Event(
            body: event_v2.EventBody(
              steerApplied: event_v2.SteerApplied(
                turnId: 'turn-1',
                clientRequestId: 'req-1',
              ),
            ),
          ),
        );
        await Future.delayed(Duration.zero);
        expect(
          events,
          isNotEmpty,
          reason:
              'wire SteerApplied should reach the broadcast stream so the '
              'pending-slot UI can resolve on the real signal instead of '
              'the next TurnCompleted',
        );
      } finally {
        await sub.cancel();
      }
    },
  );

  test(
    'PROXY GAP #2: same-turn TurnCompleted (validation continuation) emits once',
    () async {
      // Today: every wire TurnCompleted → CarbonTurnComplete on the
      // broadcast stream → the UI's _finalizeActiveReply runs each
      // time → one user prompt produces N agent bubbles for N
      // agent_loop rounds (the "validation continuation duplicate
      // bubble" symptom we hit live). Chat-ui should collapse
      // continuation rounds: only ONE user-visible finalization per
      // logical turn (= per ThreadCompleted, or via phase=FinalAnswer).
      final completes = <CarbonTurnComplete>[];
      final sub = svc.events.listen((e) {
        if (e is CarbonTurnComplete) completes.add(e);
      });
      try {
        // Round 1 end (Commentary phase — not the final answer yet)
        svc.debugHandleEvent(
          event_v2.Event(
            body: event_v2.EventBody(
              turnCompleted: event_v2.TurnCompleted(turnId: 'turn-A'),
            ),
          ),
        );
        // Round 2 end (still Commentary)
        svc.debugHandleEvent(
          event_v2.Event(
            body: event_v2.EventBody(
              turnCompleted: event_v2.TurnCompleted(turnId: 'turn-A'),
            ),
          ),
        );
        // Round 3 end — the FINAL one
        svc.debugHandleEvent(
          event_v2.Event(
            body: event_v2.EventBody(
              turnCompleted: event_v2.TurnCompleted(turnId: 'turn-A'),
            ),
          ),
        );
        await Future.delayed(Duration.zero);
        expect(
          completes.length,
          equals(1),
          reason:
              'Continuation rounds inside one logical turn should NOT each '
              'trigger a user-visible turn completion. UI should only '
              'finalize on the final phase or on ThreadCompleted.',
        );
      } finally {
        await sub.cancel();
      }
    },
  );

  test(
    'PROXY GAP #3: SubmitResponse.disposition=QUEUED is observably distinct',
    () async {
      // Today: _handleSubmitResponse only branches on DROPPED →
      // CarbonError. STEERED and QUEUED both fall through into the
      // generic `turnId.isNotEmpty` setter — the UI has no way to
      // tell whether the daemon queued the prompt for after the
      // current thread vs. injected it into the in-flight turn. The
      // 1-slot pending UI uses a client-side `_currentTurnId` proxy
      // to guess. When carbon's disposition reporting lands, chat-ui
      // should expose the disposition to the UI somehow (CarbonEvent
      // variant or a getter); pinning here so it doesn't get lost
      // again.
      final events = <CarbonEvent>[];
      final sub = svc.events.listen(events.add);
      try {
        svc.debugHandleSubmitResponse(
          ingress_v2.SubmitResponse(
            disposition: ingress_enum.Disposition.DISPOSITION_QUEUED,
            clientRequestId: 'req-queued-1',
          ),
        );
        await Future.delayed(Duration.zero);
        expect(
          events.any((e) =>
              // Whatever shape chat-ui picks (a new CarbonEvent
              // variant, a CarbonError-with-code="QUEUED", etc.), it
              // must reach the UI somehow.
              e is! CarbonTextDelta && e is! CarbonToolUseStart),
          isTrue,
          reason:
              'A daemon-reported QUEUED disposition must surface as a '
              'distinct CarbonEvent so the pending-slot UI doesn\'t have '
              'to guess via _currentTurnId.',
        );
      } finally {
        await sub.cancel();
      }
    },
  );
}

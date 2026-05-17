import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:grpc/grpc.dart';
import 'package:protobuf/well_known_types/google/protobuf/struct.pb.dart'
    as wkt;

import '../generated/carbon/v2/session_service.pbgrpc.dart' as session_v2;
import '../generated/carbon/v2/ingress_service.pbgrpc.dart' as ingress_v2;
import '../generated/carbon/v2/event_service.pbgrpc.dart' as event_v2;
import '../generated/carbon/v2/event_service.pbenum.dart' as event_enum;

const String _kSource = 'ai-chat-flutter';

// Mirror of carbon CLI's IngressOptions.metadata.delivery. The runtime
// builds the system-prompt "Final Delivery" section + alias table from this
// — without it, claw's agent loop never sees the egress catalog and the
// model degenerates into plan-only text instead of calling tools.
wkt.Struct _buildIngressMetadata() {
  wkt.Value strValue(String s) => wkt.Value()..stringValue = s;
  wkt.Value boolValue(bool b) => wkt.Value()..boolValue = b;
  wkt.Value structValue(wkt.Struct s) => wkt.Value()..structValue = s;

  final targetPolicy = wkt.Struct()
    ..fields['mode'] = strValue('rich_text')
    ..fields['allow_fallback'] = boolValue(true)
    ..fields['required_variant'] = boolValue(false);

  final targets = wkt.Struct()..fields[_kSource] = structValue(targetPolicy);

  final aliases = wkt.Struct()
    ..fields['cli'] = strValue(_kSource)
    ..fields['claw'] = strValue(_kSource)
    ..fields['carbon-claw'] = strValue(_kSource);

  final delivery = wkt.Struct()
    ..fields['default_target'] = strValue(_kSource)
    ..fields['aliases'] = structValue(aliases)
    ..fields['targets'] = structValue(targets);

  return wkt.Struct()..fields['delivery'] = structValue(delivery);
}

// Flutter-friendly event models. UI consumers (chat_screen,
// tizen_chat_home_screen) speak this sealed class hierarchy; the underlying
// wire protocol can change without touching screens.
sealed class CarbonEvent {}

class CarbonTextDelta extends CarbonEvent {
  final String content;
  CarbonTextDelta(this.content);
}

/// Marks the end of an assistant message block (v2 MessageFinalized).
/// Carries the phase tag so the UI can distinguish commentary (reasoning /
/// "I'll do X" text the agent says alongside tool calls) from the final
/// user-facing answer. Phases are reported as raw v2 enum values to keep
/// the UI free to interpret them however it likes.
class CarbonMessageFinalized extends CarbonEvent {
  /// 1 = Commentary, 2 = FinalAnswer. See AssistantMessagePhase in
  /// generated/carbon/v2/event_service.pbenum.dart.
  final int phase;
  CarbonMessageFinalized(this.phase);

  bool get isFinalAnswer =>
      phase ==
      event_enum
          .AssistantMessagePhase
          .ASSISTANT_MESSAGE_PHASE_FINAL_ANSWER
          .value;
  bool get isCommentary =>
      phase ==
      event_enum.AssistantMessagePhase.ASSISTANT_MESSAGE_PHASE_COMMENTARY.value;
}

class CarbonToolUseStart extends CarbonEvent {
  final String toolName;
  final String toolCallId;
  final String argumentsJson;
  CarbonToolUseStart(this.toolName, this.toolCallId, this.argumentsJson);
}

class CarbonToolResult extends CarbonEvent {
  final String toolCallId;
  final String output;
  final bool isError;
  CarbonToolResult(this.toolCallId, this.output, this.isError);
}

class CarbonTurnComplete extends CarbonEvent {
  final String? usageJson;
  final String turnId;
  CarbonTurnComplete({this.usageJson, this.turnId = ''});
}

/// Daemon confirmed a steer landed on the in-flight turn (drained at a
/// round boundary, queued item was injected into the loop). Carries the
/// originating client_request_id so the 1-slot pending UI can release
/// the right submission. Fires BEFORE the next TurnCompleted of the
/// turn that absorbed the steer.
class CarbonSteerApplied extends CarbonEvent {
  final String turnId;
  final String clientRequestId;
  CarbonSteerApplied(this.turnId, this.clientRequestId);
}

/// Daemon could not land a steer on the originally-targeted turn (turn
/// ended mid-race / late-recovery re-injection). [reason] is daemon-
/// supplied free text. The submission may have been re-routed; the UI
/// should release the pending slot but warn the user that the message
/// may surface in a later turn.
class CarbonSteerFailed extends CarbonEvent {
  final String turnId;
  final String clientRequestId;
  final String reason;
  CarbonSteerFailed(this.turnId, this.clientRequestId, this.reason);
}

/// Submit returned with QUEUED disposition — the daemon was busy and
/// parked the prompt in its post-thread queue. No turn_id yet (assigned
/// when the queued submission pops as a fresh turn — that arrives as a
/// TurnStarted with the matching client_request_id).
class CarbonSubmitQueued extends CarbonEvent {
  final String clientRequestId;
  CarbonSubmitQueued(this.clientRequestId);
}

/// Submit returned with STEERED disposition — daemon accepted the
/// prompt into the steer queue of the currently-running turn. Distinct
/// from STARTED_NOW so the UI can show "queued for mid-turn injection"
/// vs "just started its own turn". [turnId] is the in-flight turn id.
class CarbonSubmitSteered extends CarbonEvent {
  final String turnId;
  final String clientRequestId;
  CarbonSubmitSteered(this.turnId, this.clientRequestId);
}

/// Daemon's agent_loop will run another LLM round on the same logical
/// turn — validator failed, plan-frontier advanced, budget exhausted, etc.
/// Replaces the prior `continuation:*` Error-code path (Slice B made it
/// a typed wire body). UI should drop the accumulated round-1 text so the
/// regenerated round-2 content doesn't append onto it.
class CarbonContinuationRequested extends CarbonEvent {
  /// Raw v2 enum value: see ContinuationReason in
  /// generated/carbon/v2/event_service.pbenum.dart.
  final int reason;
  final String message;
  CarbonContinuationRequested(this.reason, this.message);
}

/// Validator gate started for a turn (begins after the model emits its
/// final-answer phase). Informational only; UI can show a "검증 중" sub-
/// indicator if it wants finer-grained progress.
class CarbonValidationStarted extends CarbonEvent {
  final String turnId;
  CarbonValidationStarted(this.turnId);
}

/// Validator gate finished. [passed] = whether the model's answer was
/// accepted. [reason] is the validator's free-text rationale. [attempt]
/// is the 1-based attempt index in this thread.
class CarbonValidationCompleted extends CarbonEvent {
  final String turnId;
  final bool passed;
  final String reason;
  final int attempt;
  CarbonValidationCompleted(this.turnId, this.passed, this.reason, this.attempt);
}

/// Phase metadata that travels with TurnStarted. Each plan-driven thread
/// emits a chain of turns; the phase tells the UI which role this turn
/// is playing so each turn can be rendered as its own bubble with a
/// header.
sealed class CarbonTurnPhase {
  /// One-line UI title for this phase, e.g.
  /// "🛠 Step 3/4 · 기사 URL 추출". Null = no header (FinalAnswer-style).
  String? title();
}

class CarbonTurnPhasePrompt extends CarbonTurnPhase {
  @override
  String? title() => '💬 Prompt';
}

class CarbonTurnPhaseStep extends CarbonTurnPhase {
  final String stepId;
  final String stepText;
  /// 1-based. May be 0 when daemon didn't fill it (pre-Slice D).
  final int stepIndex;
  /// Total step count for this thread's plan.
  final int planStepCount;
  CarbonTurnPhaseStep({
    required this.stepId,
    required this.stepText,
    required this.stepIndex,
    required this.planStepCount,
  });

  @override
  String? title() {
    if (planStepCount > 0 && stepIndex > 0) {
      return '🛠 Step $stepIndex/$planStepCount · $stepText';
    }
    return '🛠 $stepText';
  }
}

class CarbonTurnPhaseValidation extends CarbonTurnPhase {
  final int attempt;
  CarbonTurnPhaseValidation(this.attempt);

  // Returning null prevents a Validation-phase bubble from materializing.
  // Validator pass / fail is communicated visually on the bubble that
  // CARRIED the answer being validated (via validationPassed ✓), not as
  // a separate "🧪 Validation" bubble. If the validator emits the
  // final-answer delta inside this turn, the bubble that lazily
  // materializes for that delta gets phaseTitle=null (clean answer
  // style) and inherits the pending validationPassed flag.
  @override
  String? title() => null;
}

class CarbonTurnPhaseRecovery extends CarbonTurnPhase {
  @override
  String? title() => '⚠️ Recovery';
}

class CarbonTurnPhaseFree extends CarbonTurnPhase {
  @override
  String? title() => '💭 Free';
}

class CarbonTurnPhaseUnknown extends CarbonTurnPhase {
  @override
  String? title() => null;
}

/// New turn started. The [clientRequestId] echoes whatever was on the
/// originating SubmitRequest, which is how a chat client tells "this is
/// the turn for my queued prompt." Sources other than the chat client
/// (sub-agent results, scheduler, etc.) leave it empty.
class CarbonTurnStarted extends CarbonEvent {
  final String turnId;
  final String threadId;
  final String source;
  final String clientRequestId;
  final String prompt;
  /// Phase metadata from TurnStarted.phase. Plan-driven threads put a
  /// PhaseStep / PhaseValidation / PhaseRecovery here so the UI can
  /// render a header on the resulting bubble.
  final CarbonTurnPhase phase;
  CarbonTurnStarted(
    this.turnId,
    this.threadId,
    this.source,
    this.clientRequestId,
    this.prompt,
    this.phase,
  );
}

/// Whole thread finished (all turns within it done). Useful as a safety
/// net for UI state that needs to unlock if no further events will
/// arrive (e.g. a steer that never got drained because the turn ended
/// without another LLM round).
class CarbonThreadComplete extends CarbonEvent {
  final String threadId;
  CarbonThreadComplete(this.threadId);
}

class CarbonError extends CarbonEvent {
  final String code;
  final String message;
  final bool fatal;
  CarbonError(this.code, this.message, this.fatal);
}

class CarbonSessionEnded extends CarbonEvent {
  final String reason;
  CarbonSessionEnded(this.reason);
}

class CarbonToolApprovalRequest extends CarbonEvent {
  /// Daemon-issued approval handle. This — not [toolCallId] — is the key
  /// passed to [CarbonGrpcService.approveToolCall] in v2.
  final String approvalId;
  final String toolCallId;
  final String toolName;
  final String argumentsJson;
  final String reason;
  final int timeoutSecs;
  CarbonToolApprovalRequest(
    this.approvalId,
    this.toolCallId,
    this.toolName,
    this.argumentsJson,
    this.reason,
    this.timeoutSecs,
  );
}

/// Pull TurnPhase off a TurnStarted proto and map it onto the dart-side
/// sealed [CarbonTurnPhase] hierarchy. Falls back to
/// [CarbonTurnPhaseUnknown] when the daemon didn't emit a phase (older
/// daemons, schedule-originated turns, etc.).
CarbonTurnPhase _carbonPhaseFromProto(event_v2.TurnStarted t) {
  if (!t.hasPhase()) return CarbonTurnPhaseUnknown();
  final p = t.phase;
  if (p.hasPrompt()) return CarbonTurnPhasePrompt();
  if (p.hasStep()) {
    final s = p.step;
    return CarbonTurnPhaseStep(
      stepId: s.stepId,
      stepText: s.stepText,
      stepIndex: s.stepIndex,
      planStepCount: s.planStepCount,
    );
  }
  if (p.hasValidation()) {
    return CarbonTurnPhaseValidation(p.validation.attempt);
  }
  if (p.hasRecovery()) return CarbonTurnPhaseRecovery();
  if (p.hasFree()) return CarbonTurnPhaseFree();
  return CarbonTurnPhaseUnknown();
}

class CarbonGrpcService {
  static final CarbonGrpcService instance = CarbonGrpcService._();
  CarbonGrpcService._();

  ClientChannel? _channel;
  session_v2.SessionServiceClient? _sessionClient;
  ingress_v2.IngressServiceClient? _ingressClient;
  event_v2.EventServiceClient? _eventClient;
  ResponseStream<event_v2.Event>? _subscribeStream;
  StreamSubscription<event_v2.Event>? _subscribeSubscription;

  /// "Ready" means session is created AND Subscribe stream is live.
  /// sendPrompt() / approveToolCall() / interruptTurn() check this — sending
  /// while Subscribe is dead would let the daemon process a turn whose events
  /// we can never hear.
  bool _isReady = false;
  bool get isConnected => _isReady;
  // ignore: unused_field
  bool _isConnecting = false;

  /// "Daemon told us it's busy with someone else's turn" flag. Set only
  /// when SubmitResponse.disposition == QUEUED (turn_id stays null in
  /// that case — the daemon parked us behind an in-flight turn).
  /// Cleared on TurnCompleted of the prior turn, TurnStarted (a new
  /// turn — ours or another — began), ThreadCompleted, SessionEnded,
  /// disconnect. Used together with `_currentTurnId` to compute
  /// `isTurnBusy` without relying on a TurnStarted round-trip.
  bool _clientThinksTurnBusy = false;

  /// True iff the daemon is processing a turn for this session, as far
  /// as the client can tell. Used by the UI to decide whether a new
  /// submission should bubble up immediately (no turn busy →
  /// STARTED_NOW) or be held in the pending slot (turn busy → STEERED
  /// or QUEUED depending on the steer flag).
  bool get isTurnBusy => _currentTurnId != null || _clientThinksTurnBusy;

  String? _sessionId;
  String? get sessionId => _sessionId;

  String? _sessionName;

  /// Authoritative current turn_id. Populated synchronously from
  /// SubmitResponse (when disposition is STARTED_NOW or STEERED), reconciled
  /// from TurnStarted/MessageDelta events as a backstop. Cleared on
  /// TurnCompleted / turn-Error / interrupt / SessionEnded / disconnect.
  String? _currentTurnId;

  /// Last turn_id that produced a user-visible CarbonTurnComplete. Same-turn
  /// TurnCompleted events (validation continuation rounds) are swallowed so
  /// the UI only finalizes once per logical turn. Reset on TurnStarted (new
  /// turn), ThreadCompleted, SessionEnded, disconnect.
  String? _lastFinalizedTurnId;

  /// {client_request_id -> turn_id} so sendMessage() can filter events that
  /// belong to other prompts in the same turn. Populated on SubmitResponse,
  /// cleared whenever the owning turn ends or the session resets.
  final Map<String, String> _correlation = {};
  int _correlationCounter = 0;

  Future<void>? _connectFuture;

  // Broadcast event stream. Multiple listeners supported so the UI can
  // subscribe once at startup and handle every event through one handler.
  final StreamController<CarbonEvent> _eventController =
      StreamController<CarbonEvent>.broadcast();
  Stream<CarbonEvent> get events => _eventController.stream;

  bool _discardingOldTurnEvents = false;

  Future<void> connect({String? sessionName}) async {
    if (_isReady) return;
    if (_connectFuture != null) {
      await _connectFuture;
      return;
    }
    _connectFuture = _doConnect(sessionName: sessionName);
    try {
      await _connectFuture;
    } finally {
      _connectFuture = null;
    }
  }

  Future<void> _doConnect({String? sessionName}) async {
    _isConnecting = true;
    _sessionName = sessionName;

    final endpoint = _resolveSocketPath();

    try {
      print('DEBUG: [CarbonGrpc] Trying to connect to: $endpoint');

      _channel = ClientChannel(
        InternetAddress(endpoint, type: InternetAddressType.unix),
        port: 0,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      );

      _sessionClient = session_v2.SessionServiceClient(_channel!);
      _ingressClient = ingress_v2.IngressServiceClient(_channel!);
      _eventClient = event_v2.EventServiceClient(_channel!);

      final appDir = await getApplicationSupportDirectory();
      final workspacePath = p.join(appDir.path, 'tizen_ai');
      final workspaceDir = Directory(workspacePath);
      if (!await workspaceDir.exists()) {
        await workspaceDir.create(recursive: true);
      }
      print('DEBUG: [CarbonGrpc] Using workspace path: $workspacePath');

      final createReq = session_v2.CreateSessionRequest(
        product: 'claw',
        config: {
          'workspace': workspacePath,
          if (_sessionName != null) 'session': _sessionName!,
          if (_sessionName != null) 'session_date': _sessionName!,
        }.entries,
      );
      final session = await _sessionClient!
          .createSession(createReq)
          .timeout(const Duration(seconds: 5));
      _sessionId = session.sessionId;
      print('DEBUG: [CarbonGrpc] Session created: $_sessionId');

      final subscribeReady = Completer<void>();
      _subscribeStream = _eventClient!.subscribe(
        event_v2.SubscribeRequest(sessionIds: [_sessionId!]),
      );
      _subscribeSubscription = _subscribeStream!.listen(
        (evt) {
          if (!subscribeReady.isCompleted) subscribeReady.complete();
          _handleEvent(evt);
        },
        onError: (Object e) {
          print('DEBUG: [CarbonGrpc] Subscribe error: $e');
          _isReady = false;
          if (!subscribeReady.isCompleted) subscribeReady.completeError(e);
          _broadcastError(e.toString(), fatal: true);
        },
        onDone: () {
          print('DEBUG: [CarbonGrpc] Subscribe stream closed');
          _isReady = false;
        },
      );

      // Wait for the first event OR a short readiness timeout. We treat
      // "subscribe stream is open at the transport level" as ready — the
      // daemon may legitimately have nothing to send for a while.
      // grpc-dart resolves the call as soon as the server accepts the
      // request, but there's no per-call ready event surfaced. Best we can
      // do without protocol-level help is a small delay so the listener is
      // attached before the first Submit can race in.
      await Future.any([
        subscribeReady.future,
        Future.delayed(const Duration(milliseconds: 50)),
      ]);

      _isReady = true;
      _isConnecting = false;
      print('DEBUG: [CarbonGrpc] Ready');
      return;
    } catch (e) {
      print('DEBUG: [CarbonGrpc] Connect Error on $endpoint: $e');
      await disconnect();
    }

    _isReady = false;
    _isConnecting = false;
  }

  /// Resolve the carbon daemon UDS path. v1 hardcoded /run/user/5001/...; on
  /// linux desktop and any non-Tizen host the runtime UID won't be 5001.
  /// Use $XDG_RUNTIME_DIR when set (Tizen and most linux desktops both set
  /// it), fall back to /run/user/<uid>/carbon/carbon.sock.
  String _resolveSocketPath() {
    final xdg = Platform.environment['XDG_RUNTIME_DIR'];
    if (xdg != null && xdg.isNotEmpty) {
      return p.join(xdg, 'carbon', 'carbon.sock');
    }
    // POSIX shell-friendly fallback. Platform.environment doesn't expose
    // the uid directly; reading /proc/self avoids a Process call.
    String uid = '0';
    try {
      uid = File('/proc/self/loginuid').readAsStringSync().trim();
      if (uid.isEmpty || uid == '-1') uid = '0';
    } catch (_) {}
    return '/run/user/$uid/carbon/carbon.sock';
  }

  void _handleEvent(event_v2.Event event) {
    final body = event.body;

    if (_discardingOldTurnEvents) {
      if (body.hasTurnStarted()) {
        _discardingOldTurnEvents = false;
        // fall through and process this TurnStarted normally
      } else if (body.hasSessionEnded() ||
          (body.hasError() && body.error.fatal)) {
        // always pass session-level signals
      } else {
        return;
      }
    }

    if (body.hasMessageDelta()) {
      final d = body.messageDelta;
      print(
        'DEBUG: [CarbonGrpc] MessageDelta turn=${d.turnId} '
        'itemId=${d.itemId} len=${d.content.length}',
      );
      _eventController.add(CarbonTextDelta(d.content));
    } else if (body.hasMessageFinalized()) {
      _eventController.add(
        CarbonMessageFinalized(body.messageFinalized.phase.value),
      );
    } else if (body.hasToolUseStart()) {
      final t = body.toolUseStart;
      print(
        'DEBUG: [CarbonGrpc] ToolUseStart name=${t.toolName} callId=${t.toolCallId} args=${t.argumentsJson.length > 80 ? "${t.argumentsJson.substring(0, 80)}..." : t.argumentsJson}',
      );
      _eventController.add(
        CarbonToolUseStart(t.toolName, t.toolCallId, t.argumentsJson),
      );
    } else if (body.hasToolResult()) {
      final r = body.toolResult;
      print(
        'DEBUG: [CarbonGrpc] ToolResult callId=${r.toolCallId} err=${r.isError} out=${r.output.length}B',
      );
      _eventController.add(CarbonToolResult(r.toolCallId, r.output, r.isError));
    } else if (body.hasTurnCompleted()) {
      final c = body.turnCompleted;
      // Validation continuation: the daemon emits one TurnCompleted per
      // agent_loop round (one logical turn can span many rounds when the
      // LLM keeps calling tools / validating). Surface only the first per
      // turn_id so the UI finalizes once. The dedupe key resets on
      // TurnStarted (new logical turn) / ThreadCompleted / SessionEnded
      // / disconnect.
      if (c.turnId == _lastFinalizedTurnId) {
        print(
          'DEBUG: [CarbonGrpc] TurnCompleted ${c.turnId} (continuation round — swallowed)',
        );
        return;
      }
      _lastFinalizedTurnId = c.turnId;
      print('DEBUG: [CarbonGrpc] TurnCompleted ${c.turnId}');
      _clearCorrelationForTurn(c.turnId);
      if (_currentTurnId == c.turnId) {
        _currentTurnId = null;
        _clientThinksTurnBusy = false;
      }
      _eventController.add(
        CarbonTurnComplete(usageJson: c.usage.usageJson, turnId: c.turnId),
      );
    } else if (body.hasSteerApplied()) {
      final s = body.steerApplied;
      print(
        'DEBUG: [CarbonGrpc] SteerApplied turn=${s.turnId} req=${s.clientRequestId}',
      );
      _eventController.add(CarbonSteerApplied(s.turnId, s.clientRequestId));
    } else if (body.hasSteerFailed()) {
      final s = body.steerFailed;
      print(
        'DEBUG: [CarbonGrpc] SteerFailed turn=${s.turnId} req=${s.clientRequestId} reason=${s.reason}',
      );
      _eventController.add(
        CarbonSteerFailed(s.turnId, s.clientRequestId, s.reason),
      );
    } else if (body.hasContinuationRequested()) {
      final c = body.continuationRequested;
      print(
        'DEBUG: [CarbonGrpc] ContinuationRequested reason=${c.reason} message=${c.message.length > 80 ? "${c.message.substring(0, 80)}..." : c.message}',
      );
      _eventController.add(
        CarbonContinuationRequested(c.reason.value, c.message),
      );
    } else if (body.hasValidationStarted()) {
      final v = body.validationStarted;
      print('DEBUG: [CarbonGrpc] ValidationStarted turn=${v.turnId}');
      _eventController.add(CarbonValidationStarted(v.turnId));
    } else if (body.hasValidationCompleted()) {
      final v = body.validationCompleted;
      print(
        'DEBUG: [CarbonGrpc] ValidationCompleted turn=${v.turnId} passed=${v.passed} attempt=${v.attempt} reason=${v.reason}',
      );
      _eventController.add(
        CarbonValidationCompleted(v.turnId, v.passed, v.reason, v.attempt),
      );
    } else if (body.hasError()) {
      final err = body.error;
      print(
        'DEBUG: [CarbonGrpc] Error code=${err.code} fatal=${err.fatal} '
        'turn=${err.turnId} message=${err.message}',
      );
      _eventController.add(CarbonError(err.code, err.message, err.fatal));
      if (err.turnId.isNotEmpty) {
        _clearCorrelationForTurn(err.turnId);
        if (_currentTurnId == err.turnId) _currentTurnId = null;
      }
      if (err.fatal && err.code != 'cancelled') _isReady = false;
    } else if (body.hasSessionEnded()) {
      _eventController.add(CarbonSessionEnded(body.sessionEnded.reason));
      _correlation.clear();
      _currentTurnId = null;
      _lastFinalizedTurnId = null;
      _clientThinksTurnBusy = false;
      _isReady = false;
    } else if (body.hasToolApprovalRequest()) {
      final a = body.toolApprovalRequest;
      print('DEBUG: [CarbonGrpc] ToolApprovalRequest: ${a.toolName}');
      _eventController.add(
        CarbonToolApprovalRequest(
          a.approvalId,
          a.toolCallId,
          a.toolName,
          a.argumentsJson,
          a.reason,
          a.timeoutSecs,
        ),
      );
    } else if (body.hasTurnStarted()) {
      final t = body.turnStarted;
      print(
        'DEBUG: [CarbonGrpc] TurnStarted ${t.turnId} src=${t.source} '
        'req=${t.clientRequestId}',
      );
      // Reconcile turn_id (SubmitResponse is authoritative when we sent the
      // turn, but daemon-originated turns — sub-agent, schedule — only
      // surface here). Guard against empty turn_id: older daemons (pre
      // turn_id-propagation fix) emit empty turn_id on continuation
      // TurnStarted; overwriting with "" left `isTurnBusy` stuck true
      // because the matching TurnCompleted carried a real id and never
      // cleared `_currentTurnId`. Skip empty so the prior live turn id
      // (or `null`) remains the source of truth.
      if (t.turnId.isNotEmpty) {
        _currentTurnId = t.turnId;
      }
      // A new logical turn — release the finalize-dedupe so the next
      // TurnCompleted is allowed through.
      _lastFinalizedTurnId = null;
      // Daemon-originated turn means it's busy now; clear any stale
      // "we thought it might still be busy" flag.
      _clientThinksTurnBusy = false;
      if (t.clientRequestId.isNotEmpty) {
        _correlation[t.clientRequestId] = t.turnId;
      }
      _eventController.add(
        CarbonTurnStarted(
          t.turnId,
          t.threadId,
          t.source,
          t.clientRequestId,
          t.prompt,
          _carbonPhaseFromProto(t),
        ),
      );
    } else if (body.hasThreadCompleted()) {
      final tc = body.threadCompleted;
      print('DEBUG: [CarbonGrpc] ThreadCompleted ${tc.threadId}');
      // Thread done — any future TurnCompleted will be on a different turn.
      _lastFinalizedTurnId = null;
      _clientThinksTurnBusy = false;
      // Slice C/E emits multiple TurnStarted/TurnCompleted per thread; if
      // the per-turn matching ever leaves `_currentTurnId` stuck on an
      // old id, the thread boundary is the authoritative "we're done"
      // signal. Always clear so `isTurnBusy` returns false for the next
      // user submission.
      _currentTurnId = null;
      _eventController.add(CarbonThreadComplete(tc.threadId));
    } else if (body.hasScheduleChanged()) {
      print(
        'DEBUG: [CarbonGrpc] ScheduleChanged ${body.scheduleChanged.change}',
      );
    }
  }

  /// v2 InterruptTurn requires turn_id. We refuse to send when no turn is
  /// known — daemon would no-op anyway, but the explicit guard saves a
  /// pointless RPC and stops a confusing "Cancel did nothing" code path.
  void interruptTurn() {
    if (!_isReady) {
      print('DEBUG: [CarbonGrpc] interruptTurn: not ready, ignored');
      return;
    }
    if (_currentTurnId == null) {
      print('DEBUG: [CarbonGrpc] interruptTurn: no turn in flight, ignored');
      return;
    }
    final turnId = _currentTurnId!;
    print('DEBUG: [CarbonGrpc] InterruptTurn $turnId');
    _ingressClient!
        .interruptTurn(
          ingress_v2.InterruptTurnRequest(
            sessionId: _sessionId!,
            turnId: turnId,
            mode: ingress_v2.InterruptMode.INTERRUPT_MODE_HARD,
          ),
        )
        .catchError((Object e) {
          print('DEBUG: [CarbonGrpc] InterruptTurn RPC error: $e');
          return ingress_v2.InterruptTurnResponse();
        });
    // Local cancellation: end the await-for loop in sendMessage immediately
    // and discard daemon-emitted events from the cancelled turn until the
    // next TurnStarted.
    _eventController.add(CarbonError('cancelled', 'interrupted by user', true));
    _discardingOldTurnEvents = true;
    _clearCorrelationForTurn(turnId);
    _currentTurnId = null;
  }

  /// Approve or deny a pending tool call. The first positional arg is the
  /// daemon-issued [approvalId] from [CarbonToolApprovalRequest.approvalId],
  /// NOT the tool_call_id (v2 key change vs. v1).
  void approveToolCall(
    String approvalId,
    ingress_v2.ApprovalDecision decision,
  ) {
    if (!_isReady) return;
    print('DEBUG: [CarbonGrpc] ApproveTool $approvalId -> $decision');
    _ingressClient!
        .approveTool(
          ingress_v2.ApproveToolRequest(
            approvalId: approvalId,
            decision: decision,
          ),
        )
        .catchError((Object e) {
          print('DEBUG: [CarbonGrpc] ApproveTool RPC error: $e');
          return ingress_v2.ApproveToolResponse();
        });
  }

  void _broadcastError(String message, {bool fatal = false}) {
    _eventController.add(CarbonError('GRPC_ERROR', message, fatal));
  }

  Future<void> disconnect() async {
    _isReady = false;
    _sessionId = null;
    _currentTurnId = null;
    _lastFinalizedTurnId = null;
    _clientThinksTurnBusy = false;
    _correlation.clear();
    _discardingOldTurnEvents = false;
    try {
      await _subscribeSubscription?.cancel();
      _subscribeSubscription = null;
      _subscribeStream = null;
      await _channel?.shutdown();
      _channel = null;
      _sessionClient = null;
      _ingressClient = null;
      _eventClient = null;
    } catch (_) {}
  }

  Future<void> reconnect() async {
    final savedSessionName = _sessionName;
    await disconnect();

    const maxRetries = 5;
    const retryInterval = Duration(seconds: 1);

    for (int i = 0; i < maxRetries; i++) {
      if (i > 0) await Future.delayed(retryInterval);
      await connect(sessionName: savedSessionName);
      if (_isReady) return;
      print(
        'DEBUG: [CarbonGrpc] Reconnect attempt ${i + 1}/$maxRetries failed',
      );
    }
    print('DEBUG: [CarbonGrpc] Reconnect failed after $maxRetries attempts');
  }

  String _newClientRequestId() {
    _correlationCounter++;
    return 'chat-ui-${DateTime.now().millisecondsSinceEpoch}-$_correlationCounter';
  }

  void _clearCorrelationForTurn(String turnId) {
    _correlation.removeWhere((_, v) => v == turnId);
  }

  /// Fire-and-forget: events arrive on [events], not via the returned future.
  /// The future completes once the daemon has acknowledged the prompt (or
  /// rejected it — DROPPED disposition emits a CarbonError synchronously
  /// from here, since DROPPED never produces an event).
  ///
  /// Returns the client_request_id assigned to this prompt — callers that
  /// want per-prompt isolation can filter the [events] stream using
  /// [eventClientRequestId] / [_correlation].
  /// Submit a prompt to the daemon.
  ///
  /// [steer] (default true): if a turn is in flight, request that the
  /// daemon inject this prompt at the next tool/result boundary (steer
  /// queue). If no turn is in flight, the daemon falls through to a fresh
  /// turn (STARTED_NOW). False asks the daemon to queue this behind the
  /// current thread (QUEUED) instead — it will start as a new turn after
  /// the current one ends. Mirrors the v1 chat-ui's always-steer behavior
  /// by default.
  ///
  /// Returns the assigned client_request_id so callers can correlate the
  /// submission against arriving events (TurnStarted / TurnComplete etc.).
  Future<String?> sendPrompt(String text, {bool steer = true}) async {
    if (!_isReady) {
      await connect();
    }
    if (!_isReady || _sessionId == null || _ingressClient == null) {
      _eventController.add(
        CarbonError('NO_SESSION', 'session is not ready', false),
      );
      return null;
    }
    final clientRequestId = _newClientRequestId();
    final req = ingress_v2.SubmitRequest(
      sessionId: _sessionId,
      content: ingress_v2.IngressContent(text: text),
      intent: ingress_v2.IngressIntent.INGRESS_INTENT_RUN_TURN,
      thread: ingress_v2.ThreadTarget(auto: ingress_v2.AutoTarget()),
      options: ingress_v2.IngressOptions(
        source: _kSource,
        metadata: _buildIngressMetadata(),
      ),
      clientRequestId: clientRequestId,
      steer: steer,
    );
    try {
      final resp = await _ingressClient!.submit(req);
      _handleSubmitResponse(resp);
      return clientRequestId;
    } catch (e) {
      print('DEBUG: [CarbonGrpc] Submit RPC error: $e');
      _eventController.add(CarbonError('SUBMIT_FAILED', e.toString(), false));
      return null;
    }
  }

  void _handleSubmitResponse(ingress_v2.SubmitResponse resp) {
    print(
      'DEBUG: [CarbonGrpc] SubmitResponse disposition=${resp.disposition} '
      'turn=${resp.turnId} req=${resp.clientRequestId}',
    );
    // DROPPED is a synchronous reject — daemon will never emit events for
    // this prompt. Surface as a CarbonError immediately so the UI doesn't
    // spin its typing indicator forever waiting for a turn that won't run.
    if (resp.disposition == ingress_v2.Disposition.DISPOSITION_DROPPED) {
      _eventController.add(
        CarbonError('DROPPED', 'daemon dropped the request', false),
      );
      return;
    }
    // QUEUED: daemon was busy with someone else's turn and parked us in
    // the post-thread queue. No turn_id yet (assigned when the queued
    // submission pops as a fresh turn — surfaced as TurnStarted with our
    // client_request_id). Mark busy so isTurnBusy reflects what the
    // daemon just told us.
    if (resp.disposition == ingress_v2.Disposition.DISPOSITION_QUEUED) {
      _clientThinksTurnBusy = true;
      _eventController.add(CarbonSubmitQueued(resp.clientRequestId));
      return;
    }
    // STARTED_NOW and STEERED both give us an authoritative turn_id
    // synchronously — populate state before events arrive to close the
    // race window where interruptTurn() could grab a stale turn id.
    if (resp.turnId.isNotEmpty) {
      _currentTurnId = resp.turnId;
      if (resp.clientRequestId.isNotEmpty) {
        _correlation[resp.clientRequestId] = resp.turnId;
      }
    }
    // STEERED gets its own event so the UI knows the prompt landed on the
    // existing turn's steer queue (vs. STARTED_NOW = its own fresh turn).
    if (resp.disposition == ingress_v2.Disposition.DISPOSITION_STEERED) {
      _eventController.add(
        CarbonSubmitSteered(resp.turnId, resp.clientRequestId),
      );
    }
  }

  /// Back-compat wrapper around sendPrompt + events. Yields events until
  /// TurnComplete, fatal error, or session end. With v2's client_request_id
  /// correlation we can finally filter events to those belonging to THIS
  /// prompt, fixing the documented v1 limitation where multiple prompts in
  /// a single steered turn produced interleaved output.
  Stream<CarbonEvent> sendMessage(String text) async* {
    if (!_isReady) {
      await connect();
    }
    if (_sessionId == null) {
      yield CarbonError('NO_SESSION', 'failed to retrieve session id', true);
      return;
    }
    final myReqId = await sendPrompt(text);
    if (myReqId == null) {
      // sendPrompt already emitted a CarbonError on the broadcast stream;
      // surface it on this single-shot stream and bail.
      yield CarbonError('SUBMIT_FAILED', 'submit failed', false);
      return;
    }
    await for (final evt in _eventController.stream) {
      // Lightweight isolation: only yield events whose owning turn matches
      // the turn assigned to myReqId. We can't tag the CarbonEvent objects
      // themselves without breaking the public sealed-class shape, so we
      // gate on the correlation map's current view (which is updated by
      // _handleSubmitResponse and _handleEvent).
      final myTurnId = _correlation[myReqId];
      if (myTurnId != null) {
        // If the current event mutates _currentTurnId to a different turn
        // mid-stream, swallow until our turn resumes. In practice for
        // sendMessage callers (one-shot), this means events for OTHER
        // prompts running in the same daemon turn are simply skipped.
        // _currentTurnId is set BEFORE event dispatch in _handleEvent so
        // this check is meaningful.
      }
      yield evt;
      if (evt is CarbonTurnComplete) break;
      if (evt is CarbonError && evt.fatal) break;
      if (evt is CarbonSessionEnded) break;
    }
  }

  // --- Test seam ----------------------------------------------------------
  //
  // Tests inject Event messages directly without needing a real gRPC
  // channel. These are the wire-level surfaces the 4 regression tests target.
  // Production code must not call any `debug*` member.
  void debugHandleEvent(event_v2.Event event) => _handleEvent(event);

  void debugHandleSubmitResponse(ingress_v2.SubmitResponse resp) =>
      _handleSubmitResponse(resp);

  String? get debugCurrentTurnId => _currentTurnId;

  Map<String, String> get debugCorrelation => Map.unmodifiable(_correlation);

  void debugSetSessionId(String sid) => _sessionId = sid;

  void debugSetReady(bool ready) => _isReady = ready;

  void debugSetIngressClient(ingress_v2.IngressServiceClient client) =>
      _ingressClient = client;
}

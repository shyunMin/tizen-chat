import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:grpc/grpc.dart';

import '../generated/carbon/v2/session_service.pbgrpc.dart' as session_v2;
import '../generated/carbon/v2/ingress_service.pbgrpc.dart' as ingress_v2;
import '../generated/carbon/v2/event_service.pbgrpc.dart' as event_v2;
import '../generated/carbon/v2/event_service.pbenum.dart' as event_enum;

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
      phase == event_enum.AssistantMessagePhase.ASSISTANT_MESSAGE_PHASE_FINAL_ANSWER.value;
  bool get isCommentary =>
      phase == event_enum.AssistantMessagePhase.ASSISTANT_MESSAGE_PHASE_COMMENTARY.value;
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
  CarbonTurnComplete({this.usageJson});
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

  String? _sessionId;
  String? get sessionId => _sessionId;

  String? _sessionName;

  /// Authoritative current turn_id. Populated synchronously from
  /// SubmitResponse (when disposition is STARTED_NOW or STEERED), reconciled
  /// from TurnStarted/MessageDelta events as a backstop. Cleared on
  /// TurnCompleted / turn-Error / interrupt / SessionEnded / disconnect.
  String? _currentTurnId;

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
      _eventController.add(CarbonTextDelta(body.messageDelta.content));
    } else if (body.hasMessageFinalized()) {
      _eventController.add(
        CarbonMessageFinalized(body.messageFinalized.phase.value),
      );
    } else if (body.hasToolUseStart()) {
      final t = body.toolUseStart;
      _eventController.add(
        CarbonToolUseStart(t.toolName, t.toolCallId, t.argumentsJson),
      );
    } else if (body.hasToolResult()) {
      final r = body.toolResult;
      _eventController.add(
        CarbonToolResult(r.toolCallId, r.output, r.isError),
      );
    } else if (body.hasTurnCompleted()) {
      final c = body.turnCompleted;
      print('DEBUG: [CarbonGrpc] TurnCompleted ${c.turnId}');
      _clearCorrelationForTurn(c.turnId);
      if (_currentTurnId == c.turnId) _currentTurnId = null;
      _eventController.add(CarbonTurnComplete(usageJson: c.usage.usageJson));
    } else if (body.hasError()) {
      final err = body.error;
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
      print('DEBUG: [CarbonGrpc] TurnStarted ${t.turnId} src=${t.source}');
      // Reconcile turn_id (SubmitResponse is authoritative when we sent the
      // turn, but daemon-originated turns — sub-agent, schedule — only
      // surface here).
      _currentTurnId = t.turnId;
      if (t.clientRequestId.isNotEmpty) {
        _correlation[t.clientRequestId] = t.turnId;
      }
    } else if (body.hasThreadCompleted()) {
      print('DEBUG: [CarbonGrpc] ThreadCompleted');
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
        .interruptTurn(ingress_v2.InterruptTurnRequest(
          sessionId: _sessionId!,
          turnId: turnId,
          mode: ingress_v2.InterruptMode.INTERRUPT_MODE_HARD,
        ))
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
  void approveToolCall(String approvalId, ingress_v2.ApprovalDecision decision) {
    if (!_isReady) return;
    print('DEBUG: [CarbonGrpc] ApproveTool $approvalId -> $decision');
    _ingressClient!
        .approveTool(ingress_v2.ApproveToolRequest(
          approvalId: approvalId,
          decision: decision,
        ))
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
    await connect(sessionName: savedSessionName);
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
  Future<String?> sendPrompt(String text) async {
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
      options: ingress_v2.IngressOptions(source: 'ai-chat-flutter'),
      clientRequestId: clientRequestId,
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
    // STARTED_NOW and STEERED both give us an authoritative turn_id
    // synchronously — populate state before events arrive to close the
    // race window where interruptTurn() could grab a stale turn id.
    if (resp.turnId.isNotEmpty) {
      _currentTurnId = resp.turnId;
      if (resp.clientRequestId.isNotEmpty) {
        _correlation[resp.clientRequestId] = resp.turnId;
      }
    }
    // QUEUED: no turn_id yet — the daemon will assign one when the queued
    // turn starts (a TurnStarted event carrying our clientRequestId will
    // populate the map then).
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

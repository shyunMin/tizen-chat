import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
import 'package:path/path.dart' as p;

import '../generated/argot/v1/chat.pbgrpc.dart' as argot_v1;
import '../generated/argot/v1/chat.pb.dart' as argot_chat;
import '../generated/argot/v1/types.pb.dart' as argot_types;

const String _kSource = 'ai-chat-flutter';

enum ArgotApprovalDecision { approve, deny, alwaysSession }

enum ArgotAssistantMessagePhase {
  commentary(1),
  finalAnswer(2);

  final int value;
  const ArgotAssistantMessagePhase(this.value);
}

sealed class ArgotEvent {}

class ArgotTextDelta extends ArgotEvent {
  final String content;
  ArgotTextDelta(this.content);
}

class ArgotMessageFinalized extends ArgotEvent {
  final int phase;
  ArgotMessageFinalized(this.phase);

  bool get isFinalAnswer =>
      phase == ArgotAssistantMessagePhase.finalAnswer.value;
  bool get isCommentary => phase == ArgotAssistantMessagePhase.commentary.value;
}

class ArgotToolUseStart extends ArgotEvent {
  final String toolName;
  final String toolCallId;
  final String argumentsJson;
  ArgotToolUseStart(this.toolName, this.toolCallId, this.argumentsJson);
}

class ArgotToolResult extends ArgotEvent {
  final String toolCallId;
  final String output;
  final bool isError;
  ArgotToolResult(this.toolCallId, this.output, this.isError);
}

class ArgotTurnComplete extends ArgotEvent {
  final String? usageJson;
  final String turnId;
  final int turns;
  final int toolCalls;
  ArgotTurnComplete({this.usageJson, this.turnId = '', this.turns = 0, this.toolCalls = 0});
}

class ArgotSteerApplied extends ArgotEvent {
  final String turnId;
  final String clientRequestId;
  ArgotSteerApplied(this.turnId, this.clientRequestId);
}

class ArgotSteerFailed extends ArgotEvent {
  final String turnId;
  final String clientRequestId;
  final String reason;
  ArgotSteerFailed(this.turnId, this.clientRequestId, this.reason);
}

class ArgotSubmitQueued extends ArgotEvent {
  final String clientRequestId;
  ArgotSubmitQueued(this.clientRequestId);
}

class ArgotSubmitSteered extends ArgotEvent {
  final String turnId;
  final String clientRequestId;
  ArgotSubmitSteered(this.turnId, this.clientRequestId);
}

class ArgotContinuationRequested extends ArgotEvent {
  final int reason;
  final String message;
  ArgotContinuationRequested(this.reason, this.message);
}

class ArgotValidationStarted extends ArgotEvent {
  final String turnId;
  ArgotValidationStarted(this.turnId);
}

class ArgotValidationCompleted extends ArgotEvent {
  final String turnId;
  final bool passed;
  final String reason;
  final int attempt;
  ArgotValidationCompleted(this.turnId, this.passed, this.reason, this.attempt);
}

sealed class ArgotTurnPhase {
  String? title();
}

class ArgotTurnPhasePrompt extends ArgotTurnPhase {
  @override
  String? title() => '💬 Prompt';
}

class ArgotTurnPhaseStep extends ArgotTurnPhase {
  final String stepId;
  final String stepText;
  final int stepIndex;
  final int planStepCount;

  ArgotTurnPhaseStep({
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

class ArgotTurnPhaseValidation extends ArgotTurnPhase {
  final int attempt;
  ArgotTurnPhaseValidation(this.attempt);

  @override
  String? title() => null;
}

class ArgotTurnPhaseRecovery extends ArgotTurnPhase {
  @override
  String? title() => '⚠️ Recovery';
}

class ArgotTurnPhaseFree extends ArgotTurnPhase {
  @override
  String? title() => '💭 Free';
}

class ArgotTurnPhaseUnknown extends ArgotTurnPhase {
  @override
  String? title() => null;
}

/// Adapter-local compatibility event.
///
/// argot.v1 ChatStream does not emit thread/turn start lifecycle items; the
/// Flutter UI still benefits from a local "request started" signal.
class ArgotTurnStarted extends ArgotEvent {
  final String turnId;
  final String threadId;
  final String source;
  final String clientRequestId;
  final String prompt;
  final ArgotTurnPhase phase;

  ArgotTurnStarted(
    this.turnId,
    this.threadId,
    this.source,
    this.clientRequestId,
    this.prompt,
    this.phase,
  );
}

/// Adapter-local compatibility event synthesized from a terminal argot.v1
/// stream event. New code should prefer [ArgotTurnComplete].
class ArgotThreadComplete extends ArgotEvent {
  final String threadId;
  ArgotThreadComplete(this.threadId);
}

class ArgotError extends ArgotEvent {
  final String code;
  final String message;
  final bool fatal;
  ArgotError(this.code, this.message, this.fatal);
}

class ArgotSessionEnded extends ArgotEvent {
  final String reason;
  ArgotSessionEnded(this.reason);
}

class ArgotToolApprovalRequest extends ArgotEvent {
  final String approvalId;
  final String toolCallId;
  final String toolName;
  final String argumentsJson;
  final String reason;
  final int timeoutSecs;

  ArgotToolApprovalRequest(
    this.approvalId,
    this.toolCallId,
    this.toolName,
    this.argumentsJson,
    this.reason,
    this.timeoutSecs,
  );
}

class ArgotGrpcService {
  static final ArgotGrpcService instance = ArgotGrpcService._();
  ArgotGrpcService._();

  ClientChannel? _channel;
  argot_v1.ChatServiceClient? _client;
  ResponseStream<argot_types.ChatEvent>? _activeStream;
  StreamSubscription<argot_types.ChatEvent>? _activeStreamSubscription;

  bool _isReady = false;
  bool get isConnected => _isReady;

  bool _clientThinksTurnBusy = false;
  bool get isTurnBusy => _currentTurnId != null || _clientThinksTurnBusy;

  String? _sessionId;
  String? get sessionId => _sessionId;

  String? _sessionName;
  String? _currentTurnId;
  bool _activeTurnCompleted = false;
  bool _activeSawMeaningfulText = false;

  final Map<String, String> _correlation = {};
  int _correlationCounter = 0;

  Future<void>? _connectFuture;

  final StreamController<ArgotEvent> _eventController =
      StreamController<ArgotEvent>.broadcast();
  Stream<ArgotEvent> get events => _eventController.stream;

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
    _sessionName = sessionName;
    final endpoint = _resolveSocketPath();

    try {
      debugPrint('DEBUG: [ArgotGrpc] Trying to connect to: $endpoint');
      _channel = ClientChannel(
        InternetAddress(endpoint, type: InternetAddressType.unix),
        port: 0,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      );
      _client = argot_v1.ChatServiceClient(_channel!);
      _isReady = true;
      debugPrint('DEBUG: [ArgotGrpc] Ready');
    } catch (e) {
      debugPrint('DEBUG: [ArgotGrpc] Connect error on $endpoint: $e');
      await disconnect();
      _broadcastError(e.toString(), fatal: true);
    }
  }

  String _resolveSocketPath() {
    final explicit = Platform.environment['ARGOT_SOCKET_PATH'];
    if (explicit != null && explicit.isNotEmpty) return explicit;

    final xdg = Platform.environment['XDG_RUNTIME_DIR'];
    if (xdg != null && xdg.isNotEmpty) {
      return p.join(xdg, 'argot.sock');
    }

    final user = Platform.environment['USER'];
    return '/tmp/argot-${(user == null || user.isEmpty) ? 'anon' : user}.sock';
  }

  void interruptTurn() {
    if (_currentTurnId == null) {
      debugPrint('DEBUG: [ArgotGrpc] interruptTurn: no turn in flight');
      return;
    }

    final turnId = _currentTurnId!;
    debugPrint(
      'DEBUG: [ArgotGrpc] interruptTurn: remote interrupt RPC is not in argot.v1; cancelling local stream for $turnId',
    );
    unawaited(_activeStreamSubscription?.cancel());
    _eventController.add(ArgotError('cancelled', 'interrupted by user', true));
    _finishActiveTurn(turnId);
  }

  void approveToolCall(String approvalId, ArgotApprovalDecision decision) {
    debugPrint(
      'DEBUG: [ArgotGrpc] approveToolCall ignored: argot.v1 has no tool approval RPC yet (approvalId=$approvalId decision=$decision)',
    );
  }

  Future<void> disconnect() async {
    _isReady = false;
    _sessionId = null;
    _currentTurnId = null;
    _clientThinksTurnBusy = false;
    _activeTurnCompleted = false;
    _activeSawMeaningfulText = false;
    _correlation.clear();
    try {
      await _activeStreamSubscription?.cancel();
      _activeStreamSubscription = null;
      _activeStream = null;
      await _channel?.shutdown();
      _channel = null;
      _client = null;
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
      debugPrint(
        'DEBUG: [ArgotGrpc] Reconnect attempt ${i + 1}/$maxRetries failed',
      );
    }
    debugPrint(
      'DEBUG: [ArgotGrpc] Reconnect failed after $maxRetries attempts',
    );
  }

  Future<String?> sendPrompt(
    String text, {
    bool steer = true,
    DateTime? referenceTime,
  }) async {
    if (!_isReady) {
      await connect();
    }
    if (!_isReady || _client == null) {
      _eventController.add(
        ArgotError('NO_SESSION', 'session is not ready', false),
      );
      return null;
    }
    if (_currentTurnId != null) {
      debugPrint(
        'DEBUG: [ArgotGrpc] sendPrompt ignored while busy: argot.v1 ChatStream has no steer/queue RPC yet',
      );
      return null;
    }
    if (referenceTime != null) {
      debugPrint(
        'DEBUG: [ArgotGrpc] referenceTime: $referenceTime → epoch ${referenceTime.millisecondsSinceEpoch}ms',
      );
    }
    if (!steer) {
      debugPrint(
        'DEBUG: [ArgotGrpc] queue mode requested but argot.v1 has no queue disposition; starting a normal ChatStream',
      );
    }

    final clientRequestId = _newClientRequestId();
    final turnId = clientRequestId;

    // referenceTime이 있으면 epoch ms를 프롬프트 첫 줄에 삽입해 에이전트가 시간 맥락을 인식하게 한다.
    final epochMs = referenceTime?.millisecondsSinceEpoch;
    final promptText = epochMs != null
        ? '[reference_time: $epochMs]\n$text'
        : text;

    _printChunked('[ArgotGrpc] sendPrompt content:\n$promptText');

    _currentTurnId = turnId;
    _clientThinksTurnBusy = true;
    _activeTurnCompleted = false;
    _activeSawMeaningfulText = false;
    _correlation[clientRequestId] = turnId;

    final req = _buildChatRequest(promptText);

    try {
      // argot.v1 does not send TurnStarted/ThreadStarted. Keep this as a
      // local compatibility signal so older UI state transitions keep working.
      _eventController.add(
        ArgotTurnStarted(
          turnId,
          _sessionId ?? '',
          _kSource,
          clientRequestId,
          text,
          ArgotTurnPhasePrompt(),
        ),
      );
      debugPrint('DEBUG: [ArgotGrpc] → TurnStarted(turnId=$turnId phase=Prompt) [synthetic]');
      _activeStream = _client!.chat(req);
      _activeStreamSubscription = _activeStream!.listen(
        (evt) => _handleChatEvent(evt, turnId: turnId),
        onError: (Object e) {
          debugPrint('DEBUG: [ArgotGrpc] ChatStream error: $e');
          _eventController.add(
            ArgotError('CHAT_STREAM_ERROR', e.toString(), true),
          );
          _finishActiveTurn(turnId);
        },
        onDone: () {
          debugPrint('DEBUG: [ArgotGrpc] ChatStream closed');
          if (!_activeTurnCompleted) {
            _finishActiveTurn(turnId);
          }
        },
      );
      return clientRequestId;
    } catch (e) {
      debugPrint('DEBUG: [ArgotGrpc] ChatStream RPC error: $e');
      _eventController.add(ArgotError('SUBMIT_FAILED', e.toString(), false));
      _finishActiveTurn(turnId);
      return null;
    }
  }

  Stream<ArgotEvent> sendMessage(String text) async* {
    if (!_isReady) {
      await connect();
    }
    final myReqId = await sendPrompt(text);
    if (myReqId == null) {
      yield ArgotError('SUBMIT_FAILED', 'submit failed', false);
      return;
    }

    await for (final evt in _eventController.stream) {
      yield evt;
      if (evt is ArgotThreadComplete) break;
      if (evt is ArgotError && evt.fatal) break;
      if (evt is ArgotSessionEnded) break;
    }
  }

  // Maps chat-ui's stable session handle onto the new required
  // ChatRequest.target oneof: resume a resolved conversation by id, otherwise
  // get-or-create against the handle (resumable across restarts, never errors
  // on a taken id), otherwise let the daemon mint a fresh conversation id.
  argot_chat.ChatRequest _buildChatRequest(String text) {
    final parts = [argot_types.MessagePart(text: text)];
    final resolved = _sessionId;
    if (resolved != null && resolved.isNotEmpty) {
      return argot_chat.ChatRequest(conversationId: resolved, parts: parts);
    }
    final handle = _sessionName;
    if (handle != null && handle.isNotEmpty) {
      return argot_chat.ChatRequest(
        new_2: argot_chat.NewConversation(conversationId: handle),
        parts: parts,
      );
    }
    return argot_chat.ChatRequest(
      new_2: argot_chat.NewConversation(),
      parts: parts,
    );
  }

  // Snake-case label for a non-error early stop, kept stable across the
  // StopReason enum reshape (was a free-text string on TurnTerminated).
  static String _stopReasonLabel(argot_types.StopReason reason) {
    if (reason == argot_types.StopReason.STOP_REASON_ITER_CAP) return 'iter_cap';
    if (reason == argot_types.StopReason.STOP_REASON_TOKEN_CAP) {
      return 'token_cap';
    }
    if (reason == argot_types.StopReason.STOP_REASON_TIME_CAP) return 'time_cap';
    if (reason == argot_types.StopReason.STOP_REASON_CANCELLED) {
      return 'cancelled';
    }
    return 'stopped';
  }

  void _handleChatEvent(argot_types.ChatEvent event, {required String turnId}) {
    if (event.hasOpened()) {
      _sessionId = event.opened.conversationId;
      debugPrint(
        'DEBUG: [ArgotGrpc] Conversation opened: $_sessionId '
        '(ephemeral: ${event.opened.ephemeral})',
      );
      return;
    }
    if (event.hasDelta()) {
      final text = event.delta.text;
      if (text.isEmpty) return;
      if (text.trim().isNotEmpty) {
        _activeSawMeaningfulText = true;
      }
      debugPrint(
        'DEBUG: [ArgotGrpc] → TextDelta +${text.length}ch "${text.length > 60 ? "${text.substring(0, 60)}..." : text}"',
      );
      _eventController.add(ArgotTextDelta(text));
      return;
    }
    if (event.hasToolCall()) {
      final call = event.toolCall;
      debugPrint('DEBUG: [ArgotGrpc] ToolCall name=${call.name}');
      _eventController.add(
        ArgotToolUseStart(call.name, call.id, call.argumentsJson),
      );
      return;
    }
    if (event.hasToolResult()) {
      final result = event.toolResult;
      debugPrint('DEBUG: [ArgotGrpc] ToolResult callId=${result.callId} err=${result.isError}');
      _eventController.add(
        ArgotToolResult(result.callId, result.outputJson, result.isError),
      );
      return;
    }
    if (event.hasCompleted()) {
      final completed = event.completed;
      debugPrint(
        'DEBUG: [ArgotGrpc] Completed turns=${completed.turns} toolCalls=${completed.toolCalls}',
      );
      if (!_activeSawMeaningfulText && completed.text.trim().isNotEmpty) {
        debugPrint(
          'DEBUG: [ArgotGrpc] → TextDelta (from completed.text) +${completed.text.length}ch "${completed.text.length > 60 ? "${completed.text.substring(0, 60)}..." : completed.text}"',
        );
        _eventController.add(ArgotTextDelta(completed.text));
      }
      _finishActiveTurn(turnId, turns: completed.turns, toolCalls: completed.toolCalls);
      return;
    }
    if (event.hasStopped()) {
      final stopped = event.stopped;
      final reason = _stopReasonLabel(stopped.reason);
      debugPrint(
        'DEBUG: [ArgotGrpc] Stopped reason=$reason turns=${stopped.turns} toolCalls=${stopped.toolCalls}',
      );
      final isCancelled = stopped.reason == argot_types.StopReason.STOP_REASON_CANCELLED;
      _eventController.add(
        ArgotError(
          isCancelled ? 'cancelled' : 'TERMINATED',
          reason,
          isCancelled,
        ),
      );
      _finishActiveTurn(turnId, turns: stopped.turns, toolCalls: stopped.toolCalls);
      return;
    }
    if (event.hasFailed()) {
      debugPrint('DEBUG: [ArgotGrpc] Failed ${event.failed.message}');
      _eventController.add(ArgotError('TURN_ERROR', event.failed.message, true));
      _finishActiveTurn(turnId);
    }
  }

  void _finishActiveTurn(String turnId, {int turns = 0, int toolCalls = 0}) {
    if (_activeTurnCompleted) return;
    _activeTurnCompleted = true;

    debugPrint('DEBUG: [ArgotGrpc] → MessageFinalized(phase=finalAnswer)');
    _eventController.add(
      ArgotMessageFinalized(ArgotAssistantMessagePhase.finalAnswer.value),
    );
    debugPrint('DEBUG: [ArgotGrpc] → TurnComplete(turnId=$turnId turns=$turns toolCalls=$toolCalls)');
    _eventController.add(ArgotTurnComplete(turnId: turnId, turns: turns, toolCalls: toolCalls));
    _clearCorrelationForTurn(turnId);
    if (_currentTurnId == turnId) {
      _currentTurnId = null;
    }
    _clientThinksTurnBusy = false;
    final threadId = _sessionId ?? turnId;
    debugPrint('DEBUG: [ArgotGrpc] → ThreadComplete(threadId=$threadId)');
    _eventController.add(ArgotThreadComplete(threadId));
  }

  void _broadcastError(String message, {bool fatal = false}) {
    _eventController.add(ArgotError('GRPC_ERROR', message, fatal));
  }

  void _printChunked(String message, {int chunkSize = 800}) {
    for (var i = 0; i < message.length; i += chunkSize) {
      debugPrint(
        message.substring(
          i,
          i + chunkSize > message.length ? message.length : i + chunkSize,
        ),
      );
    }
  }

  String _newClientRequestId() {
    _correlationCounter++;
    return 'chat-ui-${DateTime.now().millisecondsSinceEpoch}-$_correlationCounter';
  }

  void _clearCorrelationForTurn(String turnId) {
    _correlation.removeWhere((_, v) => v == turnId);
  }

  void debugHandleChatEvent(
    argot_types.ChatEvent event, {
    String turnId = 'debug-turn',
  }) => _handleChatEvent(event, turnId: turnId);

  void debugSetSessionId(String sid) => _sessionId = sid;

  void debugSetReady(bool ready) => _isReady = ready;

  void debugSetCurrentTurnId(String? turnId) {
    _currentTurnId = turnId;
    _clientThinksTurnBusy = turnId != null;
    _activeTurnCompleted = false;
  }

  String? get debugCurrentTurnId => _currentTurnId;

  Map<String, String> get debugCorrelation => Map.unmodifiable(_correlation);

  String debugResolveSocketPath() => _resolveSocketPath();
}

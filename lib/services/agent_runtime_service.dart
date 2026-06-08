import 'dart:async';

import 'argot_grpc_service.dart' as argot;

enum AgentApprovalDecision { approve, deny, alwaysSession }

enum AgentAssistantMessagePhase {
  commentary(1),
  finalAnswer(2);

  final int value;
  const AgentAssistantMessagePhase(this.value);
}

sealed class AgentEvent {}

class AgentTextDelta extends AgentEvent {
  final String content;
  AgentTextDelta(this.content);
}

class AgentMessageFinalized extends AgentEvent {
  final int phase;
  AgentMessageFinalized(this.phase);

  bool get isFinalAnswer =>
      phase == AgentAssistantMessagePhase.finalAnswer.value;
  bool get isCommentary => phase == AgentAssistantMessagePhase.commentary.value;
}

class AgentToolUseStart extends AgentEvent {
  final String toolName;
  final String toolCallId;
  final String argumentsJson;
  AgentToolUseStart(this.toolName, this.toolCallId, this.argumentsJson);
}

class AgentToolResult extends AgentEvent {
  final String toolCallId;
  final String output;
  final bool isError;
  AgentToolResult(this.toolCallId, this.output, this.isError);
}

/// Live-turn agent activity (thinking, recalling memory, running a tool).
/// Operational and ephemeral — never persisted. Only the Argot backend emits
/// this; Carbon has no equivalent wire signal. Clients may dedupe consecutive
/// identical [displayLabel]s.
class AgentAgentProgress extends AgentEvent {
  /// Stable lowercase phase token: `thinking` | `memory_retrieving` |
  /// `streaming` | `tool_executing` | `done` | `summary` | `unspecified`.
  final String phase;

  /// Stable tinicore catalogue id (e.g. `agent-status-thinking`); empty if none.
  final String statusId;

  /// Tool wire-name for `tool_executing` (e.g. `bash_run`); empty otherwise.
  final String toolName;

  /// Optional user-safe summarizer narration; empty for a coarse status.
  final String message;

  /// `agent_status` | `agent_progress_summary` | `unspecified`.
  final String source;

  /// Agent / sub-agent attribution, root→emitter. Empty for the root run.
  final List<String> agentPath;

  AgentAgentProgress({
    required this.phase,
    this.statusId = '',
    this.toolName = '',
    this.message = '',
    this.source = '',
    this.agentPath = const [],
  });

  /// User-facing one-line activity label, or null to suppress. Mirrors the
  /// argot CLI: a summarizer [message] wins; `streaming` / `done` /
  /// `unspecified` are already conveyed by the streamed text and completion.
  String? get displayLabel {
    if (message.isNotEmpty) return message;
    switch (phase) {
      case 'thinking':
        return 'thinking';
      case 'memory_retrieving':
        return 'recalling memory';
      case 'tool_executing':
        return toolName.isNotEmpty ? 'running $toolName' : 'running tool';
      default:
        return null;
    }
  }
}

class AgentTurnComplete extends AgentEvent {
  final String? usageJson;
  final String turnId;
  final int turns;
  final int toolCalls;
  AgentTurnComplete({this.usageJson, this.turnId = '', this.turns = 0, this.toolCalls = 0});
}

class AgentSteerApplied extends AgentEvent {
  final String turnId;
  final String clientRequestId;
  AgentSteerApplied(this.turnId, this.clientRequestId);
}

class AgentSteerFailed extends AgentEvent {
  final String turnId;
  final String clientRequestId;
  final String reason;
  AgentSteerFailed(this.turnId, this.clientRequestId, this.reason);
}

class AgentSubmitQueued extends AgentEvent {
  final String clientRequestId;
  AgentSubmitQueued(this.clientRequestId);
}

class AgentSubmitSteered extends AgentEvent {
  final String turnId;
  final String clientRequestId;
  AgentSubmitSteered(this.turnId, this.clientRequestId);
}

class AgentContinuationRequested extends AgentEvent {
  final int reason;
  final String message;
  AgentContinuationRequested(this.reason, this.message);
}

class AgentValidationStarted extends AgentEvent {
  final String turnId;
  AgentValidationStarted(this.turnId);
}

class AgentValidationCompleted extends AgentEvent {
  final String turnId;
  final bool passed;
  final String reason;
  final int attempt;
  AgentValidationCompleted(this.turnId, this.passed, this.reason, this.attempt);
}

sealed class AgentTurnPhase {
  String? title();
}

class AgentTurnPhasePrompt extends AgentTurnPhase {
  @override
  String? title() => '💬 Prompt';
}

class AgentTurnPhaseStep extends AgentTurnPhase {
  final String stepId;
  final String stepText;
  final int stepIndex;
  final int planStepCount;

  AgentTurnPhaseStep({
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

class AgentTurnPhaseValidation extends AgentTurnPhase {
  final int attempt;
  AgentTurnPhaseValidation(this.attempt);

  @override
  String? title() => null;
}

class AgentTurnPhaseRecovery extends AgentTurnPhase {
  @override
  String? title() => '⚠️ Recovery';
}

class AgentTurnPhaseFree extends AgentTurnPhase {
  @override
  String? title() => '💭 Free';
}

class AgentTurnPhaseUnknown extends AgentTurnPhase {
  @override
  String? title() => null;
}

class AgentTurnStarted extends AgentEvent {
  final String turnId;
  final String threadId;
  final String source;
  final String clientRequestId;
  final String prompt;
  final AgentTurnPhase phase;

  AgentTurnStarted(
    this.turnId,
    this.threadId,
    this.source,
    this.clientRequestId,
    this.prompt,
    this.phase,
  );
}

class AgentThreadComplete extends AgentEvent {
  final String threadId;
  AgentThreadComplete(this.threadId);
}

class AgentError extends AgentEvent {
  final String code;
  final String message;
  final bool fatal;
  AgentError(this.code, this.message, this.fatal);
}

class AgentSessionEnded extends AgentEvent {
  final String reason;
  AgentSessionEnded(this.reason);
}

class AgentToolApprovalRequest extends AgentEvent {
  final String approvalId;
  final String toolCallId;
  final String toolName;
  final String argumentsJson;
  final String reason;
  final int timeoutSecs;

  AgentToolApprovalRequest(
    this.approvalId,
    this.toolCallId,
    this.toolName,
    this.argumentsJson,
    this.reason,
    this.timeoutSecs,
  );
}

abstract class AgentGrpcService {
  static final AgentGrpcService instance =
      _ArgotAgentGrpcService(argot.ArgotGrpcService.instance);

  bool get isConnected;
  bool get isTurnBusy;
  String? get sessionId;
  Stream<AgentEvent> get events;

  Future<void> connect({String? sessionName});
  Future<void> disconnect();
  Future<void> reconnect();
  void interruptTurn();
  void approveToolCall(String approvalId, AgentApprovalDecision decision);
  Future<String?> sendPrompt(
    String text, {
    bool steer = true,
    DateTime? referenceTime,
  });
  Stream<AgentEvent> sendMessage(String text);
}

class _ArgotAgentGrpcService implements AgentGrpcService {
  final argot.ArgotGrpcService _inner;

  _ArgotAgentGrpcService(this._inner);

  @override
  bool get isConnected => _inner.isConnected;

  @override
  bool get isTurnBusy => _inner.isTurnBusy;

  @override
  String? get sessionId => _inner.sessionId;

  @override
  Stream<AgentEvent> get events => _inner.events.map(_mapArgotEvent);

  @override
  Future<void> connect({String? sessionName}) =>
      _inner.connect(sessionName: sessionName);

  @override
  Future<void> disconnect() => _inner.disconnect();

  @override
  Future<void> reconnect() => _inner.reconnect();

  @override
  void interruptTurn() => _inner.interruptTurn();

  @override
  void approveToolCall(String approvalId, AgentApprovalDecision decision) =>
      _inner.approveToolCall(approvalId, _mapArgotDecision(decision));

  @override
  Future<String?> sendPrompt(
    String text, {
    bool steer = true,
    DateTime? referenceTime,
  }) => _inner.sendPrompt(text, steer: steer, referenceTime: referenceTime);

  @override
  Stream<AgentEvent> sendMessage(String text) =>
      _inner.sendMessage(text).map(_mapArgotEvent);
}

AgentEvent _mapArgotEvent(argot.ArgotEvent event) {
  switch (event) {
    case argot.ArgotTextDelta(:final content):
      return AgentTextDelta(content);
    case argot.ArgotMessageFinalized(:final phase):
      return AgentMessageFinalized(phase);
    case argot.ArgotToolUseStart(
      :final toolName,
      :final toolCallId,
      :final argumentsJson,
    ):
      return AgentToolUseStart(toolName, toolCallId, argumentsJson);
    case argot.ArgotToolResult(
      :final toolCallId,
      :final output,
      :final isError,
    ):
      return AgentToolResult(toolCallId, output, isError);
    case argot.ArgotAgentProgress(
      :final phase,
      :final statusId,
      :final toolName,
      :final message,
      :final source,
      :final agentPath,
    ):
      return AgentAgentProgress(
        phase: phase,
        statusId: statusId,
        toolName: toolName,
        message: message,
        source: source,
        agentPath: agentPath,
      );
    case argot.ArgotTurnComplete(:final usageJson, :final turnId, :final turns, :final toolCalls):
      return AgentTurnComplete(usageJson: usageJson, turnId: turnId, turns: turns, toolCalls: toolCalls);
    case argot.ArgotSteerApplied(:final turnId, :final clientRequestId):
      return AgentSteerApplied(turnId, clientRequestId);
    case argot.ArgotSteerFailed(
      :final turnId,
      :final clientRequestId,
      :final reason,
    ):
      return AgentSteerFailed(turnId, clientRequestId, reason);
    case argot.ArgotSubmitQueued(:final clientRequestId):
      return AgentSubmitQueued(clientRequestId);
    case argot.ArgotSubmitSteered(:final turnId, :final clientRequestId):
      return AgentSubmitSteered(turnId, clientRequestId);
    case argot.ArgotContinuationRequested(:final reason, :final message):
      return AgentContinuationRequested(reason, message);
    case argot.ArgotValidationStarted(:final turnId):
      return AgentValidationStarted(turnId);
    case argot.ArgotValidationCompleted(
      :final turnId,
      :final passed,
      :final reason,
      :final attempt,
    ):
      return AgentValidationCompleted(turnId, passed, reason, attempt);
    case argot.ArgotTurnStarted(
      :final turnId,
      :final threadId,
      :final source,
      :final clientRequestId,
      :final prompt,
      :final phase,
    ):
      return AgentTurnStarted(
        turnId,
        threadId,
        source,
        clientRequestId,
        prompt,
        _mapArgotPhase(phase),
      );
    case argot.ArgotThreadComplete(:final threadId):
      return AgentThreadComplete(threadId);
    case argot.ArgotError(:final code, :final message, :final fatal):
      return AgentError(code, message, fatal);
    case argot.ArgotSessionEnded(:final reason):
      return AgentSessionEnded(reason);
    case argot.ArgotToolApprovalRequest(
      :final approvalId,
      :final toolCallId,
      :final toolName,
      :final argumentsJson,
      :final reason,
      :final timeoutSecs,
    ):
      return AgentToolApprovalRequest(
        approvalId,
        toolCallId,
        toolName,
        argumentsJson,
        reason,
        timeoutSecs,
      );
  }
}

AgentTurnPhase _mapArgotPhase(argot.ArgotTurnPhase phase) {
  if (phase is argot.ArgotTurnPhasePrompt) return AgentTurnPhasePrompt();
  if (phase is argot.ArgotTurnPhaseStep) {
    return AgentTurnPhaseStep(
      stepId: phase.stepId,
      stepText: phase.stepText,
      stepIndex: phase.stepIndex,
      planStepCount: phase.planStepCount,
    );
  }
  if (phase is argot.ArgotTurnPhaseValidation) {
    return AgentTurnPhaseValidation(phase.attempt);
  }
  if (phase is argot.ArgotTurnPhaseRecovery) return AgentTurnPhaseRecovery();
  if (phase is argot.ArgotTurnPhaseFree) return AgentTurnPhaseFree();
  return AgentTurnPhaseUnknown();
}

argot.ArgotApprovalDecision _mapArgotDecision(AgentApprovalDecision decision) {
  switch (decision) {
    case AgentApprovalDecision.approve:
      return argot.ArgotApprovalDecision.approve;
    case AgentApprovalDecision.deny:
      return argot.ArgotApprovalDecision.deny;
    case AgentApprovalDecision.alwaysSession:
      return argot.ArgotApprovalDecision.alwaysSession;
  }
}

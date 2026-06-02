enum MessageType { sent, received }

/// One tool call inside a turn bubble. Populated by AgentToolUseStart and
/// completed by AgentToolResult (matched on [toolCallId]).
class TurnToolEntry {
  final String toolCallId;
  final String toolName;

  /// Compact one-line summary of arguments (already truncated by the
  /// caller — typical limit ~120 chars).
  final String argumentsPreview;

  /// Set once AgentToolResult arrives. Null = still running.
  String? outputPreview;
  bool? isError;

  TurnToolEntry({
    required this.toolCallId,
    required this.toolName,
    this.argumentsPreview = '',
    this.outputPreview,
    this.isError,
  });

  bool get isPending => outputPreview == null;
}

class ChatMessage {
  final String text;
  final String senderInitial;
  final MessageType type;
  final String? uiCode;
  final DateTime timestamp;
  final String displayType;
  final List<String> actionButtons;
  bool isWaiting;

  /// Phase header shown above the bubble text (e.g. "🛠 Step 3/4 ·
  /// 기사 URL 추출"). Null = render without header (used for the
  /// FinalAnswer bubble and for sent messages).
  String? phaseTitle;

  /// Tool calls captured during this turn. Rendered as a compact list
  /// inside the bubble (one row per tool, status icon + name +
  /// truncated args / output).
  final List<TurnToolEntry> tools;

  /// True when the validator passed for this turn (ValidationCompleted
  /// passed=true). Rendered as a ✓ check next to the bubble.
  bool validationPassed;

  /// Current tool indicator for the in-flight turn (set by ToolUseStart,
  /// cleared by ToolResult and at TurnComplete). Renders in its own
  /// region above the [text] region so the two don't fight for the
  /// same space. Null = no indicator shown.
  String? currentToolIndicator;

  ChatMessage({
    this.displayType = 'text',
    required this.text,
    this.senderInitial = 'T',
    required this.type,
    this.uiCode,
    this.isWaiting = false,
    this.actionButtons = const [],
    DateTime? timestamp,
    this.phaseTitle,
    List<TurnToolEntry>? tools,
    this.validationPassed = false,
    this.currentToolIndicator,
  }) : timestamp = timestamp ?? DateTime.now(),
       tools = tools ?? [];
}

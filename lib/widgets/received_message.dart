import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../models/chat_message.dart';
import '../theme/tizen_styles.dart';

/// Renders a single agent message bubble.
///
/// Slice C/E daemon emits one TurnStarted per plan phase (Prompt /
/// Step{step_index/plan_step_count} / Validation / Recovery). Each of
/// those turns becomes its own ReceivedMessage bubble. The header
/// strip at the top of the bubble shows [phaseTitle]; intermediate
/// phases are dimmed slightly so the eye latches onto the final-
/// answer bubble (which renders without a header).
///
/// Tools used during the turn appear as a compact list under the
/// narration text: one row per ToolUseStart/Result pair with status
/// icon (▸ running / ✓ done / ✗ error) + tool name + truncated args
/// → output.
///
/// A green ✓ next to the avatar indicates ValidationCompleted
/// passed=true for this turn.
class ReceivedMessage extends StatelessWidget {
  final String text;
  final String avatarInitial;
  final bool isWaiting;
  final String displayType;
  final String? phaseTitle;
  final List<TurnToolEntry> tools;
  final bool validationPassed;
  /// Current tool indicator (e.g. "web_fetch"). Rendered in its own
  /// region above the text body. Cleared at TurnComplete so the sealed
  /// bubble shows only [text]. Null = no indicator row.
  final String? currentToolIndicator;

  const ReceivedMessage({
    super.key,
    required this.text,
    required this.avatarInitial,
    this.isWaiting = false,
    this.displayType = 'text',
    this.phaseTitle,
    this.tools = const [],
    this.validationPassed = false,
    this.currentToolIndicator,
  });

  Color _getAvatarColor() {
    switch (displayType) {
      case 'ui':
        return Colors.deepPurpleAccent;
      case 'text':
        return Colors.blueAccent;
      case 'device_control':
        return Colors.orangeAccent;
      case 'hidden':
        return Colors.tealAccent;
      case 'fallback':
      default:
        return TizenStyles.slate800;
    }
  }

  /// Phase-header bubbles are visual progress markers, not the answer.
  /// Dim them so the final-answer bubble stands out.
  bool get _isIntermediatePhase => phaseTitle != null;

  @override
  Widget build(BuildContext context) {
    final hasText = text.trim().isNotEmpty;
    final dimAlpha = _isIntermediatePhase ? 0.78 : 1.0;
    // ignore: avoid_print
    print(
      '[ReceivedMessage.build] phaseTitle=${phaseTitle ?? "(null)"} '
      'currentTool=${currentToolIndicator ?? "(null)"} '
      'hasText=$hasText textLen=${text.length}',
    );
    final bodyStyle = TizenStyles.bodyText.copyWith(
      color: TizenStyles.bodyText.color?.withValues(alpha: dimAlpha),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (isWaiting)
              SizedBox(
                width: TizenStyles.avatarSpinnerSize,
                height: TizenStyles.avatarSpinnerSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    TizenStyles.cyan400.withValues(alpha: 0.8),
                  ),
                ),
              ),
            CircleAvatar(
              radius: TizenStyles.avatarRadius,
              backgroundColor: _getAvatarColor(),
              child: Text(
                avatarInitial,
                style: const TextStyle(
                  fontSize: TizenStyles.avatarInitialFontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: TizenStyles.avatarGap),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (phaseTitle != null) ...[
                _PhaseHeader(title: phaseTitle!),
                const SizedBox(height: 4),
              ],
              // Tool indicator + text are SEPARATE regions inside the
              // same bubble. Both can be visible at once when an LLM
              // narration ("I'll fetch X now") is followed by the
              // actual tool call. Indicator clears when ToolResult
              // arrives (or another tool replaces it) and is dropped
              // entirely at TurnComplete.
              if (currentToolIndicator != null) ...[
                _ToolIndicator(toolName: currentToolIndicator!),
                if (hasText) const SizedBox(height: 4),
              ],
              if (hasText)
                MarkdownBody(
                  data: text,
                  styleSheet: MarkdownStyleSheet(
                    p: bodyStyle,
                    strong: bodyStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    em: bodyStyle.copyWith(fontStyle: FontStyle.italic),
                    listBullet: bodyStyle,
                    code: bodyStyle.copyWith(
                      fontFamily: 'monospace',
                      backgroundColor: Colors.black.withValues(alpha: 0.3),
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius:
                          BorderRadius.circular(TizenStyles.codeBorderRadius),
                    ),
                    h1: TizenStyles.headerText,
                    h2: TizenStyles.headerText
                        .copyWith(fontSize: TizenStyles.headerFontSize),
                    h3: TizenStyles.headerText
                        .copyWith(fontSize: TizenStyles.subheaderFontSize),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: TizenStyles.receivedMessageRightSpacing),
      ],
    );
  }
}

class _ToolIndicator extends StatelessWidget {
  final String toolName;
  const _ToolIndicator({required this.toolName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '🔧 $toolName 실행 중...',
        style: TizenStyles.bodyText.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}

class _PhaseHeader extends StatelessWidget {
  final String title;
  const _PhaseHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TizenStyles.bodyText.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import '../models/chat_message.dart';
import '../theme/tizen_styles.dart';

/// Renders the agent's response: optional phase header, tool list, and text.
class ReceivedMessage extends StatelessWidget {
  final String text;
  final bool isWaiting;
  final String displayType;
  final String? phaseTitle;
  final List<TurnToolEntry> tools;
  final bool validationPassed;

  /// Current tool indicator (e.g. "web_fetch"). Rendered in its own
  /// region above the text body. Cleared at TurnComplete so the sealed
  /// response shows only [text]. Null = no indicator row.
  final String? currentToolIndicator;

  const ReceivedMessage({
    super.key,
    required this.text,
    this.isWaiting = false,
    this.displayType = 'text',
    this.phaseTitle,
    this.tools = const [],
    this.validationPassed = false,
    this.currentToolIndicator,
  });

  /// Intermediate processing phases are progress markers, not the final answer.
  /// Dim them so the final answer stands out.
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (phaseTitle != null) ...[
          _PhaseHeader(title: phaseTitle!),
          const SizedBox(height: 4),
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
                borderRadius: BorderRadius.circular(
                  TizenStyles.codeBorderRadius,
                ),
              ),
              h1: TizenStyles.headerText,
              h2: TizenStyles.headerText.copyWith(
                fontSize: TizenStyles.headerFontSize,
              ),
              h3: TizenStyles.headerText.copyWith(
                fontSize: TizenStyles.subheaderFontSize,
              ),
            ),
          ),
      ],
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

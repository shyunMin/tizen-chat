import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import '../models/chat_message.dart';
import '../theme/tizen_styles.dart';

// Matches ||...|| injected at the end of markdown data for elapsed time
class _ElapsedTimeSyntax extends md.InlineSyntax {
  _ElapsedTimeSyntax() : super(r'\|\|(.+?)\|\|');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    parser.addNode(md.Element.text('elapsed', match[1]!));
    return true;
  }
}

class _ElapsedTimeBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    return Text(
      element.textContent,
      style: const TextStyle(
        fontSize: TizenStyles.tinyFontSize,
        color: Color(0x57FFFFFF),
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

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

  /// Seconds from request start to TurnComplete. Shown inline after the
  /// response body as smaller gray text ("N초 걸림").
  final int? elapsedSeconds;

  const ReceivedMessage({
    super.key,
    required this.text,
    this.isWaiting = false,
    this.displayType = 'text',
    this.phaseTitle,
    this.tools = const [],
    this.validationPassed = false,
    this.currentToolIndicator,
    this.elapsedSeconds,
  });

  bool get _isIntermediatePhase => phaseTitle != null;

  static final _elapsedExtensionSet = md.ExtensionSet(
    md.ExtensionSet.gitHubFlavored.blockSyntaxes,
    [...md.ExtensionSet.gitHubFlavored.inlineSyntaxes, _ElapsedTimeSyntax()],
  );
  static final _elapsedBuilders = <String, MarkdownElementBuilder>{
    'elapsed': _ElapsedTimeBuilder(),
  };

  @override
  Widget build(BuildContext context) {
    final dimAlpha = _isIntermediatePhase ? 0.78 : 1.0;
    // ignore: avoid_print
    print(
      '[ReceivedMessage.build] phaseTitle=${phaseTitle ?? "(null)"} '
      'currentTool=${currentToolIndicator ?? "(null)"} '
      'textLen=${text.length}',
    );
    final bodyStyle = TizenStyles.bodyText.copyWith(
      color: TizenStyles.bodyText.color?.withValues(alpha: dimAlpha),
    );

    final showMeta = !isWaiting && elapsedSeconds != null;
    
    final safeText = text.trimRight();
    final timeStr = '✓\u00A0$elapsedSeconds초';
    final markdownData = showMeta 
        ? (safeText.isEmpty 
            ? '||$timeStr||' 
            : '$safeText\n\n||$timeStr||') 
        : text;

    final hasContent = markdownData.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (phaseTitle != null) ...[
          _PhaseHeader(title: phaseTitle!),
          const SizedBox(height: 3),
        ],
        if (hasContent)
          MarkdownBody(
            data: markdownData,
            extensionSet: showMeta ? _elapsedExtensionSet : null,
            builders: showMeta ? _elapsedBuilders : const {},
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
        fontSize: TizenStyles.tMeta,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

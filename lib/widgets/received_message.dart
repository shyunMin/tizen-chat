import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:markdown/markdown.dart' as md;
import '../theme/tizen_styles.dart';
import '../screens/generative_web_view.dart';

class ReceivedMessage extends StatelessWidget {
  final String text;
  final String avatarInitial;
  final String? uiCode;
  final bool isWaiting;
  final String displayType;
  final void Function(String text)? onCommand;

  const ReceivedMessage({
    super.key,
    required this.text,
    required this.avatarInitial,
    this.uiCode,
    this.isWaiting = false,
    this.displayType = 'text',
    this.onCommand,
  });

  Color _getAvatarColor() {
    switch (displayType) {
      case 'ui':
        return Colors.deepPurpleAccent; // UI/GenUI 타입
      case 'text':
        return Colors.blueAccent; // JSON 기반 일반 텍스트
      case 'device_control':
        return Colors.orangeAccent; // 기기 제어 타입 (Yellow/Orange)
      case 'hidden':
        return Colors.tealAccent; // 숨김/시스템 동작 타입
      case 'fallback':
      default:
        return TizenStyles.slate800; // 일반 원본 텍스트(JSON 없음)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (isWaiting)
              SizedBox(
                width: 38,
                height: 38,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    TizenStyles.cyan400.withValues(alpha: 0.8),
                  ),
                ),
              ),
            CircleAvatar(
              radius: 16,
              backgroundColor: _getAvatarColor(),
              child: Text(
                avatarInitial,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              MarkdownBody(
                data: text,
                inlineSyntaxes: [_AnchorTagSyntax()],
                builders: {
                  'a': _ButtonLinkBuilder(
                    onCommand: (cmd) => onCommand?.call(cmd),
                  ),
                },
                styleSheet: MarkdownStyleSheet(
                  p: TizenStyles.bodyText,
                  strong: TizenStyles.bodyText.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  em: TizenStyles.bodyText.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                  listBullet: TizenStyles.bodyText,
                  code: TizenStyles.bodyText.copyWith(
                    fontFamily: 'monospace',
                    backgroundColor: Colors.black.withValues(alpha: 0.3),
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  h1: TizenStyles.headerText,
                  h2: TizenStyles.headerText.copyWith(fontSize: 17),
                  h3: TizenStyles.headerText.copyWith(fontSize: 16),
                ),
              ),
              // if (uiCode != null && uiCode!.isNotEmpty) ...[
              //   const SizedBox(height: 12),
              //   GenerativeWebView(uiCode: uiCode!, isInline: true),
              // ],
            ],
          ),
        ),
        const SizedBox(width: 100),
      ],
    );
  }
}

class _AnchorTagSyntax extends md.InlineSyntax {
  _AnchorTagSyntax() : super(r'<a>(.*?)</a>');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final text = match.group(1);
    final element = md.Element.text('a', text!);
    parser.addNode(element);
    return true;
  }
}

class _ButtonLinkBuilder extends MarkdownElementBuilder {
  final void Function(String text) onCommand;

  _ButtonLinkBuilder({required this.onCommand});

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final String textContent = element.textContent;
    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 4),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          side: BorderSide(color: Colors.blueAccent.withOpacity(0.5)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () => onCommand(textContent),
        child: Text(textContent, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}

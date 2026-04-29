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
      child: Focus(
        onFocusChange: (hasFocus) {
          // FocusNode가 직접 제공되지 않으므로, 이 레벨에서 context를 통해 스크롤 처리
        },
        child: Builder(
          builder: (context) {
            final bool isFocused = Focus.of(context).hasFocus;

            if (isFocused) {
              // 포커스를 받았을 때 해당 위젯이 보이도록 스크롤 수행
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Scrollable.ensureVisible(
                  context,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  alignment: 0.5, // 중앙에 위치하도록 시도
                );
              });
            }

            return OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: isFocused
                    ? Colors.blueAccent
                    : Colors.transparent,
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: isFocused
                      ? Colors.transparent
                      : Colors.blueAccent.withOpacity(0.5),
                  width: isFocused ? 2.0 : 1.0,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: isFocused ? 8 : 0,
                shadowColor: Colors.blueAccent.withOpacity(0.4),
              ),
              onPressed: () => onCommand(textContent),
              child: Text(
                textContent,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isFocused ? FontWeight.w800 : FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

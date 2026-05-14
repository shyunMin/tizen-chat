import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/tizen_styles.dart';

class SentMessage extends StatelessWidget {
  final String text;

  /// True for a pending submission (steer/queue) the daemon hasn't picked
  /// up yet. Rendered with an amber-tinted gradient + dashed-style border
  /// so the user can distinguish what's been *typed and queued* from
  /// what's already in the conversation.
  final bool isWaiting;

  const SentMessage({super.key, required this.text, this.isWaiting = false});

  @override
  Widget build(BuildContext context) {
    final gradientColors = isWaiting
        ? [
            Colors.amber.shade700.withValues(alpha: 0.55),
            Colors.amber.shade900.withValues(alpha: 0.55),
          ]
        : [
            TizenStyles.blue800.withValues(alpha: 0.7),
            TizenStyles.blue900.withValues(alpha: 0.7),
          ];
    final borderColor = isWaiting
        ? Colors.amber.shade300.withValues(alpha: 0.7)
        : Colors.white.withValues(alpha: 0.1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 40),
        Flexible(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(2),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(2),
                  ),
                  border: Border.all(
                    color: borderColor,
                    width: isWaiting ? 1.5 : 1.0,
                  ),
                ),
                child: Text(
                  text,
                  style: TizenStyles.sentText,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/tizen_styles.dart';

class SentMessage extends StatelessWidget {
  final String text;

  const SentMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: TizenStyles.sentMessageLeftSpacing),
        Flexible(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(TizenStyles.windowBorderRadius),
              topRight: Radius.circular(TizenStyles.windowBorderRadius),
              bottomLeft: Radius.circular(TizenStyles.windowBorderRadius),
              bottomRight: Radius.circular(TizenStyles.messageTailRadius),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: TizenStyles.backdropBlurSigma, sigmaY: TizenStyles.backdropBlurSigma),
              child: Container(
                padding: TizenStyles.bubblePadding,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      TizenStyles.blue800.withValues(alpha: 0.7),
                      TizenStyles.blue900.withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(TizenStyles.windowBorderRadius),
                    topRight: Radius.circular(TizenStyles.windowBorderRadius),
                    bottomLeft: Radius.circular(TizenStyles.windowBorderRadius),
                    bottomRight: Radius.circular(TizenStyles.messageTailRadius),
                  ),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
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

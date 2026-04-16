import 'package:flutter/material.dart';

class DimOverlay extends StatelessWidget {
  final bool isVisible;
  final Duration duration;
  final double opacity;

  const DimOverlay({
    super.key,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 500),
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Background dimming
          Positioned.fill(
            child: AnimatedContainer(
              duration: duration,
              curve: Curves.easeInOut,
              color: isVisible
                  ? Colors.black.withValues(alpha: 0.5 * opacity)
                  : Colors.transparent,
              child: isVisible
                  ? Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black.withValues(alpha: 0.3 * opacity),
                            Colors.black.withValues(alpha: 0.5 * opacity),
                            Colors.black.withValues(alpha: 0.7 * opacity),
                          ],
                        ),
                      ),
                    )
                  : null,
            ),
          ),
          // Green dot for recording
          // Positioned(
          //   top: 25,
          //   right: 25,
          //   child: Container(
          //     width: 8,
          //     height: 8,
          //     decoration: BoxDecoration(
          //       color: Colors.greenAccent.withValues(alpha: 0.8),
          //       shape: BoxShape.circle,
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.greenAccent.withValues(alpha: 0.4),
          //           blurRadius: 10,
          //           spreadRadius: 2,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

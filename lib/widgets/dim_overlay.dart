import 'package:flutter/material.dart';

class DimOverlay extends StatelessWidget {
  final bool isVisible;
  final Duration duration;

  const DimOverlay({
    super.key,
    required this.isVisible,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeInOut,
        color: isVisible ? Colors.black.withOpacity(0.5) : Colors.transparent,
        child: isVisible
            ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.5),
                    ],
                  ),
                ),
              )
            : null,
      ),
    );
  }
}

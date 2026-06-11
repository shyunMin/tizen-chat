import 'package:flutter/material.dart';
import '../theme/tizen_styles.dart';

class ChipBackgroundEffects extends StatefulWidget {
  final bool isFocused;
  final Widget child;

  const ChipBackgroundEffects({
    super.key,
    required this.isFocused,
    required this.child,
  });

  @override
  State<ChipBackgroundEffects> createState() => _ChipBackgroundEffectsState();
}

class _ChipBackgroundEffectsState extends State<ChipBackgroundEffects>
    with SingleTickerProviderStateMixin {
  late AnimationController _auraController;

  @override
  void initState() {
    super.initState();
    _auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300), // 2.6s total cycle
    );
    if (widget.isFocused) {
      _auraController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ChipBackgroundEffects oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFocused && !oldWidget.isFocused) {
      _auraController.repeat(reverse: true);
    } else if (!widget.isFocused && oldWidget.isFocused) {
      _auraController.stop();
      _auraController.reset();
    }
  }

  @override
  void dispose() {
    _auraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _auraController,
      builder: (context, child) {
        // opacity pulses between 0.55 and 0.95
        final double auraOpacity = 0.55 + (_auraController.value * 0.40);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Focused Aura (outer glow)
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: widget.isFocused ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      TizenStyles.actionButtonBorderRadius,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(
                          alpha: 0.18 * auraOpacity,
                        ),
                        blurRadius:
                            12.0, // Increased for a softer, wider smudge
                        spreadRadius: 2.0, // Spread the glow further
                      ),
                      BoxShadow(
                        color: const Color(
                          0xFFDCEBFF,
                        ).withValues(alpha: 0.10 * auraOpacity),
                        blurRadius: 24.0, // Huge soft blur for the outer aura
                        spreadRadius: 4.0, // Spread further to create a halo
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Base frosted glass and border
            ClipRRect(
              borderRadius: BorderRadius.circular(
                TizenStyles.actionButtonBorderRadius,
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: widget.isFocused
                      ? const Color(0xFF555555).withValues(
                          alpha: 0.6,
                        ) // Semi-transparent gray for better text legibility
                      : TizenStyles.matThin,
                  borderRadius: BorderRadius.circular(
                    TizenStyles.actionButtonBorderRadius,
                  ),
                  border: Border.all(
                    color: widget.isFocused
                        ? Colors.white.withValues(alpha: 0.95)
                        : Colors.white.withValues(alpha: 0.25),
                    width: widget.isFocused ? 0.75 : 0.5,
                  ),
                ),
                child: widget.child,
              ),
            ),
          ],
        );
      },
      child: widget.child,
    );
  }
}

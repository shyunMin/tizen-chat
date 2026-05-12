import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/onboarding_grpc_service.dart';
import '../generated/carbon/v1/setup.pb.dart';
import '../theme/tizen_styles.dart';

class OnboardingScreen extends StatefulWidget {
  final OnboardingGrpcService service;

  const OnboardingScreen({required this.service, super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String? _url;
  bool _isLoading = true;
  String? _errorMessage;
  StreamSubscription<SetupEvent>? _watchSub;
  bool _isCompleting = false;

  final FocusNode _closeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _startSetup();
  }

  Future<void> _startSetup() async {
    try {
      _watchSub = widget.service.watchSetup().listen(
        _onSetupEvent,
        onError: (e) => debugPrint('[Onboarding] WatchSetup error: $e'),
      );

      final url = await widget.service.startSetup();

      if (mounted) {
        setState(() {
          _url = url;
          _isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _closeFocusNode.requestFocus();
        });
      }
    } catch (e) {
      debugPrint('[Onboarding] StartSetup error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _closeFocusNode.requestFocus();
        });
      }
    }
  }

  void _onSetupEvent(SetupEvent event) {
    if (_isCompleting) return;
    switch (event.kind) {
      case SetupEvent_Kind.COMPLETED:
        _isCompleting = true;
        _finishSetup(completed: true);
      case SetupEvent_Kind.STOPPED:
        _isCompleting = true;
        _finishSetup(completed: false);
      default:
        break;
    }
  }

  Future<void> _finishSetup({required bool completed}) async {
    try {
      await widget.service.stopSetup();
    } catch (e) {
      debugPrint('[Onboarding] StopSetup error: $e');
    }
    if (mounted) Navigator.of(context).pop(completed);
  }

  @override
  void dispose() {
    _watchSub?.cancel();
    _closeFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        autofocus: true,
        onKeyEvent: (_, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.escape ||
                  event.logicalKey == LogicalKeyboardKey.goBack ||
                  event.logicalKey == LogicalKeyboardKey.browserBack)) {
            _finishSetup(completed: false);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Center(child: _buildContent()),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: TizenStyles.cyan400),
          SizedBox(height: TizenStyles.onboardingLoadingGap),
          Text('Starting setup...', style: TizenStyles.bodyText),
        ],
      );
    }

    if (_errorMessage != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.orange,
            size: TizenStyles.onboardingErrorIconSize,
          ),
          const SizedBox(height: TizenStyles.onboardingErrorIconGap),
          const Text('Setup service unavailable', style: TizenStyles.headerText),
          const SizedBox(height: TizenStyles.onboardingErrorMsgGap),
          Text(_errorMessage!, style: TizenStyles.bodyText),
          const SizedBox(height: TizenStyles.onboardingErrorButtonGap),
          _buildCloseButton(),
        ],
      );
    }

    final isLocalhost = _url?.contains('127.0.0.1') ?? false;

    return Padding(
      padding: TizenStyles.onboardingPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: TizenStyles.onboardingPanelWidth,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carbon',
                  style: TizenStyles.headerText.copyWith(
                    fontSize: TizenStyles.onboardingTitleFontSize,
                  ),
                ),
                const SizedBox(height: TizenStyles.onboardingTitleGap),
                Text(
                  '휴대전화로 스캔하거나 링크로 이동해서 설정을 완료 하세요',
                  style: TizenStyles.bodyText,
                ),
                if (_url != null) ...[
                  if (isLocalhost)
                    Container(
                      padding: TizenStyles.onboardingWarningPadding,
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(
                          alpha: TizenStyles.onboardingWarningBgAlpha,
                        ),
                        borderRadius: BorderRadius.circular(
                          TizenStyles.onboardingWarningBorderRadius,
                        ),
                        border: Border.all(
                          color: Colors.orange.withValues(
                            alpha: TizenStyles.onboardingWarningBorderAlpha,
                          ),
                        ),
                      ),
                      child: const Text(
                        '⚠ LAN IP not found. Check TV network.',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: TizenStyles.baseFontSize,
                        ),
                      ),
                    ),
                  Text(_url!, style: TizenStyles.bodyText),
                ],
                const Spacer(),
                _buildCloseButton(),
              ],
            ),
          ),
          const SizedBox(width: TizenStyles.onboardingPanelGap),
          if (_url != null)
            Container(
              padding: TizenStyles.qrContainerPadding,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(TizenStyles.qrBorderRadius),
                boxShadow: const [TizenStyles.qrBoxShadow],
              ),
              child: QrImageView(
                data: _url!,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return Focus(
      focusNode: _closeFocusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.select ||
              event.logicalKey == LogicalKeyboardKey.enter) {
            _finishSetup(completed: false);
            return KeyEventResult.handled;
          }
          if (event.logicalKey == LogicalKeyboardKey.arrowUp ||
              event.logicalKey == LogicalKeyboardKey.arrowDown ||
              event.logicalKey == LogicalKeyboardKey.arrowLeft ||
              event.logicalKey == LogicalKeyboardKey.arrowRight) {
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return GestureDetector(
            onTap: () => _finishSetup(completed: false),
            child: Container(
              padding: TizenStyles.onboardingCloseButtonPadding,
              decoration: BoxDecoration(
                color: isFocused
                    ? Colors.white
                    : Colors.black.withValues(
                        alpha: TizenStyles.onboardingCloseButtonBgAlpha,
                      ),
                borderRadius: BorderRadius.circular(
                  TizenStyles.actionButtonBorderRadius,
                ),
                border: Border.all(width: TizenStyles.focusBorderWidth),
                boxShadow: isFocused
                    ? [
                        BoxShadow(
                          color: TizenStyles.focusGlowColor.withValues(
                            alpha: TizenStyles.focusGlowAlpha,
                          ),
                          blurRadius: TizenStyles.focusGlowBlurRadius,
                          spreadRadius: TizenStyles.focusGlowSpreadRadius,
                        ),
                      ]
                    : null,
              ),
              child: Text(
                'Close',
                style: TextStyle(
                  color: isFocused ? Colors.black : Colors.white,
                  fontSize: TizenStyles.baseFontSize,
                  fontWeight: isFocused ? FontWeight.w600 : FontWeight.w400,
                  letterSpacing: TizenStyles.onboardingCloseButtonLetterSpacing,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

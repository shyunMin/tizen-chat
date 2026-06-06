import 'package:flutter/material.dart';

class TizenStyles {
  // ── Colors ────────────────────────────────────────────────────
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color cyan400 = Color(0xFF22D3EE);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue800 = Color(0xFF1E40AF);
  static const Color blue900 = Color(0xFF1E3A8A);

  // ── Font Sizes ────────────────────────────────────────────────
  static const double baseFontSize = 14.0;
  static const double tinyFontSize = 12.0;
  static const double headerFontSize = 17.0;
  static const double subheaderFontSize = 16.0;
  static const double avatarInitialFontSize = 10.0;
  static const double promptBarInputFontSize = 20.0;
  static const double promptBarHintFontSize = 18.0;

  // ── Border Radii ─────────────────────────────────────────────
  static const double windowBorderRadius = 18.0;
  static const double messageTailRadius = 2.0;
  static const double actionButtonBorderRadius = 50.0;
  static const double codeBorderRadius = 4.0;

  // ── Widget Sizes ─────────────────────────────────────────────
  static const double avatarRadius = 16.0;
  static const double avatarSpinnerSize = 38.0;
  static const double focusBorderWidth = 1.5;
  static const double sessionHeaderDotSize = 6.0;
  static const double actionBarHeight = 44.0;
  static const double promptBarCollapsedWidth = 64.0;
  static const double promptBarInnerHeight = 68.0;
  static const double promptBarContentHeight = 64.0;
  static const double promptBarIconSize = 24.0;
  static const double iconButtonPadding = 8.0;
  static const double sentMessageLeftSpacing = 40.0;
  static const double receivedMessageRightSpacing = 100.0;
  static const double backdropBlurSigma = 12.0;
  static const double agentWindowHeightReserved = 280.0;

  // ── Spacing ───────────────────────────────────────────────────
  static const double avatarGap = 12.0;
  static const double messageSpacing = 10.0;
  static const double actionBarItemSpacing = 8.0;
  static const double sessionHeaderGap = 8.0;

  // ── EdgeInsets ────────────────────────────────────────────────
  static const EdgeInsets messagePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets actionButtonPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 8,
  );
  static const EdgeInsets actionBarHorizontalPadding = EdgeInsets.symmetric(
    horizontal: 10,
  );
  static const EdgeInsets messageListPadding = EdgeInsets.fromLTRB(
    12,
    16,
    12,
    12,
  );
  static const EdgeInsets sessionHeaderPadding = EdgeInsets.fromLTRB(
    16,
    12,
    16,
    10,
  );
  static const EdgeInsets promptBarContentPadding = EdgeInsets.only(
    left: 80.0,
    right: 16.0,
  );

  // ── Screen Layout Positions ───────────────────────────────────
  static const double promptBarBottom = 10.0;
  static const double promptBarBottomKeyboard = 270.0;
  static const double promptBarLeft = 10.0;
  static const double promptBarContainerHeight = 80.0;
  static const double actionBarBottom = 90.0;
  static const double actionBarBottomKeyboard = 350.0;
  static const double chatWindowBottomBase = 90.0;
  static const double chatWindowBottomWithActions = 146.0;
  static const double chatWindowBottomKeyboard = 358.0;
  static const double chatWindowBottomKeyboardWithActions = 418.0;

  // ── Onboarding ────────────────────────────────────────────────
  static const double onboardingTitleFontSize = 28.0;
  static const double onboardingTitleGap = 20.0;
  static const double onboardingPanelWidth = 380.0;
  static const double onboardingPanelGap = 64.0;
  static const double onboardingWarningBorderRadius = 8.0;
  static const double onboardingWarningBgAlpha = 0.15;
  static const double onboardingWarningBorderAlpha = 0.4;
  static const double onboardingLoadingGap = 16.0;
  static const double onboardingErrorIconSize = 48.0;
  static const double onboardingErrorIconGap = 16.0;
  static const double onboardingErrorMsgGap = 8.0;
  static const double onboardingErrorButtonGap = 24.0;
  static const double onboardingCloseButtonBgAlpha = 0.7;
  static const double onboardingCloseButtonLetterSpacing = 0.5;
  static const EdgeInsets onboardingPadding = EdgeInsets.symmetric(vertical: 200);
  static const EdgeInsets onboardingWarningPadding = EdgeInsets.all(10);
  static const EdgeInsets onboardingCloseButtonPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 12);

  // ── QR Code ───────────────────────────────────────────────────
  static const double qrBorderRadius = 16.0;
  static const EdgeInsets qrContainerPadding = EdgeInsets.all(16);
  static const BoxShadow qrBoxShadow = BoxShadow(
    color: Color(0x80000000),
    blurRadius: 20,
    offset: Offset(0, 10),
  );

  // ── Focus Glow ────────────────────────────────────────────────
  static const Color focusGlowColor = Color(0xFF6366F1);
  static const double focusGlowBlurRadius = 14.0;
  static const double focusGlowSpreadRadius = 1.0;
  static const double focusGlowAlpha = 0.45;

  // ── Shadows ───────────────────────────────────────────────────
  static const BoxShadow windowShadow = BoxShadow(
    color: Color(0x80000000),
    blurRadius: 24,
    spreadRadius: 2,
    offset: Offset(0, 8),
  );

  // ── Text Styles ───────────────────────────────────────────────
  static const TextStyle bodyText = TextStyle(
    color: slate200,
    fontSize: baseFontSize,
    height: 1.6,
  );

  static const TextStyle sentText = TextStyle(
    color: Colors.white,
    fontSize: baseFontSize,
  );

  static const TextStyle headerText = TextStyle(
    fontSize: headerFontSize,
    fontWeight: FontWeight.w800,
    letterSpacing: 2.0,
    color: Colors.white,
  );

  static const TextStyle promptInputText = TextStyle(
    color: Colors.white,
    fontSize: promptBarInputFontSize,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
    letterSpacing: 0.3,
  );

  // ── Gradients ─────────────────────────────────────────────────
  static const RadialGradient backgroundGradient = RadialGradient(
    center: Alignment.topRight,
    radius: 1.5,
    colors: [slate900, Colors.black, Colors.black],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [TizenStyles.blue600, TizenStyles.cyan400],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF2DD4BF)],
  );
}

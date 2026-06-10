import 'package:flutter/material.dart';

class TizenStyles {
  // ═══════════════════════════════════════════════════════════════
  // Design System v2  (design_03.html 기준, DPR=1.6 보정)
  // 물리 해상도: 1920×1080 / 논리 해상도: 1200×675
  // 물리 px = dp × 1.6  /  목표 dp = HTML 물리 px ÷ 1.6
  // DPR 출처: tizen/App.cs → UserPixelRatio = 1.6
  // ═══════════════════════════════════════════════════════════════

  // ── Type ramp ────────────────────────────────────────────────
  // design_03: --t-title/body 1.667cqw=32px / --t-caption .95cqw=18.2px
  //            --t-meta 1.25cqw=24px / ask-said·chip 1.458cqw=28px
  static const double tResultTitle = 25.0;  // 40.0px ÷ 1.6  (2.083cqw, 미사용)
  static const double tTitle       = 20.0;  // 32.0px ÷ 1.6  (1.667cqw)
  static const double tBody        = 20.0;  // 32.0px ÷ 1.6  (1.667cqw, t-title과 동일)
  static const double tCaption     = 11.5;  // 18.2px ÷ 1.6  (0.95cqw)
  static const double tMeta        = 15.0;  // 24.0px ÷ 1.6  (1.25cqw)
  static const double tAskSaid     = 17.5;  // 28.0px ÷ 1.6  (1.458cqw, 독립값)
  static const double tChip        = 17.5;  // 28.0px ÷ 1.6  (1.458cqw, 독립값)
  static const double tProcBusy    = 15.0;  // 24.0px ÷ 1.6  (1.25cqw, busy 한줄 전용)

  // ── Colors ────────────────────────────────────────────────────
  // Background
  static const Color bgBase = Color(0xFF070A10);

  // Materials (BackdropFilter 위에 올리는 반투명 배경)
  static const Color matThin  = Color(0x8C10131B); // rgba(16,19,27,.55)
  static const Color matThick = Color(0x99141822); // rgba(20,24,34,.60)

  // Hairline border
  static const Color hairline = Color(0x1AFFFFFF); // rgba(255,255,255,.10)

  // Accent & identity
  static const Color accent    = Color(0xFF6FD0FF); // #6fd0ff
  static const Color glyphGlow = Color(0x8C5A96FF); // rgba(90,150,255,.55)

  // Text hierarchy
  static const Color txt  = Color(0xF5FFFFFF); // rgba(255,255,255,.96)
  static const Color txt2 = Color(0x8FFFFFFF); // rgba(255,255,255,.56)
  static const Color txt3 = Color(0x57FFFFFF); // rgba(255,255,255,.34)

  // Legacy colors (기존 코드 참조 유지)
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color cyan400  = Color(0xFF22D3EE);
  static const Color blue600  = Color(0xFF2563EB);
  static const Color blue800  = Color(0xFF1E40AF);
  static const Color blue900  = Color(0xFF1E3A8A);

  // ── Border Radii ─────────────────────────────────────────────
  // HTML: --r-card 2.55cqw=49px → 30.5dp / --r-pill 999px
  static const double rCard = 30.5;  // 49px ÷ 1.6 (design_03: 2.2→2.55cqw)
  static const double rPill = 999.0;

  // Legacy radii (기존 코드 참조 유지)
  static const double windowBorderRadius    = rCard;
  static const double windowCardRadius      = rCard;   // 이전값 42.0은 물리px였음, 21dp로 정정
  static const double messageTailRadius     = 2.0;
  static const double actionButtonBorderRadius = rPill;
  static const double codeBorderRadius      = 4.0;

  // ── Layout ────────────────────────────────────────────────────
  // HTML: --safe-x/b 2.5cqw=48px → 30dp / --col-max 700px → 437.5dp
  static const double safeX   = 30.0;  // 48px ÷ 1.6
  static const double safeB   = 30.0;  // 48px ÷ 1.6
  static const double colMax  = 437.5; // 700px ÷ 1.6 (design_03: 640→700px)

  // ── Glyph Orb sizes ───────────────────────────────────────────
  // HTML: lg 2.6cqw=50px→31dp / md 2.2cqw=42px→26.5dp / sm 1.6cqw=30.7px→19dp
  static const double glyphLg = 31.0;  // 50.0px ÷ 1.6
  static const double glyphMd = 26.5;  // 42.0px ÷ 1.6
  static const double glyphSm = 19.0;  // 30.7px ÷ 1.6

  // ── Backdrop blur sigma (dp 단위, DPR이 물리 렌더링 스케일) ────
  // HTML: blur-thin 20px→12.5dp / blur-thick 34px→21dp
  static const double blurThin  = 12.5; // 20px ÷ 1.6
  static const double blurThick = 21.0; // 34px ÷ 1.6

  // ── Motion ────────────────────────────────────────────────────
  static const Duration dur  = Duration(milliseconds: 420);
  static const Curve    ease = Cubic(0.22, 0.61, 0.36, 1.0);

  // ═══════════════════════════════════════════════════════════════
  // Legacy / 기존 참조 유지 (새 토큰으로 점진적 교체 예정)
  // ═══════════════════════════════════════════════════════════════

  // ── Font Sizes ────────────────────────────────────────────────
  static const double titleFontSize          = tTitle;
  static const double baseFontSize           = tBody;
  static const double captionFontSize        = tCaption;
  static const double tinyFontSize           = tMeta;
  static const double headerFontSize         = tTitle;
  static const double subheaderFontSize      = tBody;
  static const double avatarInitialFontSize  = tMeta;
  static const double promptBarInputFontSize = tTitle;
  static const double promptBarHintFontSize  = tTitle;

  // ── Widget Sizes ─────────────────────────────────────────────
  static const double avatarRadius         = glyphMd / 2; // 10.5
  static const double avatarSpinnerSize    = glyphMd + 4;  // 25
  static const double focusBorderWidth     = 1.5;
  static const double sessionHeaderDotSize = 6.0;
  static const double actionBarHeight      = 34.0;
  static const double promptBarCollapsedWidth  = 64.0;
  static const double promptBarInnerHeight     = 68.0;
  static const double promptBarContentHeight   = 64.0;
  static const double promptBarIconSize        = 24.0;
  static const double iconButtonPadding        = 8.0;
  static const double sentMessageLeftSpacing   = 40.0;
  static const double receivedMessageRightSpacing = 100.0;
  static const double backdropBlurSigma    = blurThin;
  static const double agentWindowHeightReserved = 280.0;

  // ── Spacing ───────────────────────────────────────────────────
  static const double avatarGap          = 12.0;
  static const double messageSpacing     = 10.0; // HTML stream gap 1cqw=19.2px→9.6dp
  static const double actionBarItemSpacing = 8.0;
  static const double sessionHeaderGap   = 8.0;

  // ── EdgeInsets ────────────────────────────────────────────────
  static const EdgeInsets messagePadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets actionButtonPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 6,
  );
  static const EdgeInsets actionBarHorizontalPadding = EdgeInsets.symmetric(
    horizontal: 10,
  );
  static const EdgeInsets messageListPadding = EdgeInsets.fromLTRB(
    12, 16, 12, 12,
  );
  static const EdgeInsets sessionHeaderPadding = EdgeInsets.fromLTRB(
    16, 12, 16, 10,
  );
  static const EdgeInsets promptBarContentPadding = EdgeInsets.only(
    left: 80.0,
    right: 16.0,
  );

  // ── Screen Layout Positions ───────────────────────────────────
  static const double promptBarBottom           = safeB;
  static const double promptBarBottomKeyboard   = 270.0;
  static const double promptBarLeft             = safeX;
  static const double promptBarContainerHeight  = 80.0;
  static const double actionBarBottom           = 90.0;
  static const double actionBarBottomKeyboard   = 350.0;
  static const double chatWindowBottomBase      = 90.0;
  static const double chatWindowBottomWithActions     = 146.0;
  static const double chatWindowBottomKeyboard        = 358.0;
  static const double chatWindowBottomKeyboardWithActions = 418.0;

  // ── Onboarding ────────────────────────────────────────────────
  static const double onboardingTitleFontSize   = tTitle * 2; // 28dp 유지
  static const double onboardingTitleGap        = 20.0;
  static const double onboardingPanelWidth      = 380.0;
  static const double onboardingPanelGap        = 64.0;
  static const double onboardingWarningBorderRadius = 8.0;
  static const double onboardingWarningBgAlpha  = 0.15;
  static const double onboardingWarningBorderAlpha  = 0.4;
  static const double onboardingLoadingGap      = 16.0;
  static const double onboardingErrorIconSize   = 48.0;
  static const double onboardingErrorIconGap    = 16.0;
  static const double onboardingErrorMsgGap     = 8.0;
  static const double onboardingErrorButtonGap  = 24.0;
  static const double onboardingCloseButtonBgAlpha = 0.7;
  static const double onboardingCloseButtonLetterSpacing = 0.5;
  static const EdgeInsets onboardingPadding = EdgeInsets.symmetric(vertical: 200);
  static const EdgeInsets onboardingWarningPadding = EdgeInsets.all(10);
  static const EdgeInsets onboardingCloseButtonPadding = EdgeInsets.symmetric(
    horizontal: 24,
    vertical: 12,
  );

  // ── QR Code ───────────────────────────────────────────────────
  static const double qrBorderRadius = 16.0;
  static const EdgeInsets qrContainerPadding = EdgeInsets.all(16);
  static const BoxShadow qrBoxShadow = BoxShadow(
    color: Color(0x80000000),
    blurRadius: 20,
    offset: Offset(0, 10),
  );

  // ── Focus ────────────────────────────────────────────────────
  // HTML: focus-shadow = 0 1.4cqw 3cqw -.6cqw rgba(0,0,0,.72), 0 0 0 .12cqw rgba(140,220,255,.55)
  static const Color  focusGlowColor        = Color(0x8D8CDCFF); // rgba(140,220,255,.55)
  static const double focusGlowBlurRadius   = 0.0;
  static const double focusGlowSpreadRadius = 2.3;  // .12cqw = 2.3dp
  static const double focusGlowAlpha        = 0.55;
  static const double focusScale            = 1.05;

  // ── Shadows ───────────────────────────────────────────────────
  static const BoxShadow windowShadow = BoxShadow(
    color: Color(0x80000000),
    blurRadius: 24,
    spreadRadius: 2,
    offset: Offset(0, 8),
  );

  // ── Text Styles ───────────────────────────────────────────────
  static const TextStyle bodyText = TextStyle(
    color: txt,
    fontSize: tBody,
    height: 1.55,
  );

  static const TextStyle sentText = TextStyle(
    color: txt2,
    fontSize: tCaption,
  );

  static const TextStyle headerText = TextStyle(
    fontSize: tTitle,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.04,
    color: txt3,
  );

  static const TextStyle promptInputText = TextStyle(
    color: txt2,
    fontSize: tTitle,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.01,
  );

  // ── Gradients ─────────────────────────────────────────────────
  static const RadialGradient backgroundGradient = RadialGradient(
    center: Alignment.topRight,
    radius: 1.5,
    colors: [slate900, Colors.black, Colors.black],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [blue600, cyan400],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF2DD4BF)],
  );
}

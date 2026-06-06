/// Build-time platform flag.
///
/// Defaults to **true** so the normal `flutter-tizen build tpk` flow keeps
/// working with no extra args. Non-Tizen targets (linux desktop dev runs,
/// unit tests) must pass `--dart-define=IS_TIZEN=false` so the Tizen-only
/// `tizen_app_control` runtime calls (and any other Tizen platform-channel
/// usage) are skipped.
///
/// The Tizen-only `tizen_app_control` import sites guard their usage with
/// `if (kIsTizen)`; when this flag is false the unused Tizen plugin calls
/// are never reached.
const bool kIsTizen = bool.fromEnvironment('IS_TIZEN', defaultValue: true);

/// Response layout mode for agent turns. A/B comparison knob.
///
/// - `single` (default): one response per turn. Content morphs as
///   processing text and tool indicators arrive; final answer replaces
///   it at TurnComplete.
/// - `multi`: a new response entry for each finalized commentary block.
///   Produces a chain of entries per turn.
///
/// Build with `--dart-define=LAYOUT_MODE=multi` to try the V2 layout.
const String kLayoutModeRaw =
    String.fromEnvironment('LAYOUT_MODE', defaultValue: 'single');

enum LayoutMode { single, multi }

LayoutMode get kLayoutMode =>
    kLayoutModeRaw == 'multi' ? LayoutMode.multi : LayoutMode.single;

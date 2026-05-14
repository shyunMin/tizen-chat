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

/// Bubble layout mode for assistant turns. A/B comparison knob.
///
/// - `single` (default): one bubble per turn. Content morphs as commentary
///   text and tool indicators arrive; final answer replaces it at
///   TurnComplete. Commentary blocks are preserved across tool calls
///   (the fix for the "narration disappears" bug).
/// - `multi`: a new bubble for each finalized commentary block. Tool
///   indicators live inside the active bubble; when MessageFinalized
///   arrives the bubble is sealed and the next TextDelta starts a fresh
///   one. Produces a chain of bubbles per turn.
///
/// Build with `--dart-define=BUBBLE_MODE=multi` to try the V2 layout.
const String kBubbleModeRaw =
    String.fromEnvironment('BUBBLE_MODE', defaultValue: 'single');

enum BubbleMode { single, multi }

BubbleMode get kBubbleMode =>
    kBubbleModeRaw == 'multi' ? BubbleMode.multi : BubbleMode.single;

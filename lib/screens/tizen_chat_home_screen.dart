import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tizen_app_control/tizen_app_control.dart';
import 'dart:convert';
import '../widgets/agent_panel.dart';
import '../widgets/agent_window.dart';
import '../widgets/action_button_bar.dart';
import '../services/agent_runtime_service.dart';
import '../platform/platform_flags.dart' as platform_flags;
import '../platform/platform_flags.dart' show kIsTizen, LayoutMode;
import '../models/chat_message.dart';
import '../services/agent_response_parser.dart';
import 'dart:async';
import '../features/http_message_overlay/http_message_bus.dart';
import '../services/window_focus_service.dart';
import '../services/agent_onboarding_service.dart';
import '../services/setup_http_server.dart';
import 'onboarding_screen.dart';
import '../theme/tizen_styles.dart';
import '../utils/request_perf_logger.dart';

class TizenChatHomeScreen extends StatefulWidget {
  final bool enableHttpMessageBus;
  final bool enablePerfLog;
  const TizenChatHomeScreen({
    super.key,
    this.enableHttpMessageBus = true,
    this.enablePerfLog = false,
  });

  @override
  State<TizenChatHomeScreen> createState() => _TizenChatHomeScreenState();
}

class _TizenChatHomeScreenState extends State<TizenChatHomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // ── 대화창 상태 ──────────────────────────────────────────────
  bool _hasChatStarted = false;

  // ── Speech 패널 애니메이션 ───────────────────────────────────
  // SPEECH_START: fade + slide(조건부) 동시 실행
  // SPEECH_END  : Phase1=빠른 fade in(120ms) → Phase2=slide 복귀(250ms)
  late final AnimationController _speechFadeController;
  late final AnimationController _speechSlideController;
  static const double _speechSlideDistance =
      TizenStyles.actionBarHeight + TizenStyles.promptBarLeft;
  final List<ChatMessage> _messages = [];
  DateTime? _requestStartTime;
  final GlobalKey<AgentWindowState> _agentWindowKey =
      GlobalKey<AgentWindowState>();
  final GlobalKey<ActionButtonBarState> _actionBarKey =
      GlobalKey<ActionButtonBarState>();

  bool _isGrpcReady = false;
  bool _interruptRequested = false;

  // ── 서비스 ───────────────────────────────────────────────────
  final FocusNode _keyboardFocusNode = FocusNode();
  final FocusNode _chatScrollFocusNode = FocusNode();
  final AgentGrpcService _grpcService = AgentGrpcService.instance;
  StreamSubscription<String>? _messageBusSubscription;
  StreamSubscription<AgentEvent>? _eventSubscription;
  final Completer<bool> _initCompleter = Completer<bool>();
  bool _hasPendingAppControl = false;
  DateTime? _speechStartTimestamp;
  late final RequestPerfLogger _perfLogger;
  String? _logUserMessage;
  DateTime? _logRequestSentTime;

  // ── 진행 중인 응답 추적 ───────────────────────────────────────
  // turn 한 번에 응답 항목도 한 개로 유지한다. 들어오는 모든 delta가
  // 하나의 항목에 누적된다. null = 진행 중인 응답 없음.
  int? _activeReplyIndex;
  String _currentSegmentText = '';

  /// Inline "🔧 toolName 실행 중..." overlay shown in the active response.
  /// Cleared on tool result. The persistent tool history per turn lives on
  /// ChatMessage.tools — this field only drives the "currently running" hint.
  String? _activeToolName;

  /// Optional phase metadata for the in-flight turn. Argot v1 does not emit
  /// TurnStarted, so this is null for normal Argot traffic. When a phase is
  /// provided, the response entry created on the first delta/tool gets it
  /// as a header title.
  AgentTurnPhase? _currentPhase;

  /// Live agent-activity label for the in-flight turn (e.g. "생각하는 중이에요…",
  /// "기억을 살펴보는 중이에요…"), driven by the Argot AgentProgress wire event.
  /// Ephemeral: surfaces in the typing indicator only while the turn runs, then
  /// clears at the turn boundary. Null = fall back to the phase-based label.
  String? _currentProgressLabel;

  /// Stash a successful ValidationCompleted result that arrived before
  /// the response entry materialized (the final-answer delta usually lands
  /// a few ms after). Applied to the next entry created within this turn.
  bool _pendingValidationPassed = false;

  // Thread-level "agent is doing something" flag for the spinner UI.
  // Goes true when a request is submitted and clears when the selected backend
  // emits AgentTurnComplete, AgentThreadComplete, or a fatal error.
  bool _isAgentBusy = false;

  // ChatWindow 위에 표시할 마지막 사용자 요청 텍스트
  String? _lastSentText;

  // ── Pending submission slot ───────────────────────────────────
  // While the daemon is processing a turn, a new submission lands here
  // instead of being shown immediately. The slot holds at most one entry
  // (UI constraint). Argot v1 does not support mid-turn submissions;
  // its adapter logs and ignores them. On release the input is unlocked.
  _PendingSubmission? _pending;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _speechFadeController = AnimationController(vsync: this, value: 1.0);
    _speechSlideController = AnimationController(vsync: this);
    _perfLogger = RequestPerfLogger(enabled: widget.enablePerfLog);
    unawaited(_perfLogger.init());
    if (kIsTizen) {
      AppControl.onAppControl.listen(_onAppControlReceived);
    }

    // gRPC 의 broadcast 이벤트 스트림을 단일 핸들러로 받는다. 연결이 아직
    // 완료되지 않아도 broadcast 라 재구독 없이 이후 이벤트를 모두 받는다.
    _eventSubscription = _grpcService.events.listen(_handleAgentEvent);

    _initializeServices();
    if (widget.enableHttpMessageBus) {
      _startHttpMessageBus();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && !_hasPendingAppControl) {
          unawaited(WindowFocusService.grabNavigationKeys());
        }
      });
    });
  }

  void _onAppControlReceived(ReceivedAppControl appControl) async {
    _hasPendingAppControl = true;
    final initOk = await _initCompleter.future;
    debugPrint('[AppControl] Received! caller: ${appControl.callerAppId}');
    debugPrint('[AppControl] extraData: ${appControl.extraData}');

    try {
      final extraData = appControl.extraData;

      // eventType으로 이벤트 구분
      final eventTypeRaw = extraData['eventType'];
      final eventType = eventTypeRaw is List && eventTypeRaw.isNotEmpty
          ? eventTypeRaw.first.toString()
          : eventTypeRaw?.toString();
      debugPrint('[AppControl] eventType=$eventType');

      // timestamp 파싱
      DateTime? tsDateTime;
      if (extraData.containsKey('timestamp')) {
        final ts = extraData['timestamp'];
        final tsStr = ts is List && ts.isNotEmpty
            ? ts.first.toString()
            : ts.toString();
        final tsMs = int.tryParse(tsStr);
        tsDateTime = tsMs != null
            ? DateTime.fromMillisecondsSinceEpoch(tsMs)
            : null;
        debugPrint(
          '[AppControl] timestamp=$tsStr / ${tsDateTime?.toIso8601String()}',
        );
      }

      if (eventType == 'SPEECH_START') {
        // Turn 내 최초 SPEECH_START만 기준 시간으로 저장
        if (_speechStartTimestamp == null) {
          _speechStartTimestamp = tsDateTime;
          debugPrint(
            '[AppControl] SPEECH_START — turn reference time set: $_speechStartTimestamp',
          );
        } else {
          debugPrint(
            '[AppControl] SPEECH_START — reference time kept: $_speechStartTimestamp',
          );
        }
        if (mounted) {
          unawaited(WindowFocusService.setFocusable(false));
          unawaited(_hidePanelForSpeech());
        }
      } else if (eventType == 'SPEECH_END') {
        if (mounted) _showPanelAfterSpeech();
        // message 추출
        String? messageText;
        if (extraData.containsKey('message')) {
          final msg = extraData['message'];
          final raw = msg is List && msg.isNotEmpty
              ? msg.first.toString()
              : msg.toString();
          if (raw.isNotEmpty) messageText = raw;
        }
        debugPrint(
          '[AppControl] SPEECH_END — message=${messageText ?? '(empty)'}, referenceTime=$_speechStartTimestamp',
        );

        if (messageText != null) {
          // 실제 메시지 → 요청 전달 (기준 시간 포함, 완료 시 초기화)
          final referenceTime = _speechStartTimestamp;
          if (!initOk) {
            debugPrint('[AppControl] Onboarding incomplete — showing error');
            if (mounted) {
              setState(() {
                _hasChatStarted = true;
                _messages.add(
                  ChatMessage(
                    text:
                        'API 키 설정이 완료되지 않아 요청을 처리할 수 없습니다.\n설정을 완료한 후 다시 시도해 주세요.',
                    type: MessageType.received,
                  ),
                );
              });
              _scrollToBottom();
            }
          } else {
            debugPrint('[AppControl] Proceeding to _handleSend: $messageText');
            if (mounted) _handleSend(messageText, referenceTime: referenceTime);
          }
        }
        // 메시지 없음(NO_SPEECH): 기준 시간은 유지, 별도 UI 처리 없음
      } else {
        debugPrint('[AppControl] Unknown or missing eventType, ignoring.');
      }
    } catch (e) {
      debugPrint('[AppControl] Error processing extraData: $e');
    }
  }

  Future<void> _initializeServices() async {
    try {
      // 1. 온보딩 상태 확인
      final onboardingOk = await _checkOnboarding();

      // 2. 오늘 날짜를 세션 이름으로 사용
      final now = DateTime.now();
      final sessionName =
          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      debugPrint('[Init] Session name: $sessionName');

      // 3. gRPC 연결
      await _grpcService.connect(sessionName: sessionName);
      if (!_grpcService.isConnected) {
        await _grpcService.reconnect();
      }

      // 4. 연결 완료
      if (mounted) {
        setState(() => _isGrpcReady = true);
        if (!_hasPendingAppControl) {
          unawaited(WindowFocusService.grabNavigationKeys());
        }
      }

      if (!_initCompleter.isCompleted) _initCompleter.complete(onboardingOk);
    } catch (e) {
      debugPrint('[Init] Error: $e');
      if (mounted) {
        setState(() => _isGrpcReady = true);
        if (!_hasPendingAppControl) {
          unawaited(WindowFocusService.grabNavigationKeys());
        }
      }
      if (!_initCompleter.isCompleted) _initCompleter.complete(false);
    }
  }

  /// 온보딩 완료 여부를 반환한다.
  /// - config 이미 준비됨: true
  /// - 브리지 미실행 또는 연결 실패: true (건너뜀)
  /// - QR 화면에서 설정 완료: true
  /// - QR 화면에서 취소/종료: false
  Future<bool> _checkOnboarding() async {
    final onboardingService = AgentOnboardingService();
    // Single server instance shared across all QR screen iterations so the
    // browser always reaches the same server even when the screen is recreated.
    final httpServer = SetupHttpServer();
    try {
      await onboardingService.connect();

      while (true) {
        final config = await onboardingService.getConfig();
        debugPrint(
          '[ConfigCheck] App started. getConfig result: ready=${config.ready}, hasHint=${config.hint.isNotEmpty}',
        );

        if (config.ready) return true;
        if (!mounted) return false;

        final completed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => OnboardingScreen(
              service: onboardingService,
              httpServer: httpServer,
            ),
          ),
        );

        if (completed != true) return false;
      }
    } catch (e) {
      // 브리지 미실행 또는 연결 실패 시 온보딩 건너뜀
      debugPrint('[Init] Onboarding check skipped: $e');
      return true;
    } finally {
      // httpServer manages its own shutdown via _closeTimer (after save) or
      // _finishSetup(stopServer: true) (cancel / timeout paths). Do not stop
      // it here — calling stop() immediately would cancel the 10-second close
      // delay before the browser can finish loading.
      await onboardingService.disconnect();
    }
  }

  Future<void> _startHttpMessageBus() async {
    try {
      await HttpMessageBus.instance.acquire();
    } catch (e) {
      debugPrint('[REQ_006] HttpMessageBus acquire failed: $e');
    }
    _messageBusSubscription = HttpMessageBus.instance.stream.listen((msg) {
      if (!mounted) return;
      _handleSend(msg); // 사용자 입력과 동일하게 처리
    });
  }

  Future<void> _handleSend(
    String text, {
    bool steer = true,
    DateTime? referenceTime,
  }) async {
    debugPrint(
      '[Chat] _handleSend called: text="${text.length > 40 ? "${text.substring(0, 40)}..." : text}" steer=$steer',
    );

    // 1-slot pending: refuse second submissions while one is in flight.
    if (_pending != null) {
      debugPrint('[Chat] _handleSend ignored — pending slot occupied');
      return;
    }

    final turnBusy = _grpcService.isTurnBusy;
    _requestStartTime = DateTime.now();
    // 첫 제출(에이전트 idle)일 때만 perf 로그 기준값 캡처
    if (!_isAgentBusy) {
      _logUserMessage = text;
      _logRequestSentTime = _requestStartTime;
    }
    setState(() => _isAgentBusy = true);
    _focusAgentWindow();

    if (!turnBusy) {
      // Idle daemon: clear immediately and start fresh.
      setState(() {
        _lastSentText = text;
        _messages.clear();
        _activeReplyIndex = null;
        _currentSegmentText = '';
        _activeToolName = null;
        _currentPhase = null;
        _currentProgressLabel = null;
        _pendingValidationPassed = false;
      });
      _beginChatView();
      unawaited(
        _grpcService.sendPrompt(
          text,
          steer: steer,
          referenceTime: referenceTime,
        ),
      );
      return;
    }

    // Argot v1 does not support mid-turn submit; returns null.
    final reqId = await _grpcService.sendPrompt(
      text,
      steer: steer,
      referenceTime: referenceTime,
    );
    if (reqId == null) {
      return;
    }
    setState(() {
      _pending = _PendingSubmission(
        text: text,
        reqId: reqId,
        steer: steer,
        submittedAt: DateTime.now(),
      );
    });
    debugPrint('[Chat] held in pending slot: $reqId');
  }

  void _handleInterrupt() {
    _interruptRequested = true;
    _grpcService.interruptTurn();
    _speechStartTimestamp = null;
    setState(() {
      _isAgentBusy = false;
      _activeReplyIndex = null;
      _currentSegmentText = '';
      _activeToolName = null;
      _requestStartTime = null;
      _messages.clear();
      _messages.add(
        ChatMessage(
          text: '요청이 중단되었습니다.',
          type: MessageType.received,
          isWaiting: false,
        ),
      );
    });
    _scrollToBottom();
    unawaited(WindowFocusService.grabNavigationKeys());
    _focusAgentWindow();
  }

  void _beginChatView() {
    setState(() {
      if (!_hasChatStarted) {
        _hasChatStarted = true;
        debugPrint('[Chat] First message!');
      }
    });
    unawaited(WindowFocusService.ungrabNavigationKeys());
    _focusAgentWindow();
  }

  /// SteerApplied: A's pre-steer output is discarded and the display is
  /// cleared. The next delta will open a fresh response entry for B's result.
  void _applySteerSplit() {
    final p = _pending;
    if (p == null) return;
    debugPrint('[Chat] steer applied: ${p.reqId} — clearing display');
    setState(() {
      _messages.clear();
      _activeReplyIndex = null;
      _currentSegmentText = '';
      _activeToolName = null;
      _currentPhase = null;
      _currentProgressLabel = null;
      _pendingValidationPassed = false;
      _pending = null;
    });
  }

  /// Daemon confirmed the pending submission has been picked up. Clear slot.
  void _resolvePending(String reason) {
    if (_pending == null) return;
    debugPrint('[Chat] pending slot resolved ($reason): ${_pending!.reqId}');
    setState(() => _pending = null);
  }

  void _completeAgentRequest(String reason) {
    if (!_isAgentBusy) return;
    debugPrint('[Chat] completing agent request: $reason');
    final completeTime = DateTime.now();
    unawaited(
      _perfLogger.record(
        userMessage: _logUserMessage ?? '',
        speechStartTime: _speechStartTimestamp,
        requestSentTime: _logRequestSentTime,
        requestCompleteTime: completeTime,
      ),
    );
    _logUserMessage = null;
    _logRequestSentTime = null;
    _appendElapsedToLastMessage();
    _speechStartTimestamp = null;
    setState(() => _isAgentBusy = false);
    _scrollToBottom();
    unawaited(WindowFocusService.grabNavigationKeys());
    _focusAgentWindow();
  }

  void _handleAgentEvent(AgentEvent event) {
    if (!mounted) return;

    switch (event) {
      case AgentTextDelta(:final content):
        _appendDelta(content);
        break;

      case AgentMessageFinalized():
        _onMessageFinalized(event);
        break;

      case AgentToolUseStart(
        :final toolName,
        :final toolCallId,
        :final argumentsJson,
      ):
        // Indicator is derived from entry.tools (computed via
        // _computeIndicator), so _recordToolStart alone handles both
        // adding the entry and refreshing the indicator.
        _activeToolName = toolName; // kept for legacy refresh-gate logic
        _recordToolStart(toolCallId, toolName, argumentsJson);
        break;

      case AgentToolResult(:final toolCallId, :final output, :final isError):
        // Indicator advance is driven by _computeIndicator inside
        // _recordToolResult — once the matching entry's outputPreview
        // is populated, the next pending tool (if any) becomes the
        // active indicator, or null clears it.
        _recordToolResult(toolCallId, output, isError);
        break;

      case AgentAgentProgress():
        // Live, ephemeral "what the agent is doing" signal. Surfaced in the
        // typing indicator (the only live-status affordance while the turn is
        // in flight); never written to a bubble since it isn't persisted.
        _applyAgentProgress(event);
        break;

      case AgentTurnComplete(:final turns, :final toolCalls):
        debugPrint('[Chat] TurnComplete turns=$turns toolCalls=$toolCalls');
        if (_activeReplyIndex != null) {
          _finalizeActiveReply();
        }
        _currentPhase = null;
        _currentProgressLabel = null;
        break;

      case AgentSteerApplied(:final clientRequestId):
        if (_pending != null &&
            _pending!.steer &&
            _pending!.reqId == clientRequestId) {
          _applySteerSplit();
        }
        break;

      case AgentSteerFailed(:final clientRequestId, :final reason):
        // Compatibility-only: release the UI slot if an older adapter sends it.
        if (_pending != null &&
            _pending!.steer &&
            _pending!.reqId == clientRequestId) {
          _resolvePending('SteerFailed: $reason');
        }
        break;

      case AgentSubmitQueued():
        break;

      case AgentSubmitSteered():
        break;

      case AgentTurnStarted(:final clientRequestId, :final phase):
        if (_pending != null &&
            !_pending!.steer &&
            _pending!.reqId == clientRequestId) {
          _resolvePending('compat TurnStarted');
        }
        debugPrint('[Chat] TurnStarted phase=${phase.title() ?? "(none)"}');
        _currentPhase = phase;
        break;

      case AgentThreadComplete():
        if (_pending != null) {
          _resolvePending('ThreadComplete');
        }
        if (_activeReplyIndex != null) {
          _finalizeActiveReply();
        }
        _completeAgentRequest('ThreadComplete');
        break;

      case AgentContinuationRequested(:final reason, :final message):
        debugPrint(
          '[Chat] ContinuationRequested reason=$reason msg=${message.length > 80 ? "${message.substring(0, 80)}..." : message}',
        );
        break;

      case AgentValidationStarted():
        // Informational — could surface as a sub-indicator in the active
        // response (e.g. "검증 중…"). For now we just log;
        // the thread-level spinner stays on regardless.
        break;

      case AgentValidationCompleted(
        :final passed,
        :final attempt,
        :final reason,
      ):
        // Mark the validation phase's response with a ✓ check when the
        // validator accepts the turn. The response entry may not yet exist
        // (the final-answer delta usually lands a few ms after), so stash
        // on _pendingValidationPassed for the next entry in this turn.
        debugPrint(
          '[Chat] ValidationCompleted passed=$passed attempt=$attempt '
          'reason=${reason.length > 80 ? "${reason.substring(0, 80)}..." : reason}',
        );
        if (passed) {
          if (_activeReplyIndex != null) {
            setState(() {
              _messages[_activeReplyIndex!].validationPassed = true;
            });
          } else {
            _pendingValidationPassed = true;
          }
        }
        break;

      case AgentError(:final code, :final message, :final fatal):
        // 로컬에서 이미 중단 처리한 경우 서버의 cancelled 이벤트는 무시
        if (_interruptRequested && code == 'cancelled') {
          _interruptRequested = false;
          break;
        }
        // Backwards-compat catch-all for older adapters that encoded
        // continuation notices as non-fatal errors.
        if (!fatal && code.startsWith('continuation:')) {
          debugPrint('[Chat] continuation notice (legacy Error path): $code');
          if (_activeReplyIndex != null) {
            _currentSegmentText = '';
            _activeToolName = null;
          }
          break;
        }
        // Clear any pending slot on error so the user can recover.
        if (_pending != null) {
          _resolvePending('Error: $code');
        }
        if (_isAgentBusy && (fatal || _activeReplyIndex == null)) {
          _speechStartTimestamp = null;
          setState(() => _isAgentBusy = false);
        }
        _handleAgentError(code, message, fatal);
        break;

      case AgentSessionEnded():
        if (_pending != null) {
          _resolvePending('SessionEnded');
        }
        if (_isAgentBusy) {
          _speechStartTimestamp = null;
          setState(() => _isAgentBusy = false);
        }
        unawaited(WindowFocusService.grabNavigationKeys());
        _grpcService.reconnect();
        break;

      case AgentToolApprovalRequest(:final approvalId, :final toolName):
        debugPrint(
          '[Chat] ToolApprovalRequest received for $toolName — auto-approving',
        );
        _grpcService.approveToolCall(approvalId, AgentApprovalDecision.approve);
        break;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Response layout — V1 (single morphing) vs V2 (multi, finalize-driven).
  // See platform_flags.dart kLayoutMode for the build switch.
  //
  // Shared state:
  //   _currentSegmentText — accumulated text of the *current* block
  //   _activeReplyIndex   — index of the response entry being mutated
  //   _activeToolName     — current tool indicator (null = none)
  //
  // V1: a single response per turn. _currentSegmentText accumulates EVERY
  //     TextDelta in the turn; MessageFinalized is ignored for boundaries.
  //     Processing text stays visible through tool calls.
  //
  // V2: a response per finalized assistant message. MessageFinalized seals
  //     the active entry; the next TextDelta starts a fresh one. Tool
  //     indicators live inside whichever entry is active when the tool fires.
  // ─────────────────────────────────────────────────────────────

  /// Pushes the in-flight turn state (_currentSegmentText, entry.tools)
  /// onto the active response entry. The entry has TWO regions: a tool
  /// indicator (computed from the tools list — picks the first pending
  /// entry) and a text region (append-only as deltas stream). At
  /// TurnComplete the indicator is dropped, leaving only the text.
  void _refreshActiveResponse({required bool isWaiting}) {
    setState(() {
      if (_activeReplyIndex == null) {
        if (_currentSegmentText.isEmpty && _activeToolName == null) return;
        // Argot v1 may send delta/tool events without any lifecycle prelude.
        _beginAgentResponse('', isWaiting: isWaiting);
      }
      final old = _messages[_activeReplyIndex!];
      _messages[_activeReplyIndex!] = ChatMessage(
        text: _currentSegmentText,
        type: MessageType.received,
        isWaiting: isWaiting,
        phaseTitle: old.phaseTitle,
        tools: old.tools,
        validationPassed: old.validationPassed,
        displayType: old.displayType,
        currentToolIndicator: _computeIndicator(old.tools),
      );
    });
    _scrollToBottom();
  }

  /// Pick the indicator string from a turn's tool list:
  ///   * first not-yet-completed entry → "`tool` · `arg` (N/M)"
  ///     where N = completed count + 1, M = total
  ///   * all completed → null (TurnComplete clears it, but this is
  ///     called from refresh too, so the indicator may briefly read
  ///     null between final result and TurnComplete)
  /// Returns null if the list is empty or all done.
  String? _computeIndicator(List<TurnToolEntry> tools) {
    if (tools.isEmpty) return null;
    // Prefer the first still-pending tool (so the indicator advances as
    // each Result lands). When every tool has completed, keep showing
    // the LAST tool of the turn — AgentTurnComplete is the event that
    // clears the indicator (see _finalizeActiveReply).
    final pendingIdx = tools.indexWhere((t) => t.isPending);
    final activeIdx = pendingIdx >= 0 ? pendingIdx : tools.length - 1;
    final active = tools[activeIdx];
    final total = tools.length;
    final pos = activeIdx + 1;
    final progress = total > 1 ? ' ($pos/$total)' : '';
    final arg = active.argumentsPreview.isEmpty
        ? ''
        : ' · ${active.argumentsPreview}';
    return '${active.toolName}$arg$progress';
  }

  /// Creates the response entry for the in-flight turn. Called by
  /// [_refreshActiveResponse] on the first text delta, and by
  /// [_recordToolStart] when the turn opens with a tool call (no text).
  void _beginAgentResponse(String text, {required bool isWaiting}) {
    final phaseTitle = (_currentPhase is AgentTurnPhasePrompt)
        ? null
        : _currentPhase?.title();
    final validationPassed = _pendingValidationPassed;
    _pendingValidationPassed = false;
    _activeReplyIndex = _messages.length;
    _messages.add(
      ChatMessage(
        text: text,
        type: MessageType.received,
        isWaiting: isWaiting,
        phaseTitle: phaseTitle,
        validationPassed: validationPassed,
      ),
    );
    debugPrint(
      '[Chat] agent response created (idx=$_activeReplyIndex) phase=${phaseTitle ?? "(none)"}',
    );
  }

  /// Appends a new tool entry to the active response. Creates the entry
  /// lazily if the turn opens with a tool call before any text arrives.
  void _recordToolStart(String toolCallId, String toolName, String argsJson) {
    setState(() {
      if (_activeReplyIndex == null) {
        _beginAgentResponse('', isWaiting: true);
      }
      final entry = _messages[_activeReplyIndex!];
      entry.tools.add(
        TurnToolEntry(
          toolCallId: toolCallId,
          toolName: toolName,
          argumentsPreview: _summarizeArgsJson(argsJson),
        ),
      );
      entry.isWaiting = true;
      // Recompute the indicator from the up-to-date tools list so the
      // new entry's name + arg shows immediately (or, if a prior tool
      // is still mid-flight per outputPreview==null, keep that one).
      entry.currentToolIndicator = _computeIndicator(entry.tools);
    });
  }

  /// Completes the matching tool entry on the active response. Matches by
  /// [toolCallId] so out-of-order results stay attached to the right call.
  void _recordToolResult(String toolCallId, String output, bool isError) {
    if (_activeReplyIndex == null) return;
    setState(() {
      final entry = _messages[_activeReplyIndex!];
      for (final t in entry.tools) {
        if (t.toolCallId == toolCallId) {
          t.outputPreview = _summarizeToolOutput(output);
          t.isError = isError;
          break;
        }
      }
      entry.currentToolIndicator = _computeIndicator(entry.tools);
    });
  }

  /// Render a one-line preview of a tool's arguments_json. Picks the
  /// most identifying field for the common tools (url for web_fetch,
  /// command for shell, plan summary for update_plan) and falls back to
  /// a truncated dump.
  String _summarizeArgsJson(String argsJson) {
    if (argsJson.isEmpty) return '';
    try {
      final decoded = jsonDecode(argsJson);
      if (decoded is Map<String, dynamic>) {
        for (final key in const ['url', 'command', '_tool', 'query']) {
          final v = decoded[key];
          if (v is String && v.isNotEmpty) return v;
        }
        if (decoded['plan'] is List) {
          final steps = (decoded['plan'] as List).length;
          return 'plan: $steps step${steps == 1 ? '' : 's'}';
        }
      }
    } catch (_) {}
    return argsJson.length > 120 ? '${argsJson.substring(0, 120)}…' : argsJson;
  }

  String _summarizeToolOutput(String output) {
    final trimmed = output.replaceAll('\n', ' ').trim();
    final lineCount = '\n'.allMatches(output).length + 1;
    final bytes = output.length;
    final preview = trimmed.length > 80
        ? '${trimmed.substring(0, 80)}…'
        : trimmed;
    return '${bytes}B · ${lineCount}L · $preview';
  }

  void _appendDelta(String content) {
    _currentSegmentText += content;
    debugPrint(
      '[Chat] _appendDelta(+${content.length} chars) total=${_currentSegmentText.length} '
      'preview="${_currentSegmentText.length > 60 ? "${_currentSegmentText.substring(0, 60)}..." : _currentSegmentText}"',
    );
    _refreshActiveResponse(isWaiting: true);
  }

  void _onMessageFinalized(AgentMessageFinalized event) {
    if (platform_flags.kLayoutMode != LayoutMode.multi) return;
    // Keep this marker as a no-op; response sealing lives at AgentTurnComplete.
    return;
  }

  /// Surface live agent activity (thinking, recalling memory, running a tool)
  /// in the typing indicator. Progress is ephemeral (never persisted), so we
  /// keep only the latest label and drop it at the turn boundary. Consecutive
  /// identical labels are deduped to avoid needless rebuilds, mirroring the
  /// argot CLI.
  void _applyAgentProgress(AgentAgentProgress progress) {
    final label = _progressLabel(progress);
    if (label == null || label == _currentProgressLabel) return;
    setState(() => _currentProgressLabel = label);
  }

  /// Localized one-line activity label for a progress event, or null to
  /// suppress. progress는 raw 이벤트가 표현 못 하는 구간(thinking / memory)만
  /// 담당한다. tool_executing은 raw ToolCall/ToolResult 스트림이 소유하므로 여기서
  /// 다루지 않고, streaming / done / unspecified 도 이미 텍스트·완료 프레임으로
  /// 전달되므로 표시하지 않는다. summarizer narration(message)이 있으면 그게 우선.
  String? _progressLabel(AgentAgentProgress progress) {
    if (progress.message.isNotEmpty) return progress.message;
    switch (progress.phase) {
      case 'thinking':
        return '생각하는 중이에요…';
      case 'memory_retrieving':
        return '기억을 살펴보는 중이에요…';
      default:
        return null;
    }
  }

  void _finalizeActiveReply() {
    if (_activeReplyIndex == null) return;
    debugPrint(
      '[Chat] _finalizeActiveReply: _currentSegmentText.length=${_currentSegmentText.length} '
      'first200="${_currentSegmentText.length > 200 ? "${_currentSegmentText.substring(0, 200)}..." : _currentSegmentText}"',
    );
    final old = _messages[_activeReplyIndex!];
    // Seal-time body:
    //  * commentary streamed → parse + use the parser's content
    //  * silent turn (no text, just tools) → empty body; phase header
    //    alone tells the user what happened, no fake tool summary
    final String sealedText;
    final String sealedDisplayType;
    final String? sealedUiCode;
    final List<String> sealedButtons;
    if (_currentSegmentText.trim().isNotEmpty) {
      final parsedResponse = AgentResponseParser.parse(_currentSegmentText);
      debugPrint(
        '[Chat] parsed.displayType=${parsedResponse.displayType} '
        'parsed.content.length=${parsedResponse.content.length} '
        'parsed.first200="${parsedResponse.content.length > 200 ? "${parsedResponse.content.substring(0, 200)}..." : parsedResponse.content}"',
      );
      sealedText = parsedResponse.content;
      sealedDisplayType = parsedResponse.displayType;
      sealedUiCode = parsedResponse.uiCode;
      sealedButtons = parsedResponse.actionButtons;
    } else {
      sealedText = '';
      sealedDisplayType = old.displayType;
      sealedUiCode = old.uiCode;
      sealedButtons = old.actionButtons;
      debugPrint(
        '[Chat] _finalizeActiveReply: silent turn — phase header only',
      );
    }
    final int? elapsed = _requestStartTime != null
        ? DateTime.now().difference(_requestStartTime!).inSeconds
        : null;
    setState(() {
      _messages[_activeReplyIndex!] = ChatMessage(
        text: sealedText,
        displayType: sealedDisplayType,
        type: MessageType.received,
        isWaiting: false,
        uiCode: sealedUiCode,
        actionButtons: sealedButtons,
        phaseTitle: old.phaseTitle,
        tools: old.tools,
        validationPassed: old.validationPassed,
        currentToolIndicator: null,
        elapsedSeconds: elapsed,
      );
    });
    _activeToolName = null;
    _currentProgressLabel = null;
    _activeReplyIndex = null;
    _currentSegmentText = '';
    _scrollToBottom();
  }

  Future<void> _handleAgentError(
    String code,
    String message,
    bool fatal,
  ) async {
    debugPrint(
      '[Chat] _handleAgentError called with code: $code, message: $message, fatal: $fatal',
    );

    if (code.startsWith('continuation:')) {
      return;
    }

    unawaited(WindowFocusService.grabNavigationKeys());

    setState(() {
      final displayMessage = '[$code] $message';

      if (fatal) {
        final isCancelled = (code == 'cancelled');

        if (_activeReplyIndex != null) {
          _messages[_activeReplyIndex!] = ChatMessage(
            text: _currentSegmentText.isEmpty
                ? (isCancelled ? '요청이 취소되었습니다.' : '오류: $displayMessage')
                : '$_currentSegmentText\n\n(${isCancelled ? '요청 취소됨' : '에러: $displayMessage'})',
            type: MessageType.received,
            isWaiting: false,
          );
          _activeReplyIndex = null;
          _currentSegmentText = '';
        } else {
          _messages.add(
            ChatMessage(
              text: isCancelled
                  ? '요청이 취소되었습니다.'
                  : '오류가 발생했습니다: $displayMessage',
              type: MessageType.received,
              isWaiting: false,
            ),
          );
        }
      } else {
        if (_activeReplyIndex != null) {
          _messages[_activeReplyIndex!] = ChatMessage(
            text: _currentSegmentText,
            type: MessageType.received,
            isWaiting: false,
          );
          _activeReplyIndex = null;
          _currentSegmentText = '';
        }
      }
    });

    _scrollToBottom();
    _focusAgentWindow();

    if ((fatal && code != 'cancelled') || code == 'NO_SESSION') {
      await _grpcService.reconnect();
    }
  }

  void _scrollToBottom() {
    _agentWindowKey.currentState?.scrollToBottom();
  }

  void _focusAgentWindow() {
    if (!_hasChatStarted) return;
    _chatScrollFocusNode.requestFocus();
  }

  List<String> get _currentActionButtons {
    for (int i = _messages.length - 1; i >= 0; i--) {
      final m = _messages[i];
      if (m.type == MessageType.received) {
        return m.isWaiting ? [] : m.actionButtons;
      }
    }
    return [];
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkConfigStatus();
    }
  }

  Future<void> _checkConfigStatus() async {
    final onboardingService = AgentOnboardingService();
    try {
      await onboardingService.connect();
      final config = await onboardingService.getConfig();
      debugPrint(
        '[ConfigCheck] App resumed. getConfig result: ready=${config.ready}, hasHint=${config.hint.isNotEmpty}',
      );
    } catch (e) {
      debugPrint('[ConfigCheck] App resumed. getConfig error: $e');
    } finally {
      await onboardingService.disconnect();
    }
  }

  // 처리 중: 항상 slide+fade. 완료+액션바 없음: slide+fade. 완료+액션바 있음: fade만.
  Future<void> _hidePanelForSpeech() async {
    await Future.wait([
      _speechSlideController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      ),
      _speechFadeController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      ),
    ]);
  }

  void _showPanelAfterSpeech() {
    _speechFadeController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
    _speechSlideController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageBusSubscription?.cancel();
    _eventSubscription?.cancel();
    HttpMessageBus.instance.release();
    _speechFadeController.dispose();
    _speechSlideController.dispose();
    _keyboardFocusNode.dispose();
    _chatScrollFocusNode.dispose();
    super.dispose();
  }

  String get _typingLabel {
    if (_activeReplyIndex != null && _activeReplyIndex! < _messages.length) {
      final msg = _messages[_activeReplyIndex!];
      if (msg.phaseTitle != null) return msg.phaseTitle!;
      // 툴 표시는 raw ToolCall/ToolResult 스트림(currentToolIndicator)이 소유하되,
      // "지금 실행 중(pending)인 툴이 있을 때"만 보여준다. 툴이 끝나면 아래 progress
      // (생각/기억)로 떨어져, 마지막 툴명이 턴 끝까지 남지 않는다.
      if (msg.tools.any((t) => t.isPending) &&
          msg.currentToolIndicator != null) {
        return msg.currentToolIndicator!;
      }
    }
    // progress는 raw 이벤트가 없는 구간(생각 중 / 기억 검색)만 채운다.
    if (_currentProgressLabel != null) return _currentProgressLabel!;
    final phase = _currentPhase;
    if (phase is AgentTurnPhaseValidation || phase is AgentTurnPhaseUnknown) {
      return '답변을 검토하는 중입니다.';
    }
    if (phase is AgentTurnPhasePrompt) {
      return '요청을 분석하는 중입니다.';
    }
    return '응답을 기다리는 중입니다.';
  }

  void _appendElapsedToLastMessage() {
    final start = _requestStartTime;
    _requestStartTime = null;
    if (start == null) return;
    // _finalizeActiveReply() sets elapsedSeconds at TurnComplete.
    // This is a fallback for edge cases (e.g. ThreadComplete without TurnComplete).
    for (int i = _messages.length - 1; i >= 0; i--) {
      if (_messages[i].type == MessageType.received) {
        final msg = _messages[i];
        if (msg.elapsedSeconds == null) {
          _messages[i] = ChatMessage(
            text: msg.text,
            type: msg.type,
            senderInitial: msg.senderInitial,
            isWaiting: msg.isWaiting,
            displayType: msg.displayType,
            uiCode: msg.uiCode,
            actionButtons: msg.actionButtons,
            phaseTitle: msg.phaseTitle,
            tools: msg.tools,
            validationPassed: msg.validationPassed,
            currentToolIndicator: msg.currentToolIndicator,
            elapsedSeconds: DateTime.now().difference(start).inSeconds,
          );
        }
        break;
      }
    }
  }

  // ────────────────────────────────────────────────────────────
  // Build
  // ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final bool showActionBar = !_isAgentBusy && _currentActionButtons.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Focus(
        focusNode: _keyboardFocusNode,
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event.logicalKey == LogicalKeyboardKey.escape ||
              event.logicalKey == LogicalKeyboardKey.goBack ||
              event.logicalKey == LogicalKeyboardKey.browserBack) {
            if (event is KeyDownEvent) {
              if (_isAgentBusy) {
                _handleInterrupt();
              } else {
                SystemNavigator.pop();
              }
            }
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: SizedBox.expand(
          child: Stack(
            children: [
              if (_hasChatStarted)
                Positioned(
                  bottom: 30.0,
                  left: 20.0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      _speechFadeController,
                      _speechSlideController,
                    ]),
                    builder: (context, child) => Opacity(
                      opacity: _speechFadeController.value,
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          -_speechSlideController.value * _speechSlideDistance,
                        ),
                        child: child,
                      ),
                    ),
                    child: AgentPanel(
                      lastSentText: _lastSentText,
                      agentWindowKey: _agentWindowKey,
                      focusNode: _chatScrollFocusNode,
                      onScrolledToBottomDown: () =>
                          _actionBarKey.currentState?.focusFirstButton(),
                      messages: _messages,
                      isConnecting: !_isGrpcReady,
                      isThreadInFlight: _isAgentBusy,
                      typingLabel: _typingLabel,
                      requestStartTime: _requestStartTime,
                      actionButtons:
                          showActionBar ? _currentActionButtons : const [],
                      onSend: _handleSend,
                      actionBarKey: _actionBarKey,
                      onArrowUp: _focusAgentWindow,
                      onArrowDown: _focusAgentWindow,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One in-flight submission held in the pending slot. The slot can hold
/// at most one of these at a time — second submissions are rejected by
/// `_handleSend` until this resolves.
class _PendingSubmission {
  final String text;
  final String reqId;

  /// True = adapter was asked to inject mid-turn. False = adapter was asked to
  /// queue behind the current request. Argot v1 supports neither today.
  final bool steer;
  final DateTime submittedAt;

  _PendingSubmission({
    required this.text,
    required this.reqId,
    required this.steer,
    required this.submittedAt,
  });
}

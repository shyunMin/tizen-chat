import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/tizen_styles.dart';
import 'package:tizen_app_control/tizen_app_control.dart';
import 'dart:convert';
import '../widgets/chat_window.dart';
import '../widgets/action_button_bar.dart';
import '../widgets/prompt_bar.dart';
import '../services/carbon_grpc_service.dart';
import '../generated/carbon/v2/ingress_service.pbenum.dart';
import '../platform/platform_flags.dart' as platform_flags;
import '../platform/platform_flags.dart' show kIsTizen, BubbleMode;
import '../models/chat_message.dart';
import '../services/agent_response_parser.dart';
import 'dart:async';
import '../features/http_message_overlay/http_message_bus.dart';
import '../services/window_focus_service.dart';
import '../services/onboarding_grpc_service.dart';
import '../services/setup_http_server.dart';
import 'onboarding_screen.dart';
import '../utils/elapsed_timer.dart';

class TizenChatHomeScreen extends StatefulWidget {
  final bool enableHttpMessageBus;
  const TizenChatHomeScreen({super.key, this.enableHttpMessageBus = true});

  @override
  State<TizenChatHomeScreen> createState() => _TizenChatHomeScreenState();
}

class _TizenChatHomeScreenState extends State<TizenChatHomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // ── UI 상태 ──────────────────────────────────────────────────
  bool _isVisible = false;
  bool _isVoiceKeyPressed = false;
  bool _isPromptBarVisible = false;
  bool _promptBarFocused = false;
  Timer? _voiceKeyReleaseTimer;

  // ── 대화창 상태 ──────────────────────────────────────────────
  bool _hasChatStarted = false;
  final List<ChatMessage> _messages = [];
  DateTime? _requestStartTime;
  final GlobalKey<ChatWindowState> _chatWindowKey =
      GlobalKey<ChatWindowState>();
  final GlobalKey<ActionButtonBarState> _actionBarKey =
      GlobalKey<ActionButtonBarState>();

  bool _isGrpcReady = false;
  bool _interruptRequested = false;

  // ── 서비스 ───────────────────────────────────────────────────
  final FocusNode _keyboardFocusNode = FocusNode();
  final FocusNode _chatScrollFocusNode = FocusNode();
  final FocusNode _promptBarFocusNode = FocusNode();
  final CarbonGrpcService _grpcService = CarbonGrpcService.instance;
  StreamSubscription<String>? _messageBusSubscription;
  StreamSubscription<CarbonEvent>? _eventSubscription;
  final Completer<bool> _initCompleter = Completer<bool>();
  bool _hasPendingAppControl = false;
  DateTime? _speechStartTimestamp;

  // ── 진행 중인 응답 추적 ───────────────────────────────────────
  // Steer-based UX: turn 한 번에 agent reply 버블도 한 개로 유지한다.
  // 사용자가 mid-turn 에 새 프롬프트를 보내면 _handleSend 가 새 user
  // 버블을 _activeReplyIndex 위치에 insert 하고 _activeReplyIndex 를
  // 한 칸 증가시켜 같은 agent 버블을 계속 가리키게 한다. 결과적으로
  // 들어오는 모든 delta(직전 round 의 trailing 포함)가 한 버블에
  // 누적된다. null = 진행 중인 응답 없음.
  int? _activeReplyIndex;
  String _currentSegmentText = '';

  /// Inline "🔧 toolName 실행 중..." overlay shown inside the active
  /// reply bubble's text. Cleared on tool result. The persistent tool
  /// history per turn lives on ChatMessage.tools (rendered as a list
  /// inside the bubble) — this field only drives the in-bubble
  /// "currently running" hint.
  String? _activeToolName;

  /// Phase metadata of the in-flight turn (captured on CarbonTurnStarted,
  /// cleared on CarbonTurnComplete). The bubble that materializes for
  /// this turn — lazily, on the first delta / tool — gets this phase as
  /// its header title.
  CarbonTurnPhase? _currentPhase;

  /// Stash a successful ValidationCompleted result that arrived before
  /// the validation-phase bubble materialized (the assistant's final-
  /// answer delta usually lands a few ms after). Applied to the next
  /// bubble created within the same turn.
  bool _pendingValidationPassed = false;

  // Thread-level "agent is doing something" flag for the spinner UI.
  // Goes true on the first Submit of a thread, stays true through
  // round-boundary gaps (between TurnComplete and the next TurnStarted —
  // e.g. steer-recovery), and only clears on ThreadCompleted / fatal
  // error / SessionEnded. Without this the spinner blinks off whenever
  // the active reply bubble seals while another turn is about to spin
  // up, giving the impression that the agent stopped.
  bool _isAgentBusy = false;

  // ── Pending submission slot ───────────────────────────────────
  // While the daemon is processing a turn, a new submission lands here
  // instead of immediately becoming a user bubble. The slot holds at
  // most one entry (UI constraint — see /plan-eng-review discussion).
  // It releases when:
  //   - steer mode:  the next CarbonTurnComplete arrives (means the
  //                  daemon drained its steer queue at the next round
  //                  boundary and ran another LLM call). Safety net:
  //                  CarbonThreadComplete unconditionally clears too.
  //   - queue mode:  CarbonTurnStarted with the matching client_request_id
  //                  arrives (the queued submission has been popped and
  //                  started as a new turn).
  // On release the user bubble materializes at the bottom of the chat
  // and the input is unlocked.
  _PendingSubmission? _pending;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
          setState(() {
            _isVisible = true;
            _isPromptBarVisible = true;
          });
          _focusPromptBar();
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
          setState(() {
            _isVisible = true;
            _isVoiceKeyPressed = true;
            _isPromptBarVisible = false;
          });
        }
      } else if (eventType == 'SPEECH_END') {
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
          // 실제 메시지 → 요청 전달 (기준 시간 포함, 초기화는 ThreadComplete에서)
          final referenceTime = _speechStartTimestamp;
          if (mounted) setState(() => _isVoiceKeyPressed = false);
          if (!initOk) {
            debugPrint('[AppControl] Onboarding incomplete — showing error');
            if (mounted) {
              setState(() {
                _isVisible = true;
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
        } else {
          // 메시지 없음 → 음성 인식 실패 (NO_SPEECH 대체), 기준 시간은 유지
          _voiceKeyReleaseTimer?.cancel();
          if (mounted) {
            setState(() {
              _isVoiceKeyPressed = false;
              if (!_isAgentBusy) _isPromptBarVisible = true;
            });
          }
        }
      } else {
        debugPrint('[AppControl] Unknown or missing eventType, ignoring.');
      }
    } catch (e) {
      debugPrint('[AppControl] Error processing extraData: $e');
      if (mounted) setState(() => _isVisible = true);
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

      // 3. 화면 표시 (gRPC 연결 전 — 비활성 상태)
      // AppControl 없는 경우만 PromptBar 노출. AppControl 경로는 _handleSend 후 ChatWindow만 표시.
      if (mounted) {
        setState(() {
          _isVisible = true;
          _isPromptBarVisible = !_hasPendingAppControl;
        });
        if (!_hasPendingAppControl) {
          unawaited(WindowFocusService.grabNavigationKeys());
          _focusPromptBar();
        }
      }

      // 4. gRPC 연결 (실패 시 daemon 재시작 대기 포함)
      await _grpcService.connect(sessionName: sessionName);
      if (!_grpcService.isConnected) {
        await _grpcService.reconnect();
      }

      // 5. 연결 완료 → PromptBar 활성화
      if (mounted) {
        setState(() => _isGrpcReady = true);
        if (!_hasPendingAppControl) {
          // 일반 실행: nav 키 grab + PromptBar 포커스 (케이스 1)
          unawaited(WindowFocusService.grabNavigationKeys());
          _focusPromptBar();
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
    final onboardingService = OnboardingGrpcService();
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
    setState(() {
      _isAgentBusy = true;
      _isPromptBarVisible = false;
    });
    _focusChatWindow();

    if (!turnBusy) {
      // Idle daemon: clear immediately and start fresh.
      setState(() {
        _messages.clear();
        _activeReplyIndex = null;
        _currentSegmentText = '';
        _activeToolName = null;
        _currentPhase = null;
        _pendingValidationPassed = false;
      });
      _materializeUserBubble();
      unawaited(
        _grpcService.sendPrompt(
          text,
          steer: steer,
          referenceTime: referenceTime,
        ),
      );
      return;
    }

    // Busy daemon (steer): don't clear yet. A's ongoing output stays
    // visible until SteerApplied confirms the steer took effect — that's
    // when _applySteerSplit wipes the display and the post-steer output
    // starts a clean new bubble.
    final reqId = await _grpcService.sendPrompt(
      text,
      steer: steer,
      referenceTime: referenceTime,
    );
    if (reqId == null) {
      return;
    }
    setState(() {
      _isVisible = true;
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
      _isPromptBarVisible = true;
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
  }

  void _materializeUserBubble() {
    setState(() {
      if (!_hasChatStarted) {
        _hasChatStarted = true;
        debugPrint('[Chat] First message!');
      }
      _isVisible = true;
    });
    unawaited(WindowFocusService.ungrabNavigationKeys());
  }

  /// SteerApplied: A's pre-steer output is discarded and the display is
  /// cleared. The next delta will open a fresh bubble for B's result.
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

  void _handleAgentEvent(CarbonEvent event) {
    if (!mounted) return;

    switch (event) {
      case CarbonTextDelta(:final content):
        _appendDelta(content);
        break;

      case CarbonMessageFinalized():
        _onMessageFinalized(event);
        break;

      case CarbonToolUseStart(
        :final toolName,
        :final toolCallId,
        :final argumentsJson,
      ):
        // Indicator is derived from bubble.tools (computed via
        // _computeIndicator), so _recordToolStart alone handles both
        // adding the entry and refreshing the indicator.
        _activeToolName = toolName; // kept for legacy refresh-gate logic
        _recordToolStart(toolCallId, toolName, argumentsJson);
        break;

      case CarbonToolResult(:final toolCallId, :final output, :final isError):
        // Indicator advance is driven by _computeIndicator inside
        // _recordToolResult — once the matching entry's outputPreview
        // is populated, the next pending tool (if any) becomes the
        // active indicator, or null clears it.
        _recordToolResult(toolCallId, output, isError);
        break;

      case CarbonTurnComplete():
        // Slice C/E daemon model: each plan phase / validation gate is
        // its own turn, so TurnComplete = bubble seal boundary. (The
        // earlier "do nothing here" comment applied to the pre-Slice-B
        // daemon that emitted multiple TurnCompleted per logical turn —
        // no longer.)
        if (_activeReplyIndex != null) {
          _finalizeActiveReply();
        }
        // Phase ends here; next CarbonTurnStarted will set a new one.
        _currentPhase = null;
        break;

      case CarbonSteerApplied(:final clientRequestId):
        // Real signal from the daemon: the steer queue drained at a
        // round boundary and our prompt is now in the live agent loop.
        // Release the pending slot iff this confirmation is for our
        // submission (other clients can steer the same turn).
        if (_pending != null &&
            _pending!.steer &&
            _pending!.reqId == clientRequestId) {
          _applySteerSplit();
        }
        break;

      case CarbonSteerFailed(:final clientRequestId, :final reason):
        // Daemon couldn't land the steer on the originally-targeted
        // turn (typically late-recovery re-injection). The submission
        // is preserved on the daemon side — it'll surface in a later
        // turn — so release the slot and tell the user it slipped.
        if (_pending != null &&
            _pending!.steer &&
            _pending!.reqId == clientRequestId) {
          _resolvePending('SteerFailed: $reason');
        }
        break;

      case CarbonSubmitQueued():
        // No UI action: the pending bubble was already placed
        // synchronously inside _handleSend. It'll resolve later when
        // the queued submission pops as a fresh TurnStarted (matched
        // by client_request_id below).
        break;

      case CarbonSubmitSteered():
        // No UI action: this is the wire receipt of "daemon accepted
        // into steer queue". The user-visible release happens later on
        // CarbonSteerApplied (drained at round boundary).
        break;

      case CarbonTurnStarted(:final clientRequestId, :final phase):
        if (_pending != null &&
            !_pending!.steer &&
            _pending!.reqId == clientRequestId) {
          _resolvePending('TurnStarted (queued popped)');
        }
        debugPrint('[Chat] TurnStarted phase=${phase.title() ?? "(none)"}');
        _currentPhase = phase;
        setState(() {
          _messages.clear();
          _activeReplyIndex = null;
          _currentSegmentText = '';
          _activeToolName = null;
          _pendingValidationPassed = false;
        });
        if (phase.title() != null && phase is! CarbonTurnPhasePrompt) {
          setState(() {
            _materializeAgentBubble('', isWaiting: true);
          });
        }
        break;

      case CarbonThreadComplete():
        // Safety net 1: if a pending submission never resolved (steer
        // dropped on the floor, queue never popped), free the slot.
        if (_pending != null) {
          _resolvePending('ThreadComplete (safety net)');
        }
        // Safety net 2: a trailing un-finalized bubble (single mode +
        // validation continuation: the dedupe swallows round-2+
        // TurnCompleted, so a round-2 bubble keeps isWaiting=true
        // until thread end seals it).
        if (_activeReplyIndex != null) {
          _finalizeActiveReply();
        }
        // Thread done → kill the spinner. This is the ONLY happy-path
        // clear; per-round TurnComplete intentionally does NOT clear it
        // so the spinner stays on through round-boundary gaps (e.g.
        // steer-recovery turn spinning up after the first turn ends).
        if (_isAgentBusy) {
          _appendElapsedToLastMessage();
          _speechStartTimestamp = null;
          setState(() {
            _isAgentBusy = false;
            _isPromptBarVisible = true;
          });
          _scrollToBottom();
        }
        // 처리 완료: nav 키 재grab + ChatWindow 포커스 유지 (케이스 3)
        unawaited(WindowFocusService.grabNavigationKeys());
        _focusChatWindow();
        break;

      case CarbonContinuationRequested(:final reason, :final message):
        // Slice C/E daemon: each phase is its own turn, so the per-turn
        // bubble was already sealed by the preceding TurnCompleted.
        // No segment reset needed here — the next phase's TurnStarted
        // sets a new _currentPhase and the next delta/tool will
        // materialize a fresh bubble.
        debugPrint(
          '[Chat] ContinuationRequested reason=$reason msg=${message.length > 80 ? "${message.substring(0, 80)}..." : message}',
        );
        break;

      case CarbonValidationStarted():
        // Informational — could surface as a sub-indicator inside the
        // active reply bubble (e.g. "검증 중…"). For now we just log;
        // the thread-level spinner stays on regardless.
        break;

      case CarbonValidationCompleted(
        :final passed,
        :final attempt,
        :final reason,
      ):
        // Mark the validation phase's bubble with a ✓ check when the
        // validator accepts the turn. The bubble may not yet exist (the
        // validation turn often only materializes after the assistant
        // emits the final-answer delta), so we also stash the latest
        // result on _pendingValidationPassed for the next bubble that
        // lands inside this same turn.
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

      case CarbonError(:final code, :final message, :final fatal):
        // 로컬에서 이미 중단 처리한 경우 서버의 cancelled 이벤트는 무시
        if (_interruptRequested && code == 'cancelled') {
          _interruptRequested = false;
          break;
        }
        // continuation:* Error codes were the pre-Slice-B path for
        // continuation notices. Slice B promoted them to typed
        // ContinuationRequested wire bodies, so this guard is now a
        // backwards-compat catch-all for daemons that haven't shipped
        // Slice B yet.
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

      case CarbonSessionEnded():
        if (_pending != null) {
          _resolvePending('SessionEnded');
        }
        if (_isAgentBusy) {
          _speechStartTimestamp = null;
          setState(() {
            _isAgentBusy = false;
            _isPromptBarVisible = true;
          });
        }
        unawaited(WindowFocusService.grabNavigationKeys());
        _grpcService.reconnect();
        break;

      case CarbonToolApprovalRequest(:final approvalId, :final toolName):
        debugPrint(
          '[Chat] ToolApprovalRequest received for $toolName — auto-approving',
        );
        _grpcService.approveToolCall(
          approvalId,
          ApprovalDecision.APPROVAL_DECISION_APPROVE,
        );
        break;
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Bubble layout — V1 (single morphing) vs V2 (multi, finalize-driven).
  // See platform_flags.dart kBubbleMode for the build switch.
  //
  // Shared state:
  //   _currentSegmentText — accumulated text of the *current* block
  //   _activeReplyIndex   — index of the bubble currently being mutated
  //   _activeToolName     — current tool indicator (null = none)
  //
  // V1: a single bubble per turn. _currentSegmentText accumulates EVERY
  //     TextDelta in the turn; MessageFinalized is ignored for bubble
  //     boundaries. Commentary stays visible through tool calls.
  //
  // V2: a bubble per finalized assistant message. MessageFinalized seals
  //     the active bubble; the next TextDelta starts a fresh one. Tool
  //     indicators live inside whichever bubble is active when the tool
  //     fires.
  // ─────────────────────────────────────────────────────────────

  /// Push the screen-level "in-flight turn" state (_currentSegmentText,
  /// bubble.tools) onto the active bubble. The bubble has TWO regions:
  /// a tool indicator (computed from the bubble's tools list — picks
  /// the first not-yet-completed entry so the user can see exactly
  /// which call is running right now) and a text region (append-only
  /// as deltas stream). At TurnComplete the indicator is dropped,
  /// leaving only the text.
  void _refreshActiveBubble({required bool isWaiting}) {
    setState(() {
      if (_activeReplyIndex == null) {
        if (_currentSegmentText.isEmpty && _activeToolName == null) return;
        // TurnStarted 없이 델타가 도달하는 경우(continuation 경로 등)
        // 이전 봉인된 버블이 남아있을 수 있으므로 먼저 정리한다.
        _messages.clear();
        _materializeAgentBubble('', isWaiting: isWaiting);
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
    // the LAST tool of the turn — TurnCompleted is the only event that
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

  /// Create the bubble for the in-flight turn. Used by [_refreshActiveBubble]
  /// when the first text delta arrives, and by [_recordToolStart] when the
  /// turn opens with a tool call (no text). Carries the current phase
  /// title onto the bubble so each turn's bubble renders its own header.
  void _materializeAgentBubble(String text, {required bool isWaiting}) {
    final phaseTitle = (_currentPhase is CarbonTurnPhasePrompt)
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
      '[Chat] new agent bubble appended (idx=$_activeReplyIndex) phase=${phaseTitle ?? "(none)"}',
    );
  }

  /// Append a new tool entry to the active bubble's tool list. Creates
  /// the bubble lazily if this is the first event of the turn (some
  /// phases open straight with a tool call before any narration).
  void _recordToolStart(String toolCallId, String toolName, String argsJson) {
    setState(() {
      if (_activeReplyIndex == null) {
        _materializeAgentBubble('', isWaiting: true);
      }
      final bubble = _messages[_activeReplyIndex!];
      bubble.tools.add(
        TurnToolEntry(
          toolCallId: toolCallId,
          toolName: toolName,
          argumentsPreview: _summarizeArgsJson(argsJson),
        ),
      );
      bubble.isWaiting = true;
      // Recompute the indicator from the up-to-date tools list so the
      // new entry's name + arg shows immediately (or, if a prior tool
      // is still mid-flight per outputPreview==null, keep that one).
      bubble.currentToolIndicator = _computeIndicator(bubble.tools);
    });
  }

  /// Complete the matching tool entry on the active bubble. Matches by
  /// [toolCallId] so out-of-order results stay attached to the right call.
  /// Advances the indicator to the next pending tool (carbon emits all
  /// ToolUseStart upfront, then ToolResults sequentially as each
  /// executes, so the "currently running" tool is whichever pending
  /// entry comes first in the list).
  void _recordToolResult(String toolCallId, String output, bool isError) {
    if (_activeReplyIndex == null) return;
    setState(() {
      final bubble = _messages[_activeReplyIndex!];
      for (final t in bubble.tools) {
        if (t.toolCallId == toolCallId) {
          t.outputPreview = _summarizeToolOutput(output);
          t.isError = isError;
          break;
        }
      }
      bubble.currentToolIndicator = _computeIndicator(bubble.tools);
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
    _refreshActiveBubble(isWaiting: true);
  }

  void _onMessageFinalized(CarbonMessageFinalized event) {
    if (platform_flags.kBubbleMode != BubbleMode.multi) return;
    // V2 with phase-aware sealing (option C): Commentary blocks are
    // intermediate reasoning that interleaves with tool calls. Sealing
    // on every Commentary makes the tool indicator vanish before the
    // user can see it (daemon emits ToolUseStart → MessageFinalized
    // milliseconds apart). Only seal on FinalAnswer — that's the
    // explicit "this is the user-visible answer block" signal from the
    // daemon. Commentary blocks keep accumulating into the same active
    // bubble until FinalAnswer (or TurnComplete) closes it out.
    // In the per-phase bubble model, MessageFinalized is just a
    // message-block boundary marker — not the bubble seal moment. The
    // bubble is owned by TurnStarted (creates) and TurnCompleted
    // (seals). Dropping phase header here was killing the header for
    // every Prompt-phase final answer too — exactly the regression the
    // user spotted. So no-op now; the seal logic lives in
    // _finalizeActiveReply.
    return;
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
    if (_currentSegmentText.isNotEmpty) {
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
        // Drop the tool indicator: turn is done, no tool is running.
        // The text region (or tool summary above) carries the result.
        currentToolIndicator: null,
      );
    });
    _activeToolName = null;
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
      _isPromptBarVisible = true;
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
        } else if (_messages.isNotEmpty) {
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
    _focusChatWindow();

    if ((fatal && code != 'cancelled') || code == 'NO_SESSION') {
      await _grpcService.reconnect();
    }
  }

  void _scrollToBottom() {
    _chatWindowKey.currentState?.scrollToBottom();
  }

  void _focusPromptBar() {
    setState(() => _promptBarFocused = true);
    _promptBarFocusNode.requestFocus();
  }

  void _focusChatWindow() {
    setState(() => _promptBarFocused = false);
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
    final onboardingService = OnboardingGrpcService();
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageBusSubscription?.cancel();
    _eventSubscription?.cancel();
    _voiceKeyReleaseTimer?.cancel();
    HttpMessageBus.instance.release();
    _keyboardFocusNode.dispose();
    _chatScrollFocusNode.dispose();
    _promptBarFocusNode.dispose();
    super.dispose();
  }

  String get _typingLabel {
    if (_activeReplyIndex != null && _activeReplyIndex! < _messages.length) {
      final msg = _messages[_activeReplyIndex!];
      if (msg.phaseTitle != null) return msg.phaseTitle!;
      if (msg.currentToolIndicator != null) return msg.currentToolIndicator!;
    }
    final phase = _currentPhase;
    if (phase is CarbonTurnPhaseValidation || phase is CarbonTurnPhaseUnknown) {
      return '답변을 검토하는 중입니다.';
    }
    if (phase is CarbonTurnPhasePrompt) {
      return '요청을 분석하는 중입니다.';
    }
    return '다음 단계를 준비하는 중입니다.';
  }

  void _appendElapsedToLastMessage() {
    final start = _requestStartTime;
    if (start == null) return;
    final label = 'Worked · ${ElapsedTimer.format(start)}';

    for (int i = _messages.length - 1; i >= 0; i--) {
      if (_messages[i].type == MessageType.received) {
        final msg = _messages[i];
        _messages[i] = ChatMessage(
          text: '${msg.text}\n\n$label',
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
        );
        break;
      }
    }
    _requestStartTime = null;
  }

  // ────────────────────────────────────────────────────────────
  // Build
  // ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bool hasButtons = _currentActionButtons.isNotEmpty;

    // 표시 여부 플래그
    final bool showPromptBar = _isVisible && _isPromptBarVisible;
    final bool chatWindowOnScreen =
        _isVisible && (_hasChatStarted || _isAgentBusy);
    // ActionBar: 요청 중(threadInFlight)일 때만 숨김. voice key pressed는 영향 없음.
    final bool showActionBar =
        _isVisible && _hasChatStarted && !_isAgentBusy && hasButtons;

    // ActionButtonBar: PromptBar 위 고정 위치
    const double actionBarTargetBottom = TizenStyles.chatWindowBottomBase;

    // ChatWindow 위치:
    // - chatWindowOnScreen=false: 화면 밖
    // - voice key 누름 중: 이전 위치 유지 (PromptBar가 있을 때의 위치)
    // - PromptBar 표시: 98 (버튼 없음) / 158 (버튼 있음)
    // - PromptBar 숨김 (요청 중 / voice key release 후): bottom=10
    final double chatWindowTargetBottom;
    if (!chatWindowOnScreen) {
      chatWindowTargetBottom = -screenHeight;
    } else if (_isVoiceKeyPressed) {
      chatWindowTargetBottom = hasButtons
          ? TizenStyles.chatWindowBottomWithActions
          : TizenStyles.chatWindowBottomBase;
    } else if (showPromptBar) {
      chatWindowTargetBottom = showActionBar
          ? TizenStyles.chatWindowBottomWithActions
          : TizenStyles.chatWindowBottomBase;
    } else {
      chatWindowTargetBottom = TizenStyles.promptBarBottom;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Focus(
        focusNode: _keyboardFocusNode,
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event.logicalKey.keyLabel == 'XF86BTVoice' ||
              event.logicalKey.debugName == 'XF86BTVoice' ||
              event.logicalKey.keyId == 137438953472) {
            if (event is KeyDownEvent && !_isVoiceKeyPressed) {
              _voiceKeyReleaseTimer?.cancel();
              setState(() {
                _isVoiceKeyPressed = true;
                _isPromptBarVisible = false;
              });
            } else if (event is KeyUpEvent && _isVoiceKeyPressed) {
              _voiceKeyReleaseTimer?.cancel();
              _voiceKeyReleaseTimer = Timer(const Duration(seconds: 1), () {
                if (mounted) {
                  setState(() {
                    _isVoiceKeyPressed = false;
                    if (!_isAgentBusy) _isPromptBarVisible = true;
                  });
                }
              });
            }
            return KeyEventResult.ignored;
          }

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
            // KeyRepeat / KeyUp 도 handled 로 반환해 플랫폼이 앱 종료하지 않도록 차단
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: SizedBox.expand(
          child: Stack(
            children: [
              // ── PromptBar ─────────────────────────────────────
              Positioned(
                bottom: TizenStyles.promptBarBottom,
                left: TizenStyles.promptBarLeft,
                child: IgnorePointer(
                  ignoring: !showPromptBar,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    opacity: showPromptBar ? 1.0 : 0.0,
                    child: PromptBar(
                      isVisible: _isVisible,
                      isConnecting: !_isGrpcReady,
                      isWaiting: _isAgentBusy,
                      hasChatStarted: _hasChatStarted,
                      isFocused: _promptBarFocused,
                      outerFocusNode: _promptBarFocusNode,
                      onSend: _handleSend,
                      onCancel: _handleInterrupt,
                      onArrowUp: _focusChatWindow,
                    ),
                  ),
                ),
              ),

              // ── ActionButtonBar ───────────────────────────────
              if (showActionBar)
                Positioned(
                  bottom: actionBarTargetBottom,
                  left: 0,
                  right: 0,
                  child: ActionButtonBar(
                    key: _actionBarKey,
                    buttons: _currentActionButtons,
                    onSend: _handleSend,
                    onArrowUp: _focusChatWindow,
                    onArrowDown: _focusPromptBar,
                  ),
                ),

              // ── ChatWindow ───────────────────────────────────
              AnimatedPositioned(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                bottom: chatWindowTargetBottom,
                left: TizenStyles.promptBarLeft,
                child: ChatWindow(
                  key: _chatWindowKey,
                  focusNode: _chatScrollFocusNode,
                  onScrolledToBottomDown: () {
                    if (showActionBar) {
                      _actionBarKey.currentState?.focusFirstButton();
                    } else if (showPromptBar) {
                      _focusPromptBar();
                    }
                  },
                  messages: _messages,
                  isConnecting: !_isGrpcReady,
                  isThreadInFlight: _isAgentBusy,
                  typingLabel: _typingLabel,
                  requestStartTime: _requestStartTime,
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

  /// True = daemon was asked to inject mid-turn (steer queue). False =
  /// daemon was asked to queue behind the current thread.
  final bool steer;
  final DateTime submittedAt;

  _PendingSubmission({
    required this.text,
    required this.reqId,
    required this.steer,
    required this.submittedAt,
  });
}

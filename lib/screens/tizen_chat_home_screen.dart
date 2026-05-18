import 'package:ai_chat/widgets/prompt_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/tizen_styles.dart';
import 'package:tizen_app_control/tizen_app_control.dart';
import 'dart:convert';
import '../widgets/chat_window.dart';
import '../widgets/action_button_bar.dart';
import '../services/carbon_grpc_service.dart';
import '../generated/carbon/v2/ingress_service.pbenum.dart';
import '../platform/platform_flags.dart' as platform_flags;
import '../platform/platform_flags.dart' show kIsTizen, BubbleMode;
import '../services/session_repository.dart';
import '../models/chat_message.dart';
import '../services/agent_response_parser.dart';
import 'dart:async';
import '../features/http_message_overlay/http_message_bus.dart';
import '../services/window_focus_service.dart';
import '../services/onboarding_grpc_service.dart';
import '../services/setup_http_server.dart';
import 'onboarding_screen.dart';

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
  bool _isWaiting = false;
  bool _isVoiceKeyPressed = false;
  bool _isKeyboardFocused = false;

  // ── 대화창 상태 ──────────────────────────────────────────────
  bool _hasChatStarted = false;
  bool _isTyping = false;
  final List<ChatMessage> _messages = [];
  String _sessionTitle = '';
  final GlobalKey<ChatWindowState> _chatWindowKey =
      GlobalKey<ChatWindowState>();
  final GlobalKey<ActionButtonBarState> _actionBarKey =
      GlobalKey<ActionButtonBarState>();

  bool _isGrpcReady = false;

  // ── 서비스 ───────────────────────────────────────────────────
  final FocusNode _keyboardFocusNode = FocusNode();
  final FocusNode _promptBarFocusNode = FocusNode();
  final FocusNode _chatScrollFocusNode = FocusNode();
  final CarbonGrpcService _grpcService = CarbonGrpcService.instance;
  StreamSubscription<String>? _messageBusSubscription;
  StreamSubscription<CarbonEvent>? _eventSubscription;
  final Completer<bool> _initCompleter = Completer<bool>();
  bool _hasPendingAppControl = false;

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
  bool _threadInFlight = false;

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
          unawaited(WindowFocusService.setFocusable(true));
          setState(() => _isVisible = true);
          _promptBarFocusNode.requestFocus();
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
      String? messageText;

      // 1. 직접적인 'message' 키 확인
      if (extraData.containsKey('message')) {
        final msg = extraData['message'];
        if (msg is List && msg.isNotEmpty) {
          messageText = msg.first.toString();
        } else {
          messageText = msg.toString();
        }
        debugPrint('[AppControl] Found message in direct key: $messageText');
      }

      // 2. JSON 형태나 기타 키 순회 확인 (위에서 못 찾은 경우)
      if (messageText == null || messageText.isEmpty) {
        for (var entry in extraData.entries) {
          final keyStr = entry.key;
          final valStr = entry.value is List && entry.value.isNotEmpty
              ? entry.value.first.toString()
              : entry.value.toString();

          // Value가 JSON인 경우
          try {
            final decodedVal = jsonDecode(valStr);
            if (decodedVal is Map && decodedVal.containsKey('message')) {
              messageText = decodedVal['message'];
              debugPrint(
                '[AppControl] Found message in decoded value: $messageText',
              );
              break;
            }
          } catch (_) {}

          // Key가 JSON인 경우
          try {
            final decodedKey = jsonDecode(keyStr);
            if (decodedKey is Map && decodedKey.containsKey('message')) {
              messageText = decodedKey['message'];
              debugPrint(
                '[AppControl] Found message in decoded key: $messageText',
              );
              break;
            }
          } catch (_) {}
        }
      }

      if (messageText != null && messageText.isNotEmpty) {
        if (!initOk) {
          // 온보딩 미완료: 요청 메시지를 보여주고 에러 응답 표시
          debugPrint('[AppControl] Onboarding incomplete — showing error');
          if (mounted) {
            setState(() {
              _isVisible = true;
              _hasChatStarted = true;
              _messages.addAll([
                ChatMessage(text: messageText!, type: MessageType.sent),
                ChatMessage(
                  text: 'API 키 설정이 완료되지 않아 요청을 처리할 수 없습니다.\n설정을 완료한 후 다시 시도해 주세요.',
                  type: MessageType.received,
                ),
              ]);
            });
            _scrollToBottom();
          }
        } else {
          debugPrint('[AppControl] Proceeding to _handleSend: $messageText');
          if (mounted) _handleSend(messageText);
        }
      } else {
        debugPrint('[AppControl] No message content found in extraData.');
        if (mounted) setState(() => _isVisible = true);
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

      // 2. 오늘 날짜 세션 확보 + 로컬 목록에 기록
      final sessionName = await SessionRepository.instance.ensureTodaySession();
      debugPrint('[Init] Session name: $sessionName');
      if (mounted) setState(() => _sessionTitle = sessionName);

      // 3. PromptBar 표시 (gRPC 연결 전 — 비활성 상태)
      // AppControl 대기 중이어도 온보딩 완료 후 복귀 시 화면을 보여줘야 한다.
      if (mounted) {
        if (!_hasPendingAppControl) unawaited(WindowFocusService.setFocusable(true));
        setState(() => _isVisible = true);
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
          // 요청 없는 일반 실행: 앱이 준비된 시점에 윈도우 포커스를 명시적으로
          // 확보한다. AppControl 경로는 _handleSend → setFocusable(false) →
          // ThreadComplete → setFocusable(true) 순으로 처리되므로 여기서 제외.
          unawaited(WindowFocusService.setFocusable(true));
          _promptBarFocusNode.requestFocus();
        }
      }

      if (!_initCompleter.isCompleted) _initCompleter.complete(onboardingOk);
    } catch (e) {
      debugPrint('[Init] Error: $e');
      if (mounted) setState(() => _isGrpcReady = true);
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
        debugPrint('[ConfigCheck] App started. getConfig result: ready=${config.ready}, hasHint=${config.hint.isNotEmpty}');

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

  // ────────────────────────────────────────────────────────────
  // 메시지 전송 및 gRPC 이벤트 처리 (steer-based)
  // ────────────────────────────────────────────────────────────
  //
  // 흐름:
  //   _handleSend(text)
  //     ├─ 진행 중인 agent reply 버블이 있으면(_activeReplyIndex != null)
  //     │   사용자 버블을 그 버블 "바로 위"에 insert 하고 _activeReplyIndex 를
  //     │   한 칸 밀어 같은 버블을 계속 가리키게 한다. agent 버블은 그대로
  //     │   유지되고, round 경계 전후의 모든 delta 가 한 버블에 누적된다.
  //     ├─ 진행 중이 아니면(_activeReplyIndex == null) 사용자 버블을 끝에 append.
  //     └─ _grpcService.sendPrompt(text) — fire-and-forget. 응답은 globally
  //         구독 중인 _handleAgentEvent 로 들어온다.
  //
  // 결과 레이아웃 예 (mid-turn 에 B 가 들어온 경우):
  //   [user A]
  //   [user B]                ← _handleSend 가 agent 버블 위에 insert
  //   [agent (single, ongoing)]
  //
  // 왜 한 버블로 유지하는가: carbon 은 mid-turn steer 가 inject 되는 round
  // 경계를 proto 로 emit 하지 않아(`agent_main.rs:204` — `intent==RunTurn &&
  // !msg.steer` 일 때만 TurnStarted), 클라이언트는 "직전 round 의 trailing
  // delta" 와 "steer 후 round 의 새 응답" 을 구분할 수 없다. 굳이 새 버블로
  // 쪼개면 trailing delta 가 새 버블 머리에 잠깐 보였다가 본 응답으로
  // 이어지는 글리치가 생긴다. 한 버블로 두면 그 트랜지션이 그냥 같은
  // 버블 안에서 자연스러운 텍스트 흐름으로 보인다.

  Future<void> _handleSend(String text, {bool steer = true}) async {
    debugPrint(
      '[Chat] _handleSend called: text="${text.length > 40 ? "${text.substring(0, 40)}..." : text}" steer=$steer',
    );

    // 1-slot pending: refuse second submissions while one is in flight.
    if (_pending != null) {
      debugPrint('[Chat] _handleSend ignored — pending slot occupied');
      return;
    }

    final turnBusy = _grpcService.isTurnBusy;
    // Spinner stays on from prompt-sent until ThreadCompleted. Set BEFORE
    // both branches so the idle-daemon path also gets a stable spinner.
    setState(() => _threadInFlight = true);

    if (!turnBusy) {
      // Idle daemon → STARTED_NOW. Go straight to a finalized user bubble.
      _materializeUserBubble(text, isWaiting: false);
      unawaited(_grpcService.sendPrompt(text, steer: steer));
      return;
    }

    // Turn is in flight. Submit with the chosen mode (daemon routes to
    // its steer queue or post-thread queue). Place a "pending" user
    // bubble in the chat right away so the user can see what's been
    // sent — visually marked with a STEER/QUEUE prefix so the buffer
    // it landed in is obvious. The bubble gets rewritten to clean text
    // when the daemon's TurnComplete (steer) or TurnStarted (queue)
    // confirms pickup.
    final reqId = await _grpcService.sendPrompt(text, steer: steer);
    if (reqId == null) {
      _materializeUserBubble(text, isWaiting: false);
      return;
    }
    setState(() {
      _isVisible = true;
      // Append the pending bubble at the END of the chat (below any
      // active agent reply / tool indicator). Per UX spec: while
      // waiting, the queued prompt sits visually under the agent's
      // current activity. On resolve we leave the bubble in place —
      // the next round's agent bubble is appended AFTER it, producing
      // the natural "old turn → applied user prompt → new turn"
      // reading order.
      final index = _messages.length;
      _messages.insert(
        index,
        ChatMessage(
          text: _pendingBubbleText(text, steer),
          type: MessageType.sent,
          isWaiting: true,
        ),
      );
      _pending = _PendingSubmission(
        text: text,
        reqId: reqId,
        steer: steer,
        submittedAt: DateTime.now(),
        bubbleIndex: index,
      );
    });
    _scrollToBottom();
    debugPrint('[Chat] held in pending slot: $reqId');
    _logUiSnapshot('after-pending-insert');
  }

  String _pendingBubbleText(String text, bool steer) {
    final tag = steer ? '↪ STEER · 대기' : '⏳ QUEUE · 대기';
    return '$tag\n$text';
  }

  /// User bubble materialization for the idle-daemon path. (The pending
  /// path inserts its own bubble inside `_handleSend` so the pending
  /// state is visible while it waits.)
  void _materializeUserBubble(String text, {required bool isWaiting}) {
    final userBubble = ChatMessage(
      text: text,
      type: MessageType.sent,
      isWaiting: isWaiting,
    );
    setState(() {
      if (!_hasChatStarted) {
        _hasChatStarted = true;
        debugPrint('[Chat] First message! Session: $_sessionTitle');
      }
      _isVisible = true;
      _isWaiting = true;
      if (_activeReplyIndex == null) {
        _isTyping = true;
      }
      if (_activeReplyIndex != null) {
        _messages.insert(_activeReplyIndex!, userBubble);
        _activeReplyIndex = _activeReplyIndex! + 1;
      } else {
        _messages.add(userBubble);
      }
    });
    unawaited(WindowFocusService.setFocusable(false));
    _scrollToBottom();
  }

  /// SteerApplied-specific path: the daemon injected our prompt into the
  /// in-flight turn at a tool/result boundary, so the steer landed
  /// *between* the pre-steer assistant output and the post-steer
  /// continuation. The pending bubble currently sits at the end of the
  /// chat (below the still-streaming active reply); semantically it
  /// belongs between the now-sealed pre-steer reply and the next
  /// continuation. Snap the active reply at this point, slot the steer
  /// bubble right after it, and clear active-streaming state so the next
  /// delta opens a fresh post-steer bubble.
  void _applySteerSplit() {
    final p = _pending;
    if (p == null) return;
    final activeIdx = _activeReplyIndex;
    debugPrint(
      '[Chat] applying steer split: ${p.reqId} bubbleIdx=${p.bubbleIndex} activeIdx=$activeIdx',
    );
    setState(() {
      if (activeIdx != null &&
          p.bubbleIndex > activeIdx &&
          p.bubbleIndex < _messages.length) {
        // Seal the in-flight assistant bubble at its current pre-steer
        // content (no text rewrite — _refreshActiveBubble already painted
        // it). Just freeze it + drop any active tool indicator so it
        // doesn't spin forever (the active reply moves to a fresh
        // bubble below, and TurnCompleted for the steered turn lands
        // there, not here).
        _messages[activeIdx].isWaiting = false;
        _messages[activeIdx].currentToolIndicator = null;
        // Re-home the steer bubble: remove from its end-of-chat slot and
        // re-insert right after the sealed pre-steer reply.
        _messages.removeAt(p.bubbleIndex);
        final steerBubble = ChatMessage(
          text: p.text,
          type: MessageType.sent,
          isWaiting: false,
        );
        _messages.insert(activeIdx + 1, steerBubble);
        // Reset active streaming state so the very next CarbonTextDelta /
        // CarbonToolUseStart materializes a fresh post-steer agent bubble
        // below the relocated steer message.
        _activeReplyIndex = null;
        _currentSegmentText = '';
        _activeToolName = null;
      } else if (p.bubbleIndex < _messages.length) {
        // No active reply to split around (rare race) — just seal the
        // bubble in place as a regular sent message.
        _messages[p.bubbleIndex] = ChatMessage(
          text: p.text,
          type: MessageType.sent,
          isWaiting: false,
        );
      }
      _pending = null;
    });
    _scrollToBottom();
    _logUiSnapshot('after-steer-apply');
  }

  /// Daemon confirmed the pending submission has been picked up (steer
  /// queue drained at a round boundary, or queue popped into a new turn).
  /// Rewrite the pending bubble to clean text and clear the slot.
  void _resolvePending(String reason) {
    final p = _pending;
    if (p == null) return;
    debugPrint(
      '[Chat] pending slot resolved ($reason): ${p.reqId} bubbleIdx=${p.bubbleIndex}',
    );
    setState(() {
      if (p.bubbleIndex < _messages.length) {
        _messages[p.bubbleIndex] = ChatMessage(
          text: p.text,
          type: MessageType.sent,
          isWaiting: false,
        );
      }
      _pending = null;
    });
    _logUiSnapshot('after-resolve($reason)');
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

      case CarbonToolUseStart(:final toolName, :final toolCallId, :final argumentsJson):
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
        // Queue slot release: a queued submission has been popped and
        // is starting as a new turn. Match by client_request_id.
        if (_pending != null &&
            !_pending!.steer &&
            _pending!.reqId == clientRequestId) {
          _resolvePending('TurnStarted (queued popped)');
        }
        _currentPhase = phase;
        debugPrint('[Chat] TurnStarted phase=${phase.title() ?? "(none)"}');
        // Materialize the bubble EAGERLY when the phase has a title.
        // The phase header itself reads as "I'm about to do X" (e.g.
        // "🛠 Step 1/4 · 기사 목록 가져오기"), so showing it the
        // instant TurnStarted arrives gives the user an immediate
        // "agent is starting this step" signal — they don't have to
        // wait for the LLM's first delta to know what's happening.
        // Subsequent deltas / tools refresh the same bubble in place.
        if (phase.title() != null) {
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
        if (_threadInFlight) {
          setState(() => _threadInFlight = false);
        }
        // Restore window focus only here — not on per-phase TurnComplete.
        // setFocusable(false) fires once on user send; the matching true
        // must wait until the entire thread (all phases) is done.
        unawaited(WindowFocusService.setFocusable(true));
        _chatScrollFocusNode.requestFocus();
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

      case CarbonValidationCompleted(:final passed, :final attempt, :final reason):
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
        if (fatal && _threadInFlight) {
          setState(() => _threadInFlight = false);
        }
        _handleAgentError(code, message, fatal);
        break;

      case CarbonSessionEnded():
        if (_pending != null) {
          _resolvePending('SessionEnded');
        }
        if (_threadInFlight) {
          setState(() => _threadInFlight = false);
        }
        unawaited(WindowFocusService.setFocusable(true));
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

  /// Dump the current `_messages` list to stderr as a structured snapshot.
  /// One log entry per bubble: index, type, isWaiting, first-30-chars preview.
  /// Lets us diff UI bubble order against the daemon's event stream.
  void _logUiSnapshot(String tag) {
    final lines = <String>[
      'UI_SNAPSHOT[$tag] count=${_messages.length} active=$_activeReplyIndex pending=${_pending?.bubbleIndex}',
    ];
    for (int i = 0; i < _messages.length; i++) {
      final m = _messages[i];
      final preview = m.text
          .replaceAll('\n', ' ')
          .substring(0, m.text.length > 50 ? 50 : m.text.length);
      final phase = m.phaseTitle != null ? ' phase="${m.phaseTitle}"' : '';
      final tool = m.currentToolIndicator != null
          ? ' tool="${m.currentToolIndicator}"'
          : '';
      final vp = m.validationPassed ? ' ✓' : '';
      lines.add(
        '  [$i] type=${m.type.name} wait=${m.isWaiting}$phase$tool$vp "$preview"',
      );
    }
    debugPrint(lines.join('\n'));
  }

  /// Push the screen-level "in-flight turn" state (_currentSegmentText,
  /// bubble.tools) onto the active bubble. The bubble has TWO regions:
  /// a tool indicator (computed from the bubble's tools list — picks
  /// the first not-yet-completed entry so the user can see exactly
  /// which call is running right now) and a text region (append-only
  /// as deltas stream). At TurnComplete the indicator is dropped,
  /// leaving only the text.
  void _refreshActiveBubble({required bool isWaiting}) {
    setState(() {
      _isTyping = false;
      if (_activeReplyIndex == null) {
        if (_currentSegmentText.isEmpty && _activeToolName == null) return;
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
  ///   * first not-yet-completed entry → "<tool> · <arg> (N/M)"
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
    final arg = active.argumentsPreview.isEmpty ? '' : ' · ${active.argumentsPreview}';
    return '${active.toolName}$arg$progress';
  }

  /// Create the bubble for the in-flight turn. Used by [_refreshActiveBubble]
  /// when the first text delta arrives, and by [_recordToolStart] when the
  /// turn opens with a tool call (no text). Carries the current phase
  /// title onto the bubble so each turn's bubble renders its own header.
  void _materializeAgentBubble(String text, {required bool isWaiting}) {
    final phaseTitle = _currentPhase?.title();
    final validationPassed = _pendingValidationPassed;
    _pendingValidationPassed = false;
    // Where does a brand-new agent bubble go? While a steer/queue is
    // still pending (not yet picked up by the daemon), the current
    // turn's output BELONGS visually above the pending submission —
    // because the pending submission hasn't taken effect yet. So we
    // insert AT the pending bubble's slot (pushing it down by one).
    if (_pending != null && _pending!.bubbleIndex < _messages.length) {
      final insertAt = _pending!.bubbleIndex;
      _messages.insert(
        insertAt,
        ChatMessage(
          text: text,
          type: MessageType.received,
          isWaiting: isWaiting,
          phaseTitle: phaseTitle,
          validationPassed: validationPassed,
        ),
      );
      _activeReplyIndex = insertAt;
      _pending!.bubbleIndex = _pending!.bubbleIndex + 1;
      debugPrint(
        '[Chat] new agent bubble inserted ABOVE pending (idx=$insertAt, pending now at ${_pending!.bubbleIndex}) phase=${phaseTitle ?? "(none)"}',
      );
      _logUiSnapshot('insert-above-pending');
    } else {
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
        '[Chat] new agent bubble appended at end (idx=$_activeReplyIndex) phase=${phaseTitle ?? "(none)"}',
      );
      _logUiSnapshot('append-agent-end');
    }
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
      bubble.tools.add(TurnToolEntry(
        toolCallId: toolCallId,
        toolName: toolName,
        argumentsPreview: _summarizeArgsJson(argsJson),
      ));
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
    if (_activeReplyIndex == null) {
      setState(() {
        _isWaiting = false;
        _isTyping = false;
      });
      return;
    }
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
      debugPrint('[Chat] _finalizeActiveReply: silent turn — phase header only');
    }
    setState(() {
      _isWaiting = false;
      _isTyping = false;
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

    unawaited(WindowFocusService.setFocusable(true));

    setState(() {
      _isWaiting = false;
      _isTyping = false;

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
    _chatScrollFocusNode.requestFocus();

    if ((fatal && code != 'cancelled') || code == 'NO_SESSION') {
      await _grpcService.reconnect();
    }
  }

  void _scrollToBottom() {
    _chatWindowKey.currentState?.scrollToBottom();
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
      debugPrint('[ConfigCheck] App resumed. getConfig result: ready=${config.ready}, hasHint=${config.hint.isNotEmpty}');
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
    HttpMessageBus.instance.release();
    _keyboardFocusNode.dispose();
    _promptBarFocusNode.dispose();
    _chatScrollFocusNode.dispose();
    super.dispose();
  }

  // ────────────────────────────────────────────────────────────
  // Build
  // ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    debugPrint(
      '[Chat] build() called. _hasChatStarted: $_hasChatStarted, _isVisible: $_isVisible, messages: ${_messages.length}',
    );
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Focus(
        focusNode: _keyboardFocusNode,
        descendantsAreFocusable: true,
        onKeyEvent: (node, event) {
          if (event.logicalKey.keyLabel == 'XF86BTVoice' ||
              event.logicalKey.debugName == 'XF86BTVoice' ||
              event.logicalKey.keyId == 137438953472) {
            if (event is KeyDownEvent && !_isVoiceKeyPressed) {
              setState(() => _isVoiceKeyPressed = true);
            } else if (event is KeyUpEvent && _isVoiceKeyPressed) {
              setState(() => _isVoiceKeyPressed = false);
            }
            return KeyEventResult.ignored;
          }

          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape ||
                event.logicalKey == LogicalKeyboardKey.goBack ||
                event.logicalKey == LogicalKeyboardKey.browserBack) {
              if (_isWaiting) {
                _grpcService.interruptTurn();
              } else {
                SystemNavigator.pop();
              }
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: SizedBox.expand(
          child: Stack(
            children: [
              // ── PromptBar (bottom: 10, height: 80) ──────────
              AnimatedPositioned(
                key: const ValueKey('prompt-bar'),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                bottom: _isKeyboardFocused
                    ? TizenStyles.promptBarBottomKeyboard
                    : TizenStyles.promptBarBottom,
                left: TizenStyles.promptBarLeft,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: (_isVisible && !_isVoiceKeyPressed) ? 1.0 : 0.0,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      height: TizenStyles.promptBarContainerHeight,
                      child: PromptBar(
                        outerFocusNode: _promptBarFocusNode,
                        isConnecting: !_isGrpcReady,
                        onArrowUp: () {
                          if (!_hasChatStarted) return;
                          if (_currentActionButtons.isNotEmpty) {
                            _actionBarKey.currentState?.focusFirstButton();
                          } else {
                            _chatScrollFocusNode.requestFocus();
                          }
                        },
                        isVisible: _isVisible,
                        // Lock the bar only while a submission is sitting
                        // in the pending slot (the 1-slot UI constraint).
                        // During an in-flight turn with the slot empty
                        // the user is free to type a new steer/queue.
                        isWaiting: _pending != null,
                        hasChatStarted: _hasChatStarted,
                        onSend: (text) => _handleSend(text),
                        onCancel: () {
                          _grpcService.interruptTurn();
                        },
                        onKeyboardFocusChanged: (isFocused) {
                          if (mounted) {
                            setState(() => _isKeyboardFocused = isFocused);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // ── ActionButtonBar (PromptBar 바로 위) ──────────
              if (_hasChatStarted)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  bottom: _isKeyboardFocused
                      ? TizenStyles.actionBarBottomKeyboard
                      : TizenStyles.actionBarBottom,
                  left: 0,
                  right: 0,
                  child: ActionButtonBar(
                    key: _actionBarKey,
                    buttons: _currentActionButtons,
                    onSend: _handleSend,
                    onArrowUp: () => _chatScrollFocusNode.requestFocus(),
                    onArrowDown: () => _promptBarFocusNode.requestFocus(),
                  ),
                ),

              // ── ChatWindow ───────────────────────────────────
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                bottom: _hasChatStarted
                    ? (_isKeyboardFocused
                          ? (_currentActionButtons.isNotEmpty
                                ? TizenStyles
                                      .chatWindowBottomKeyboardWithActions
                                : TizenStyles.chatWindowBottomKeyboard)
                          : (_currentActionButtons.isNotEmpty
                                ? TizenStyles.chatWindowBottomWithActions
                                : TizenStyles.chatWindowBottomBase))
                    : -screenHeight,
                left: TizenStyles.promptBarLeft,
                child: ChatWindow(
                  key: _chatWindowKey,
                  focusNode: _chatScrollFocusNode,
                  onScrolledToBottomDown: () {
                    if (_currentActionButtons.isNotEmpty) {
                      _actionBarKey.currentState?.focusFirstButton();
                    } else {
                      _promptBarFocusNode.requestFocus();
                    }
                  },
                  messages: _messages,
                  // Bottom-of-list typing indicator: show only when the
                  // thread is busy AND there's no active reply bubble.
                  // When a bubble is filling (or showing a tool
                  // indicator) it carries its own waiting state — a
                  // second spinner below would be a visual duplicate.
                  // The gap that previously left users wondering — between
                  // one round ending and the next round's first delta —
                  // is what this guards: _activeReplyIndex is null in
                  // that window, so the dots fill in for the spinner.
                  isTyping: _threadInFlight && _activeReplyIndex == null,
                  sessionTitle: _sessionTitle,
                  onHeaderTap: () {
                    debugPrint(
                      '[SessionHeader] tapped — session picker not yet implemented',
                    );
                  },
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

  /// Index in `_messages` where this submission's "pending" bubble lives.
  /// On resolution the bubble's text is rewritten to drop the
  /// "STEER/QUEUE 대기" prefix and `isWaiting` flips off.
  int bubbleIndex;
  _PendingSubmission({
    required this.text,
    required this.reqId,
    required this.steer,
    required this.submittedAt,
    required this.bubbleIndex,
  });
}

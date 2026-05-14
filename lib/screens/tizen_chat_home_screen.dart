import 'package:ai_chat/widgets/prompt_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class TizenChatHomeScreen extends StatefulWidget {
  final bool enableHttpMessageBus;
  const TizenChatHomeScreen({super.key, this.enableHttpMessageBus = true});

  @override
  State<TizenChatHomeScreen> createState() => _TizenChatHomeScreenState();
}

class _TizenChatHomeScreenState extends State<TizenChatHomeScreen>
    with TickerProviderStateMixin {
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

  // ── 서비스 ───────────────────────────────────────────────────
  final FocusNode _keyboardFocusNode = FocusNode();
  final FocusNode _promptBarFocusNode = FocusNode();
  final FocusNode _chatScrollFocusNode = FocusNode();
  final CarbonGrpcService _grpcService = CarbonGrpcService.instance;
  StreamSubscription<String>? _messageBusSubscription;
  StreamSubscription<CarbonEvent>? _eventSubscription;
  final Completer<void> _initCompleter = Completer<void>();
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
  String? _activeToolName;

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
          setState(() => _isVisible = true);
          // rebuild 완료 후 포커스 부여 (isVisible=true 상태에서 shimmer 표시 보장)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _promptBarFocusNode.requestFocus();
          });
        }
      });
    });
  }

  void _onAppControlReceived(ReceivedAppControl appControl) async {
    _hasPendingAppControl = true;
    await _initCompleter.future;
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
        debugPrint('[AppControl] Proceeding to _handleSend: $messageText');
        if (mounted) {
          _handleSend(messageText!);
        }
      } else {
        debugPrint('[AppControl] No message content found in extraData.');
        // 만약 메시지는 없지만 앱이 깨어났다면, 최소한 점이라도 표시하거나 화면을 활성화할지 결정
        setState(() {
          _isVisible = true;
        });
      }
    } catch (e) {
      debugPrint('[AppControl] Error processing extraData: $e');
    }
  }

  Future<void> _initializeServices() async {
    try {
      // 1. 오늘 날짜로 세션 확보 + 로컈 목록에 기록
      final sessionName = await SessionRepository.instance.ensureTodaySession();
      debugPrint('[Init] Session name: $sessionName');

      // 2. UI 타이틀 설정
      if (mounted) setState(() => _sessionTitle = sessionName);

      // 3. 세션 이름으로 gRPC 연결
      await _grpcService.connect(sessionName: sessionName);

      if (!_initCompleter.isCompleted) _initCompleter.complete();
    } catch (e) {
      debugPrint('[Init] Error: $e');
      if (!_initCompleter.isCompleted) _initCompleter.complete();
    }
  }

  Future<void> _startHttpMessageBus() async {
    try {
      await HttpMessageBus.instance.acquire();
    } catch (e) {
      print('[REQ_006] HttpMessageBus acquire failed: $e');
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

  /// Daemon confirmed the pending submission has been picked up (steer
  /// queue drained at a round boundary, or queue popped into a new turn).
  /// Rewrite the pending bubble to clean text and clear the slot.
  void _resolvePending(String reason) {
    final p = _pending;
    if (p == null) return;
    debugPrint('[Chat] pending slot resolved ($reason): ${p.reqId} bubbleIdx=${p.bubbleIndex}');
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

      case CarbonToolUseStart(:final toolName):
        _markToolUse(toolName);
        break;

      case CarbonToolResult():
        _onToolResult();
        break;

      case CarbonTurnComplete():
        // No pending resolve here anymore — SteerApplied is the real
        // signal (fires at the round boundary BEFORE this turn-end).
        // ThreadComplete remains the safety net if SteerApplied never
        // arrives (e.g. turn ended mid-race before drain).
        _finalizeActiveReply();
        break;

      case CarbonSteerApplied(:final clientRequestId):
        // Real signal from the daemon: the steer queue drained at a
        // round boundary and our prompt is now in the live agent loop.
        // Release the pending slot iff this confirmation is for our
        // submission (other clients can steer the same turn).
        if (_pending != null &&
            _pending!.steer &&
            _pending!.reqId == clientRequestId) {
          _resolvePending('SteerApplied');
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

      case CarbonTurnStarted(:final clientRequestId):
        // Queue slot release: a queued submission has been popped and
        // is starting as a new turn. Match by client_request_id.
        if (_pending != null &&
            !_pending!.steer &&
            _pending!.reqId == clientRequestId) {
          _resolvePending('TurnStarted (queued popped)');
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
        break;

      case CarbonError(:final code, :final fatal):
        // Clear any pending slot on error so the user can recover.
        if (_pending != null) {
          _resolvePending('Error: $code');
        }
        _handleAgentError(code, fatal);
        break;

      case CarbonSessionEnded():
        if (_pending != null) {
          _resolvePending('SessionEnded');
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
    final lines = <String>['UI_SNAPSHOT[$tag] count=${_messages.length} active=$_activeReplyIndex pending=${_pending?.bubbleIndex}'];
    for (int i = 0; i < _messages.length; i++) {
      final m = _messages[i];
      final preview = m.text
          .replaceAll('\n', ' ')
          .substring(0, m.text.length > 50 ? 50 : m.text.length);
      lines.add('  [$i] type=${m.type.name} wait=${m.isWaiting} "$preview"');
    }
    debugPrint(lines.join('\n'));
  }

  String _composeBubbleText() {
    if (_activeToolName != null) {
      return _currentSegmentText.isNotEmpty
          ? '$_currentSegmentText\n\n🔧 $_activeToolName 실행 중...'
          : '🔧 $_activeToolName 실행 중...';
    }
    return _currentSegmentText;
  }

  void _refreshActiveBubble({required bool isWaiting}) {
    setState(() {
      _isTyping = false;
      final display = _composeBubbleText();
      if (_activeReplyIndex == null) {
        if (display.isEmpty) return;
        // Where does a brand-new agent bubble go? While a steer/queue is
        // still pending (not yet picked up by the daemon), the current
        // turn's output BELONGS visually above the pending submission —
        // because the pending submission hasn't taken effect yet. So we
        // insert AT the pending bubble's slot (pushing it down by one).
        // Once the daemon picks up the pending (TurnComplete /
        // TurnStarted), `_pending = null`, and subsequent agent bubbles
        // naturally fall to the end of the list — which is *below* the
        // now-resolved user prompt, exactly what the UX spec asks for.
        if (_pending != null && _pending!.bubbleIndex < _messages.length) {
          final insertAt = _pending!.bubbleIndex;
          _messages.insert(
            insertAt,
            ChatMessage(
              text: display,
              type: MessageType.received,
              isWaiting: isWaiting,
            ),
          );
          _activeReplyIndex = insertAt;
          _pending!.bubbleIndex = _pending!.bubbleIndex + 1;
          debugPrint(
            '[Chat] new agent bubble inserted ABOVE pending (idx=$insertAt, pending now at ${_pending!.bubbleIndex})',
          );
          _logUiSnapshot('insert-above-pending');
        } else {
          _activeReplyIndex = _messages.length;
          _messages.add(
            ChatMessage(
              text: display,
              type: MessageType.received,
              isWaiting: isWaiting,
            ),
          );
          debugPrint('[Chat] new agent bubble appended at end (idx=$_activeReplyIndex)');
          _logUiSnapshot('append-agent-end');
        }
      } else {
        _messages[_activeReplyIndex!] = ChatMessage(
          text: display,
          type: MessageType.received,
          isWaiting: isWaiting,
        );
      }
    });
    _scrollToBottom();
  }

  void _appendDelta(String content) {
    _currentSegmentText += content;
    debugPrint(
      '[Chat] _appendDelta(+${content.length} chars) total=${_currentSegmentText.length} '
      'preview="${_currentSegmentText.length > 60 ? "${_currentSegmentText.substring(0, 60)}..." : _currentSegmentText}"',
    );
    _refreshActiveBubble(isWaiting: true);
  }

  void _markToolUse(String toolName) {
    // Both V1 and V2: tool indicator overlays the current bubble's text.
    // CRITICAL: do NOT clear _currentSegmentText — that's the v1 bug that
    // hid commentary. The accumulated text stays; the tool indicator
    // appends in _composeBubbleText.
    _activeToolName = toolName;
    _refreshActiveBubble(isWaiting: true);
  }

  void _onToolResult() {
    // Intentionally do NOT refresh the bubble here. If the daemon is about
    // to start another tool (typical agentic loop), refreshing now would
    // briefly drop the tool indicator just to bring it back in a few ms,
    // producing visible flicker for any turn with multiple tools. We just
    // record that the active tool slot is free; the next _markToolUse
    // will replace the indicator name in place, or the next _appendDelta /
    // MessageFinalized / TurnComplete will repaint without it.
    _activeToolName = null;
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
    if (!event.isFinalAnswer) return;
    if (_activeReplyIndex == null) return;
    _activeToolName = null;
    setState(() {
      _messages[_activeReplyIndex!] = ChatMessage(
        text: _currentSegmentText,
        type: MessageType.received,
        isWaiting: false,
      );
    });
    _activeReplyIndex = null;
    _currentSegmentText = '';
  }

  void _finalizeActiveReply() {
    unawaited(WindowFocusService.setFocusable(true));
    if (_activeReplyIndex == null) {
      // turn 이 끝났는데 렌더링된 응답이 전혀 없는 경우(예: 빈 응답).
      // typing 인디케이터/대기 상태만 해제한다.
      setState(() {
        _isWaiting = false;
        _isTyping = false;
      });
      _chatScrollFocusNode.requestFocus();
      return;
    }
    debugPrint(
      '[Chat] _finalizeActiveReply: _currentSegmentText.length=${_currentSegmentText.length} '
      'first200="${_currentSegmentText.length > 200 ? "${_currentSegmentText.substring(0, 200)}..." : _currentSegmentText}"',
    );
    final parsedResponse = AgentResponseParser.parse(_currentSegmentText);
    debugPrint(
      '[Chat] parsed.displayType=${parsedResponse.displayType} '
      'parsed.content.length=${parsedResponse.content.length} '
      'parsed.first200="${parsedResponse.content.length > 200 ? "${parsedResponse.content.substring(0, 200)}..." : parsedResponse.content}"',
    );
    setState(() {
      _isWaiting = false;
      _isTyping = false;
      _messages[_activeReplyIndex!] = ChatMessage(
        text: parsedResponse.content,
        displayType: parsedResponse.displayType,
        type: MessageType.received,
        isWaiting: false,
        uiCode: parsedResponse.uiCode,
        actionButtons: parsedResponse.actionButtons,
      );
    });
    _activeReplyIndex = null;
    _currentSegmentText = '';
    _activeToolName = null;
    _scrollToBottom();
    _chatScrollFocusNode.requestFocus();
  }

  Future<void> _handleAgentError(String code, bool fatal) async {
    unawaited(WindowFocusService.setFocusable(true));
    setState(() {
      _isWaiting = false;
      _isTyping = false;
      if (_activeReplyIndex != null) {
        _messages[_activeReplyIndex!] = ChatMessage(
          text: _currentSegmentText.isEmpty
              ? '요청이 취소되었습니다.'
              : '$_currentSegmentText\n\n(요청 중단됨)',
          type: MessageType.received,
          isWaiting: false,
        );
        _activeReplyIndex = null;
        _currentSegmentText = '';
        _activeToolName = null;
      } else if (code == 'cancelled') {
        _messages.add(
          ChatMessage(
            text: '요청이 취소되었습니다.',
            type: MessageType.received,
            isWaiting: false,
          ),
        );
      }
    });
    _scrollToBottom();
    _chatScrollFocusNode.requestFocus();

    // "cancelled" 는 interruptTurn() 으로 인한 정상 중단이므로 reconnect 없이
    // 대기 상태만 해제한다.
    if (fatal && code != 'cancelled') {
      await _grpcService.reconnect();
    }
  }

  void _scrollToBottom() {
    _chatWindowKey.currentState?.scrollToBottom();
  }

  // 마지막 완료된 received 메시지의 버튼 목록 (대기 중이면 빈 리스트)
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
  void dispose() {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Focus(
        focusNode: _keyboardFocusNode,
        autofocus: true,
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

            // // 리모컨 상/하 키로 스크롤 처리
            // if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            //   if (_scrollController.hasClients) {
            //     final newOffset = (_scrollController.offset - 150).clamp(
            //       0.0,
            //       _scrollController.position.maxScrollExtent,
            //     );
            //     _scrollController.animateTo(
            //       newOffset,
            //       duration: const Duration(milliseconds: 200),
            //       curve: Curves.easeOut,
            //     );
            //     return KeyEventResult.handled;
            //   }
            // }
            // if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            //   if (_scrollController.hasClients) {
            //     final newOffset = (_scrollController.offset + 150).clamp(
            //       0.0,
            //       _scrollController.position.maxScrollExtent,
            //     );
            //     _scrollController.animateTo(
            //       newOffset,
            //       duration: const Duration(milliseconds: 200),
            //       curve: Curves.easeOut,
            //     );
            //     return KeyEventResult.handled;
            //   }
            // }
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
                bottom: _isKeyboardFocused ? 270 : 10,
                left: 10,
                right: 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: (_isVisible && !_isVoiceKeyPressed) ? 1.0 : 0.0,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      height: 80,
                      child: PromptBar(
                        outerFocusNode: _promptBarFocusNode,
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
                          if (mounted) setState(() => _isKeyboardFocused = isFocused);
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
                  bottom: _isKeyboardFocused ? 358 : 98,
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
                        ? (_currentActionButtons.isNotEmpty ? 418 : 358)
                        : (_currentActionButtons.isNotEmpty ? 158 : 98))
                    : -screenHeight,
                left: 10,
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
                  isTyping: _isTyping,
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

import 'package:ai_chat/widgets/prompt_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tizen_app_control/tizen_app_control.dart';
import 'dart:convert';
import '../widgets/chat_window.dart';
import '../widgets/action_button_bar.dart';
import '../services/carbon_grpc_service.dart';
import '../generated/carbon/v1/agent.pbenum.dart';
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

  @override
  void initState() {
    super.initState();
    AppControl.onAppControl.listen(_onAppControlReceived);

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

  Future<void> _handleSend(String text) async {
    debugPrint('[Chat] _handleSend called with text: $text');

    final userBubble = ChatMessage(text: text, type: MessageType.sent);

    setState(() {
      if (!_hasChatStarted) {
        _hasChatStarted = true;
        debugPrint('[Chat] First message! Session: $_sessionTitle');
      }
      _isVisible = true;
      _isWaiting = true;
      // agent 버블이 이미 활성이면 새 typing 인디케이터는 띄우지 않는다
      // (그 버블에 곧 또 delta 가 도착해 자연스럽게 이어지므로).
      if (_activeReplyIndex == null) {
        _isTyping = true;
      }

      if (_activeReplyIndex != null) {
        // mid-turn: agent 버블 위에 새 user 버블 삽입.
        _messages.insert(_activeReplyIndex!, userBubble);
        _activeReplyIndex = _activeReplyIndex! + 1;
      } else {
        _messages.add(userBubble);
      }
    });
    unawaited(WindowFocusService.setFocusable(false));
    debugPrint(
      '[Chat] State updated. _hasChatStarted: $_hasChatStarted, _isVisible: $_isVisible',
    );
    _scrollToBottom();

    // Fire-and-forget. carbon_grpc_service 가 항상 steer:true 로 전송하므로
    // 데몬은 (a) 진행 중 turn 이면 round 경계에 inject, (b) 아니면 새 turn 시작.
    await _grpcService.sendPrompt(text);
  }

  void _handleAgentEvent(CarbonEvent event) {
    if (!mounted) return;

    switch (event) {
      case CarbonTextDelta(:final content):
        _appendDelta(content);
        break;

      case CarbonToolUseStart(:final toolName):
        _markToolUse(toolName);
        break;

      case CarbonToolResult():
        // 결과 자체는 별도 버블로 안 띄움 (기존 동작 유지)
        _activeToolName = null;
        break;

      case CarbonTurnComplete():
        _finalizeActiveReply();
        break;

      case CarbonError(:final code, :final fatal):
        _handleAgentError(code, fatal);
        break;

      case CarbonSessionEnded():
        unawaited(WindowFocusService.setFocusable(true));
        _grpcService.reconnect();
        break;

      case CarbonToolApprovalRequest(:final toolCallId, :final toolName):
        debugPrint(
          '[Chat] ToolApprovalRequest received for $toolName — auto-approving',
        );
        _grpcService.approveToolCall(
          toolCallId,
          ApprovalDecision.APPROVAL_DECISION_APPROVE,
        );
        break;
    }
  }

  void _appendDelta(String content) {
    _currentSegmentText += content;
    setState(() {
      _isTyping = false;
      if (_activeReplyIndex == null) {
        _activeReplyIndex = _messages.length;
        _messages.add(
          ChatMessage(
            text: _currentSegmentText,
            type: MessageType.received,
            isWaiting: true,
          ),
        );
      } else {
        _messages[_activeReplyIndex!] = ChatMessage(
          text: _currentSegmentText,
          type: MessageType.received,
          isWaiting: true,
        );
      }
    });
    _scrollToBottom();
  }

  void _markToolUse(String toolName) {
    _activeToolName = toolName;
    // 도구 호출 직전까지 쌓인 텍스트(reasoning)를 도구 표시 아래에 붙임
    final toolMessage = _currentSegmentText.trim();
    _currentSegmentText = '';
    final toolText = toolMessage.isNotEmpty
        ? '🔧 $toolName 실행 중...\n$toolMessage'
        : '🔧 $toolName 실행 중...';
    setState(() {
      _isTyping = false;
      if (_activeReplyIndex == null) {
        _activeReplyIndex = _messages.length;
        _messages.add(
          ChatMessage(
            text: toolText,
            type: MessageType.received,
            isWaiting: true,
          ),
        );
      } else {
        _messages[_activeReplyIndex!] = ChatMessage(
          text: toolText,
          type: MessageType.received,
          isWaiting: true,
        );
      }
    });
    _scrollToBottom();
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
    final parsedResponse = AgentResponseParser.parse(_currentSegmentText);
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
                        isWaiting: _isWaiting,
                        hasChatStarted: _hasChatStarted,
                        onSend: _handleSend,
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

import 'package:ai_chat/widgets/prompt_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tizen_app_control/tizen_app_control.dart';
import 'dart:convert';
import '../widgets/dim_overlay.dart';
import '../widgets/chat_window.dart';
import '../services/carbon_grpc_service.dart';
import '../generated/carbon/v1/agent.pbenum.dart';
import '../services/session_repository.dart';
import '../models/chat_message.dart';
import '../services/agent_response_parser.dart';
import 'dart:async';
import '../features/http_message_overlay/http_message_bus.dart';

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

  // ── 서비스 ───────────────────────────────────────────────────
  final FocusNode _keyboardFocusNode = FocusNode();
  final FocusNode _promptBarFocusNode = FocusNode();
  final FocusNode _chatScrollFocusNode = FocusNode();
  final CarbonGrpcService _grpcService = CarbonGrpcService.instance;
  StreamSubscription<String>? _messageBusSubscription;
  final Completer<void> _initCompleter = Completer<void>();
  bool _hasPendingAppControl = false;

  @override
  void initState() {
    super.initState();
    AppControl.onAppControl.listen(_onAppControlReceived);

    _initializeServices();
    if (widget.enableHttpMessageBus) {
      _startHttpMessageBus();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && !_hasPendingAppControl) {
          setState(() => _isVisible = true);
          _promptBarFocusNode.requestFocus();
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
  // 메시지 전송 및 gRPC 스트리밍 처리
  // ────────────────────────────────────────────────────────────
  Future<void> _handleSend(String text) async {
    debugPrint('[Chat] _handleSend called with text: $text');
    if (_isWaiting) {
      debugPrint('[Chat] Already waiting, ignoring...');
      return;
    }

    // 메시지 전송 시점의 상태 갱신
    setState(() {
      if (!_hasChatStarted) {
        _hasChatStarted = true;
        // _sessionTitle은 날짜 기반으로 이미 설정됨 (_initializeServices에서)
        debugPrint('[Chat] First message! Session: $_sessionTitle');
      }

      _isVisible = true;
      _isWaiting = true;
      _isTyping = true;
      _messages.add(ChatMessage(text: text, type: MessageType.sent));
    });
    debugPrint(
      '[Chat] State updated. _hasChatStarted: $_hasChatStarted, _isVisible: $_isVisible',
    );
    _scrollToBottom();

    try {
      // 중간 단계마다 리셋되는 텍스트 버퍼. TurnComplete 시점의 값이 최종 메시지.
      String currentSegmentText = '';
      int replyIndex = -1;

      final stream = _grpcService.sendMessage(text);
      await for (final event in stream) {
        if (!mounted) break;

        // 응답 말풍선이 생겼을 때 타이핑 인디케이터 중지
        if (_isTyping && replyIndex != -1) {
          setState(() => _isTyping = false);
        }

        switch (event) {
          case CarbonTextDelta(:final content):
            currentSegmentText += content;
            if (replyIndex == -1) {
              replyIndex = _messages.length;
              setState(() {
                _isTyping = false;
                _messages.add(
                  ChatMessage(
                    text: currentSegmentText,
                    type: MessageType.received,
                    isWaiting: true,
                  ),
                );
              });
            } else {
              setState(() {
                _messages[replyIndex] = ChatMessage(
                  text: currentSegmentText,
                  type: MessageType.received,
                  isWaiting: true,
                );
              });
            }
            _scrollToBottom();
            break;

          case CarbonToolUseStart(:final toolName):
            // 도구 호출 직전까지 쌓인 텍스트(reasoning)를 도구 표시 아래에 붙임
            final toolMessage = currentSegmentText.trim();
            currentSegmentText = '';
            final toolText = toolMessage.isNotEmpty
                ? '🔧 $toolName 실행 중...\n$toolMessage'
                : '🔧 $toolName 실행 중...';
            if (replyIndex == -1) {
              replyIndex = _messages.length;
              setState(() {
                _isTyping = false;
                _messages.add(
                  ChatMessage(
                    text: toolText,
                    type: MessageType.received,
                    isWaiting: true,
                  ),
                );
              });
            } else {
              setState(() {
                _messages[replyIndex] = ChatMessage(
                  text: toolText,
                  type: MessageType.received,
                  isWaiting: true,
                );
              });
            }
            _scrollToBottom();
            break;

          case CarbonToolResult():
            break;

          case CarbonTurnComplete():
            final parsedResponse = AgentResponseParser.parse(
              currentSegmentText,
            );
            setState(() {
              _isWaiting = false;
              _isTyping = false;
              if (replyIndex != -1) {
                // 스트리밍 버블을 최종 내용으로 확정 (스피너 종료)
                _messages[replyIndex] = ChatMessage(
                  text: parsedResponse.content,
                  displayType: parsedResponse.displayType,
                  type: MessageType.received,
                  isWaiting: false,
                  uiCode: parsedResponse.uiCode,
                );
              } else if (parsedResponse.content.trim().isNotEmpty) {
                // 스트리밍 버블이 없는 경우에만 새 버블 추가
                _messages.add(
                  ChatMessage(
                    text: parsedResponse.content,
                    displayType: parsedResponse.displayType,
                    type: MessageType.received,
                    uiCode: parsedResponse.uiCode,
                  ),
                );
              }
            });
            _scrollToBottom();
            _chatScrollFocusNode.requestFocus();
            return;

          case CarbonError(:final code, :final fatal):
            setState(() {
              _isWaiting = false;
              _isTyping = false;
              if (replyIndex != -1) {
                // 에러나 취소가 발생했을 때 해당 메시지의 로딩 상태를 해제
                _messages[replyIndex] = ChatMessage(
                  text: currentSegmentText.isEmpty
                      ? '요청이 취소되었습니다.'
                      : '$currentSegmentText\n\n(요청 중단됨)',
                  type: MessageType.received,
                  isWaiting: false,
                );
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

            // "cancelled"는 interruptTurn()으로 인한 정상 중단이므로
            // reconnect 없이 대기 상태만 해제한다.
            if (fatal && code != 'cancelled') await _grpcService.reconnect();
            return;

          case CarbonSessionEnded():
            await _grpcService.reconnect();
            return;

          case CarbonToolApprovalRequest(:final toolCallId, :final toolName):
            debugPrint(
              '[Chat] ToolApprovalRequest received for $toolName — auto-approving',
            );
            _grpcService.approveToolCall(
              toolCallId,
              ApprovalDecision.APPROVAL_DECISION_APPROVE,
            );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isWaiting = false;
          _isTyping = false;
        });
        _chatScrollFocusNode.requestFocus();
      }
    }
  }

  void _scrollToBottom() {
    _chatWindowKey.currentState?.scrollToBottom();
  }

  @override
  void dispose() {
    _messageBusSubscription?.cancel();
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
              // ── 3. PromptBar ────────────────────────────────
              AnimatedPositioned(
                key: const ValueKey('prompt-bar'),
                duration: const Duration(milliseconds: 600),
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
                          if (_hasChatStarted)
                            _chatScrollFocusNode.requestFocus();
                        },
                        isVisible: _isVisible,
                        isWaiting: _isWaiting,
                        hasChatStarted: _hasChatStarted,
                        onSend: _handleSend,
                        onCancel: () {
                          _grpcService.interruptTurn();
                        },
                        onKeyboardFocusChanged: (isFocused) {
                          if (mounted) {
                            setState(() {
                              _isKeyboardFocused = isFocused;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // ── 0. 실시간 상태 표시 (초록색 동그라미) ─────────
              // Positioned(
              //   top: 30,
              //   right: 30,
              //   child: Container(
              //     width: 15,
              //     height: 15,
              //     decoration: BoxDecoration(
              //       color: Colors.greenAccent.withValues(alpha: 0.9),
              //       shape: BoxShape.circle,
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.greenAccent.withValues(alpha: 0.6),
              //           blurRadius: 15,
              //           spreadRadius: 5,
              //         ),
              //       ],
              //     ),
              //     child: const Center(
              //       child: Icon(
              //         Icons.mic_none,
              //         size: 9,
              //         color: Colors.black87,
              //       ),
              //     ),
              //   ),
              // ),

              // ── 1. Dim Overlay ─────────────────────────────
              // if (_hasChatStarted)
              //   DimOverlay(isVisible: _isVisible || _isWaiting, opacity: 1.0),

              // ── 2. 대화창 (첫 메시지 전송 후 표시) ─────────
              AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  bottom: _hasChatStarted
                      ? (_isKeyboardFocused ? 370 : 100)
                      : -screenHeight,
                  left: 10,
                  child: ChatWindow(
                    key: _chatWindowKey,
                    focusNode: _chatScrollFocusNode,
                    onScrolledToBottomDown: () =>
                        _promptBarFocusNode.requestFocus(),
                    messages: _messages,
                    isTyping: _isTyping,
                    sessionTitle: _sessionTitle,
                    onSendMessage: _handleSend,
                    onHeaderTap: () {
                      // TODO: 세션 목록 팝업 (추후 구현)
                      debugPrint(
                        '[SessionHeader] tapped — session picker not yet implemented',
                      );
                    },
                  ),
                ),

              // ── 3. PromptBar ────────────────────────────────
              // AnimatedPositioned(
              //   key: const ValueKey('prompt-bar'),
              //   duration: const Duration(milliseconds: 600),
              //   curve: Curves.easeOutCubic,
              //   bottom: (_isVisible || !_shouldSlideDown) ? 60 : -150,
              //   left: 0,
              //   right: 0,
              //   child: AnimatedOpacity(
              //     duration: const Duration(milliseconds: 200),
              //     opacity: _isVisible ? 1.0 : 0.0,
              //     child: Align(
              //       alignment: Alignment.bottomCenter,
              //       child: SizedBox(
              //         height: 70,
              //         child: PromptBar(
              //           isVisible: _isVisible,
              //           isWaiting: _isWaiting,
              //           hasChatStarted: _hasChatStarted,
              //           onSend: _handleSend,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

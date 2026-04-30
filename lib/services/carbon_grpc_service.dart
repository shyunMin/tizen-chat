import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:grpc/grpc.dart';
import '../generated/carbon/v1/agent.pbgrpc.dart';

// Flutter-friendly event models
sealed class CarbonEvent {}

class CarbonTextDelta extends CarbonEvent {
  final String content;
  CarbonTextDelta(this.content);
}

class CarbonToolUseStart extends CarbonEvent {
  final String toolName;
  final String toolCallId;
  final String argumentsJson;
  CarbonToolUseStart(this.toolName, this.toolCallId, this.argumentsJson);
}

class CarbonToolResult extends CarbonEvent {
  final String toolCallId;
  final String output;
  final bool isError;
  CarbonToolResult(this.toolCallId, this.output, this.isError);
}

class CarbonTurnComplete extends CarbonEvent {
  final String? usageJson;
  CarbonTurnComplete({this.usageJson});
}

class CarbonError extends CarbonEvent {
  final String code;
  final String message;
  final bool fatal;
  CarbonError(this.code, this.message, this.fatal);
}

class CarbonSessionEnded extends CarbonEvent {
  final String reason;
  CarbonSessionEnded(this.reason);
}

class CarbonToolApprovalRequest extends CarbonEvent {
  final String toolCallId;
  final String toolName;
  final String argumentsJson;
  final String reason;
  final int timeoutSecs;
  CarbonToolApprovalRequest(
    this.toolCallId,
    this.toolName,
    this.argumentsJson,
    this.reason,
    this.timeoutSecs,
  );
}

class CarbonGrpcService {
  static final CarbonGrpcService instance = CarbonGrpcService._();
  CarbonGrpcService._();

  ClientChannel? _channel;
  AgentServiceClient? _client;
  StreamController<ClientMessage>? _requestStreamController;

  bool _isConnected = false;
  bool _isConnecting = false;
  bool get isConnected => _isConnected;

  String? _sessionId;
  String? get sessionId => _sessionId;

  String? _sessionName; // 연결 시 사용한 세션 이름 (reconnect에서 재사용)

  Future<void>? _connectFuture;

  Future<void> connect({String? sessionName}) async {
    if (_isConnected) return;
    if (_connectFuture != null) {
      await _connectFuture;
      return;
    }
    _connectFuture = _doConnect(sessionName: sessionName);
    try {
      await _connectFuture;
    } finally {
      _connectFuture = null;
    }
  }

  Future<void> _doConnect({String? sessionName}) async {
    _isConnecting = true;
    _sessionName = sessionName;

    final endpoint = '/run/user/5001/carbon/carbon.sock';

    try {
      print('DEBUG: [CarbonGrpc] Trying to connect to: $endpoint');

      _channel = ClientChannel(
        InternetAddress(endpoint, type: InternetAddressType.unix),
        port: 0,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        ),
      );

      _client = AgentServiceClient(_channel!);
      _requestStreamController = StreamController<ClientMessage>();

      final responseStream = _client!.session(_requestStreamController!.stream);
      final handshakeCompleter = Completer<void>();

      _responseSubscription = responseStream.listen(
        (ServerEvent event) {
          // [LOG] 하위 gRPC 스트림에서 오는 모든 이벤트 출력
          print('DEBUG: [CarbonGrpc] Raw Event: ${event.whichEvent()}');
          if (event.hasSessionCreated()) {
            _sessionId = event.sessionCreated.sessionId;
            print(
              'DEBUG: [CarbonGrpc] Session Created: $_sessionId via $endpoint',
            );
            if (!handshakeCompleter.isCompleted) handshakeCompleter.complete();
          } else {
            _handleServerEvent(event);
          }
        },
        onError: (e) {
          print('DEBUG: [CarbonGrpc] Stream Error on $endpoint: $e');
          _isConnected = false;
          if (!handshakeCompleter.isCompleted)
            handshakeCompleter.completeError(e);
          else
            _broadcastError(e.toString(), fatal: true);
        },
        onDone: () {
          print('DEBUG: [CarbonGrpc] Stream Closed');
          _isConnected = false;
        },
      );

      // Get app-specific storage path for workspace
      final appDir = await getApplicationSupportDirectory();
      final workspacePath = p.join(appDir.path, 'tizen_ai');

      // Ensure directory exists
      final workspaceDir = Directory(workspacePath);
      if (!await workspaceDir.exists()) {
        await workspaceDir.create(recursive: true);
      }
      print('DEBUG: [CarbonGrpc] Using workspace path: $workspacePath');

      // Send the handshake
      _requestStreamController!.add(
        ClientMessage(
          createSession: CreateSessionRequest(
            product: "claw",
            config: {
              "workspace": workspacePath,
              if (_sessionName != null) "session": _sessionName!,
              if (_sessionName != null) "session_date": _sessionName!,
            }.entries,
          ),
        ),
      );

      await handshakeCompleter.future.timeout(const Duration(seconds: 3));
      _isConnected = true;
      _isConnecting = false;
      print('DEBUG: [CarbonGrpc] Successfully connected to $endpoint');
      return;
    } catch (e) {
      print('DEBUG: [CarbonGrpc] Connect Error on $endpoint: $e');
      await disconnect();
    }

    _isConnected = false;
    _isConnecting = false;
  }

  // Broadcast stream of agent events. Multiple listeners are supported, so
  // the UI can subscribe once at startup and dispatch every event through a
  // single handler — required for the steer-based UX where one logical turn
  // can produce text deltas for multiple consecutive user prompts.
  final StreamController<CarbonEvent> _eventController =
      StreamController<CarbonEvent>.broadcast();
  StreamSubscription<ServerEvent>? _responseSubscription;

  /// Long-lived broadcast stream of agent events. UI should subscribe once
  /// in initState and route every event through a single handler — this
  /// is what allows mid-turn steers to land in a fresh message bubble while
  /// the turn keeps running on the daemon.
  Stream<CarbonEvent> get events => _eventController.stream;

  // 취소 후 이전 턴의 잔여 이벤트를 다음 TurnStarted까지 버린다.
  bool _discardingOldTurnEvents = false;

  void _handleServerEvent(ServerEvent event) {
    if (_discardingOldTurnEvents) {
      if (event.hasTurnStarted()) {
        _discardingOldTurnEvents = false;
        // fall through: TurnStarted는 정상 처리
      } else if (event.hasSessionEnded() ||
          (event.hasError() && event.error.fatal)) {
        // 연결/세션 종료 이벤트는 항상 통과
      } else {
        return; // 이전 턴 잔여 이벤트 폐기
      }
    }

    if (event.hasTextDelta()) {
      _eventController.add(CarbonTextDelta(event.textDelta.content));
    } else if (event.hasToolUseStart()) {
      _eventController.add(
        CarbonToolUseStart(
          event.toolUseStart.toolName,
          event.toolUseStart.toolCallId,
          event.toolUseStart.argumentsJson,
        ),
      );
    } else if (event.hasToolResult()) {
      _eventController.add(
        CarbonToolResult(
          event.toolResult.toolCallId,
          event.toolResult.output,
          event.toolResult.isError,
        ),
      );
    } else if (event.hasTurnComplete()) {
      print(
        'DEBUG: [CarbonGrpc] Event -> TurnComplete (usage: ${event.turnComplete.usageJson})',
      );
      _eventController.add(
        CarbonTurnComplete(usageJson: event.turnComplete.usageJson),
      );
    } else if (event.hasError()) {
      _eventController.add(
        CarbonError(event.error.code, event.error.message, event.error.fatal),
      );
      if (event.error.fatal && event.error.code != 'cancelled') _isConnected = false;
    } else if (event.hasSessionEnded()) {
      _eventController.add(CarbonSessionEnded(event.sessionEnded.reason));
      _isConnected = false;
    } else if (event.hasToolApprovalRequest()) {
      final req = event.toolApprovalRequest;
      print(
        'DEBUG: [CarbonGrpc] Event -> ToolApprovalRequest: ${req.toolName}',
      );
      _eventController.add(
        CarbonToolApprovalRequest(
          req.toolCallId,
          req.toolName,
          req.argumentsJson,
          req.reason,
          req.timeoutSecs,
        ),
      );
    } else if (event.hasTurnStarted()) {
      print(
        'DEBUG: [CarbonGrpc] Event -> TurnStarted: ${event.turnStarted.source}',
      );
    } else if (event.hasThreadComplete()) {
      print('DEBUG: [CarbonGrpc] Event -> ThreadComplete');
    } else if (event.hasScheduleEvent()) {
      print(
        'DEBUG: [CarbonGrpc] Event -> ScheduleEvent: ${event.scheduleEvent.status}',
      );
    }
  }

  /// 도구 실행 승인/거부 전송.
  /// [decision]: ApprovalDecision.APPROVAL_DECISION_APPROVE 등
  void approveToolCall(String toolCallId, ApprovalDecision decision) {
    if (_sessionId == null || _requestStreamController == null) return;
    print('DEBUG: [CarbonGrpc] Sending ToolApproval: $toolCallId -> $decision');
    _requestStreamController!.add(
      ClientMessage(
        toolApproval: ToolApproval(
          sessionId: _sessionId,
          toolCallId: toolCallId,
          decision: decision,
        ),
      ),
    );
  }

  /// 진행 중인 턴만 중단 (세션은 유지).
  void interruptTurn() {
    if (_sessionId == null || _requestStreamController == null) return;
    print('DEBUG: [CarbonGrpc] Sending InterruptTurn');
    _requestStreamController!.add(
      ClientMessage(interruptTurn: InterruptTurnRequest(sessionId: _sessionId)),
    );
    // 로컬에서 즉시 emit: sendMessage()의 await for를 즉시 종료시켜
    // UI 피드백 지연 및 hang을 방지한다.
    _eventController.add(CarbonError("cancelled", "interrupted by user", true));
    // 취소 이후 이전 턴의 잔여 이벤트(Carbon이 비동기로 완료한 응답)를
    // 다음 TurnStarted 전까지 버린다.
    _discardingOldTurnEvents = true;
  }

  void _broadcastError(String message, {bool fatal = false}) {
    _eventController.add(CarbonError("GRPC_ERROR", message, fatal));
  }

  Future<void> disconnect() async {
    _isConnected = false;
    _sessionId = null;
    try {
      _responseSubscription?.cancel();
      _responseSubscription = null;
      _requestStreamController?.close();
      _requestStreamController = null;
      _channel?.shutdown();
      _channel = null;
    } catch (_) {}
  }

  Future<void> reconnect() async {
    final savedSessionName = _sessionName; // 재연결 전에 보존
    await disconnect();
    await connect(sessionName: savedSessionName);
  }

  /// Send a user prompt to the agent. Always uses `steer: true` so the
  /// daemon will:
  ///   - Inject this at the next round boundary if a turn is in flight, or
  ///   - Start a new turn when no turn is currently running.
  ///
  /// Per the Carbon proto, `steer` is ignored when no turn is running, so
  /// the same call works for both the new-turn and mid-turn cases — there
  /// is no need for the caller to check whether a turn is busy.
  ///
  /// Fire-and-forget: events arrive on the [events] stream, not via the
  /// returned future. The future completes once the prompt is buffered to
  /// the gRPC request stream (or fails synchronously on connect/session
  /// errors, which are surfaced as a [CarbonError] event).
  Future<void> sendPrompt(String text) async {
    if (!_isConnected) {
      await connect();
    }
    if (_sessionId == null || _requestStreamController == null) {
      _eventController.add(
        CarbonError("NO_SESSION", "session is not ready", false),
      );
      return;
    }
    _requestStreamController!.add(
      ClientMessage(
        ingressInput: IngressInput(
          sessionId: _sessionId,
          intent: IngressIntent.INGRESS_INTENT_RUN_TURN,
          source: "ai-chat-flutter",
          text: text,
          steer: true,
        ),
      ),
    );
  }

  /// Backward-compat wrapper around [sendPrompt] + [events]. Prefer the
  /// listener model in new screens — this single-shot stream wraps an
  /// arbitrary slice of the broadcast event stream, so it does not give
  /// per-prompt isolation when multiple prompts are in flight inside the
  /// same daemon turn.
  Stream<CarbonEvent> sendMessage(String text) async* {
    if (!_isConnected) {
      await connect();
    }
    if (_sessionId == null) {
      yield CarbonError("NO_SESSION", "Failed to retrieve session id", true);
      return;
    }
    await sendPrompt(text);
    await for (final evt in _eventController.stream) {
      yield evt;
      if (evt is CarbonTurnComplete) break;
      if (evt is CarbonError && evt.fatal) break;
      if (evt is CarbonSessionEnded) break;
    }
  }
}

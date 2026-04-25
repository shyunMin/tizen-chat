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

  Future<void> connect({String? sessionName}) async {
    if (_isConnected || _isConnecting) return;
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
            },
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

  // To support returning a stream from sendMessage() while using a single gRPC stream,
  // we use a broadcast stream controller.
  final StreamController<CarbonEvent> _eventController =
      StreamController<CarbonEvent>.broadcast();
  StreamSubscription<ServerEvent>? _responseSubscription;

  // Track if a turn is currently active to avoid duplicate processing of the same stream
  bool _isTurnActive = false;

  void _handleServerEvent(ServerEvent event) {
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
      if (event.error.fatal) _isConnected = false;
    } else if (event.hasSessionEnded()) {
      _eventController.add(CarbonSessionEnded(event.sessionEnded.reason));
      _isConnected = false;
    }
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

  Stream<CarbonEvent> sendMessage(String text) async* {
    if (!_isConnected) {
      await connect();
    }

    if (_sessionId == null) {
      yield CarbonError("NO_SESSION", "Failed to retrieve session id", true);
      return;
    }

    // Mutex: Wait if a turn is already active
    if (_isTurnActive) {
      print(
        'DEBUG: [CarbonGrpc] Warning: Multiple sendMessage calls overlap. Waiting for previous turn...',
      );
      // In a more robust system we might use a queue, but here we just block/error or wait
      while (_isTurnActive) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    _isTurnActive = true;
    try {
      _requestStreamController!.add(
        ClientMessage(
          ingressInput: IngressInput(
            sessionId: _sessionId,
            intent: IngressIntent.INGRESS_INTENT_RUN_TURN,
            source: "ai-chat-flutter",
            text: text,
          ),
        ),
      );

      // Now we wait for events from our broadcast controller.
      await for (final evt in _eventController.stream) {
        yield evt;
        if (evt is CarbonTurnComplete) {
          break;
        } else if (evt is CarbonError && evt.fatal) {
          break;
        } else if (evt is CarbonSessionEnded) {
          break;
        }
      }
    } catch (e) {
      yield CarbonError("SEND_ERROR", e.toString(), false);
    } finally {
      _isTurnActive = false;
    }
  }
}

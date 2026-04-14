import 'dart:async';
import 'dart:io';

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

  Future<void> connect() async {
    if (_isConnected || _isConnecting) return;
    _isConnecting = true;

    // Tizen Flutter does not support Unix Domain Socket (dart:io limitation on Tizen).
    // carbon-daemon listens on a Unix socket; socat bridges it to TCP 50051 on the device.
    // Start socat bridge before connecting:
    //   sdb shell "socat TCP-LISTEN:50051,reuseaddr,fork UNIX-CLIENT:/tmp/carbon/carbon.sock &"
    final endpoints = [
      // 'TCP:127.0.0.1:50051', // socat bridge: Unix socket → TCP (primary)
      // 'TCP:192.168.0.11:50051',
      // '/run/carbon/carbon.sock',
      '/run/user/5001/carbon/carbon.sock',
    ];

    Exception? lastError;

    for (final endpoint in endpoints) {
      try {
        print('DEBUG: [CarbonGrpc] Trying to connect to: $endpoint');

        if (endpoint.startsWith('TCP:')) {
          final parts = endpoint.split(':');
          _channel = ClientChannel(
            parts[1],
            port: int.parse(parts[2]),
            options: const ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          );
        } else {
          _channel = ClientChannel(
            InternetAddress(endpoint, type: InternetAddressType.unix),
            port: 0,
            options: const ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          );
        }

        _client = AgentServiceClient(_channel!);
        _requestStreamController = StreamController<ClientMessage>();

        final responseStream = _client!.session(
          _requestStreamController!.stream,
        );
        final handshakeCompleter = Completer<void>();

        _responseSubscription = responseStream.listen(
          (ServerEvent event) {
            if (event.hasSessionCreated()) {
              _sessionId = event.sessionCreated.sessionId;
              print(
                'DEBUG: [CarbonGrpc] Session Created: $_sessionId via $endpoint',
              );
              if (!handshakeCompleter.isCompleted)
                handshakeCompleter.complete();
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

        // Send the handshake
        _requestStreamController!.add(
          ClientMessage(createSession: CreateSessionRequest(product: "claw")),
        );

        await handshakeCompleter.future.timeout(const Duration(seconds: 3));
        _isConnected = true;
        _isConnecting = false;
        print('DEBUG: [CarbonGrpc] Successfully connected to $endpoint');
        return; // Connection successful!
      } catch (e) {
        print('DEBUG: [CarbonGrpc] Connect Error on $endpoint: $e');
        lastError = Exception(e.toString());
        await disconnect(); // Cleanup before trying next
      }
    }

    _isConnected = false;
    _isConnecting = false;
    // throw lastError ?? Exception('All connection attempts failed');
  }

  // To support returning a stream from sendMessage() while using a single gRPC stream,
  // we use a broadcast stream controller.
  final StreamController<CarbonEvent> _eventController =
      StreamController<CarbonEvent>.broadcast();
  StreamSubscription<ServerEvent>? _responseSubscription;

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
    await disconnect();
    await connect();
  }

  Stream<CarbonEvent> sendMessage(String text) async* {
    if (!_isConnected) {
      await connect();
    }

    if (_sessionId == null) {
      yield CarbonError("NO_SESSION", "Failed to retrieve session id", true);
      return;
    }

    final ingressInput = IngressInput(
      sessionId: _sessionId,
      intent: IngressIntent.INGRESS_INTENT_RUN_TURN,
      source: "ai-chat-flutter",
      text: text,
    );

    try {
      _requestStreamController!.add(ClientMessage(ingressInput: ingressInput));

      // Now we wait for events from our broadcast controller.
      // We yield them until TurnComplete, fatal error, or SessionEnded.
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
    }
  }
}

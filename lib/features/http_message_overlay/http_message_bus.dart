import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

const int kHttpMessagePort = 7777;

/// Singleton HTTP message bus.
/// Manages a single HttpServer instance shared by all consumers.
/// Use acquire() before subscribing and release() when done.
class HttpMessageBus {
  HttpMessageBus._internal();
  static final HttpMessageBus instance = HttpMessageBus._internal();

  HttpServer? _server;
  int _acquireCount = 0;
  // Persistent controller — never closed so re-subscription always works.
  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  /// Broadcast stream of incoming messages.
  Stream<String> get stream => _controller.stream;

  /// Call once per consumer (in initState). Starts server on first call.
  Future<void> acquire() async {
    _acquireCount++;
    if (_server != null) return; // already running
    try {
      _server = await HttpServer.bind(
          InternetAddress.loopbackIPv4, kHttpMessagePort);
      debugPrint('[HttpMessageBus] Listening on port $kHttpMessagePort');
      _server!.listen(_handleRequest);
    } catch (e) {
      debugPrint('[HttpMessageBus] Failed to start: $e');
    }
  }

  /// Call once per consumer (in dispose). Stops server when no consumers remain.
  Future<void> release() async {
    _acquireCount = (_acquireCount - 1).clamp(0, 9999);
    if (_acquireCount == 0) {
      await _server?.close(force: true);
      _server = null;
      debugPrint('[HttpMessageBus] Server stopped');
    }
  }

  Future<void> _handleRequest(HttpRequest request) async {
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers
        .add('Access-Control-Allow-Methods', 'POST, OPTIONS');
    request.response.headers
        .add('Access-Control-Allow-Headers', 'Content-Type');

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.ok;
      await request.response.close();
      return;
    }

    if (request.method == 'POST' && request.uri.path == '/message') {
      try {
        final body = await utf8.decoder.bind(request).join();
        String message = body;
        final ct = request.headers.contentType?.toString() ?? '';
        if (ct.contains('application/json')) {
          final data = jsonDecode(body);
          message = data['text']?.toString() ?? body;
        }
        _controller.add(message);
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write('{"status":"ok"}');
      } catch (e) {
        debugPrint('[HttpMessageBus] Request error: $e');
        request.response.statusCode = HttpStatus.internalServerError;
      }
    } else {
      request.response.statusCode = HttpStatus.notFound;
    }
    await request.response.close();
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

const int kHttpMessagePort = 7777;

class HttpMessageServer {
  HttpServer? _server;
  final StreamController<String> _controller = StreamController<String>.broadcast();

  Stream<String> get messageStream => _controller.stream;

  Future<void> start() async {
    if (_server != null) return;

    try {
      _server = await HttpServer.bind(InternetAddress.loopbackIPv4, kHttpMessagePort);
      print('HttpMessageServer listening on port $kHttpMessagePort');

      _server!.listen((HttpRequest request) async {
        // CORS Header
        request.response.headers.add('Access-Control-Allow-Origin', '*');
        request.response.headers.add('Access-Control-Allow-Methods', 'POST, OPTIONS');
        request.response.headers.add('Access-Control-Allow-Headers', 'Content-Type');

        if (request.method == 'OPTIONS') {
          request.response.statusCode = HttpStatus.ok;
          await request.response.close();
          return;
        }

        if (request.method == 'POST' && request.uri.path == '/message') {
          try {
            final body = await utf8.decoder.bind(request).join();
            String message = body;

            final contentType = request.headers.contentType?.toString() ?? '';
            if (contentType.contains('application/json')) {
              final data = jsonDecode(body);
              message = data['text']?.toString() ?? body;
            }

            _controller.add(message);

            request.response
              ..statusCode = HttpStatus.ok
              ..headers.contentType = ContentType.json
              ..write(jsonEncode({'status': 'ok'}));
          } catch (e) {
            print('Error processing request: $e');
            request.response.statusCode = HttpStatus.internalServerError;
          }
        } else {
          request.response.statusCode = HttpStatus.notFound;
        }

        await request.response.close();
      });
    } catch (e) {
      print('Failed to start HttpMessageServer: $e');
    }
  }

  Future<void> stop() async {
    await _server?.close(force: true);
    _server = null;
    await _controller.close();
  }
}

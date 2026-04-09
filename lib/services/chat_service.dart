import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  //sdb shell curl -v -X POST http://192.168.0.6:10010/api/status
  final String baseUrl =
      'http://192.168.0.6:10010'; // Use PC's LAN IP for stability
  // Use static http methods for better stability in SDB environments
  // final http.Client _client = http.Client(); // Removed instance-based client
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<Map<String, dynamic>> connect() async {
    if (_isConnected) {
      return {'can_chat': true, 'message': 'Already connected.'};
    }
    try {
      print('DEBUG: [CONNECT-START] -> $baseUrl/api/status');
      final startTime = DateTime.now();

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/status'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Connection': 'close', // Force close to prevent SDB hang
            },
          )
          .timeout(const Duration(seconds: 15));

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      print(
        'DEBUG: [CONNECT-END] Status: ${response.statusCode} (${duration}ms)',
      );

      if (response.statusCode == 200) {
        _isConnected = true;
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        return {
          'can_chat': false,
          'message': 'Server error: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('DEBUG: [ERROR-CONNECT] $e');
      return {
        'can_chat': false,
        'message':
            'Connection failed. Ensure PC server is active and SDB reverse is configured.',
      };
    }
  }

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      // If not connected, try to connect first (Initialize)
      if (!_isConnected) {
        print('DEBUG: [CHAT-INIT] Server not ready, initializing first...');
        await connect();
      }

      print('DEBUG: [CHAT-START] -> "$message"');
      final startTime = DateTime.now();

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/chat'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Connection': 'close', // Force close to prevent SDB hang
            },
            body: jsonEncode({'message': message, 'session_id': '1234567890'}),
          )
          .timeout(const Duration(seconds: 180));

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      final String bodyString = utf8.decode(response.bodyBytes);
      print('DEBUG: [CHAT-END] Status: ${response.statusCode} (${duration}ms)');
      print('DEBUG: [CHAT-BODY] Length: ${bodyString.length}');

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(bodyString) as Map<String, dynamic>;
          return {
            ...decoded,
            'text':
                decoded['text'] ??
                decoded['response'] ??
                decoded['message'] ??
                '',
            'ui_code': decoded['ui_code'] ?? '',
          };
        } catch (je) {
          print('DEBUG: [ERROR-JSON] $je');
          return {'text': bodyString, 'ui_code': ''};
        }
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } on TimeoutException {
      print('DEBUG: [TIMEOUT] SDB request timed out.');
      throw Exception('Server request timed out. Check SDB connection.');
    } catch (e) {
      print('DEBUG: [ERROR-SEND] $e');
      throw Exception('Chat error: $e');
    }
  }

  void dispose() {
    // No-op for static http usage
  }
}

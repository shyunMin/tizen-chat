import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  // final String baseUrl =
  // 'http://192.168.0.6:10010'; // Use PC's LAN IP for stability
  final String baseUrl = 'http://localhost:9090';
  final http.Client _client = http.Client();
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<Map<String, dynamic>> connect() async {
    // New server doesn't need to check connection on startup
    /*
    if (_isConnected) {
      return {'can_chat': true, 'message': 'Already connected.'};
    }
    try {
      print('DEBUG: [REQUEST] Connecting to $baseUrl/status ...');

      final response = await _client
          .get(
            Uri.parse('$baseUrl/api/status'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Connection': 'close',
            },
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        _isConnected = true;
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      print('DEBUG: [ERROR-CONNECT] $e');
    }
    */
    return {'can_chat': true, 'message': 'Connection check skipped.'};
  }

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      print('DEBUG: [REQUEST] chat -> $message');

      final response = await _client
          .post(
            Uri.parse('$baseUrl/api/chat'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Connection': 'close',
            },
            body: jsonEncode({
              'prompt': message, 
              'session_id': '1234567890',
              'stream': false // Explicitly disable stream if supported
            }),
          )
          .timeout(const Duration(seconds: 180)); // Extend to 180s for complex reasoning agents

      print('DEBUG: [RESPONSE] Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        print('DEBUG: [RESPONSE] Full Data: ${jsonEncode(decoded)}');
        return decoded;
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } on TimeoutException {
      print('DEBUG: [TIMEOUT] Chat response delayed or blocked.');
      throw Exception(
        'The agent took too long to respond. Please check the python server console.',
      );
    } catch (e) {
      print('DEBUG: [ERROR-SEND] $e');
      throw Exception('Chat error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

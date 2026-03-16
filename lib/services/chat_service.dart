import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = 'http://192.168.0.6:9090'; // Use PC's LAN IP for stability
  final http.Client _client = http.Client();

  Future<Map<String, dynamic>> connect() async {
    try {
      print('DEBUG: [REQUEST] Connecting to $baseUrl/connect ...');
      
      final response = await _client.post(
        Uri.parse('$baseUrl/connect'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Connection': 'close',
        },
      ).timeout(const Duration(seconds: 20));

      print('DEBUG: [RESPONSE] Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } on TimeoutException {
      print('DEBUG: [TIMEOUT] No response bytes received within 20s.');
      throw Exception(
        'Server at $baseUrl is not responding back. \n'
        '1. Ensure "sdb reverse tcp:9090 tcp:9090" is active. \n'
        '2. Check if PC firewall allows Python/Uvicorn to communicate. \n'
        '3. Try restarting the Tizen device and SDB server.'
      );
    } catch (e) {
      print('DEBUG: [ERROR] $e');
      throw Exception('Connection error: $e');
    }
  }

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      print('DEBUG: [REQUEST] chat -> $message');
      
      final response = await _client.post(
        Uri.parse('$baseUrl/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Connection': 'close',
        },
        body: jsonEncode({'message': message}),
      ).timeout(const Duration(seconds: 60));

      print('DEBUG: [RESPONSE] Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        return decoded;
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } on TimeoutException {
      print('DEBUG: [TIMEOUT] Chat response delayed or blocked.');
      throw Exception('The agent took too long to respond. Please check the python server console.');
    } catch (e) {
      print('DEBUG: [ERROR] $e');
      throw Exception('Chat error: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

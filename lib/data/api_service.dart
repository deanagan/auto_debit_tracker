import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5146';
    } else {
      // iOS Simulator and Desktop use localhost
      return 'http://localhost:5146';
    }
  }

  Future<List<Map<String, dynamic>>> fetchAccounts() async {
    final url = Uri.parse('$baseUrl/api/Accounts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch accounts');
    }
  }
}

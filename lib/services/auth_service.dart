import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {

  static Future<Map<String, dynamic>?> login(
      String correo, String password) async {

    final response = await http.post(
      Uri.parse('http://TU_API/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "correo": correo,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
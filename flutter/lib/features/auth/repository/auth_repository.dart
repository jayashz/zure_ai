import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zure_ai/core/constant.dart';

class AuthRepository {
  Future<bool> login(String username, String password) async {
    final url = Uri.parse('${Constant.ipAddress}/api/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      print("✅ Login successful. Token: $token");
      return true;
    } else {
      print("❌ Login failed: ${response.body}");
      return false;
    }
  }

  Future<bool> signup(String username, String password) async {
    final url = Uri.parse('${Constant.ipAddress}/api/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      print("✅ Signup successful. Token saved.");
      return true;
    } else {
      print("❌ Signup failed: ${response.body}");
      return false;
    }
  }
}

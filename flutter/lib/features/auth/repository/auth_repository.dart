import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zure_ai/core/constant.dart';
import 'package:zure_ai/core/services/database_services.dart';

class AuthRepository {
  final DatabaseServices databaseServices = DatabaseServices();
  String _token = "";

  String get getToken => _token;

  Future<void> init() async {
    final tempToken = await databaseServices.getToken();
    if (tempToken.isNotEmpty) {
      _token = tempToken;
    }
  }

  Future<Either<String, dynamic>> login(
    String username,
    String password,
  ) async {
    final url = Uri.parse('${Constant.ipAddress}/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      final data = jsonDecode(response.body);
      final token = data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);
      return Right(null);
    } catch (e) {
      return Left("Error loggin in:${e.toString()}");
    }
  }

  Future<Either<String, dynamic>> signup(
    String username,
    String password,
  ) async {
    final url = Uri.parse('${Constant.ipAddress}/api/auth/register');

    try {
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
      }
      return Right(null);
    } catch (e) {
      return Left("Error signing up:${e.toString()}");
    }
  }

  Future<void> logout() async {
    _token = "";
    databaseServices.removeToken();
  }
}

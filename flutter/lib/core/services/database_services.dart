import 'package:shared_preferences/shared_preferences.dart';

class DatabaseServices {
  static const _token = 'jwt_token';
  
  Future<String> getToken() async {
    final instance = await SharedPreferences.getInstance();
    return instance.getString(_token) ?? "";
  }

  Future<void> saveToken(String token) async {
    final instance = await SharedPreferences.getInstance();
    instance.setString(_token, token);
  }

  Future<void> removeToken() async {
    final instance = await SharedPreferences.getInstance();
    instance.remove(_token);
  }
}

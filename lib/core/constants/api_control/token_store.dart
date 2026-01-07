import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _key = 'token'; // Changed from 'auth_token' to match rest of app

  static Future<void> save(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key, token);
  }

  static Future<String> get() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_key) ?? "";
  }
}

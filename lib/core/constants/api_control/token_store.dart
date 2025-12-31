import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _key = 'auth_token';

  static Future<void> save(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key, token);
  }

  static Future<String> get() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_key) ?? "";
  }
}

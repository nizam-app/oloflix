import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  /// 🔑 লগইন করা আছে কিনা সেটা true/false দেবে
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString("email");
    final token = prefs.getString("token");

    return (email?.isNotEmpty ?? false) && (token?.isNotEmpty ?? false);
  }}
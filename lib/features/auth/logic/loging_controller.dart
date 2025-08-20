import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isLoggedIn = false.obs;
  var rememberMe = false.obs;
  var isLoading = false.obs; 

  Future<void> login(String email, String password) async {
  try {
    isLoading.value = true;

    var url = Uri.parse("http://103.145.138.111:8000/api/login");

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      // ✅ ধরলাম API token ফেরত দেয়
      String token = data["token"] ?? "";

      isLoggedIn.value = true;

      // Save credentials only if "remember me" is checked
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("email", email);
      if (rememberMe.value) {
        await prefs.setString("password", password);
      }
      if (token.isNotEmpty) {
        await prefs.setString("token", token);
      }

      Get.offAllNamed("/homePage");
    } else {
      var data = jsonDecode(response.body);
      Get.snackbar("Error", data["message"] ?? "Invalid email or password");
    }
  } catch (e) {
    Get.snackbar("Error", e.toString());
  } finally {
    isLoading.value = false;
  }
}
}

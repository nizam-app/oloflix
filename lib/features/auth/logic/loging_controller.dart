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

      var url = Uri.parse(" "); 
      var response = await http.post(url, body: {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        
        String token = data["token"];

        isLoggedIn.value = true;

        if (rememberMe.value) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString("email", email);
          await prefs.setString("password", password);
          await prefs.setString("token", token);
        }

        
        Get.offAllNamed("/homePage");
      } else {
        Get.snackbar("Error", "Invalid email or password");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    isLoggedIn.value = false;
    Get.offAllNamed("/login");
  }

  Future<void> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString("email");
    String? password = prefs.getString("password");

    if (email != null && password != null) {
      isLoggedIn.value = true;
      Get.offAllNamed("/homePage"); 
    } else {
      Get.offAllNamed("/login");
    }
  }
}

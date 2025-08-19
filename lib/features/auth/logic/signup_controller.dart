import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignupController extends GetxController{

  var isLoading = false.obs;

  Future<void> signup(String name, String email, String password, String confirmPassword, ) async {
    try {
    
      if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        Get.snackbar("Error","Enter Valid Name, Email, or Password");
        return;
      }
      if (password != confirmPassword) {
        Get.snackbar("Error", "Password and  Confirm Password  Same ");
        return;
      }

      isLoading.value = true;

      var url = Uri.parse(" "); 
      var response = await http.post(url, body: {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // ✅ ধরি API success হলে token আসবে
        String token = data["token"] ?? "";

        // SharedPreferences এ চাইলে রাখতে পারেন
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("email", email);
        await prefs.setString("token", token);

        Get.snackbar("Success", "Signup successful! Please login");
        Get.offAllNamed("/login_screen"); 
      } else {
        Get.snackbar("Error", "Signup failed! Try again");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
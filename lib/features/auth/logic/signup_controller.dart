
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;

  Future<void> signup(
    String name,
    String email,
    String password,
    String password_confirmation,
  ) async {
    try {
      // Validation
      if (name.isEmpty || email.isEmpty || password.isEmpty || password_confirmation.isEmpty) {
        Get.snackbar("Error", "Enter valid Name, Email, and Password");
        return;
      }
      if (password != password_confirmation) {
        Get.snackbar("Error", "Password and Confirm Password must be same");
        return;
      }

      isLoading.value = true;
      
      var url = Uri.parse("http://103.145.138.111:8000/api/signup");

      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": password_confirmation, 
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);

        // ✅ ধরলাম API থেকে token আসবে
        String token = data["token"] ?? "";

        // Save to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("email", email);
        if (token.isNotEmpty) {
          await prefs.setString("token", token);
        }

        Get.snackbar("Success", data["message"] ?? "Signup successful!");
        Get.offAllNamed("/login_screen"); 
        print("Signup succesfull"); 
      } else {
        var data = jsonDecode(response.body);
        Get.snackbar("Error", data["error"] ?? "Signup failed! Try again");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgetController extends GetxController{
  var isLoading = false.obs;

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }

    try {
      isLoading.value = true;

      var url = Uri.parse(" "); 
      var response = await http.post(
        url,
        body: {"email": email},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        Get.snackbar("Success", data["message"] ?? "Reset link sent to your email");
      } else {
        var data = jsonDecode(response.body);
        Get.snackbar("Error", data["error"] ?? "Failed to send reset link");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
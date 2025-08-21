import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OtpController extends GetxController{
  var isLoading = false.obs;

  /// ✅ Send OTP (to Email)
  Future<void> sendOtp(String email) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }
    try {
      isLoading.value = true;

      var url = Uri.parse("http://103.145.138.116:3000/users/send-otp");
      var response = await http.post(
        url,
        body: {"email": email},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        Get.snackbar("Success", data["message"] ?? "OTP sent to your email");
      } else {
        var data = jsonDecode(response.body);
        Get.snackbar("Error", data["error"] ?? "Failed to send OTP");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }

     // ✅ Verify OTP
  Future<void> verifyOtp(String email, String otp) async {
    if (email.isEmpty || otp.isEmpty) {
      Get.snackbar("Error", "Please enter email and OTP");
      return;
    }
    try {
      isLoading.value = true;

      var url = Uri.parse("http://103.145.138.116:3000/users/verify-otp");
      var response = await http.post(
        url,
        body: {"email": email, "otp": otp},
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        Get.snackbar("Success", data["message"] ?? "OTP verified successfully");

        // Get.offAllNamed("/profile");
      } else {
        var data = jsonDecode(response.body);
        Get.snackbar("Error", data["error"] ?? "Invalid OTP");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  }
  }
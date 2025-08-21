import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignupController extends GetxController {
  var isLoading = false.obs;

  Future<void> signup(
    BuildContext context,
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty || passwordConfirmation.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid Name, Email, and Password")),
      );
      return;
    }

    if (password != passwordConfirmation) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password and Confirm Password must be same")),
      );
      return;
    }

    isLoading.value = true;

    try {
      var url = Uri.parse("http://103.145.138.111:8000/api/signup");
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        }),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        String token = data["token"] ?? "";

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("email", email);
        if (token.isNotEmpty) await prefs.setString("token", token);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Signup successful!")),
        );

        // ✅ redirect to login
        GoRouter.of(context).go("/login_screen");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["error"] ?? data["message"] ?? "Signup failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      isLoading.value = false;
    }
  }
}

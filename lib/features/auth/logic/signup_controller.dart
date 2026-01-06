import 'dart:convert';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class SignupController extends GetxController {
  var isLoading = false.obs;

  Future<void> signup(
    BuildContext context,
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    // Validation
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
      // ✅ Use centralized API endpoint
      final url = Uri.parse(AuthAPIController.signup);
      debugPrint('📤 Signup Request to: $url');
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
        }),
      );

      debugPrint('📥 Signup Response Status: ${response.statusCode}');
      debugPrint('📥 Signup Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Signup successful!');

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data["message"] ?? "Signup successful! Please login."),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }

        // ✅ Navigate to Login Screen after successful signup
        await Future.delayed(const Duration(milliseconds: 500));
        if (context.mounted) {
          debugPrint('🔐 Navigating to Login screen...');
          context.go("/login_screen");
          debugPrint('✅ Navigation to login executed!');
        }
      } else {
        // Handle error responses
        String errorMessage = "Signup failed";
        
        if (data["error"] != null) {
          errorMessage = data["error"];
        } else if (data["message"] != null) {
          errorMessage = data["message"];
        } else if (data["errors"] != null) {
          // Handle validation errors (Laravel format)
          var errors = data["errors"];
          if (errors is Map) {
            // Get first error message
            var firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              errorMessage = firstError[0].toString();
            } else {
              errorMessage = firstError.toString();
            }
          }
        }

        debugPrint('❌ Signup failed: $errorMessage');
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Signup Exception: $e');
      debugPrint('Stack trace: $stackTrace');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Network Error: ${e.toString()}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}

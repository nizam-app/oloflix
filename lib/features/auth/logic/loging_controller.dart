import 'dart:convert';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
   var rememberMe = false.obs;


  Future<void> login(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter Email and Password")),
      );
      return;
    }

    isLoading.value = true;

    try {
      var url = Uri.parse(AuthAPIController.login);
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      var data = jsonDecode(response.body);
      

      if (response.statusCode == 200) {
        print(response.body);
        String token = data["data"]["token"] ?? "";
        print( "this tha token token $token") ;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("email", email);
        if (token.isNotEmpty) await prefs.setString("token", token);

        // ✅ Navigate to Home Page
        GoRouter.of(context).go("/homePage");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Invalid email or password")),
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
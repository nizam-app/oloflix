import 'dart:convert';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:Oloflix/core/widget/bottom_nav_bar/screen/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/widget/bottom_nav_bar/controller/bottom_controller.dart';
import '../../deshboard/logic/deshboard_reverport.dart';

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
      final url = Uri.parse(AuthAPIController.login);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final String token = data["data"]?["token"] ?? "";

        // 1) Token সেভ (await দিয়ে)
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("email", email);
        if (token.isNotEmpty) await prefs.setString("token", token);

        // (ঐচ্ছিক) পুরনো cached profile মুছুন
        await prefs.remove("profile");

        // 2) Riverpod cache/state রিসেট + warm fetch
        final container = ProviderScope.containerOf(context);

        // যে যে প্রোভাইডার নতুন ডেটা আনে, সেগুলো invalidate করুন
        container.invalidate(profileProvider);
        container.invalidate(userProvider);
        container.invalidate(selectedIndexProvider);

        // চাইলে প্রোফাইল আগে থেকেই ফেচ করিয়ে নিতে পারেন
        try {
          await container.read(profileProvider.future);
        } catch (_) {
          // প্রোফাইল না এলে ন্যাভিগেট করলেও UI পরে লোড হয়ে যাবে
        }

        // 3) ন্যাভিগেট
        if (context.mounted) context.go(BottomNavBar.routeName);
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
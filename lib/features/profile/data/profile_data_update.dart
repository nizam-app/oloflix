import 'dart:convert';
import 'dart:io';

import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final profileUpdateController =
StateNotifierProvider<ProfileUpdateNotifier, AsyncValue<Map<String, dynamic>>>(
      (ref) => ProfileUpdateNotifier(),
);

class ProfileUpdateNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  ProfileUpdateNotifier() : super(const AsyncValue.data({}));

  Future<void> updateProfile({
    required String name,
    required String email,
    String? phone,
    String? address,
    File? imageFile,
  }) async {
    try {
      state = const AsyncValue.loading();

      // 🔹 টোকেন লোড করা
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        state = const AsyncValue.error("No Token Found", StackTrace.empty);
        return;
      }

      // 🔹 API URL
      final url = Uri.parse("${AuthAPIController.profile}");

      // 🔹 multipart request তৈরি
      var request = http.MultipartRequest("POST", url);
      request.headers["Authorization"] = "Bearer $token";

      request.fields["name"] = name;
      request.fields["email"] = email;
      if (phone != null) request.fields["phone"] = phone;
      if (address != null) request.fields["user_address"] = address;

      // যদি ছবি থাকে তবে যোগ করো
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath("user_image", imageFile.path));
      }

      // 🔹 request পাঠানো
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        state = AsyncValue.data(data);
      } else {
        state = AsyncValue.error(
            "Error: ${response.statusCode} - ${response.body}", StackTrace.empty);
      }
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
}
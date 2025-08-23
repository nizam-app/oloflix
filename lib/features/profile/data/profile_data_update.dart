

import 'dart:io';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class ProfileUpdateController extends StateNotifier<AsyncValue<void>> {
  ProfileUpdateController() : super(const AsyncData(null));

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    required String address,
    File? imageFile,
  }) async {
    state = const AsyncLoading();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token"); // token sharedPref এ সেভ করা আছে

      if (token == null) {
        throw Exception("Token not found!");
      }

      var uri = Uri.parse("${AuthAPIController.profile}"); // তোমার API endpoint
      var request = http.MultipartRequest("POST", uri);

      // Header এ bearer token
      request.headers["Authorization"] = "Bearer $token";

      // Body data
      request.fields["name"] = name;
      request.fields["email"] = email;
      request.fields["phone"] = phone;
      request.fields["address"] = address;

      // Image থাকলে upload
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "image",
          imageFile.path,
        ));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        state = const AsyncData(null);
      } else {
        throw Exception("Failed with status: ${response.statusCode}");
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
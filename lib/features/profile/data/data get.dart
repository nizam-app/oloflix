import 'dart:convert';
import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:Oloflix/features/profile/model/profile_data_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileRepository {


  Future<ProfileResponse> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      throw Exception("No token found in SharedPreferences");
    }

    final response = await http.get(
      Uri.parse(AuthAPIController.profile),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProfileResponse.fromJson(data);
    } else {
      throw Exception("Failed to load profile. Code: ${response.statusCode}");
    }
  }
}
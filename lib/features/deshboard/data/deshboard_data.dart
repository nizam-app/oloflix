import 'dart:convert';
import 'package:Oloflix/features/deshboard/model/deshboard_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ProfileRepository {
  /// GET profile with Bearer token from SharedPreferences
  Future<ProfileResponse> fetchProfile(String apiUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('No token found in SharedPreferences');
    }

    final res = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return ProfileResponse.fromJson(body);
    } else {
      throw Exception('Failed to load profile. Code: ${res.statusCode}');
    }
  }
}
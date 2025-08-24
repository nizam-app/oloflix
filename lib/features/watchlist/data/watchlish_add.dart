import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WatchlistAddRepository {
  Future<bool> addToWatchlist(String apiUrl, int postId, String postType) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      throw Exception("No token found in SharedPreferences");
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "post_id": postId,
        "post_type": postType,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // success
      return true;
    } else {
      throw Exception("Failed to add watchlist. Code: ${response.statusCode}, Body: ${response.body}");
    }
  }
}
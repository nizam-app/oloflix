import 'dart:convert';
import 'package:Oloflix/features/watchlist/model/watchlist_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WatchlistRepository {
  Future<List<Watchlist>> fetchWatchlist(String apiUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      throw Exception("No token found in SharedPreferences");
    }

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // ধরলাম response এ "watchlist" নামে list আসে
      final List<dynamic> list = data['watchlist'] ?? [];

      return list.map((item) => Watchlist.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load watchlist. Code: ${response.statusCode}");
    }
  }
}
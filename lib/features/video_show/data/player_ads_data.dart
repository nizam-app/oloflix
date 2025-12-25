import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/player_ads_model.dart';
import 'package:Oloflix/core/constants/api_control/global_api.dart';

class PlayerAdsService {
  /// Fetch player ads from the API
  static Future<PlayerAdsResponse?> fetchPlayerAds() async {
    try {
      final url = Uri.parse('${api}api/player-ads');
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PlayerAdsResponse.fromJson(data);
      } else {
        print('Failed to load player ads. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching player ads: $e');
      return null;
    }
  }
}


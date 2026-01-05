import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/player_ads_model.dart';

class PlayerAdsService {
  static const String apiUrl = 'http://103.208.183.250:8000/api/player-ads';

  /// Fetch player ads from API
  static Future<PlayerAdsResponse?> fetchPlayerAds() async {
    try {
      print('🎬 Fetching player ads from: $apiUrl');
      
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final adsResponse = PlayerAdsResponse.fromJson(jsonData);
        
        print('✅ Player ads loaded successfully');
        print('   Show ads: ${adsResponse.showAds}');
        print('   Number of ads: ${adsResponse.ads.length}');
        
        for (var i = 0; i < adsResponse.ads.length; i++) {
          final ad = adsResponse.ads[i];
          print('   Ad ${i + 1}: ${ad.timestart} - ${ad.source}');
        }
        
        return adsResponse;
      } else {
        print('❌ Failed to fetch player ads: ${response.statusCode}');
        print('   Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching player ads: $e');
      return null;
    }
  }
}


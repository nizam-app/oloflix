// lib/features/ads/data/ads_repository.dart
import 'dart:convert';
import 'package:Oloflix/core/widget/movie_and_promotion/model/promosion_slider.dart';
import 'package:http/http.dart' as http;

class AdsRepository {
  final String endpoint; // e.g. GlobalApi.adsEndpoint
  final String baseUrl;  // e.g. api (যেটা তুমি movie thumb-এ ইউজ করো)
  AdsRepository({required this.endpoint, required this.baseUrl});

  String toFullUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    // backend যদি relative path দেয়: "upload/xxx.jpg"
    if (path.startsWith('http')) return path;
    return '$baseUrl$path';
  }

  Future<List<AdModel>> fetchAds({required String token}) async {
    final res = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode != 200) {
      throw Exception('Ads fetch failed: ${res.statusCode} ${res.body}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final parsed = AdsResponse.fromJson(data);
    return parsed.ads;
  }
}
// lib/features/ads/data/ads_repository.dart
import 'dart:convert';
import 'package:Oloflix/core/widget/movie_and_promotion/model/promosion_slider.dart';
import 'package:http/http.dart' as http;

class AdsRepository {
  final String endpoint; // e.g. https://example.com/api/ads
  final String baseUrl;  // e.g. https://example.com/

  AdsRepository({required this.endpoint, required this.baseUrl});

  // নিশ্চিত করি যাতে baseUrl + path সঠিকভাবে join হয়
  String toFullUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;

    final b = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final p = path.startsWith('/') ? path : '/$path';
    return '$b$p'; // <-- এখানেই $globalApi (baseUrl) যুক্ত হচ্ছে
  }

  Future<List<AdModel>> fetchAds({required String token}) async {
    final res = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Accept': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Ads fetch failed: ${res.statusCode} ${res.body}');
    }

    final data = jsonDecode(res.body);
    if (data is List) {
      return data.map<AdModel>((e) => AdModel.fromJson(e as Map<String, dynamic>)).toList();
    } else if (data is Map<String, dynamic>) {
      final parsed = AdsResponse.fromJson(data);
      return parsed.ads;
    } else {
      throw Exception('Unexpected ads response shape');
    }
  }
}
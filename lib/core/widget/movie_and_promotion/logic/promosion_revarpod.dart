// lib/features/ads/logic/ads_providers.dart
import 'package:Oloflix/core/widget/movie_and_promotion/data/promosion_data.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/model/promosion_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:Oloflix/core/constants/api_control/auth_api.dart';   // endpoint
import 'package:Oloflix/core/constants/api_control/global_api.dart'; // baseUrl

final adsRepoProvider = Provider<AdsRepository>((ref) {
  // ⚠️ এখানে baseUrl এবং endpoint আলাদা রাখো
  final String baseUrl  = api;       // যেমন: "https://your-domain.com/"
  final String endpoint = AuthAPIController.ads;   // যেমন: "https://your-domain.com/api/ads"
  return AdsRepository(endpoint: endpoint, baseUrl: baseUrl);
});

final adsProvider = FutureProvider<List<AdModel>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';
  return ref.read(adsRepoProvider).fetchAds(token: token);
});

final adsSliderIndexProvider = StateProvider<int>((_) => 0);
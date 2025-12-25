// lib/features/ads/logic/ads_providers.dart
import 'package:Oloflix/core/constants/api_control/auth_api.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/data/promosion_data.dart';
import 'package:Oloflix/core/widget/movie_and_promotion/model/promosion_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Oloflix/core/constants/api_control/global_api.dart'; // endpoint/baseUrl ধরে

final adsRepoProvider = Provider<AdsRepository>((ref) {
  return AdsRepository(
    endpoint: AuthAPIController.ads, // <-- নিজের endpoint বসাও
    baseUrl: api,                    // <-- তোমার আগের base var (e.g. api)
  );
});



final adsProvider = FutureProvider<List<AdModel>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token'); // null হতে পারে
  
  // token থাকুক বা না থাকুক, ads fetch করবে (public access)
  return ref.read(adsRepoProvider).fetchAds(token: token);
});

// ডট ইন্ডিকেটর/কারেন্ট ইনডেক্সের জন্য ছোট state
final adsSliderIndexProvider = StateProvider<int>((_) => 0);
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
  try {
    print("🎬 Starting to fetch ads...");
    
    // Try to get token (but don't fail if it's missing)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    
    if (token.isEmpty) {
      print("⚠️ No auth token found, trying without authentication");
    } else {
      print("🔑 Auth token found, using it");
    }
    
    // Fetch ads (with or without token)
    final ads = await ref.read(adsRepoProvider).fetchAds(token: token.isEmpty ? null : token);
    
    print("✅ Successfully loaded ${ads.length} ads");
    
    if (ads.isNotEmpty) {
      print("📋 First ad: ${ads[0].title}");
      print("   Image: ${ads[0].image}");
    }
    
    return ads;
  } catch (e, stackTrace) {
    print("❌ Error loading ads: $e");
    print("Stack trace: $stackTrace");
    // Return empty list instead of throwing to prevent app crash
    return <AdModel>[];
  }
});

// ডট ইন্ডিকেটর/কারেন্ট ইনডেক্সের জন্য ছোট state
final adsSliderIndexProvider = StateProvider<int>((_) => 0);
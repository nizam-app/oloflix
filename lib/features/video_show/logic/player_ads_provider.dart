import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import '../models/player_ads_model.dart';
import '../data/player_ads_service.dart';

// Provider to fetch player ads
final playerAdsProvider = FutureProvider<PlayerAdsResponse?>((ref) async {
  return await PlayerAdsService.fetchPlayerAds();
});

// Provider to track which ads have been played
final playedAdsProvider = StateProvider<Set<int>>((ref) => {});

// Provider to check if currently playing an ad
final isPlayingAdProvider = StateProvider<bool>((ref) => false);

// Provider for the current ad controller
final currentAdControllerProvider = StateProvider<VideoPlayerController?>((ref) => null);

/// Ad Manager Class
class AdManager {
  final PlayerAdsResponse? adsResponse;
  final Set<int> playedAds;
  final Function(int adIndex) onAdTriggered;

  AdManager({
    required this.adsResponse,
    required this.playedAds,
    required this.onAdTriggered,
  });

  /// Check if an ad should be played at the current position
  void checkAndTriggerAd(Duration currentPosition) {
    if (adsResponse == null || !adsResponse!.showAds) {
      return;
    }

    for (var i = 0; i < adsResponse!.ads.length; i++) {
      final ad = adsResponse!.ads[i];
      
      // Skip if ad already played
      if (playedAds.contains(i)) {
        continue;
      }

      final adTime = ad.timestartDuration;
      
      // Check if current position has reached or passed the ad time
      // Allow a small buffer (1 second) to account for timing variations
      if (currentPosition >= adTime && 
          currentPosition < adTime + const Duration(seconds: 1)) {
        print('🎬 Triggering ad ${i + 1} at ${ad.timestart}');
        onAdTriggered(i);
        break; // Only trigger one ad at a time
      }
    }
  }

  /// Get ad by index
  VideoAd? getAd(int index) {
    if (adsResponse == null || index >= adsResponse!.ads.length) {
      return null;
    }
    return adsResponse!.ads[index];
  }
}


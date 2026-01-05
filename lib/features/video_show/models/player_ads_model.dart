// Model for player ads API response
class PlayerAdsResponse {
  final bool showAds;
  final String vastType;
  final String vastUrl;
  final String playerDefaultAds;
  final List<VideoAd> ads;

  PlayerAdsResponse({
    required this.showAds,
    required this.vastType,
    required this.vastUrl,
    required this.playerDefaultAds,
    required this.ads,
  });

  factory PlayerAdsResponse.fromJson(Map<String, dynamic> json) {
    return PlayerAdsResponse(
      showAds: json['show_ads'] as bool? ?? false,
      vastType: json['vast_type']?.toString() ?? '',
      vastUrl: json['vast_url']?.toString() ?? '',
      playerDefaultAds: json['player_default_ads']?.toString() ?? '',
      ads: (json['ads'] as List<dynamic>?)
              ?.map((e) => VideoAd.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class VideoAd {
  final String source;
  final String timestart;
  final String? link;

  VideoAd({
    required this.source,
    required this.timestart,
    this.link,
  });

  factory VideoAd.fromJson(Map<String, dynamic> json) {
    return VideoAd(
      source: json['source']?.toString() ?? '',
      timestart: json['timestart']?.toString() ?? '',
      link: json['link']?.toString(),
    );
  }

  // Convert timestart (HH:MM:SS) to Duration
  Duration get timestartDuration {
    try {
      final parts = timestart.split(':');
      if (parts.length == 3) {
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final seconds = int.parse(parts[2]);
        return Duration(hours: hours, minutes: minutes, seconds: seconds);
      }
    } catch (e) {
      print('❌ Error parsing timestart: $timestart - $e');
    }
    return Duration.zero;
  }

  // Check if this is a video ad (vs a link ad)
  bool get isVideoAd {
    return source.toLowerCase().endsWith('.mp4') || 
           source.toLowerCase().endsWith('.webm') ||
           source.toLowerCase().contains('video');
  }
}


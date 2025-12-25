class PlayerAdsResponse {
  final bool showAds;
  final String vastType;
  final String vastUrl;
  final String playerDefaultAds;
  final List<AdItem> ads;

  PlayerAdsResponse({
    required this.showAds,
    required this.vastType,
    required this.vastUrl,
    required this.playerDefaultAds,
    required this.ads,
  });

  factory PlayerAdsResponse.fromJson(Map<String, dynamic> json) {
    return PlayerAdsResponse(
      showAds: json['show_ads'] ?? false,
      vastType: json['vast_type']?.toString() ?? '',
      vastUrl: json['vast_url']?.toString() ?? '',
      playerDefaultAds: json['player_default_ads']?.toString() ?? '',
      ads: (json['ads'] as List<dynamic>?)
              ?.map((e) => AdItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AdItem {
  final String source;
  final String timestart;
  final String? link;

  AdItem({
    required this.source,
    required this.timestart,
    this.link,
  });

  factory AdItem.fromJson(Map<String, dynamic> json) {
    return AdItem(
      source: json['source']?.toString() ?? '',
      timestart: json['timestart']?.toString() ?? '00:00:00',
      link: json['link']?.toString(),
    );
  }

  /// Convert timestart (e.g., "00:05:00") to seconds
  int get timestartInSeconds {
    try {
      final parts = timestart.split(':');
      if (parts.length == 3) {
        final hours = int.parse(parts[0]);
        final minutes = int.parse(parts[1]);
        final seconds = int.parse(parts[2]);
        return hours * 3600 + minutes * 60 + seconds;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}


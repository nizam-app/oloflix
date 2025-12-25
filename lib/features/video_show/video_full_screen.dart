import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:Oloflix/features/profile/logic/login_check.dart';
import 'package:Oloflix/features/video_show/data/player_ads_data.dart';
import 'package:Oloflix/features/video_show/model/player_ads_model.dart';
import 'package:Oloflix/features/video_show/widgets/ad_player_overlay.dart';

class FullScreenPlayer extends StatefulWidget {
  const FullScreenPlayer({super.key, required this.controller});
  final VideoPlayerController controller;

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  bool _showControls = true;
  bool _isLoggedIn = false;
  PlayerAdsResponse? _adsResponse;
  List<AdItem> _pendingAds = [];
  Set<int> _shownAdIndexes = {};
  bool _isShowingAd = false;
  Timer? _adCheckTimer;
  Duration? _pausedPosition;

  @override
  void initState() {
    super.initState();
    // 👉 Only in fullscreen = landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    _checkAuthAndLoadAds();
    _startAdCheckTimer();
  }

  /// Check if user is logged in and load ads if not
  Future<void> _checkAuthAndLoadAds() async {
    _isLoggedIn = await AuthHelper.isLoggedIn();
    
    if (!_isLoggedIn) {
      // User is not logged in, fetch ads
      _adsResponse = await PlayerAdsService.fetchPlayerAds();
      
      if (_adsResponse != null && _adsResponse!.showAds) {
        setState(() {
          _pendingAds = List.from(_adsResponse!.ads);
        });
      }
    }
  }

  /// Start timer to check if it's time to show an ad
  void _startAdCheckTimer() {
    _adCheckTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isShowingAd && !_isLoggedIn && _pendingAds.isNotEmpty) {
        _checkAndShowAd();
      }
    });
  }

  /// Check current video position and show ad if needed
  void _checkAndShowAd() {
    if (_isShowingAd || widget.controller.value.position == Duration.zero) {
      return;
    }

    final currentSeconds = widget.controller.value.position.inSeconds;

    for (int i = 0; i < _pendingAds.length; i++) {
      if (_shownAdIndexes.contains(i)) continue;

      final ad = _pendingAds[i];
      final adTriggerTime = ad.timestartInSeconds;

      // Show ad if we've reached or passed the trigger time
      if (currentSeconds >= adTriggerTime && currentSeconds < adTriggerTime + 2) {
        _showAd(ad, i);
        break;
      }
    }
  }

  /// Show the ad overlay
  void _showAd(AdItem ad, int adIndex) async {
    if (_isShowingAd) return;

    setState(() {
      _isShowingAd = true;
      _shownAdIndexes.add(adIndex);
    });

    // Pause the main video
    _pausedPosition = widget.controller.value.position;
    await widget.controller.pause();

    if (!mounted) return;

    // Show ad overlay
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        pageBuilder: (context, _, __) => AdPlayerOverlay(
          adUrl: ad.source,
          onAdComplete: () {
            Navigator.of(context).pop();
          },
          onAdSkipped: () {
            Navigator.of(context).pop();
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    // Resume main video after ad
    if (mounted) {
      setState(() {
        _isShowingAd = false;
      });
      
      if (_pausedPosition != null) {
        await widget.controller.seekTo(_pausedPosition!);
      }
      await widget.controller.play();
    }
  }

  @override
  void dispose() {
    _adCheckTimer?.cancel();
    // 👉 Back to portrait when exit
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  String formatDuration(Duration position) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = position.inHours;
    final minutes = position.inMinutes.remainder(60);
    final seconds = position.inSeconds.remainder(60);
    if (hours > 0) {
      return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
    } else {
      return "${twoDigits(minutes)}:${twoDigits(seconds)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;

    return WillPopScope(
      onWillPop: () async {
        // fullscreen থেকে বের হওয়ার সময়ও থামাও চাইলে:
        await controller.pause();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            if (!_isShowingAd) {
              setState(() => _showControls = !_showControls);
            }
          },
          child: Stack(
            children: [
              // 🎬 Video
              Center(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              ),

              if (_showControls) ...[
                // 🔙 Back/Close Button (top-left)
                Positioned(
                  top: 20,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // ▶️ Play / Pause + Skip
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ⏪ Back 10s
                      IconButton(
                        icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
                        onPressed: () {
                          final newPos = controller.value.position - const Duration(seconds: 10);
                          controller.seekTo(newPos >= Duration.zero ? newPos : Duration.zero);
                        },
                      ),

                      // ▶️ / ⏸️ Play / Pause (reactive)
                      ValueListenableBuilder<VideoPlayerValue>(
                        valueListenable: controller,
                        builder: (_, value, __) {
                          final playing = value.isPlaying;
                          return IconButton(
                            icon: Icon(
                              playing ? Icons.pause_circle : Icons.play_circle,
                              color: Colors.white,
                              size: 60,
                            ),
                            onPressed: () {
                              if (playing) {
                                controller.pause();
                              } else {
                                controller.setVolume(1.0);
                                controller.play();
                              }
                            },
                          );
                        },
                      ),

                      // ⏩ Forward 10s
                      IconButton(
                        icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
                        onPressed: () {
                          final maxPos = controller.value.duration;
                          final newPos = controller.value.position + const Duration(seconds: 10);
                          controller.seekTo(newPos <= maxPos ? newPos : maxPos);
                        },
                      ),
                    ],
                  ),
                ),

                // Timeline + Time
                Positioned(
                  bottom: 10,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.red,
                          backgroundColor: Colors.grey,
                          bufferedColor: Colors.white30,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatDuration(controller.value.position),
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            formatDuration(controller.value.duration),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
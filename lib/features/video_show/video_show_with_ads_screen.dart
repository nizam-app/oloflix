import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'logic/video_controler.dart';
import 'logic/player_ads_provider.dart';
import 'models/player_ads_model.dart';
import 'data/player_ads_service.dart';
import 'video_full_screen.dart';

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}

class VideoShowWithAdsScreen extends ConsumerStatefulWidget {
  final String videoUrl;
  const VideoShowWithAdsScreen({super.key, required this.videoUrl});
  static const String routeName = '/videoShowScreen';

  @override
  ConsumerState<VideoShowWithAdsScreen> createState() => _VideoShowWithAdsScreenState();
}

class _VideoShowWithAdsScreenState extends ConsumerState<VideoShowWithAdsScreen> {
  VideoPlayerController? _adController;
  bool _isPlayingAd = false;
  bool _isLoggedIn = false;
  PlayerAdsResponse? _adsResponse;
  Set<int> _playedAds = {};
  VideoPlayerController? _mainController;
  bool _listenerAdded = false;
  bool _adSystemReady = false;
  bool _hasPreloadedFirstAd = false;
  
  // Skip button state
  bool _canSkipAd = false;
  int _adStartTime = 0;
  int _currentAdIndex = -1;
  Timer? _skipCountdownTimer;
  int _skipCountdown = 5;

  @override
  void initState() {
    super.initState();
    _initializeAdSystem();
  }

  // Initialize ad system with proper async handling
  Future<void> _initializeAdSystem() async {
    try {
      // Step 1: Check login status first (must complete before ads)
      await _checkLoginStatus();
      
      // Step 2: Initialize ads if user is not logged in
      if (!_isLoggedIn) {
        await _initializeAds();
        
        // Step 3: Pre-load first ad if it exists and is at start of video
        await _preloadFirstAd();
      }
      
      setState(() {
        _adSystemReady = true;
      });
      
      print('✅ Ad system fully initialized and ready');
    } catch (e) {
      print('❌ Error initializing ad system: $e');
      setState(() {
        _adSystemReady = true; // Allow video to play even if ad system fails
      });
    }
  }

  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      _isLoggedIn = token.isNotEmpty;
      
      print('🔐 Login status checked: ${_isLoggedIn ? "Logged In" : "Guest"}');
      
      if (_isLoggedIn) {
        print('✅ User logged in - Ads will be DISABLED');
      } else {
        print('👤 Guest user - Ads will be ENABLED');
      }
    } catch (e) {
      print('❌ Error checking login status: $e');
      _isLoggedIn = false;
    }
  }

  Future<void> _initializeAds() async {
    if (_isLoggedIn) {
      print('🚫 Skipping ad initialization - User is logged in');
      return;
    }

    try {
      print('🔄 Loading ads from provider...');
      
      // Use ref.read to get the AsyncValue and handle it properly
      final adsAsyncValue = ref.read(playerAdsProvider);
      
      // Handle the AsyncValue using when() or direct pattern matching
      await adsAsyncValue.when(
        data: (adsResponse) async {
          if (adsResponse != null && adsResponse.showAds) {
            _adsResponse = adsResponse;
            print('✅ Ads loaded: ${adsResponse.ads.length} ads available');
            
            // Log ad timings for debugging
            for (var i = 0; i < adsResponse.ads.length; i++) {
              final ad = adsResponse.ads[i];
              print('   Ad ${i + 1}: ${ad.timestart} (${ad.timestartDuration.inSeconds}s) - ${ad.isVideoAd ? "VIDEO" : "LINK"}');
            }
          } else {
            print('⚠️ No ads to show');
          }
        },
        loading: () async {
          print('🔄 Ads still loading, waiting...');
          // If still loading, we need to wait for it
          // Use a workaround: read the provider service directly
          final adsResponse = await PlayerAdsService.fetchPlayerAds();
          if (adsResponse != null && adsResponse.showAds) {
            _adsResponse = adsResponse;
            print('✅ Ads loaded: ${adsResponse.ads.length} ads available');
            
            for (var i = 0; i < adsResponse.ads.length; i++) {
              final ad = adsResponse.ads[i];
              print('   Ad ${i + 1}: ${ad.timestart} (${ad.timestartDuration.inSeconds}s) - ${ad.isVideoAd ? "VIDEO" : "LINK"}');
            }
          }
        },
        error: (error, stackTrace) async {
          print('❌ Error loading ads: $error');
        },
      );
    } catch (e) {
      print('❌ Error loading ads: $e');
    }
  }

  // Pre-load the first ad if it's at the start of the video
  Future<void> _preloadFirstAd() async {
    if (_adsResponse == null || _adsResponse!.ads.isEmpty) {
      print('⚠️ No ads to preload');
      return;
    }

    try {
      // Find first ad that's within the first 5 seconds
      for (var i = 0; i < _adsResponse!.ads.length; i++) {
        final ad = _adsResponse!.ads[i];
        
        // Check if ad is at the start (within first 5 seconds)
        if (ad.timestartDuration.inSeconds <= 5 && ad.isVideoAd) {
          print('📥 Pre-loading first ad at ${ad.timestart}...');
          
          // Validate URL
          if (ad.source.isEmpty || 
              (!ad.source.startsWith('http://') && !ad.source.startsWith('https://'))) {
            print('⚠️ Invalid ad URL: ${ad.source}');
            continue;
          }

          // Pre-initialize the ad controller
          _adController = VideoPlayerController.network(ad.source);
          
          await _adController!.initialize().timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              print('⏱️ First ad pre-load timed out');
              throw TimeoutException('Ad pre-load timeout');
            },
          );
          
          print('✅ First ad pre-loaded successfully');
          _hasPreloadedFirstAd = true;
          
          // If ad is at position 0, play it immediately
          if (ad.timestartDuration.inSeconds == 0) {
            print('🎬 Playing pre-roll ad immediately...');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _playPreloadedAd(i, ad);
            });
          }
          
          break; // Only preload the first early ad
        }
      }
    } catch (e) {
      print('❌ Error pre-loading first ad: $e');
      _adController?.dispose();
      _adController = null;
      _hasPreloadedFirstAd = false;
    }
  }

  // Play a pre-loaded ad
  Future<void> _playPreloadedAd(int adIndex, VideoAd ad) async {
    if (_adController == null || !_adController!.value.isInitialized) {
      print('⚠️ Pre-loaded ad not ready, loading now...');
      await _playAd(adIndex, ad);
      return;
    }

    print('🎬 Playing pre-loaded ad ${adIndex + 1}');
    
    setState(() {
      _isPlayingAd = true;
      _canSkipAd = false;
      _currentAdIndex = adIndex;
      _adStartTime = DateTime.now().millisecondsSinceEpoch;
      _skipCountdown = 5;
    });

    // Start countdown timer
    _skipCountdownTimer?.cancel();
    _skipCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPlayingAd || _currentAdIndex != adIndex) {
        timer.cancel();
        return;
      }

      setState(() {
        _skipCountdown--;
      });

      if (_skipCountdown <= 0) {
        timer.cancel();
        setState(() {
          _canSkipAd = true;
        });
        print('⏭️ Skip button enabled for ad ${adIndex + 1}');
      }
    });

    // Pause main video if it's playing
    _mainController?.pause();

    try {
      // Play the pre-loaded ad
      await _adController!.play();
      print('▶️ Pre-loaded ad playing');

      // Listen for ad completion
      _adController!.addListener(() {
        if (_adController != null &&
            _adController!.value.isInitialized &&
            _adController!.value.position >= _adController!.value.duration) {
          print('✅ Pre-loaded ad completed normally');
          _onAdComplete(adIndex);
        }
      });
    } catch (e) {
      print('❌ Error playing pre-loaded ad: $e');
      _onAdComplete(adIndex);
    }
  }

  void _setupMainVideoListener() {
    if (_mainController == null || _listenerAdded || _isLoggedIn) {
      return;
    }

    _mainController!.addListener(() {
      if (!mounted || _isPlayingAd || _adsResponse == null) {
        return;
      }

      final currentPosition = _mainController!.value.position;
      _checkAndPlayAd(currentPosition);
    });

    _listenerAdded = true;
    print('✅ Video listener added for ad checks');
  }

  void _checkAndPlayAd(Duration currentPosition) {
    // Don't check for ads if logged in or already playing an ad
    if (_isLoggedIn || _isPlayingAd || _adsResponse == null) {
      return;
    }

    for (var i = 0; i < _adsResponse!.ads.length; i++) {
      // Skip if ad already played
      if (_playedAds.contains(i)) {
        continue;
      }

      final ad = _adsResponse!.ads[i];
      final adTime = ad.timestartDuration;

      // Check if we should play this ad (within 1 second tolerance)
      if (currentPosition >= adTime &&
          currentPosition < adTime + const Duration(seconds: 1)) {
        print('🎬 Ad trigger at ${currentPosition.inSeconds}s (target: ${adTime.inSeconds}s)');
        _playAd(i, ad);
        break;
      }
    }
  }

  Future<void> _playAd(int adIndex, VideoAd ad) async {
    print('🎬 Attempting to play ad ${adIndex + 1} at ${ad.timestart}');
    print('   Source: ${ad.source}');

    // Only play video ads, skip link ads
    if (!ad.isVideoAd) {
      print('⚠️ Skipping non-video ad (not a video format)');
      _markAdAsPlayed(adIndex);
      return;
    }

    // Validate ad source URL
    if (ad.source.isEmpty || 
        (!ad.source.startsWith('http://') && !ad.source.startsWith('https://'))) {
      print('⚠️ Invalid ad source URL: ${ad.source}');
      _markAdAsPlayed(adIndex);
      return;
    }

    // Check if this is the first ad and it's already pre-loaded
    bool usingPreloadedAd = false;
    if (_hasPreloadedFirstAd && 
        _adController != null && 
        _adController!.value.isInitialized &&
        ad.timestartDuration.inSeconds <= 5) {
      print('✅ Using pre-loaded ad controller');
      usingPreloadedAd = true;
    }

    setState(() {
      _isPlayingAd = true;
      _canSkipAd = false;
      _currentAdIndex = adIndex;
      _adStartTime = DateTime.now().millisecondsSinceEpoch;
      _skipCountdown = 5;
    });

    // Start countdown timer
    _skipCountdownTimer?.cancel();
    _skipCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPlayingAd || _currentAdIndex != adIndex) {
        timer.cancel();
        return;
      }

      setState(() {
        _skipCountdown--;
      });

      if (_skipCountdown <= 0) {
        timer.cancel();
        setState(() {
          _canSkipAd = true;
        });
        print('⏭️ Skip button enabled for ad ${adIndex + 1}');
      }
    });

    // Pause main video
    print('⏸️ Pausing main video for ad');
    _mainController?.pause();

    try {
      // Initialize ad controller if not using pre-loaded one
      if (!usingPreloadedAd) {
        print('📥 Loading ad from: ${ad.source}');
        _adController = VideoPlayerController.network(ad.source);
        
        await _adController!.initialize().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            print('⏱️ Ad initialization timed out');
            throw TimeoutException('Ad loading timeout');
          },
        );

        print('✅ Ad initialized successfully');
      } else {
        print('✅ Using pre-loaded ad - instant playback');
      }

      // Play the ad
      await _adController!.play();
      print('▶️ Ad playing');

      // Listen for ad completion
      _adController!.addListener(() {
        if (_adController != null &&
            _adController!.value.isInitialized &&
            _adController!.value.position >= _adController!.value.duration) {
          print('✅ Ad completed normally');
          _onAdComplete(adIndex);
        }
      });
    } catch (e) {
      print('❌ Error playing ad: $e');
      print('🔄 Resuming main video');
      _onAdComplete(adIndex);
    }
  }

  void _onAdComplete(int adIndex) {
    print('✅ Ad ${adIndex + 1} completed');
    _markAdAsPlayed(adIndex);

    // Dispose ad controller
    _adController?.dispose();
    _adController = null;

    // Cancel countdown timer
    _skipCountdownTimer?.cancel();
    _skipCountdownTimer = null;

    // Reset preload flag
    _hasPreloadedFirstAd = false;

    setState(() {
      _isPlayingAd = false;
      _canSkipAd = false;
      _currentAdIndex = -1;
      _skipCountdown = 5;
    });

    // Resume main video
    _mainController?.play();
  }

  void _skipAd() {
    if (!_canSkipAd || _currentAdIndex == -1) return;
    
    print('⏭️ User skipped ad ${_currentAdIndex + 1}');
    _onAdComplete(_currentAdIndex);
  }

  void _markAdAsPlayed(int adIndex) {
    setState(() {
      _playedAds.add(adIndex);
    });
    print('   Marked ad ${adIndex + 1} as played (${_playedAds.length}/${_adsResponse?.ads.length ?? 0})');
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
  void dispose() {
    _adController?.dispose();
    _skipCountdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoAsync = ref.watch(videoPlayerControllerProvider(widget.videoUrl));
    final position = ref.watch(videoPositionProvider(widget.videoUrl));

    return WillPopScope(
      onWillPop: () async {
        final controller = videoAsync.asData?.value;
        if (controller != null && controller.value.isInitialized) {
          await controller.pause();
          await controller.setVolume(0.0);
        }
        _adController?.dispose();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: videoAsync.when(
          data: (controller) {
            // Store main controller reference
            _mainController = controller;

            if (!controller.value.isInitialized) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // Show loading while ad system initializes (only for guest users)
            if (!_isLoggedIn && !_adSystemReady) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(color: Colors.orange),
                    SizedBox(height: 20),
                    Text(
                      "Preparing video...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }

            // Setup listener for ad checks (only once)
            if (!_isLoggedIn && !_listenerAdded && _adSystemReady) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _setupMainVideoListener();
              });
            }

            return Stack(
              children: [
                // Main Video or Ad Video
                Center(
                  child: AspectRatio(
                    aspectRatio: _isPlayingAd && _adController != null
                        ? _adController!.value.aspectRatio
                        : controller.value.aspectRatio,
                    child: _isPlayingAd && _adController != null
                        ? VideoPlayer(_adController!)
                        : VideoPlayer(controller),
                  ),
                ),

                // Ad Label and Skip Button (only show when playing ad)
                if (_isPlayingAd)
                  Positioned(
                    top: 50,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // AD Label
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.yellow.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'AD',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 10),
                        
                        // Skip Button (appears after 5 seconds)
                        if (_canSkipAd)
                          ElevatedButton.icon(
                            onPressed: _skipAd,
                            icon: const Icon(Icons.skip_next, size: 18),
                            label: const Text(
                              'Skip Ad',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.9),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 4,
                            ),
                          )
                        else
                          // Countdown text (before skip is available)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Skip in ${_skipCountdown}s',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                // Back button
                Positioned(
                  top: 30,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () async {
                      await controller.pause();
                      await controller.setVolume(0.0);
                      _adController?.dispose();
                      context.pop();
                    },
                  ),
                ),

                // Ad Progress Bar (only show when playing ad)
                if (_isPlayingAd && _adController != null && _adController!.value.isInitialized)
                  Positioned(
                    bottom: 10,
                    left: 20,
                    right: 20,
                    child: Column(
                      children: [
                        VideoProgressIndicator(
                          _adController!,
                          allowScrubbing: false, // Don't allow scrubbing on ads
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          colors: const VideoProgressColors(
                            playedColor: Colors.yellow,
                            backgroundColor: Colors.white24,
                            bufferedColor: Colors.white38,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatDuration(_adController!.value.position),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              formatDuration(_adController!.value.duration),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Controls (only show when NOT playing ad)
                if (!_isPlayingAd)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // Control buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Rewind 10s
                            IconButton(
                              icon: const Icon(Icons.replay_10, color: Colors.white, size: 30),
                              onPressed: () {
                                final newPos = controller.value.position - const Duration(seconds: 10);
                                controller.seekTo(newPos >= Duration.zero ? newPos : Duration.zero);
                              },
                            ),

                            // Play/Pause
                            ValueListenableBuilder<VideoPlayerValue>(
                              valueListenable: controller,
                              builder: (_, value, __) {
                                final playing = value.isPlaying;
                                return IconButton(
                                  icon: Icon(
                                    playing ? Icons.pause_circle : Icons.play_circle,
                                    color: Colors.white,
                                    size: 50,
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

                            // Forward 10s
                            IconButton(
                              icon: const Icon(Icons.forward_10, color: Colors.white, size: 30),
                              onPressed: () {
                                final maxPos = controller.value.duration;
                                final newPos = controller.value.position + const Duration(seconds: 10);
                                controller.seekTo(newPos <= maxPos ? newPos : maxPos);
                              },
                            ),
                            
                            // Fullscreen button
                            IconButton(
                              icon: const Icon(Icons.fullscreen, color: Colors.white, size: 30),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenPlayer(
                                      controller: controller,
                                      videoUrl: widget.videoUrl,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        
                        // Progress Bar with Time Labels
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              // Video Progress Indicator Bar
                              VideoProgressIndicator(
                                controller,
                                allowScrubbing: true,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                colors: const VideoProgressColors(
                                  playedColor: Colors.red,
                                  backgroundColor: Colors.grey,
                                  bufferedColor: Colors.white30,
                                ),
                              ),
                              
                              const SizedBox(height: 6),
                              
                              // Time labels below progress bar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    formatDuration(position),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    formatDuration(controller.value.duration),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
          loading: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(color: Colors.orange),
                SizedBox(height: 20),
                Text(
                  "Loading video...",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 20),
                  const Text(
                    "Failed to load video",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$e",
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Go Back"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


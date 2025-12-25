import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class AdPlayerOverlay extends StatefulWidget {
  final String adUrl;
  final VoidCallback onAdComplete;
  final VoidCallback onAdSkipped;

  const AdPlayerOverlay({
    Key? key,
    required this.adUrl,
    required this.onAdComplete,
    required this.onAdSkipped,
  }) : super(key: key);

  @override
  State<AdPlayerOverlay> createState() => _AdPlayerOverlayState();
}

class _AdPlayerOverlayState extends State<AdPlayerOverlay> {
  late VideoPlayerController _adController;
  bool _isInitialized = false;
  bool _isError = false;
  int _countdown = 5;
  Timer? _countdownTimer;
  bool _canSkip = false;

  @override
  void initState() {
    super.initState();
    _initializeAdPlayer();
    _startCountdown();
  }

  void _initializeAdPlayer() async {
    try {
      _adController = VideoPlayerController.networkUrl(
        Uri.parse(widget.adUrl),
      );

      await _adController.initialize();
      await _adController.setVolume(1.0);
      await _adController.play();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }

      // Listen for ad completion
      _adController.addListener(() {
        if (_adController.value.position >= _adController.value.duration) {
          if (mounted) {
            _onAdFinished();
          }
        }
      });
    } catch (e) {
      print('Error initializing ad player: $e');
      if (mounted) {
        setState(() {
          _isError = true;
        });
        // Auto-skip if ad fails to load
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) widget.onAdComplete();
        });
      }
    }
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        if (mounted) {
          setState(() {
            _countdown--;
          });
        }
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            _canSkip = true;
          });
        }
      }
    });
  }

  void _onAdFinished() {
    _countdownTimer?.cancel();
    _adController.dispose();
    widget.onAdComplete();
  }

  void _onSkipPressed() {
    _countdownTimer?.cancel();
    _adController.pause();
    _adController.dispose();
    widget.onAdSkipped();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _adController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Ad Video Player
          if (_isInitialized)
            Center(
              child: AspectRatio(
                aspectRatio: _adController.value.aspectRatio,
                child: VideoPlayer(_adController),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),

          // Top-right: Skip button or countdown
          Positioned(
            top: 40,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _canSkip ? Colors.red : Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: _canSkip
                  ? InkWell(
                      onTap: _onSkipPressed,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Skip Ad',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.skip_next,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    )
                  : Text(
                      'You can skip in $_countdown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
            ),
          ),

          // Ad indicator (optional)
          Positioned(
            top: 40,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'AD',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          // Ad Progress Bar (optional)
          if (_isInitialized)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _adController,
                allowScrubbing: false,
                colors: const VideoProgressColors(
                  playedColor: Colors.amber,
                  backgroundColor: Colors.grey,
                  bufferedColor: Colors.white30,
                ),
              ),
            ),
        ],
      ),
    );
  }
}


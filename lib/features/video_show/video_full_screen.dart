
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import 'logic/video_controler.dart';

class FullScreenPlayer extends ConsumerStatefulWidget {
  final String videoUrl;
  const FullScreenPlayer({super.key, required this.videoUrl, required VideoPlayerController controller});

  @override
  ConsumerState<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends ConsumerState<FullScreenPlayer> {
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    // 👉 Only in fullscreen = landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
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
    final videoAsync = ref.watch(videoPlayerControllerProvider(widget.videoUrl));
    final position = ref.watch(videoPositionProvider(widget.videoUrl));

    return Scaffold(
      backgroundColor: Colors.black,
      body: videoAsync.when(
        data: (controller) {
          return GestureDetector(
            onTap: () => setState(() => _showControls = !_showControls),
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
                          icon: const Icon(Icons.replay_10,
                              color: Colors.white, size: 40),
                          onPressed: () {
                            final newPos = controller.value.position -
                                const Duration(seconds: 10);
                            controller.seekTo(
                                newPos >= Duration.zero ? newPos : Duration.zero);
                          },
                        ),

                        // ▶️ / ⏸️ Play / Pause
                        IconButton(
                          icon: Icon(
                            controller.value.isPlaying
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            color: Colors.white,
                            size: 60,
                          ),
                          onPressed: () {
                            setState(() {
                              controller.value.isPlaying
                                  ? controller.pause()
                                  : controller.play();
                            });
                          },
                        ),

                        // ⏩ Forward 10s
                        IconButton(
                          icon: const Icon(Icons.forward_10,
                              color: Colors.white, size: 40),
                          onPressed: () {
                            final maxPos = controller.value.duration;
                            final newPos = controller.value.position +
                                const Duration(seconds: 10);
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
                              formatDuration(position),
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
          );
        },
        loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white)),
        error: (e, _) => Center(
          child: Text("Error: $e",
              style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

// 🎥 Controller Provider (autoDispose)
final videoPlayerControllerProvider =
FutureProvider.autoDispose.family<VideoPlayerController, String>((ref, videoUrl) async {
  print("🎬 Initializing video player for URL: $videoUrl");
  
  // Validate URL
  if (videoUrl.isEmpty) {
    print("❌ Video URL is empty!");
    throw Exception("Video URL is empty");
  }
  
  try {
    final controller = VideoPlayerController.network(
      videoUrl,
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: false,
        allowBackgroundPlayback: false,
      ),
    );
    
    await controller.initialize();
    print("✅ Video initialized successfully");
    print("   Duration: ${controller.value.duration}");
    print("   Size: ${controller.value.size}");
    
    controller.play();
    print("▶️ Video playback started");

    // 👇 Riverpod দিয়ে প্রতি ফ্রেমে time track করা হবে
    final positionProvider = videoPositionProvider(videoUrl);
    controller.addListener(() {
      if (controller.value.isInitialized) {
        ref.read(positionProvider.notifier).state = controller.value.position;
      }
    });

    // Auto dispose
    ref.onDispose(() {
      print("🗑️ Disposing video controller");
      controller.pause();
      controller.dispose();
    });

    return controller;
  } catch (e) {
    print("❌ Error initializing video player: $e");
    print("   URL was: $videoUrl");
    rethrow;
  }
});

// 🎯 Current Position Provider (real-time update)
final videoPositionProvider =
StateProvider.family<Duration, String>((ref, videoUrl) => Duration.zero);

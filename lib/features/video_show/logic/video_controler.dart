import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

// 🎥 Controller Provider (autoDispose)
final videoPlayerControllerProvider =
FutureProvider.autoDispose.family<VideoPlayerController, String>((ref, videoUrl) async {
  final controller = VideoPlayerController.network(videoUrl);
  await controller.initialize();
  controller.play();

  // 👇 Riverpod দিয়ে প্রতি ফ্রেমে time track করা হবে
  final positionProvider = videoPositionProvider(videoUrl);
  controller.addListener(() {
    if (controller.value.isInitialized) {
      ref.read(positionProvider.notifier).state = controller.value.position;
    }
  });

  // Auto dispose
  ref.onDispose(() {
    controller.dispose();
  });

  return controller;
});

// 🎯 Current Position Provider (real-time update)
final videoPositionProvider =
StateProvider.family<Duration, String>((ref, videoUrl) => Duration.zero);
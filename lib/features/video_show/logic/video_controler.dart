import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

// Family provider so that different videoId/url handle kora jabe
final videoPlayerControllerProvider = FutureProvider.family<VideoPlayerController, String>((ref, videoUrl) async {
  final controller = VideoPlayerController.network(videoUrl);
  await controller.initialize();
  controller.play();
  return controller;
});
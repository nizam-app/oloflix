import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

import 'logic/video_controler.dart';


class VideoShowScreen extends ConsumerWidget {
  final String videoUrl;
  const VideoShowScreen({super.key, required this.videoUrl});
  static const String routeName = '/moviePlayerScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoAsync = ref.watch(videoPlayerControllerProvider(videoUrl));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: videoAsync.when(
          data: (controller) => AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: VideoPlayer(controller),
          ),
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text("Error loading video: $e"),
        ),
      ),
      floatingActionButton: videoAsync.maybeWhen(
        data: (controller) => FloatingActionButton(
          onPressed: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
          child: Icon(
            controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
        orElse: () => null,
      ),
    );
  }
}
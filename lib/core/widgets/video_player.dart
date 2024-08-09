import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:mock_interviewer/shared/models/video_details.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.video});

  final VideoDetails video;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  ChewieController? controller;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() async {
    log('dddd : video path : ${widget.video.path}');
    final videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.video.path + '.mp4'));

    await videoPlayerController.initialize();
    controller = ChewieController(videoPlayerController: videoPlayerController);
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Chewie(controller: controller!);
  }
}

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final String? pinnedPostVideo;
  const VideoWidget({
    super.key,
    required this.pinnedPostVideo,
  });

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  bool opened = false;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.pinnedPostVideo != null) {
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    VideoPlayerController videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.pinnedPostVideo!));

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
    );

    videoPlayerController.addListener(() {
      if (!videoPlayerController.value.isPlaying) {
        _chewieController.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.pinnedPostVideo != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Chewie(
                    controller: _chewieController,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

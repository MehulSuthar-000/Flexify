import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as yt;

class VideoPlayerScreen extends StatefulWidget {
  final String videoKey;

  VideoPlayerScreen(this.videoKey);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late ChewieController _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeVideo();
  }

  void initializeVideo() async {
    final yt.YoutubeExplode ytExplode = yt.YoutubeExplode();

    final videoStreamInfo = await ytExplode.videos.streamsClient
        .getManifest(widget.videoKey)
        .then((manifest) {
      final videoStream = manifest.muxed.first;
      return videoStream.url.toString();
    });

    final videoPlayerController =
        VideoPlayerController.network(videoStreamInfo);
    await videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoInitialize: true,
      looping: false,
      aspectRatio: 16 / 9,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _isLoading
                ? Center(
                    child: Lottie.asset(
                      'assets/loading.json', // Replace with your animation file path
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : _chewieController != null &&
                        _chewieController
                            .videoPlayerController.value.isInitialized
                    ? Chewie(
                        controller: _chewieController,
                      )
                    : Center(
                        child: Lottie.asset(
                          'assets/loading.json', // Replace with your animation file path
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }
}

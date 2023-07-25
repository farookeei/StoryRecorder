import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

import '../themes/color_variables.dart';

class VideoPage extends StatefulWidget {
  final XFile file;

  const VideoPage({Key? key, required this.file}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.file.path));
    await _videoPlayerController.initialize();

    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Preview',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: ReplyColors.white),
        ),
        elevation: 0,
        backgroundColor: ReplyColors.neutralBold,
        actions: [
          IconButton(
              onPressed: () {
                Share.shareXFiles([widget.file], text: 'Check out this video!');
              },
              icon: const Icon(
                Icons.share,
                color: ReplyColors.white,
              )),
          IconButton(
            icon: const Icon(
              Icons.check,
              color: ReplyColors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return VideoPlayer(_videoPlayerController);
          }
        },
      ),
    );
  }
}




import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class WebFullScreenPreview extends StatefulWidget {
  final bool isImage;
  final String link;
  const WebFullScreenPreview({super.key, required this.isImage, required this.link});

  @override
  State<WebFullScreenPreview> createState() => _WebFullScreenPreviewState();
}

class _WebFullScreenPreviewState extends State<WebFullScreenPreview> {

  late VideoPlayerController _controller;

  @override
  void initState() {
    initialization();
    super.initState();
  }

  @override
  void dispose() async {
    log('dispose', name: 'dispose');
    widget.isImage ? null : _controller.dispose();
    super.dispose();
  }


  Future initialization() async {
    setState(() {

      widget.isImage ? null : {
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.link)),
        _controller.initialize().then((_) {
          _controller.setLooping(true);
          _controller.setVolume(0);
          _controller.play();
        }),
      };
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: widget.isImage ? 
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              widget.link,
              fit: BoxFit.contain,
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
        ) :
        Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: VideoPlayer(_controller),
            ),
          ),
        )
    );
  }
}
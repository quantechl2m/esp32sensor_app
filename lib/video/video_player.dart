import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../shared/loading.dart';

class VideoPage extends StatefulWidget {
  final snap;
  const VideoPage({super.key, required this.snap});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  String url = "";

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.snap["url"]);
    _videoPlayerController!.initialize().then((_) {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        aspectRatio: 16 / 9,
        looping: true,
        allowFullScreen: true,
        allowMuting: true,
        materialProgressColors: ChewieProgressColors(
          backgroundColor: const Color.fromARGB(255, 144, 177, 161),
          bufferedColor: const Color.fromARGB(255, 144, 177, 161),
          handleColor: const Color.fromARGB(255, 50, 135, 94),
          playedColor: const Color.fromARGB(255, 144, 177, 161),
        ),
      );
      setState(() {
        print("video good");
      });
    });
  }

  // Future<dynamic> getdetails() async {
  //   DocumentSnapshot snap =
  //       await FirebaseFirestore.instance.collection('video').doc("demo").get();

  //   setState(() {
  //     url = (snap.data() as Map<String, dynamic>)["url"];
  //   });

  // }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _chewieController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 78, 181, 131),
        title: const Text("Demo Video"),
      ),
      body: SizedBox(child: _chewieVideoPlayer()),
    );
  }

  Widget _chewieVideoPlayer() {
    return _chewieController != null && _videoPlayerController != null
        ? Container(
            color: const Color.fromARGB(255, 204, 220, 204),
            alignment: Alignment.centerRight,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Chewie(controller: _chewieController!),
            ),
          )
        : Loading(size: 40,);
  }
}

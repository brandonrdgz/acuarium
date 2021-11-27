import 'package:acuarium/componentes/tarjeta.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:video_player/video_player.dart';

class AcuariumVideoPlayer extends StatefulWidget {
  AcuariumVideoPlayer({Key? key}) : super(key: key);

  @override
  _AcuariumVideoPlayerState createState() => _AcuariumVideoPlayerState();
}

class _AcuariumVideoPlayerState extends State<AcuariumVideoPlayer> {
  late VideoPlayerController _controller;

    @override
  void initState() {
    super.initState();
     _controller = VideoPlayerController.asset('images/video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
      _controller.setLooping(true);

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Tarjeta(
      color: Colors.white, 
      contenido:_controller.value.isInitialized
              ? Column(
                children: [
                  SizedBox(height: 20,),
                  AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                IconButton(
                  color:Colors.blue,
                  icon: Icon(
                    _controller.value.isPlaying? FontAwesomeIcons.pause:FontAwesomeIcons.play),
                  onPressed:(){
                    setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play(); 
                    });
                  })
                ])
              : 
          Image(image: AssetImage('images/acuarium.png')));
  }
}


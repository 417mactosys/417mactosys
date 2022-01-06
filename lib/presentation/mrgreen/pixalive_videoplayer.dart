//import 'package:cached_video_player/cached_video_player.dart';
import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

var MOVED = false;

class PixaliveVideoPlayer extends StatefulWidget {
  static List<_PixaliveVideoPlayerState> states = List();

  final String url;
  final bool view, scaff;
  final int index;
  final bool live, file;

  PixaliveVideoPlayer(this.url, this.view, this.index, this.scaff,
      {this.live = false, this.file = false});

  @override
  _PixaliveVideoPlayerState createState() {
    final state = _PixaliveVideoPlayerState();
    states.add(state);
    return state;
  }

  static pauseAll() {
    // LiveView.pauseAll();
    states.forEach((state) {
      state.pause();
    });
  }

  var isPlaying = true;
}

class _PixaliveVideoPlayerState extends State<PixaliveVideoPlayer> {
  @override
  void initState() {
    if (widget.file) {
      print("Live Video Play1");
      print(widget.url);
      _videoPlayerController = VideoPlayerController.file(File(widget.url))
        ..initialize().then((_) {
          chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              autoPlay: false,
              looping: false,
              placeholder: Container(),
              deviceOrientationsAfterFullScreen: [
                DeviceOrientation.portraitUp
              ]);
          setState(() {});

          if (widget.live) {
            _videoPlayerController.seekTo(Duration(seconds: 3));
          }

          //_videoPlayerController.setLooping(true);
          if (_videoPlayerController.value != null &&
              _videoPlayerController.value.initialized &&
              widget.view) {
            //play();
          } else {
            pause();
            if (widget.index == 0 && widget.view) {
              play();
            } else {
              pause();
            }
          }
        });
    } else {
      print("Live Video Play");
      print(widget.url);
      _videoPlayerController = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          chewieController = ChewieController(
              videoPlayerController: _videoPlayerController,
              autoPlay: false,
              looping: false,
              showControls: true,
              allowFullScreen: true,
              showControlsOnInitialize: true,
              placeholder: Container(),
              deviceOrientationsAfterFullScreen: [
                DeviceOrientation.portraitUp
              ]);
          setState(() {});

          if (widget.live) {
            _videoPlayerController.seekTo(Duration(seconds: 3));
          }

          //_videoPlayerController.setLooping(true);
          if (_videoPlayerController.value != null &&
              _videoPlayerController.value.initialized &&
              widget.view) {
            play();
          } else {
            pause();
            if (widget.index == 0 && widget.view) {
              play();
            } else {
              pause();
            }
          }
        });
    }

    super.initState();
  }

  listener() async {
    if (mounted) {
      final pos = _videoPlayerController.value.position;
      final wol = _videoPlayerController.value.duration;
      duration.add(Duration(seconds: wol.inSeconds - pos.inSeconds));
      if (_videoPlayerController.value.duration.inMilliseconds ==
          _videoPlayerController.value.position.inMilliseconds) {
        _videoPlayerController.seekTo(Duration(milliseconds: 0));
        setState(() {
          widget.isPlaying = false;
        });
      }
    }
  }

  @override
  void deactivate() {
    _videoPlayerController.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return _videoWidget();
  }

  @override
  void didChangeDependencies() {
    pause();
  }

  @override
  void reassemble() {
    pause();
  }

  pause() {
    try {
      _videoPlayerController.removeListener(listener);
      print('pausing');
      setState(() {
        widget.isPlaying = false;
      });
      _videoPlayerController.pause();
    } catch (e) {}
  }

  play() {
    _videoPlayerController.removeListener(listener);
    _videoPlayerController.removeListener(listener);
    _videoPlayerController.removeListener(listener);
    _videoPlayerController.removeListener(listener);
    _videoPlayerController.removeListener(listener);
    _videoPlayerController.removeListener(listener);
    _videoPlayerController.removeListener(listener);
    _videoPlayerController.removeListener(listener);
    _videoPlayerController.addListener(listener);
    print('playing');
    setState(() {
      widget.isPlaying = true;
    });
    if (_videoPlayerController.value.duration.inMilliseconds ==
        _videoPlayerController.value.position.inMilliseconds) {
      _videoPlayerController.seekTo(Duration(milliseconds: 0));
      _videoPlayerController.play();
    }
    _videoPlayerController.play();
  }

  VideoPlayerController _videoPlayerController;
  ChewieController chewieController;

  @override
  void dispose() {
    if (_videoPlayerController != null) _videoPlayerController.dispose();
    if (chewieController != null) chewieController.dispose();
    PixaliveVideoPlayer.states.remove(this);
    super.dispose();
  }

  StreamController<Duration> duration = StreamController<Duration>();

  Stack _videoWidget() {
    if (_videoPlayerController.value != null &&
        _videoPlayerController.value.initialized &&
        widget.view &&
        widget.isPlaying)
      play();
    else {
      //if(widget.index == 0 && widget.isPlaying) play();
      pause();
    }

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _videoPlayerController.value != null &&
            !_videoPlayerController.value.initialized &&
            !widget.live
            ? CircularProgressIndicator()
            : Container(),
        if (widget.live)
          GestureDetector(
            onTap: toggle,
            // child: ClipRect(
            //   child: Container(
            //     height: widget.live ? MediaQuery.of(context).size.width * 1.2 : null,
            //     child: Transform.scale(
            //       alignment: Alignment.centerLeft,
            //       scale: widget.live ? 1.5 : 1,
            //       child: Container(
            //         width: MediaQuery.of(context).size.width * 2,
            //         height: widget.live ? MediaQuery.of(context).size.width * 1.2 : null,
            //         child: AspectRatio(
            //           child: CachedVideoPlayer(_videoPlayerController),
            //           aspectRatio: _videoPlayerController.value.aspectRatio,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            child: Transform.scale(
              alignment: Alignment.center,
              scale: widget.live && _videoPlayerController.value.initialized
                  ? 3.5
                  : 2,
              child: AspectRatio(
                child: VideoPlayer(_videoPlayerController),
                aspectRatio: _videoPlayerController.value.aspectRatio,
              ),
            ),
          ),
        // StreamBuilder(
        //   stream: duration.stream,
        //   builder: (BuildContext c, AsyncSnapshot<Duration> s) {
        //     if (!s.hasData) return Container();
        //     return Positioned(
        //         top: 0,
        //         right: 0,
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Text(
        //             _printDuration(s.data),
        //             style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 10,
        //                 shadows: [
        //                   BoxShadow(
        //                       color: Colors.black54,
        //                       spreadRadius: 5,
        //                       blurRadius: 5)
        //                 ]),
        //           ),
        //         ));
        //   },
        // ),
        if (widget.live)
          Container(
            height: MediaQuery.of(context).size.width * 1.5,
          ),
        if (widget.live)
          Positioned(
            //alignment: Alignment.topRight,
            top: 0,
            right: 0,
            child: Opacity(
              opacity: 0.75,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(color: Colors.red),
                child: Text(
                  'LIVE ENDED',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        if (widget.live)
          Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  widget.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white60,
                ),
              )),
        if (chewieController != null && !widget.live)
          Chewie(
            controller: chewieController,
          )
        else
          Container(
            height: 300,
          )
      ],
    );
  }

  toggle() {
    print('toggled');
    if (widget.isPlaying) {
      pause();
    } else {
      play();
    }
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wilotv/infrastructure/core/pref_manager.dart';

import '../../../domain/entities/feed.dart';
import '../../../infrastructure/api/api_service.dart';
import '../../../injection.dart';
import '../../components/custom_button.dart';
import '../../mrgreen/post_preview.dart';
import '../../utils/constants.dart';

class LiveView extends StatefulWidget {
  static List<_LiveViewState> states = List();

  final Feed video;
  final bool view, scaff;
  final int index;
  bool isPlaying = true;
  LiveView(this.video, this.view, this.index, this.scaff);
  @override
  _LiveViewState createState() {
    final state = _LiveViewState();
    states.add(state);
    return state;
  }

  static Future<void> detroyAll() async {
    for (int i = 0; i < states.length; i++) {
      final state = states[i];
      await state.destroy();
    }
  }

  static pauseAll() {
    for (int i = 0; i < states.length; i++) {
      final state = states[i];
      state.pause();
    }
  }
}

class _LiveViewState extends State<LiveView> {
  //String appID = GlobalConfiguration().get('agora_app_id');
  String appID = 'dfc294dcaf6c4e808d3440d20d9bfae8';
  // String Token = GlobalConfiguration().get('agora_token');
  ClientRole _role = ClientRole.Audience;
  StreamController<Duration> duration = StreamController<Duration>();
  _onSwitchCamera() {
    _engine.switchCamera();
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  bool tenet = true;

  turnstle() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      loading = false;
      tenet = !tenet;
    });
  }

  bool errored = false;
  bool isShowPause = false;
  @override
  Widget build(BuildContext context) {
    final gotVideo = _videoPlayerController.value.initialized;
    print("gherrerererrererere");
    print(_videoPlayerController.value);
    print(_videoPlayerController.value.initialized);
    print(widget.view);
    print(widget.isPlaying);
    if (_videoPlayerController.value != null &&
        _videoPlayerController.value.initialized &&
        widget.view &&
        widget.isPlaying) {
      print("12345678");
      //play();
    } else {
      //if(widget.index == 0 && widget.isPlaying) play();
      pause();
    }
    // if(widget.view){
    //   if(!joined && widget.video.live_ended == 0)
    //   reinit();
    // }

    if (!widget.scaff) {
      if (widget.video.live_ended == 0) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (c) => PostViewer(() {}, widget.video)));
          },
          child: Container(
            height: MediaQuery.of(context).size.width,
            width: double.maxFinite,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.video.thumbnail),
                    fit: BoxFit.cover)),
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: 130,
              height: 44,
              child: CustomButton(
                title: 'Watch Live',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) => PostViewer(() {}, widget.video)));
                },
              ),
            ),
          ),
        );
      }
    }

    return
        // ((joined || loading) && widget.video.live_ended == 0 ) ?
        ClipRect(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 150,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //Container(color: Colors.black,),

            if (loading) _loadingView(),

            //Text(_users.length.toString()),

            tenet
                ? RtcRemoteView.SurfaceView(
                    uid: widget.video.user.id,
                  )
                : _viewRows(),

            // PixaliveVideoPlayer('http://ec2-3-6-250-92.ap-south-1.compute.amazonaws.com:3000/download/${widget.video.sid}',
            //   widget.view, widget.index, widget.scaff, live: true,)

            if (gotVideo)
              GestureDetector(
                onTap: () {
                  if (widget.isPlaying) {
                    setState(() {
                      isShowPause = true;
                    });
                  }
                },
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
                  alignment: Alignment.centerLeft,
                  scale: _videoPlayerController.value.initialized ? 3.5 : 1,
                  child: AspectRatio(
                    child: VideoPlayer(_videoPlayerController),
                    aspectRatio: _videoPlayerController.value.aspectRatio,
                  ),
                ),
              ),

            widget.isPlaying == false
                ? Align(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: 0.75,
                      child: IconButton(
                          icon: Icon(Icons.play_circle_outline, size: 60),
                          onPressed: () {
                            setState(() {
                              play();
                            });
                          }),
                    ),
                  )
                : Container(),

            widget.isPlaying == true && isShowPause
                ? Align(
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: 0.75,
                      child: IconButton(
                          icon: Icon(Icons.pause_circle_outline, size: 60),
                          onPressed: () {
                            setState(() {
                              pause();
                            });
                          }),
                    ),
                  )
                : Container(),

            Align(
              alignment: Alignment.topRight,
              child: Opacity(
                opacity: 0.75,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(color: Colors.red),
                  child: Text(
                    gotVideo ? 'LIVE ENDED' : 'LIVE',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),

            StreamBuilder(
              stream: duration.stream,
              builder: (BuildContext c, AsyncSnapshot<Duration> s) {
                if (!s.hasData) return Container();
                return Positioned(
                    top: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _printDuration(s.data),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            shadows: [
                              BoxShadow(
                                  color: Colors.black54,
                                  spreadRadius: 5,
                                  blurRadius: 5)
                            ]),
                      ),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> privacies = {'Public': 0, 'Private': 1, 'Only Followers': 2};
  var privacy = 0;
  var desc = '';
  int categoryID;

  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine _engine;
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  // _renderVideo() {
  //   return _users.length > 0 ? RtcRemoteView.SurfaceView(uid: _users.first):  SizedBox(width: 24, height: 24,
  //     child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(settingRepo
  //         .setting.value.buttonColor),),
  //   );
  // }

  _loadingView() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(kColorPrimary),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _users.clear();
    // _engine.leaveChannel();
    //  _engine.destroy();

    super.dispose();
  }

  Future<void> destroy() async {
    try {
      _users.clear();
      if (_engine != null) {
        // await _engine.leaveChannel();
        await _engine.destroy();
      }
    } catch (e) {}
  }

  // reinit() async {
  //   try{
  //     _users.clear();
  //     await _engine.leaveChannel();
  //     await _engine.destroy();
  //   } catch(e){}
  //   await initialize();
  // }

  @override
  void initState() {
    super.initState();
    if (widget.scaff) {
      initialize();
      initplayer();
    } else {
      //if(widget.video.live_ended == 1)

      initplayer();
    }
  }

  VideoPlayerController _videoPlayerController;
  initplayer() {
    print("11111111");
    print(widget.video.sid);
    print("222222222222");
    _videoPlayerController = VideoPlayerController.network(
        'https://wilotv.live:3444/play/${widget.video.sid}')
      ..initialize().then((_) {
        print("VideoPlayer Initialised Successfully");

        setState(() {});

        // play();
      }).catchError((error) {
        print(error);
      });
  }

  toggle() {
    print('toggled');
    if (widget.isPlaying) {
      pause();
    } else {
      play();
    }
  }

  pause() {
    try {
      _videoPlayerController.removeListener(listener);
      print('pausing');
      setState(() {
        widget.isPlaying = false;
        isShowPause = false;
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
    widget.isPlaying = true;
    if (_videoPlayerController.value.duration.inMilliseconds ==
        _videoPlayerController.value.position.inMilliseconds) {
      _videoPlayerController.seekTo(Duration(milliseconds: 0));
      _videoPlayerController.play();
    }
    _videoPlayerController.play();
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

  bool loading = true;

  bool joined = true;

  Future<void> initialize() async {
    await LiveView.detroyAll();
    print('initing');
    setState(() {
      loading = true;
      errored = false;
    });

    try {
      await _initAgoraRtcEngine();
      _addAgoraEventHandlers();
      await _engine.enableWebSdkInteroperability(true);
      VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
      //configuration.dimensions = VideoDimensions(1920, 1080);
      configuration.dimensions = VideoDimensions(3420, 2760);
      await _engine.setVideoEncoderConfiguration(configuration);

      var d = await getIt<HeyPApiService>().joinLive(widget.video.channel_name);

      print(d.body);
      print(d.body.token);
      print(widget.video.channel_name);
      await _engine.joinChannel(
          d.body.token, widget.video.channel_name, null, Prefs.getUser().id);
    } catch (e) {
      // reinit();
    }

    setState(() {
      loading = false;
    });
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(_role);
  }

  reinit() async {
    await destroy();
    await initialize();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    print('HANDLERS');
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          errored = true;
          loading = false;
          //reinit();
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        turnstle();
        print('joinnnnnned');
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          errored = false;
          loading = false;
          joined = true;
          //joined = true;
          _infoStrings.add(info);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          errored = true;
          loading = false;
          joined = false;
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          _users.add(uid);
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          print('joinnnnnned1233');
          joined = true;
          loading = false;
        });
      },
      userOffline: (uid, elapsed) {
        setState(() {
          final info = 'userOffline: $uid';
          _infoStrings.add(info);
          loading = false;
          _users.remove(uid);
          joined = false;
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        print('firstRemoteVideo: $uid ${width}x $height');
        setState(() {
          final info = 'firstRemoteVideo: $uid ${width}x $height';
          _infoStrings.add(info);
          loading = false;
          joined = true;
        });
      },
      //     connectionLost: (){
      //   setState(() {
      //     joined = false;
      //   });
      // }
    ));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    // if (_role == ClientRole.Broadcaster) {
    //   list.add(RtcLocalView.SurfaceView());
    // }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }
}

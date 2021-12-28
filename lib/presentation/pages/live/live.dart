
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:wilotv/application/comment/comment_bloc.dart';
import 'package:wilotv/domain/entities/comment.dart';
import 'package:wilotv/domain/entities/user.dart';
import 'package:wilotv/presentation/components/labeled_text_form_field.dart';
import 'package:wilotv/presentation/components/no_internet.dart';
import 'package:wilotv/presentation/components/server_error.dart';
import 'package:wilotv/presentation/pages/live/camera_view.dart';
import '../../components/toast.dart';
import 'package:wilotv/presentation/utils/app_utils.dart';

//import 'package:screenshot/screenshot.dart';
import 'package:wilotv/infrastructure/core/pref_manager.dart';
import '../../components/custom_button.dart';
import '../../../infrastructure/api/api_service.dart';

//import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../injection.dart';

import '../../utils/constants.dart';

import 'dart:ui' as ui;
import 'package:wilotv/presentation/pages/live/widgets/live_comment_widget.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'live_view.dart';

import '../home/home.dart';

class Live extends StatefulWidget {
  Live({Key key}) : super(key: key);

  @override
  _LiveState createState() => _LiveState();
}

class _LiveState extends State<Live> {
  String channel = '';
  String sid = '';
  ScrollController _scrollController = new ScrollController();

  // TextEditingController _commentController = TextEditingController();
  CommentBloc _commentBloc;
  List<Comment> _comments = [];
  Comment _comment;
  bool _commented;


  bool initdone = true;
  bool livecomments = false;
  StreamController _postsController;
  Future<void> initialize() async {
    print('Initializing Agora123');

    try {
      await Permission.camera.request();
      await Permission.microphone.request();
      await Permission.storage.request();

      if (_engine != null) {
        print("111111");
        _engine.leaveChannel();
        _engine.destroy();
      }

      await _initAgoraRtcEngine();
      _addAgoraEventHandlers();
      VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
      configuration.orientationMode = VideoOutputOrientationMode.FixedPortrait;
      configuration.dimensions = VideoDimensions(3420, 2760);
      await _engine.setVideoEncoderConfiguration(configuration);
      // if (Platform.isAndroid) {
      //   maxZoom = await _engine.getCameraMaxZoomFactor();
      // }
      // else{
      //   maxZoom = 5.0;
      // }
      //
      // setState(() {
      initdone = true;
      // });
    } catch (e) {
      print(e);
      initialize();
    }

    //   await _engine.joinChannel('006dfc294dcaf6c4e808d3440d20d9bfae8IAAdldkOZVGuD0vf46VLut3kE42XevqBJ3M70wl0oRzAJkkQgrAAAAAAEACUgXZOVXN2YAEAAQBVc3Zg', 'ttt', null, 0);
  }

  loadPosts() async {
    HeyPApiService.create().getComments(feedid).then((value) async{
      print('Hellloooo ${value}');
      _postsController.add(value);
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
      return value;
    });
  }

  ClientRole _role = ClientRole.Broadcaster;

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create('dfc294dcaf6c4e808d3440d20d9bfae8');
    RtcLocalView.SurfaceView();
    this._addListener();
    await _engine.enableVideo();
    await _engine.enableLocalVideo(true);
    await _engine.getCameraMaxZoomFactor();

    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  RtcEngine _engine;

  String appID = 'dfc294dcaf6c4e808d3440d20d9bfae8';

  //String Token = GlobalConfiguration().get('agora_token');

  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool isJoined = false;
  int remoteUid;

  stopLive() async {
    stopped = true;
    _users.clear();
    _engine.leaveChannel();

    _engine.destroy();

    final res = await getIt<HeyPApiService>().stopLive(channel, sid);
    print(res.body);
  }

  _addListener() {
    _engine.setEventHandler(RtcEngineEventHandler(warning: (warningCode) {
      print('Warning ${warningCode}');
    }, error: (errorCode) {
      print('Warning ${errorCode}');
    }, joinChannelSuccess: (channel, uid, elapsed) {
      print('joinChannelSuccess ${channel} ${uid} ${elapsed}');
      // setState(() {
      isJoined = true;
      // });
    }, userJoined: (uid, elapsed) {
      print('userJoined $uid $elapsed');
      // this.setState(() {
      remoteUid = uid;
      // });
    }, userOffline: (uid, reason) {
      print('userOffline $uid $reason');
      // this.setState(() {
      remoteUid = null;
      // });
    }, streamMessage: (int uid, int streamId, String data) {
      // _showMyDialog(uid, streamId, data);
      print('streamMessage $uid $streamId $data');
    }, streamMessageError: (int uid, int streamId, ErrorCode error, int missed, int cached) {
      print('streamMessage $uid $streamId $error $missed $cached');
    }));
  }

  @override
  void dispose() {
    stopLive();
    //if(videoID != null)
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initialize();
    LiveView.detroyAll();
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      // setState(() {
      final info = 'onError: $code';
      _infoStrings.add(info);
      // });
      // setState(() {});
    }, joinChannelSuccess: (channel, uid, elapsed) {
      this.channel = channel;
      print('joined3');
      print(channel);
      print(uid);
      updateThumbnail();
      turnstle();
      // setState(() {
      final info = 'onJoinChannel: $channel, uid: $uid';
      _infoStrings.add(info);
      // });
      // setState(() {});
    }, leaveChannel: (stats) {
      // setState(() {
      print('joined4');
      _infoStrings.add('onLeaveChannel');
      _users.clear();
      // });
      // setState(() {});
    }, userJoined: (uid, elapsed) {
      // setState(() {
      print('joined5');
      final info = 'userJoined: $uid';
      _infoStrings.add(info);
      _users.add(uid);
      print(_users.length);
      // });
      // setState(() {});
    }, userOffline: (uid, elapsed) {
      // setState(() {
      print('joined6');
      final info = 'userOffline: $uid';
      _infoStrings.add(info);
      _users.remove(uid);
      // });
      // setState(() {});
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      // setState(() {
      print('joined7');
      final info = 'firstRemoteVideo: $uid ${width}x $height';
      _infoStrings.add(info);
      // });
      // setState(() {});
    }));
  }

  String desc = '';

  _dialog() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Prefs.isDark() ? Colors.black : Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            //controller: desc,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Live Description...',
              hintStyle: TextStyle(
                color: Prefs.isDark()
                    ? Colors.white.withOpacity(0.5)
                    : kColorGrey.withOpacity(0.5),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 10,
              ),
            ),
            style: Theme.of(context).textTheme.subtitle1,
            minLines: 1,
            maxLines: 5,
            autofocus: true,
            onChanged: (d) {
              desc = d;
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          if (initdone)
            CustomButton(
              title: 'Start Live',
              color: Colors.red,
              onPressed: () async {
                // setState(() {
                loading = true;
                // });
                channel = DateTime.now().millisecondsSinceEpoch.toString();
                final res =
                await getIt<HeyPApiService>().startLive(channel, desc);
                sid = res.body.sid;
                Token = res.body.token;
                feedid = res.body.feedid;
                print('Hello Friends good ${res.body.feedid}');
                print('Hello Friends good ${res.body.sid}');
                print('Hello Friends good ${res.body.token}');
                await _engine.joinChannel(Token, channel, null, Prefs.getUser().id);
                Timer.periodic(Duration(seconds: 3), (_) => loadPosts());
                await _engine.isCameraZoomSupported();
                maxZoom = await _engine.getCameraMaxZoomFactor();
                loading = false;
                livecomments = true;
                _postsController = new StreamController();
                // setState(() {});
              },
            ),
        ],
      ),
    );
  }

  double zoomlvl = 1.0;
  double maxZoom = 5.0;

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (_role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    //_users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
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
    // setState(() {
    _infoStrings.add(views.length.toString());
    // });
    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[_videoView(views[0])],
        );
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

  bool stopped = false;

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
    // Navigator.pop(context);
  }

  void _onToggleMute() async {
    // await _engine.isCameraZoomSupported();
    // print('Hello Friends Good ${await _engine.isCameraZoomSupported()}');
    // await _engine.setCameraZoomFactor(3);
    // print('Hello Friends Good ${await _engine.getCameraMaxZoomFactor()}');
    // setState(() {
    muted = !muted;
    // });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() async {
    _engine.switchCamera();
  }

  onBackPressed() {
    if (channel.isNotEmpty && sid.isNotEmpty) {
      showDialog(
          context: context,
          builder: (c) {
            return AlertDialog(
              title: Text('Do you want to End Live?'),
              actions: [
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(c).pop();
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    //showToast('Live ended successfully');
                    stopLive();
                    Navigator.of(c).pop();
                    showSaveLiveDialog();
                  },
                ),
              ],
            );
          });
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => Home()));
    }
  }

  showSaveLiveDialog() {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text('Do you want to Save this Live?'),
            actions: [
              FlatButton(
                child: Text('No'),
                onPressed: () async {
                  showToast('Live Saved successfully');
                  getIt<HeyPApiService>().deleteLive(channel);
                  Navigator.of(c).pop();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => Home()));
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  showToast('Live Saved successfully');
                  stopLive();
                  Navigator.of(c).pop();
                  //Navigator.of(context).pop();
                  //Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => Home()));
                },
              ),
            ],
          );
        });
  }

  Widget _toolbar() {
    if (_role == ClientRole.Audience) return Container();
    return SafeArea(
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 24, top: 16),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 16,
                ),
                RawMaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  //onPressed: (){},
                  child: Row(
                    children: [
                      Text(
                        this.channel,
                        // _users.length.toString(),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Icon(
                        Icons.remove_red_eye_rounded,
                        size: 20.0,
                      ),
                    ],
                  ),
                  onPressed: () {},
                ),
                Spacer(),
                RawMaterialButton(
                  onPressed: onBackPressed,
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                ),
              ],
            ),
            Spacer(),
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: RawMaterialButton(
                    onPressed: _onToggleMute,
                    child: Icon(
                      muted ? Icons.mic_off : Icons.mic,
                      color: muted ? Colors.white : kColorPrimary,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: muted ? kColorPrimary : Colors.white,
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: RawMaterialButton(
                    onPressed: _onSwitchCamera,
                    child: Icon(
                      Icons.switch_camera,
                      color: kColorPrimary,
                      size: 20.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(12.0),
                  ),
                ),
                _sendMessage(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sendMessage() {
    return LiveCommentWidget(
      onPressed: (){
        // if (_commentController.text.trim().isEmpty) return;
        _commentBloc.add(CommentEvent.addComment(feedid));
        _commentBloc.state.comment.value.fold(
              (f) => f.maybeMap(
            empty: (_) => 'fill_the_field'.tr(),
            orElse: () => null,
          ),
              (value) {
            final User user = User(
              id: Prefs.getInt(Prefs.ID, def: -1),
              username: Prefs.getUsername(),
              avatar: Prefs.getString(Prefs.AVATAR, def: ''),
            );
            final DateTime now = DateTime.now();
            final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
            final String formatted = formatter.format(now);
            final Comment comment = Comment(
              comment: value,
              user: user,
              date: formatted,
            );
            setState(() {
              _comments.add(comment);
            });
          },
        );
        Future.delayed(Duration(seconds: 1),(){
          _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
        });
      },
    );
  }

  updateThumbnail() async {
    try {
      await Permission.storage.request();

      await Future.delayed(Duration(seconds: 7));
      final data = await _capturePng();
      final task = await FirebaseStorage.instance
          .ref(DateTime.now().millisecondsSinceEpoch.toString() + ".png")
          .putFile(File(data));
      final url = await task.ref.getDownloadURL();

      print(url);
      await getIt<HeyPApiService>().updateThumbnail(channel, url);
    } catch (e) {}

    //if (!stopped) updateThumbnail();
  }

  Future<String> _capturePng() async {
    try {
      var pngBytes = await NativeScreenshot.takeScreenshot();
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  bool loading = false;
  bool tenet = false;
  GlobalKey thumb = new GlobalKey();

  turnstle() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      loading = false;
      tenet = !tenet;
    });
  }

  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return onBackPressed();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocProvider(
          create: (context) => _commentBloc = getIt<CommentBloc>()
            ..add(CommentEvent.getComments(feedid),),
          child: BlocConsumer<CommentBloc, CommentState>(
            listener: (context, state) {
              state.getCommentsFailureOrSuccessOption.fold(
                    () => null,
                    (either) => either.fold(
                        (failure) => serverError(),
                        (success) {
                      _comments = success.comments;
                    }
                ),
              );

              state.addCommentFailureOrSuccessOption.fold(
                    () => null,
                    (either) => either.fold(
                      (failure) {
                    _comments.removeLast();
                    return serverError();
                  },
                      (success) => _commented = true,
                ),
              );

              state.deleteCommentFailureOrSuccessOption.fold(
                    () => null,
                    (either) => either.fold(
                      (failure) => null,
                      (success) {
                    _comments.remove(_comment);
                    _comment = null;
                  },
                ),
              );

            },
            buildWhen: (p, c) => p.isSubmitting != c.isSubmitting,
            builder: (context, state) {
              return state.getCommentsFailureOrSuccessOption.fold(
                    () => Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 0,
                      bottom: 00,
                      right: 0,
                      left: 0,
                      child: InteractiveViewer(
                        child: tenet ? RtcLocalView.TextureView() : _viewRows(),
                        panEnabled: false,
                        minScale: 1.0,
                        maxScale: 5.0,
                        onInteractionUpdate: (e) {
                          // setState(() {
                          _engine.setCameraZoomFactor(e.scale);
                          // });
                        },
                      ),
                    ),
                    _toolbar(),
                    if (Token.isEmpty) _dialog(),
                    if (loading) loadingView()
                  ],
                ),
                    (either) => either.fold(
                        (failure) => NoInternet(
                      msg: failure.map(
                        serverError: (_) => null,
                        apiFailure: (e) => e.msg,
                      ),
                      onPressed: _refresh,
                    ),
                        (success) {
                      return  Stack(
                        alignment: Alignment.center,
                        children: [
                          InteractiveViewer(
                            child: tenet ? RtcLocalView.TextureView() : _viewRows(),
                            panEnabled: false,
                            // Set it to false to prev
                            // .ent panning.
                            minScale: 1.0,
                            maxScale: 5.0,
                            onInteractionUpdate: (e) {
                              // setState(() {
                              _engine.setCameraZoomFactor(e.scale);
                              // });
                            },
                          ),
                          if (livecomments == true) Align(
                            alignment:Alignment.bottomCenter,
                            child: Container(
                              height: 200,
                              margin: EdgeInsets.only(bottom: 90),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: success.comments.isNotEmpty
                                        ? _comment_part(context, _comments)
                                        : Container(),)
                                ],
                              ),
                            ),
                          ),
                          _toolbar(),
                          if (Token.isEmpty) _dialog(),
                          if (loading) loadingView()
                        ],
                      );
                    }
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _refresh() {
    _commentBloc.add(CommentEvent.getComments(feedid));
    return Future.value(true);
  }


  _comment_part(BuildContext context, List<Comment> comments) {
    return ShaderMask(
        shaderCallback: (rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple,
              Colors.transparent,
              Colors.transparent,
              Colors.purple
            ],
            stops: [
              0.0,
              0.3,
              0.9,
              1.0
            ], // 10% purple, 80% transparent, 10% purple
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child:
        // ListView.builder(
        //   controller: _scrollController,
        //   itemCount: comments.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return Container(
        //       margin: EdgeInsets.only(top: 10, bottom: 10),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: [
        //           SizedBox(
        //             width: 10,
        //           ),
        //           ClipOval(
        //             child: GestureDetector(
        //               // onTap: () => Navigator.pushNamed(
        //               //   context,
        //               //   Routes.profile,
        //               //   arguments: comment.user,
        //               // ),
        //               child: CachedNetworkImage(
        //                 imageUrl: AppUtils.getUserAvatar(comments[index].user.id, comments[index].user.avatar),
        //                 width: 48,
        //                 height: 48,
        //                 fit: BoxFit.cover,
        //                 errorWidget: (context, url, error) {
        //                   return Image.asset(
        //                     'assets/images/empty_avatar.png',
        //                     width: 48,
        //                     height: 48,
        //                   );
        //                 },
        //               ),
        //             ),
        //           ),
        //           SizedBox(
        //             width: 15,
        //           ),
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             children: [
        //               Text(
        //                 '${comments[index].user.username}',
        //                 style: TextStyle(
        //                   fontSize: 16,
        //                   fontWeight: FontWeight.w600,
        //                 ),
        //                 textAlign: TextAlign.center,
        //               ),
        //               Text(
        //                 '${comments[index].comment}',
        //                 style: TextStyle(
        //                   fontSize: 14,
        //                   fontWeight: FontWeight.w500,
        //                 ),
        //                 textAlign: TextAlign.center,
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // )
        StreamBuilder(
          stream: _postsController.stream,
          // stream: HeyPApiService.create().getComments(feedid).asStream(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            // print('Total length is ${snapshot.hasData}');
            // print('Total length is ${snapshot.data.body}');
            // print('Total length is ${snapshot.data.body.comments.length}');
            // print('Total length is ${snapshot.data.body.comments.last}');
            // final Comment comment = Comment(
            //   comment: snapshot.data.body.comments,
            //   user: user,
            //   date: formatted,
            // );
            // _comments.add(snapshot.data.body.comments);
            return  ListView.builder(
              controller: _scrollController,
              itemCount: snapshot.data.body.comments.length,
              // itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      ClipOval(
                        child: GestureDetector(
                          // onTap: () => Navigator.pushNamed(
                          //   context,
                          //   Routes.profile,
                          //   arguments: comment.user,
                          // ),
                          child: CachedNetworkImage(
                            imageUrl: AppUtils.getUserAvatar(snapshot.data.body.comments[index].user.id, snapshot.data.body.comments[index].user.avatar),
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                'assets/images/empty_avatar.png',
                                width: 48,
                                height: 48,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '${snapshot.data.body.comments[index].user.username}',
                            // '${comments[index].user.username}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '${snapshot.data.body.comments[index].comment}',
                            // '${comments[index].comment}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        )
    );
  }

  loadingView() {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.black12,
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(24),
        width: 128,
        height: 128,
        decoration: BoxDecoration(
          color: kColorGrey.withOpacity(0.5),
        ),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(kColorPrimary),
        ),
      ),
    );
  }

  Map<String, int> privacies = {'Public': 0, 'Private': 1, 'Only Followers': 2};
  var privacy = 0;

  //var desc = '';
  int category_id;

  var Token = '';
  var Channel = '';
  var videoID;
  var feedid = 0;
}

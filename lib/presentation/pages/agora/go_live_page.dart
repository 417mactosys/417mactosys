import 'dart:io';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:native_screenshot/native_screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wilotv/infrastructure/api/api_service.dart';
import 'package:wilotv/infrastructure/core/pref_manager.dart';
import 'package:wilotv/injection.dart';
import 'package:wilotv/presentation/components/custom_button.dart';
import 'package:wilotv/presentation/components/toast.dart';
import 'package:wilotv/presentation/pages/home/home.dart';
import 'package:wilotv/presentation/utils/app_utils.dart';
import 'package:wilotv/presentation/utils/constants.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;

import 'firebaseDB.dart';

class GoLiveScreen extends StatefulWidget {
  /// non-modifiable channel name of the page
  // final String channelName;
  // final String image;
  // final time;

  /// Creates a call page with given channel name.
  const GoLiveScreen({Key key}) : super(key: key);

  @override
  _GoLiveScreenState createState() => _GoLiveScreenState();
}

class _GoLiveScreenState extends State<GoLiveScreen> {
  static final _users = <int>[];
  String channelName;
  String sid = '';
  String descText = '';
  String token = '';
  int feedId;
  bool muted = false;
  List<UserAgora> userList = [];

  bool isLoading = false;
  bool isDescDialog = true;
  bool _isLogin = true;
  bool _isInChannel = true;
  int userNo = 0;
  var userMap;
  bool personBool = false;
  bool accepted = false;

  final _channelMessageController = TextEditingController();

  final _infoStrings = <Message>[];

  AgoraRtmClient _client;
  AgoraRtmChannel _channel;
  bool anyPerson = false;

  int guestID = -1;
  bool waiting = false;

  RtcEngine _engine;
  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    FireStoreClass.deleteUser(username: channelName);
    final res = getIt<HeyPApiService>().stopLive(channelName, sid);
    // clear users
    _users.clear();
    // destroy sdk
    // AgoraRtcEngine.leaveChannel();
    // AgoraRtcEngine.destroy();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  updateThumbnail() async {
    try {
      await Permission.storage.request();

      await Future.delayed(Duration(seconds: 7));
      final data = await _capturePNG();
      final task = await FirebaseStorage.instance
          .ref(DateTime.now().millisecondsSinceEpoch.toString() + ".png")
          .putFile(File(data));
      final url = await task.ref.getDownloadURL();

      print(url);
      await getIt<HeyPApiService>().updateThumbnail(channelName, url);
    } catch (e) {
      print(e);
    }

    //if (!stopped) updateThumbnail();
  }

  Future<String> _capturePNG() async {
    try {
      var pngBytes = await NativeScreenshot.takeScreenshot();
      return pngBytes;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  _startLiveStream() {
    // initialize agora sdk
    initialize();
    userMap = {channelName: Prefs.getUser().avatar};
    _createClient();
  }

  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await _engine.getCameraMaxZoomFactor();
    // await _engine.isCameraZoomSupported();
    // maxZoom = await _engine.getCameraMaxZoomFactor();
    // await AgoraRtcEngine.enableWebSdkInteroperability(true);
    // await AgoraRtcEngine.setParameters(
    //     '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await _engine.joinChannel(token, channelName, null, Prefs.getUser().id);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create('dfc294dcaf6c4e808d3440d20d9bfae8');
    // await AgoraRtcEngine.enableVideo();
    // await AgoraRtcEngine.enableLocalAudio(true);
    await _engine.enableVideo();
    await _engine.enableLocalVideo(true);
    // await _engine.getCameraMaxZoomFactor();

    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  Future<bool> _willPopCallback() async {
    if (personBool == true) {
      setState(() {
        personBool = false;
      });
    } else {
      setState(() {
        onBackPressed();
      });
    }
    return false; // return true if the route to be popped
  }

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      // setState(() {
      final info = 'onError: $code';
      print(info);
      //_infoStrings.add(info);
      // });
      // setState(() {});
    }, joinChannelSuccess: (channel, uid, elapsed) async {
      // this.channel = channel;
      print('joined3');
      print(channel);
      print(uid);
      updateThumbnail();
      await Wakelock.enable();
      // turnstle();
      // setState(() {
      final info = 'onJoinChannel: $channel, uid: $uid';
      // _infoStrings.add(info);
      // });
      // setState(() {});
    }, leaveChannel: (stats) {
      setState(() {
        // print('joined4');
        // _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
      // setState(() {});
    }, userJoined: (uid, elapsed) {
      setState(() {
        // print('joined5');
        // final info = 'userJoined: $uid';
        // _infoStrings.add(info);
        _users.add(uid);
        // print(_users.length);
      });
      // setState(() {});
    }, userOffline: (uid, elapsed) {
      // setState(() {
      // print('joined6');
      // final info = 'userOffline: $uid';
      // _infoStrings.add(info);
      // _users.remove(uid);
      // });

      if (uid == guestID) {
        setState(() {
          accepted = false;
        });
      }
      setState(() {
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      // setState(() {
      print('joined7');
      final info = 'firstRemoteVideo: $uid ${width}x $height';
      // _infoStrings.add(info);
      // });
      // setState(() {});
    }));
  }

  /// Add agora event handlers
  // void _addAgoraEventHandlers() {
  //   AgoraRtcEngine.onError = (err) {
  //     print(err);
  //   };
  //
  //   AgoraRtcEngine.onJoinChannelSuccess = (
  //     String channel,
  //     int uid,
  //     int elapsed,
  //   ) async {
  //     final documentId = channelName;
  //     channelName = documentId;
  //     // FireStoreClass.createLiveUser(
  //     //     name: documentId,
  //     //     id: uid,
  //     //     time: DateTime.now().millisecondsSinceEpoch.toString(),
  //     //     image: AppUtils.getAvatar());
  //     // The above line create a document in the firestore with username as documentID
  //
  //     await Wakelock.enable();
  //     updateThumbnail();
  //     // This is used for Keeping the device awake. Its now enabled
  //   };
  //
  //   AgoraRtcEngine.onLeaveChannel = () {
  //     setState(() {
  //       _users.clear();
  //     });
  //   };
  //
  //   AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
  //     setState(() {
  //       _users.add(uid);
  //     });
  //   };
  //
  //   AgoraRtcEngine.onUserOffline = (int uid, int reason) {
  //     if (uid == guestID) {
  //       setState(() {
  //         accepted = false;
  //       });
  //     }
  //     setState(() {
  //       _users.remove(uid);
  //     });
  //   };
  // }

  _showDescDialog() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Prefs.isDark() ? Colors.black : Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: MaterialButton(
              minWidth: 0,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.close,
                color: Colors.red,
                size: 20.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              color: Colors.white,
              padding: const EdgeInsets.all(12.0),
            ),
          ),
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
              descText = d;
            },
          ),
          SizedBox(
            height: 16.0,
          ),
          CustomButton(
            title: 'Start Live',
            color: Colors.red,
            onPressed: () async {
              await Permission.camera.request();
              await Permission.microphone.request();

              setState(() {
                isDescDialog = false;
                isLoading = true;
              });
              channelName = DateTime.now().millisecondsSinceEpoch.toString();
              final res = await getIt<HeyPApiService>()
                  .startLive(channelName, descText);
              sid = res.body.sid;
              token = res.body.token;
              feedId = res.body.feedid;
              setState(() {
                isLoading = false;
              });

              _startLiveStream();
            },
          ),
        ],
      ),
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
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: kColorGrey.withOpacity(0.5),
        ),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(kColorPrimary),
        ),
      ),
    );
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    // final list = [
    //   AgoraRenderWidget(0, local: true, preview: true),
    // ];
    // if (accepted == true) {
    //   _users.forEach((int uid) {
    //     if (uid != 0) {
    //       guestID = uid;
    //     }
    //     list.add(AgoraRenderWidget(uid));
    //   });
    // }
    // return list;

    final List<StatefulWidget> list = [];
    if (_role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    //_users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: ClipRRect(child: view));
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
    }
    return Container();

    /*    return Container(
        child: Column(
          children: <Widget>[_videoView(views[0])],
        ));*/
  }

  /// Info panel to show logs
  Widget messageList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: (_infoStrings[index].type == 'join')
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // CachedNetworkImage(
                            //   imageUrl: _infoStrings[index].image,
                            //   imageBuilder: (context, imageProvider) =>
                            //       Container(
                            //     width: 32.0,
                            //     height: 32.0,
                            //     decoration: BoxDecoration(
                            //       shape: BoxShape.circle,
                            //       image: DecorationImage(
                            //           image: imageProvider, fit: BoxFit.cover),
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                '${_infoStrings[index].user} joined',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : (_infoStrings[index].type == 'message')
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // CachedNetworkImage(
                                //   imageUrl: _infoStrings[index].image,
                                //   imageBuilder: (context, imageProvider) =>
                                //       Container(
                                //     width: 32.0,
                                //     height: 32.0,
                                //     decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       image: DecorationImage(
                                //           image: imageProvider,
                                //           fit: BoxFit.cover),
                                //     ),
                                //   ),
                                // ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        _infoStrings[index].user,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        _infoStrings[index].message,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : null,
              );
            },
          ),
        ),
      ),
    );
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  Widget _liveText() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.indigo, kColorPrimary],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
                child: Text(
                  'LIVE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 10),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.6),
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  height: 28,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.white,
                          size: 13,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '$userNo',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  )),
            ),
            Spacer(),
            MaterialButton(
              minWidth: 0,
              onPressed: onBackPressed,
              child: Icon(
                Icons.close,
                color: Colors.red,
                size: 20.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              color: Colors.white,
              padding: const EdgeInsets.all(12.0),
            )
          ],
        ),
      ),
    );
  }

  onBackPressed() {
    if (channelName.isNotEmpty && sid.isNotEmpty) {
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
                    Navigator.of(c).pop();

                    //End Live
                    doCallEnd();

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
                  Navigator.of(c).pop();

                  await getIt<HeyPApiService>().deleteLive(channelName);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => Home()));
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  showToast('Live Saved successfully');
                  Navigator.of(c).pop();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => Home()));
                },
              ),
            ],
          );
        });
  }

  doCallEnd() async {
    await Wakelock.disable();
    final res = await getIt<HeyPApiService>().stopLive(channelName, sid);
    print(res.body);
    _logout();
    _leaveChannel();
    _engine.leaveChannel();
    _engine.destroy();
    // FireStoreClass.deleteUser(username: channelName);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            body: Container(
              color: Colors.black,
              child: Center(
                child: Stack(
                  children: <Widget>[
                    isLoading
                        ? loadingView()
                        : isDescDialog
                            ? _showDescDialog()
                            : getWidgets(),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: _willPopCallback);
  }

  // double zoomlvl = 1.0;
  // double maxZoom = 5.0;

  Widget getWidgets() {
    return Stack(
      children: [
        InteractiveViewer(
            child: _viewRows(),
            panEnabled: false,
            minScale: 1.0,
            maxScale: 5.0,
            onInteractionUpdate: (e) {
              _engine.setCameraZoomFactor(e.scale);
            }),
        _liveText(),
        _bottomBar(), // send message
        messageList(),
      ],
    );
  }

  Widget _bottomBar() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Container(
      alignment: Alignment.bottomLeft,
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  minWidth: 0,
                  onPressed: _onToggleMute,
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: muted ? Colors.white : kColorPrimary,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  color: muted ? kColorPrimary : Colors.white,
                  padding: const EdgeInsets.all(12.0),
                ),
                SizedBox(width: 5),
                MaterialButton(
                  minWidth: 0,
                  onPressed: _onSwitchCamera,
                  child: Icon(
                    Icons.switch_camera,
                    color: kColorPrimary,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  color: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                ),
                SizedBox(width: 5),
                Expanded(
                    child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      cursorColor: Colors.blue,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      style: TextStyle(color: Colors.white),
                      controller: _channelMessageController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Comment',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(color: Colors.white)),
                      )),
                )),
                SizedBox(width: 5),
                MaterialButton(
                  minWidth: 0,
                  onPressed: _toggleSendChannelMessage,
                  child: Icon(
                    Icons.send,
                    color: kColorPrimary,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  color: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                )
              ]),
        ),
      ),
    );
  }

  void _logout() async {
    try {
      await _client.logout();
      //_log(info:'Logout success.',type: 'logout');
    } catch (errorCode) {
      //_log(info: 'Logout error: ' + errorCode.toString(), type: 'error');
    }
  }

  void _leaveChannel() async {
    try {
      await _channel.leave();
      //_log(info: 'Leave channel success.',type: 'leave');
      _client.releaseChannel(_channel.channelId);
      _channelMessageController.text = null;
    } catch (errorCode) {
      // _log(info: 'Leave channel error: ' + errorCode.toString(),type: 'error');
    }
  }

  void _toggleSendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.isEmpty) {
      return;
    }
    try {
      _channelMessageController.clear();
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
      _log(
          user: Prefs.getUsername(),
          info: text,
          type: 'message',
          image: AppUtils.getAvatar());

      final res = await getIt<HeyPApiService>().addComment(
          feedId, text, DateTime.now().millisecondsSinceEpoch.toString());
    } catch (errorCode) {
      //_log(info: 'Send channel message error: ' + errorCode.toString(), type: 'error');
    }
  }

  void _sendMessage(text) async {
    if (text.isEmpty) {
      return;
    }
    try {
      _channelMessageController.clear();
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
      _log(
          user: Prefs.getUsername(),
          info: text,
          type: 'message',
          image: AppUtils.getAvatar());

      final res = await getIt<HeyPApiService>().addComment(
          feedId, text, DateTime.now().millisecondsSinceEpoch.toString());
    } catch (errorCode) {
      // _log('Send channel message error: ' + errorCode.toString());
    }
  }

  void _createClient() async {
    _client =
        await AgoraRtmClient.createInstance('b42ce8d86225475c9558e478f1ed4e8e');
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log(user: peerId, info: message.text, type: 'message');
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      if (state == 5) {
        _client.logout();
        //_log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
    await _client.login(null, Prefs.getUsername());
    _channel = await _createChannel(channelName);
    await _channel.join();
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await _client.createChannel(name);
    channel.onMemberJoined = (AgoraRtmMember member) async {
      // var img = await FireStoreClass.getImage(username: member.userId);
      // var nm = await FireStoreClass.getName(username: member.userId);

      setState(() {
        userList
            .add(new UserAgora(username: member.userId, name: '', image: ''));
        if (userList.length > 0) anyPerson = true;
      });
      userMap.putIfAbsent(member.userId, () => Prefs.getUser().avatar);
      var len;
      _channel.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo = len - 1;
        });
      });

      _log(info: 'Member joined: ', user: member.userId, type: 'join');
    };
    channel.onMemberLeft = (AgoraRtmMember member) {
      var len;
      setState(() {
        userList.removeWhere((element) => element.username == member.userId);
        if (userList.length == 0) anyPerson = false;
      });

      _channel.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo = len - 1;
        });
      });
    };
    channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) {
      _log(user: member.userId, info: message.text, type: 'message', image: '');
    };
    return channel;
  }

  void _log({String info, String type, String user, String image}) {
    if (type == 'message' && info.contains('m1x2y3z4p5t6l7k8')) {
      //popUp();
    } else if (type == 'message' && info.contains('k1r2i3s4t5i6e7')) {
      setState(() {
        accepted = true;
        personBool = false;
        personBool = false;
        waiting = false;
      });
    } else if (type == 'message' && info.contains('E1m2I3l4i5E6')) {
      // stopFunction();
    } else if (type == 'message' && info.contains('R1e2j3e4c5t6i7o8n9e0d')) {
      setState(() {
        waiting = false;
      });
      /*FlutterToast.showToast(
          msg: "Guest Declined",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );*/

    } else {
      // var image = userMap[user];
      // String fullImage = 'https://wilotv.live:3443/' +
      //     'public/images/users/' +
      //     Prefs.getInt(Prefs.ID).toString() +
      //     '/128x128_' + image;

      print(info);
      print(type);
      print(user);
      print(image);

      Message m =
          new Message(message: info, type: type, user: user, image: image);
      setState(() {
        _infoStrings.insert(0, m);
      });
    }
  }

  void stopFunction() {
    setState(() {
      accepted = false;
    });
  }
}

class Message {
  String message;
  String type;
  String user;
  String image;
  Message({this.message, this.type, this.user, this.image});
}

class UserAgora {
  String username;
  String image;
  String name;
  UserAgora({this.username, this.name, this.image});
}

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:wilotv/infrastructure/api/api_service.dart';
import 'package:wilotv/infrastructure/core/pref_manager.dart';
import 'package:wilotv/injection.dart';
import 'package:wilotv/presentation/pages/home/home.dart';
import 'package:wilotv/presentation/utils/app_utils.dart';
import 'package:wilotv/presentation/utils/constants.dart';
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'go_live_page.dart';

class JoinLive extends StatefulWidget {
  final String channelName;
  final int channelId;
  final String username;
  final String hostImage;
  final String userImage;

  /// Creates a call page with given channel name.
  const JoinLive(
      {Key key,
      this.channelName,
      this.channelId,
      this.username,
      this.hostImage,
      this.userImage})
      : super(key: key);

  @override
  _JoinLiveState createState() => _JoinLiveState();
}

class _JoinLiveState extends State<JoinLive> {
  bool loading = true;
  bool completed = false;
  static final _users = <int>[];
  bool muted = true;
  int userNo = 0;
  var userMap;
  bool requested = false;
  var len;
  var token = "";
  bool _isLogin = true;
  bool _isInChannel = true;
  int feedId;

  final _channelMessageController = TextEditingController();

  final _infoStrings = <Message>[];

  AgoraRtmClient _client;
  AgoraRtmChannel _channel;

  bool accepted = false;
  bool stop = false;

  RtcEngine _engine;
  ClientRole _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
    userMap = {widget.username: widget.userImage};
    _createClient();
  }

  closeJoin() async {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text('Do you want to leave live?'),
            actions: [
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(c).pop();
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () async {
                  Navigator.of(context).pop();

                  //End Live
                  await Wakelock.disable();
                  _leaveChannel();
                  _logout();
                  _engine.leaveChannel();
                  _engine.destroy();

                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => Home()));
                },
              ),
            ],
          );
        });
  }

  Future<void> initialize() async {
    var d = await getIt<HeyPApiService>().joinLive(widget.channelName);
    token = d.body.token;
    feedId = d.body.feedid;

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await _engine.enableWebSdkInteroperability(true);
    // await _engine.setParameters(
    //     '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    // await AgoraRtcEngine.joinChannel(
    //     token, widget.channelName, null, Prefs.getUser().id);
    await _engine.joinChannel(
        token, widget.channelName, Prefs.getUsername(), Prefs.getUser().id);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create('dfc294dcaf6c4e808d3440d20d9bfae8');
    await _engine.enableVideo();
    //await AgoraRtcEngine.muteLocalAudioStream(true);
    await _engine.enableLocalAudio(false);
    await _engine.enableLocalVideo(!muted);
  }

  /// Add agora event handlers

  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      // setState(() {
      final info = 'onError: $code';
      print(info);
      //_infoStrings.add(info);
      // });
      // setState(() {});
    }, joinChannelSuccess: (channel, uid, elapsed) async {
      Wakelock.enable();
    }, leaveChannel: (stats) {
      setState(() {
        // print('joined4');
        // _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
      // setState(() {});
    }, userJoined: (uid, elapsed) {
      setState(() {
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      if (uid == widget.channelId) {
        setState(() {
          completed = true;
          Future.delayed(const Duration(milliseconds: 1500), () async {
            await Wakelock.disable();
            Navigator.pop(context);
          });
        });
      }
      _users.remove(uid);

    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      // setState(() {
      print('joined7');
      final info = 'firstRemoteVideo: $uid ${width}x $height';
      // _infoStrings.add(info);
      // });
      // setState(() {});
    }));
  }

  // void _addAgoraEventHandlers() {
  //   AgoraRtcEngine.onJoinChannelSuccess = (
  //     String channel,
  //     int uid,
  //     int elapsed,
  //   ) {
  //     Wakelock.enable();
  //   };
  //
  //   AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
  //     setState(() {
  //       _users.add(uid);
  //     });
  //   };
  //
  //   AgoraRtcEngine.onUserOffline = (int uid, int reason) {
  //     if (uid == widget.channelId) {
  //       setState(() {
  //         completed = true;
  //         Future.delayed(const Duration(milliseconds: 1500), () async {
  //           await Wakelock.disable();
  //           Navigator.pop(context);
  //         });
  //       });
  //     }
  //     _users.remove(uid);
  //   };
  // }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {


    final List<StatefulWidget> list = [];
    // if (_role == ClientRole.Broadcaster) {
    //   list.add(RtcLocalView.SurfaceView());
    // }
    // _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    // final List<AgoraRenderWidget> list = [];
    //user.add(widget.channelId);
    _users.forEach((int uid) {
      if (uid == widget.channelId) {
        // list.add(AgoraRenderWidget(uid));
        list.add(RtcRemoteView.SurfaceView(uid: uid));
      }
    });
    if (accepted == true) {
      // list.add(AgoraRenderWidget(0, local: true, preview: true));
      list.add(RtcRemoteView.SurfaceView(uid: 0));
    }
    if (list.isEmpty) {
      setState(() {
        loading = true;
      });
    } else {
      setState(() {
        loading = false;
      });
    }

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
        return (loading == true) && (completed == false)
            ?
            //LoadingPage()
            LoadingPage()
            : Container(
                child: Column(
                children: <Widget>[_videoView(views[0])],
              ));
      case 2:
        return (loading == true) && (completed == false)
            ?
            //LoadingPage()
            LoadingPage()
            : Container(
                child: Column(
                children: <Widget>[
                  _expandedVideoRow([views[0]]),
                  _expandedVideoRow([views[1]])
                ],
              ));
    }
    return Container();
  }

  /// Info panel to show logs
  Widget _messageList() {
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

  Future<bool> _willPopCallback() async {
    await Wakelock.disable();
    _leaveChannel();
    _logout();
    _engine.leaveChannel();
    _engine.destroy();
    return true;
    // return true if the route to be popped
  }

  Widget _ending() {
    return Container(
      color: Colors.black.withOpacity(.7),
      child: Center(
          child: Container(
        width: double.infinity,
        color: Colors.grey[700],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            'The Live has ended',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
        ),
      )),
    );
  }

  Widget _liveText() {
    return Container(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[Colors.indigo, kColorPrimary],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 8.0),
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
                padding: const EdgeInsets.only(left: 5),
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
              SizedBox(width: 5),
              MaterialButton(
                minWidth: 0,
                onPressed: closeJoin,
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
      ),
    );
  }

  Widget _username() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: widget.hostImage,
              imageBuilder: (context, imageProvider) => Container(
                width: 30.0,
                height: 30.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              child: Container(
                width: 100,
                child: Text(
                  '${widget.username}',
                  style: TextStyle(
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          color: Colors.black,
                          offset: Offset(0, 1.3),
                        ),
                      ],
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget requestedWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          spacing: 0,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              width: 130,
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 130,
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      alignment: Alignment(0, 0),
                      children: <Widget>[
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl: widget.hostImage,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 130,
                    alignment: Alignment.centerRight,
                    child: Stack(
                      alignment: Alignment(0, 0),
                      children: <Widget>[
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl: widget.userImage,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '${widget.username} Wants You To Be In This Live Video.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 0,
                bottom: 20,
                right: 20,
              ),
              child: Text(
                'Anyone can watch, and some of your followers may get notified.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[300],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Go Live with ${widget.username}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                elevation: 2.0,
                color: Colors.blue[400],
                onPressed: () async {
                  await _engine.enableLocalVideo(true);
                  await _engine.enableLocalAudio(true);
                  await _channel.sendMessage(
                      AgoraRtmMessage.fromText('k1r2i3s4t5i6e7 confirming'));
                  setState(() {
                    accepted = true;
                    requested = false;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Decline',
                    style: TextStyle(color: Colors.pink[300]),
                  ),
                ),
                elevation: 2.0,
                color: Colors.transparent,
                onPressed: () async {
                  await _channel.sendMessage(AgoraRtmMessage.fromText(
                      'R1e2j3e4c5t6i7o8n9e0d Rejected'));
                  setState(() {
                    requested = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            body: Container(
              color: Colors.black,
              child: Center(
                child: (completed == true)
                    ? _ending()
                    : Stack(
                        children: <Widget>[
                          InteractiveViewer(
                              child: _viewRows(),
                              panEnabled: false,
                              minScale: 1.0,
                              maxScale: 5.0),
                          if (completed == false) _bottomBar(),
                          _username(),
                          _liveText(),
                          if (completed == false) _messageList(),
                          // if(heart == true && completed==false) heartPop(),
                          if (requested == true) requestedWidget(),
                          // if(accepted == true) stopSharing(),

                          //_ending()
                        ],
                      ),
              ),
            ),
          ),
        ),
        onWillPop: _willPopCallback);
  }
// Agora RTM

  Widget _bottomBar() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            new Expanded(
                child: Container(
              height: 40,
              alignment: Alignment.center,
              child: TextField(
                  textAlignVertical: TextAlignVertical.bottom,
                  cursorColor: Colors.blue,
                  textInputAction: TextInputAction.go,
                  onSubmitted: _sendMessage,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: _channelMessageController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Comment',
                    hintStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color: Colors.white)),
                  )),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: MaterialButton(
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
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _logout() async {
    try {
      await _client.logout();
      // _log('Logout success.');
    } catch (errorCode) {
      //_log('Logout error: ' + errorCode.toString());
    }
  }

  void _leaveChannel() async {
    try {
      await _channel.leave();
      //_log('Leave channel success.');
      _client.releaseChannel(_channel.channelId);
      _channelMessageController.text = null;
    } catch (errorCode) {
      //_log('Leave channel error: ' + errorCode.toString());
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
      //_log('Send channel message error: ' + errorCode.toString());
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
      //_log('Send channel message error: ' + errorCode.toString());
    }
  }

  void _createClient() async {
    _client =
        await AgoraRtmClient.createInstance('b42ce8d86225475c9558e478f1ed4e8e');
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) async {
      // var img = await FireStoreClass.getImage(username: peerId);
      userMap.putIfAbsent(peerId, () => 'https://picsum.photos/200');
      _log(user: peerId, info: message.text, type: 'message');
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      if (state == 5) {
        _client.logout();
        // _log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
    await _client.login(null, Prefs.getUsername());
    _channel = await _createChannel(widget.channelName);
    await _channel.join();
    var len;
    _channel.getMembers().then((value) {
      len = value.length;
      setState(() {
        userNo = len - 1;
      });
    });
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await _client.createChannel(name);
    channel.onMemberJoined = (AgoraRtmMember member) async {
      // var img = await FireStoreClass.getImage(username: member.userId);
      userMap.putIfAbsent(member.userId, () => 'https://picsum.photos/200');

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
      _channel.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo = len - 1;
        });
      });
    };
    channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) async {
      // var img = await FireStoreClass.getImage(username: member.userId);
      userMap.putIfAbsent(member.userId, () => 'img');
      _log(user: member.userId, info: message.text, type: 'message');
    };
    return channel;
  }

  void _log({String info, String type, String user, String image}) {
    if (type == 'message' && info.contains('m1x2y3z4p5t6l7k8')) {
      // popUp();
    } else if (type == 'message' && info.contains('E1m2I3l4i5E6')) {
      //stopFunction();
    } else {
      Message m;
      var image = userMap[user];
      if (info.contains('d1a2v3i4s5h6')) {
        var mess = info.split(' ');
        if (mess[1] == widget.username) {
          /*m = new Message(
              message: 'working', type: type, user: user, image: image);*/
          setState(() {
            //_infoStrings.insert(0, m);
            requested = true;
          });
        }
      } else {
        m = new Message(message: info, type: type, user: user, image: image);
        setState(() {
          _infoStrings.insert(0, m);
        });
      }
    }
  }
}

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Loading',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

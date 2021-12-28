import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../infrastructure/core/pref_manager.dart';

import '../../../../infrastructure/data/socket_io_manager.dart';
import '../../../mrgreen/pixalive_videoplayer.dart';

import '../../../routes/routes.dart';

import '../../../../injection.dart';

import '../../../../infrastructure/api/api_service.dart';

class MessagesWidget extends StatefulWidget {
  final onTap, isSelected;

  MessagesWidget({this.onTap, this.isSelected});

  static _MessagesWidgetState state;

  @override
  _MessagesWidgetState createState() {
    state = _MessagesWidgetState();
    return state;
  }
}

class _MessagesWidgetState extends State<MessagesWidget> {
  int count = 0;

  getCount() async {
    final res = await getIt<HeyPApiService>().messagesCount(Prefs.getID());
    setState(() {
      count = res.body.count;
    });
  }

  bool _connected = false;
  SocketIoManager _socketIoManager;
  String _channelId;

  subscribe() {
    _socketIoManager = SocketIoManager(Routes.socketURL, {
      'channel': _channelId,
      'token': Prefs.getString(Prefs.ACCESS_TOKEN),
    })
      ..init().then((_) {
        _connected = !_connected;
        _socketIoManager.subscribe('receive_message', (jsonData) {
          print(jsonData);
          getCount();
        });
      });
  }

  @override
  void initState() {
    getCount();
    _channelId = '${Prefs.getID()}';
    subscribe();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Container(
              // width: 50,
              height: 50,
              child: !widget.isSelected
                  ? SvgPicture.asset(
                      'assets/images/chat.svg',
                      height: 30,
                      width: 30,
                      color: Color(0xffc3c3c3),
                    )
                  : ShaderMask(
                      shaderCallback: (r) {
                        return LinearGradient(
                                colors: [Colors.pinkAccent, Colors.orange],
                                begin: Alignment.bottomRight,
                                //radius: 0.1,
                                end: Alignment.topLeft)
                            .createShader(r);
                      },
                      child: SvgPicture.asset(
                        'assets/images/chat.svg',
                        color: Colors.white,
                        height: 30,
                        width: 30,
                      ),
                    ),
            ),
          ),
          if (count != 0)
            Positioned(
                top: 4,
                right: 2,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(24)),
                    child: Text(
                      '$count',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12),
                    )))
        ],
      ),
    );
  }
}

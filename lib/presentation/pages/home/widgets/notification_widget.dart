import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../infrastructure/core/pref_manager.dart';

import '../../../mrgreen/pixalive_videoplayer.dart';

import '../../../routes/routes.dart';

import '../../../../injection.dart';

import '../../../../infrastructure/api/api_service.dart';

class NotificationWidget extends StatefulWidget {
  static _NotificationWidgetState state;
  @override
  _NotificationWidgetState createState(){
    state =  _NotificationWidgetState();
    return state;
  }
}

class _NotificationWidgetState extends State<NotificationWidget> {
  int count = 0;

  getCount() async {
    final res = await getIt<HeyPApiService>().notificationsCount(Prefs.getID());
    setState(() {
      count = res.body.count;
    });
  }


  @override
  void initState() {
    getCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          child: IconButton(
            icon: SvgPicture.asset(
              'assets/images/notification.svg',
              width: 24,
              color: Prefs.isDark() ? Colors.white.withOpacity(0.87) : Color(0xff505050),
            ),
            onPressed: (){
              PixaliveVideoPlayer.pauseAll();
              Navigator.pushNamed(context, Routes.notification);
            },
          ),
        ),
        if(count != 0) Positioned(
          top: 4,
            right: 4,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(24)
              ),
                child: Text('$count', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),)
            )
        )
      ],
    );
  }
}
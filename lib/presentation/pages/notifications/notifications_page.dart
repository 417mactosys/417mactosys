import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wilotv/domain/entities/user.dart';
import 'package:wilotv/presentation/mrgreen/post_preview.dart';
import 'package:wilotv/presentation/mrgreen/user_list.dart';


import '../../../application/notification/notification_bloc.dart';
import '../../../domain/entities/notification.dart' as notif;
import '../../../injection.dart';
// import '../../domain/entities/user.dart';

import '../../../infrastructure/api/api_service.dart';

import '../../components/empty_list_widget.dart';
import '../../components/no_internet.dart';
import '../../components/notification_list_item.dart';
import '../../components/notification_list_shimmer.dart';
import '../../routes/routes.dart';

import '../../../infrastructure/core/pref_manager.dart';

import '../../components/post_list_item.dart';
import '../../pages/profile/profile_page.dart';

import '../home/widgets/notification_widget.dart';
import 'package:http/http.dart' as http;


class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with AutomaticKeepAliveClientMixin<NotificationsPage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  double width = 0.0;
  NotificationBloc _notificationBloc;

  Future<bool> _refresh() {
    _notificationBloc.add(NotificationEvent.getNotifications());
    return Future.value(true);
  }
  User appUser;
  @override
  void initState() {
    appUser = Prefs.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery. of(context). size. width;
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Notifications"),
        automaticallyImplyLeading: true,
        elevation: 1,
        shadowColor: Color(0xffedeeee),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              _deleteAllNotificationData();
            },
            child: Text("Clear All", style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600),),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: BlocProvider(
          create: (context) => _notificationBloc = getIt<NotificationBloc>()
            ..add(
              NotificationEvent.getNotifications(),
            ),
          child: BlocConsumer<NotificationBloc, NotificationState>(
            listener: (context, state) {

            },
            buildWhen: (p, c) => p.isSubmitting != c.isSubmitting,
            builder: (context, state) {
              return state.getNotificationsFailureOrSuccessOption.fold(
                () => NotificationListShimmer(),
                (either) => either.fold(
                  (failure) => NoInternet(
                    msg: failure.map(
                      serverError: (_) => null,
                      apiFailure: (e) => e.msg,
                    ),
                    onPressed: _refresh,
                  ),
                  (success) => success.notifications.isNotEmpty
                      ? _bodyWidget(context, success.notifications)
                      : Center(
                          child: EmptyListWidget(
                            icon: 'icon_no_notifications',
                            message: 'no_notifications'.tr(),
                            title: '',
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<String> _deleteAllNotificationData() async {
    print("appUser.id");
    print(appUser.id);
    var url = "https://wilotv.live:3443/api/delete_all_notifications?user_id=${appUser.id}";
    final headers = {"Content-Type": "application/json"};
    final res = await http.get(url, headers: headers);
    print("res");
    print(res);
    setState(() {
      var response = json.decode(res.body);
      print(response);
      setState(() {
        _refresh();
      });
    });

    return "SUCCESS";
  }

  Future<String> _deleteNotificationData(int id) async {
    var url = "https://wilotv.live:3443/api/delete_notification?id=$id";
    final headers = {"Content-Type": "application/json"};
    final res = await http.get(url, headers: headers);
    print("res");
    print(res);
    setState(() {
      _refresh();
    });

    return "SUCCESS";
  }


  @override
  void dispose() {
    NotificationWidget.state.getCount();
    super.dispose();
  }

  ListView _bodyWidget(

      BuildContext context, List<notif.Notification> notifications) {
    return ListView.separated(
      //physics: BouncingScrollPhysics(),
      separatorBuilder: (context, index) => Divider(
        indent: 0,
        endIndent: 0,
        color: Colors.grey.withOpacity(0.25),
      ),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: ObjectKey(notifications[index]),
          direction: DismissDirection.endToStart,

          // Remove this product from the list
          // In production enviroment, you may want to send some request to delete it on server side
          onDismissed: (_){
            // setState(() {
              _deleteNotificationData(notifications[index].id);
           // });
          },
          background: Container(
              alignment: AlignmentDirectional.centerEnd,
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0,  width*0.02, 0.0),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 0.0, width*0.05, 0.0),
                    child: Text(
                      "Delete".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              )),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: NotificationListItem(
              notification: notifications[index],
              onTap: () {
                if (notifications[index].type == 2) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) => ProfilePage(
                        user: notifications[index].sender,
                      )));
                  // Navigator.of(context).pushNamed(Routes.profile,
                  //     arguments: notifications[index].sender);
                } else {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (c) => PostViewer(() {}, this.feed)));

                  Navigator.of(context).pushNamed(Routes.post,
                      arguments: notifications[index].postId);
                }
              },
            ),
          ),
        );

      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import 'package:easy_localization/easy_localization.dart';
import './user_list.dart';

class FollowersFollowingPage extends StatefulWidget {
  final User user;
  final String kind;
  FollowersFollowingPage(this.user, this.kind);
  @override
  _FollowersFollowingPageState createState() => _FollowersFollowingPageState();
}

class _FollowersFollowingPageState extends State<FollowersFollowingPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.kind == 'followings' ? 1 : 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.user.username),
          bottom: TabBar(
            tabs: [
              Tab(text: 'followers'.tr(),),
              Tab(text: 'following'.tr(),),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UsersList(widget.user.id, 'followers'),
            UsersList(widget.user.id, 'followings'),
          ],
        )
      ),
    );
  }
}

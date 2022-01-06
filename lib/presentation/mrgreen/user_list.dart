import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../infrastructure/core/pref_manager.dart';
import 'dart:convert';
import '../routes/routes.dart';
import '../../domain/entities/user.dart';
import '../components/custom_circle_avatar.dart';
import '../components/custom_button.dart';
import '../../infrastructure/api/api_service.dart';
import '../utils/app_utils.dart';

class UsersList extends StatefulWidget {
  final int id;
  final String kind;
  UsersList(this.id, this.kind);

  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: get('https://wilotv.live:3443/api/${widget.kind}/${widget.id}/${Prefs.getUser().id}').asStream(),
      builder: (BuildContext c, AsyncSnapshot<Response> s){
        if(!s.hasData) return Center(child: CircularProgressIndicator(),);
        final List res = jsonDecode(s.data.body)['users'];
        final list = res.map((e) => User.fromJson(e)).toList();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (c, i){
            return UserListView(list[i]);
          },
        );
      },
    );
  }
}

class UserListView extends StatefulWidget {
  final User user;

  UserListView(this.user , {Key key}) : super(key: key);

  @override
  _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<UserListView> {
  bool follow = false;

  @override
  void initState() {
    super.initState();
    follow = widget.user.follow == 0 || widget.user.follow == null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:() {
        //push(context, ConvoPage(doc, widget.person));
        Navigator.pushNamed(
          context,
          Routes.profile,
          arguments: widget.user,
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.black.withOpacity(0.05)))),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomCircleAvatar(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.profile,
                  arguments: widget.user,
                );
              },
              radius: 25,
              url: AppUtils.getUserAvatar(widget.user.id, widget.user.avatar),
            ),
            SizedBox(height: 12, width: 12,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.user.username,
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.fade,
                  ),
                  SizedBox(height: 6, width: 6,),

                  Text('${widget.user.firstName} ${widget.user.lastName}')
                ],
              ),
            ),
            //Spacer(),
            CustomButton(
                title: follow ? 'Follow' : 'Following',
                onPressed: () {
                  HeyPApiService.create().followUser(widget.user.id);
                  setState(() {
                    follow = !follow;
                    //user.follow = user.follow == 0 ? 1 : 0;
                  });
                })
            //appUser ? Text("~ ${doc['name']}", style: TextStyle(color: Colors.grey),): Container()
          ],
        ),
      ),
    );
  }
}
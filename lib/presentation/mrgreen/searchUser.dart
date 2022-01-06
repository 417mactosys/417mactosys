import 'package:flutter/material.dart';
import 'package:wilotv/infrastructure/api/api_service.dart';
import 'package:wilotv/presentation/components/custom_button.dart';
import 'package:wilotv/presentation/components/custom_circle_avatar.dart';
import 'package:wilotv/presentation/routes/routes.dart';
import 'package:wilotv/presentation/utils/app_utils.dart';
import '../components/highlight_text_widget.dart';
import '../../infrastructure/core/pref_manager.dart';
import '../utils/constants.dart';

import '../../domain/entities/user.dart';

import 'contacts_friends.dart';

class SearchUser extends StatefulWidget {
  var user, query;
  SearchUser(this.user, this.query);
  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  bool follow = false;

  @override
  void initState() {
    // TODO: implement initState
    print('USER');
    print(widget.user);
    follow = widget.user['follow'] == 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        try {
          User user =
              User(id: widget.user['id'], username: widget.user['username']);
          print('USER' + user.id.toString());
          // User user = User.fromJson(widget.user);
          // push(context, ConvoPage(doc, widget.user));
          Navigator.pushNamed(
            context,
            Routes.profile,
            arguments: user,
          );
        } catch (e) {
          print('EXECPTION' + e.toString());
        }
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
              onTap: () {},
              radius: 25,
              url: AppUtils.getUserAvatar(
                  widget.user['id'], widget.user['avatar'].toString()),
            ),
            space(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HighlightText(
                    text: widget.user['first_name'].toString() +
                        widget.user['last_name'].toString(),
                    highlight: widget.query,
                    style: TextStyle(fontSize: 17),
                    // overflow: TextOverflow.fade,
                    highlightColor:
                        Prefs.isDark() ? Colors.white : Colors.black,
                  ),
                  // Text(
                  //   widget.user['first_name'].toString() +
                  //       widget.user['last_name'].toString(),
                  //   style: TextStyle(fontSize: 16),
                  //   overflow: TextOverflow.fade,
                  // ),
                  space(6),
                  HighlightText(
                    text: widget.user['username'].toString(),
                    highlight: widget.query,
                    style: TextStyle(fontSize: 17),
                    // overflow: TextOverflow.fade,
                    highlightColor:
                        Prefs.isDark() ? Colors.white : Colors.black,
                  ),
                  // Text(widget.user['username'].toString())
                ],
              ),
            ),
            //Spacer(),

            if (widget.user['id'] != Prefs.getID())
              CustomButton(
                  title: follow ? 'Follow' : 'Unfollow',
                  onPressed: () {
                    HeyPApiService.create().followUser(widget.user['id']);
                    setState(() {
                      follow = !follow;
                      // user.follow = user.follow == 0 ? 1 : 0;
                    });
                  })
          ],
        ),
      ),
    );
  }
}

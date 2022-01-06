import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../components/custom_circle_avatar.dart';
import '../../presentation/utils/app_utils.dart';

import 'package:http/http.dart';
import 'dart:convert';
import '../../domain/entities/user.dart';
import '../../infrastructure/core/pref_manager.dart';

import '../../infrastructure/api/api_service.dart';

import '../routes/routes.dart';
import '../components/custom_button.dart';
import './suggestion_list.dart';

class Suggestions extends StatefulWidget {
  @override
  _SuggestionsState createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  String suggestionURL =
      'https://wilotv.live:3443/api/suggest/people?uid=${Prefs.getUser().id}';

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 12,),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Suggested Friends',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
              ),
              Spacer(),
              FlatButton(
                child: Text(
                  'View All',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      CupertinoPageRoute(builder: (c) => SuggestionList()));
                },
              ),
            ],
          ),
          //SizedBox(height: 6,),
          StreamBuilder(
            stream: get(suggestionURL).asStream(),
            builder: (BuildContext c, AsyncSnapshot<Response> s) {
              if (!s.hasData)
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
                  ),
                );
              //final List res = jsonDecode(s.data.body)['users'];
              final List res = jsonDecode(s.data.body);
              final list = res.map((e) => User.fromJson(e)).toList();
              return SizedBox(
                height: 164,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  itemCount: list.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, i) {
                    final user = list[i];
                    return SuggestionView(user, false);
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class SuggestionView extends StatefulWidget {
  final User user;
  final bool mock;
  SuggestionView(this.user, this.mock);
  @override
  _SuggestionViewState createState() => _SuggestionViewState();
}

class _SuggestionViewState extends State<SuggestionView> {
  bool follow = false;

  @override
  void initState() {
    follow = widget.user.follow == 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mock) {
      return Container(
        width: 80, //height: 100,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        //color: Colors.blue.shade700,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10.0),
            //   child: FadeInImage(
            //       placeholder: AssetImage(''),
            //       image: NetworkImage(AppUtils.getUserAvatar(10, widget.user.avatar)),
            //     width: 100, height: 100,
            //   ),
            // ),
            SizedBox(
              height: 6,
            ),
            Text(
              '@username',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 6,
            ),
            Expanded(
              child: FlatButton(
                child: Text(
                  follow ? 'Following' : 'Follow',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.deepOrange,
                padding: EdgeInsets.all(0),
              ),
            )
          ],
        ),
      );
    }

    return Container(
      width: 100, //height: 100,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      //color: Colors.blue.shade700,
      child: Column(
        children: [
          CustomCircleAvatar(
            radius: 50,
            url: AppUtils.getUserAvatar(widget.user.id, widget.user.avatar),
            isSquare: true,
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.profile,
                arguments: widget.user,
              );
            },
          ),
          //SizedBox(height: 6,),
          Transform.translate(
            offset: Offset(0, -13),
            child: follow
                ? Container(
                    alignment: Alignment.center,
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              spreadRadius: 3,
                              blurRadius: 3,
                              offset: Offset(0, 3))
                        ]),
                    child: Icon(
                      Icons.done,
                      color: Colors.deepOrange,
                      size: 19,
                    ),
                  )
                : SizedBox(
                    height: 26,
                    width: 75,
                    child: CustomButton(
                      title: follow ? 'Following' : 'Follow',
                      onPressed: () {
                        HeyPApiService.create().followUser(widget.user.id);
                        setState(() {
                          follow = !follow;
                        });
                      },
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      //color: Colors.deepOrange,
                      padding: EdgeInsets.all(0),
                    ),
                  ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.profile,
                  arguments: widget.user,
                );
              },
              child: Text(
                widget.user.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
  }
}

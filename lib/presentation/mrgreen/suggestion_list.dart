import 'package:flutter/material.dart';
import '../components/custom_circle_avatar.dart';
import '../../presentation/utils/app_utils.dart';

import 'package:http/http.dart';
import 'dart:convert';
import '../../domain/entities/user.dart';
import '../../infrastructure/core/pref_manager.dart';

import '../../infrastructure/api/api_service.dart';

import '../mrgreen/user_list.dart';

class SuggestionList extends StatefulWidget {
  SuggestionList({Key key}) : super(key: key);

  @override
  _SuggestionListState createState() => _SuggestionListState();
}

class _SuggestionListState extends State<SuggestionList> {

  String suggestionURL = 'https://wilotv.live:3443/api/suggest/people?uid=${Prefs.getUser().id}';

  @override
  void initState() {
    print('USERID');
    print(Prefs.getUser().id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        titleSpacing: 0.0,
        shadowColor: Color(0xffedeeee),
        title: Text(
          'Suggested Friends',
        ),
      ),
      body: StreamBuilder(
        stream: get(suggestionURL).asStream(),
        builder: (BuildContext c, AsyncSnapshot<Response> s){
          if(!s.hasData) return Center(child: CircularProgressIndicator(),);

          print(s.data.body);

          //final List res = jsonDecode(s.data.body)['users'];
          final List res = jsonDecode(s.data.body);
          final list = res.map((e) => User.fromJson(e)).toList();

          print(list.length);

          return ListView.builder(
           // shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 4),
            itemCount: list.length,
            //scrollDirection: Axis.horizontal,
            itemBuilder: (c, i){
              final user = list[i];
              return UserListView(user);
            },
          );
        },
      ),
    );
  }
}
import 'dart:convert';
import 'dart:math';

import 'dart:async';

// import 'package:flutter_sms/flutter_sms_web.dart';
import 'package:http/http.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import '../utils/app_utils.dart';
import '../../infrastructure/core/pref_manager.dart';
import '../components/custom_circle_avatar.dart';
import '../components/custom_button.dart';
import '../../infrastructure/api/api_service.dart';
import '../utils/constants.dart';
import '../routes/routes.dart';

import './contacts_repo.dart';

import '../../infrastructure/api/api_service.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/user.dart';

import 'package:flutter_sms/flutter_sms.dart';

import './contacts_repo.dart';

class ContactsList extends StatefulWidget {
  @override
  _ContactsListState createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  void initState() {
    super.initState();
    //getContacts();
    initC();
    //getC();
  }

  initC() async {
    allowed = await Permission.contacts.isGranted;
    setState(() {});
    if (!allowed) {
      requestContact();
    } else {
      //getC();
    }
  }

  requestContact() async {
    allowed = (await Permission.contacts.request()) == PermissionStatus.granted;
    if (allowed) {
      setState(() {

      });
    }
  }

  @override
  void dispose() {
    //contacts_controller.close();
  }

  bool allowed = false;

  bool showSearch = false;

  String keyword = '';

  @override
  Widget build(BuildContext context) {
    final searchBar = Container(
      child: SizedBox(
        height: 36,
        child: TextFormField(
          autofocus: true,
          onChanged: (s){
            setState(() {
              keyword = s;
            });
          },

          decoration: InputDecoration(
            filled: true,
            fillColor: Prefs.isDark() ? Colors.white12 : Colors.black12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.transparent)
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.transparent)
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.transparent)
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            hintText: 'Search',
            hintStyle: TextStyle(color: Prefs.isDark() ? Colors.white24 : Colors.black26)
          ),
        ),
      ),
    );

    if (!allowed) {
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: Color(0xffedeeee),
          title: Text(
            'My Contacts',
          ),
        ),
        body: Center(
          child: FlatButton(
            child: Text("Get Contacts"),
            onPressed: requestContact,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        titleSpacing: 0.0,
        shadowColor: Color(0xffedeeee),
        title: showSearch ? searchBar :  Text(
          'My Contacts',
        ),
        actions: [
          IconButton(
            icon: Icon(showSearch ? Icons.close_rounded : CupertinoIcons.search, color: (Prefs.isDark() ? Colors.white : Colors.black ).withOpacity(0.8),),
            onPressed: (){
              setState(() {
                showSearch = !showSearch;
              });
            },
          )
        ],
      ),
      body: SafeArea(
          child:
              // list.length != 0 ? ListView.builder(
              //   physics: BouncingScrollPhysics(),
              //   padding: EdgeInsets.only(top: 12),
              //   itemCount: list.length,
              //   itemBuilder: (c, i) {
              //     return ContactsView(
              //       list[i],
              //       key: ValueKey(list[i]),
              //     );
              //   },
              // ): Center(
              //   child: CircularProgressIndicator(backgroundColor: Colors.grey, value: progress,),
              // )

              repo.list.length == 0
                  ? StreamBuilder(
                      stream: getC().asStream(),
                      builder: (BuildContext c, AsyncSnapshot<List<Friend>> s) {
                        if(!s.hasData) return Center(child: CircularProgressIndicator(),);
                        return s.data.length != 0
                            ? ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.only(top: 12),
                                itemCount: s.data.length,
                                itemBuilder: (c, i) {
                                  return ContactsView(
                                    s.data[i],
                                    key: ValueKey(s.data[i]),
                                    keyword: keyword
                                  );
                                },
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  //value: s.data.progress,
                                ),
                              );
                      },
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 12),
                      itemCount: repo.list.length,
                      itemBuilder: (c, i) {
                        return ContactsView(
                          repo.list[i],
                          key: ValueKey(repo.list[i]),
                        );
                      },
                    )

          //       ListView.builder(
          //   physics: BouncingScrollPhysics(),
          //   padding: EdgeInsets.only(top: 12),
          //   itemCount: contacts.length,
          //   itemBuilder: (c, i) {
          //     return ContactsView(
          //       contacts[i],
          //       (p) {
          //         setState(() {
          //           print(contacts.indexOf(p));
          //           contacts.remove(p);
          //           contacts.insert(0, p);
          //           //contacts = contacts.toList();
          //
          //           contacts.forEach((element) {
          //             print(element.toString());
          //           });
          //         });
          //       },
          //       key: ValueKey(contacts[i]),
          //     );
          //   },
          // )
          ),
    );
  }
}

class ContactsView extends StatefulWidget {
  final Friend friend;
  final String keyword;

  ContactsView(this.friend, {Key key, this.keyword}) : super(key: key);

  @override
  _ContactsViewState createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  bool appUser = false;
  bool fetching = false;

  //User user;

  bool follow = false;

  @override
  void initState() {
    super.initState();
    appUser = widget.friend.user != null;
    if (appUser) follow = widget.friend.user.follow == 0;
  }

  // checkUserRegistered() async {
  //   if (widget.person.phones.length > 0) {
  //     user = await isUser(widget.person.phones.first.normalizedNumber);
  //     if (user != null) {
  //       print('re');
  //       if (mounted) widget.reorder(widget.person);
  //     }
  //     setState(() {
  //       appUser = user != null;
  //     });
  //   }
  //   setState(() {
  //     fetching = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var visible = widget.friend.person.name.toString().toLowerCase().contains(widget.keyword.toLowerCase()) ||
        (widget.friend.user != null && widget.friend.user.username.toString().toLowerCase().contains(widget.keyword.toLowerCase())) || widget.keyword.isEmpty;


    //visible = widget.keyword.isEmpty;

    if(!visible) return Container();

    return InkWell(
      onTap: appUser
          ? () {
              //push(context, ConvoPage(doc, widget.person));
              Navigator.pushNamed(
                context,
                Routes.profile,
                arguments: widget.friend.user,
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.black.withOpacity(0.05)))),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !appUser
                ? Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color:
                            rc[Random().nextInt(rc.length)].withOpacity(0.4)),
                    child: Text(
                      '${widget.friend.person.displayName.substring(0, 1).toUpperCase()}',
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  )
                : CustomCircleAvatar(
                    onTap: () {},
                    radius: 25,
                    url: AppUtils.getUserAvatar(
                        widget.friend.user.id, widget.friend.user.avatar),
                  ),
            space(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appUser
                        ? '' + widget.friend.user.username
                        : widget.friend.person.displayName.trim(),
                    style: TextStyle(fontSize: 16),
                    overflow: TextOverflow.fade,
                  ),
                  space(6),
                  widget.friend.person.phones.length > 0
                      ? Text(widget.friend.person.phones.first.normalizedNumber
                          .trim())
                      : Text("No number")
                ],
              ),
            ),
            //Spacer(),
            if (fetching)
              SizedBox(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.deepOrangeAccent),
                ),
                height: 24,
                width: 24,
              )
            else
              appUser
                  ? //Container()
                  CustomButton(
                      title: follow ? 'Follow' : 'Unfollow',
                      onPressed: () {
                        HeyPApiService.create()
                            .followUser(widget.friend.user.id);
                        setState(() {
                          follow = !follow;
                          //user.follow = user.follow == 0 ? 1 : 0;
                        });
                      })
                  : CustomButton(
                      title: 'Invite',
                      onPressed: () async {
                        List<String> recipients = [
                          widget.friend.person.phones.first.normalizedNumber
                        ];
                        // await FlutterSmsPlugin()
                        //     .sendSMS(
                        //         message:
                        //             "https://play.google.com/store/apps/details?id=com.sataware.wilotv",
                        //         recipients: recipients)
                        //     .catchError((onError) {
                        //   print(onError);
                        // });
                      },
                    )
            //appUser ? Text("~ ${doc['name']}", style: TextStyle(color: Colors.grey),): Container()
          ],
        ),
      ),
    );
  }
}

space(double px) {
  return SizedBox(
    height: px,
    width: px,
  );
}

var rc = [
  Colors.blueGrey,
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.cyan,
  Colors.purple
];

Future<Contact> getContact(String phone) async {
  var list = await FlutterContacts.getContacts(withProperties: true);
  Contact res;
  list.forEach((element) {
    if (element.phones.first.normalizedNumber == phone) res = element;
    if (phone.contains(element.phones.first.number.replaceAll(" ", "")))
      res = element;
  });
  return res;
}

Future<User> isUser(String phone) async {
  final res = await get(Uri.parse(
      'https://wilotv.live:3443/api/is_user?phone=$phone&id=${Prefs.ID}'));
  final u = jsonDecode(res.body)['user'];
  if (u == null) return null;
  var uu = await HeyPApiService.create().getUserInfo(User.fromJson(u).id);
  print("USER" + uu.body.toString());
  return uu.body.user;
}

class Friend {
  final Contact person;
  final User user;
  Friend(this.person, this.user);
}

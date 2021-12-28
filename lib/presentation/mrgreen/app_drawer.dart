import 'package:flutter/material.dart';

import '../routes/routes.dart';
import '../components/custom_circle_avatar.dart';
import '../components/waiting_dialog.dart';
import '../pages/post/widgets/publish_button_widget.dart';
import '../pages/channels/createChannel.dart';
import '../pages/profile/profile_page.dart';
import '../pages/home/home.dart';
import '../utils/app_utils.dart';
import '../utils/app_themes.dart';
import '../utils/constants.dart';
import '../mrgreen/pixalive_videoplayer.dart';

import '../../domain/entities/detail_user.dart';
import '../../domain/entities/detail_channels.dart';
import 'package:chopper/chopper.dart';
import '../../domain/entities/user.dart';
import '../../infrastructure/api/api_service.dart';
import '../../infrastructure/core/pref_manager.dart';

import '../../injection.dart';

class PixaliveAppDrawer extends StatefulWidget {
  @override
  _PixaliveAppDrawerState createState() => _PixaliveAppDrawerState();
}

Color DC = Colors.deepOrange;

class _PixaliveAppDrawerState extends State<PixaliveAppDrawer> {
  void switchChannel(int id) async {
    showWaitingDialog(context);
    final success = await getIt<HeyPApiService>().switchAccount(id);

    print(success.body);
    User user = success.body.user;

    Prefs.setString(Prefs.ACCESS_TOKEN, success.body.accessToken);
    Prefs.setInt(Prefs.ID, user.id);
    Prefs.setString(Prefs.USERNAME, user.username);
    Prefs.setString(Prefs.FIRST_NAME, user.firstName);
    Prefs.setString(Prefs.LAST_NAME, user.lastName);
    Prefs.setString(Prefs.EMAIL, user.email);
    Prefs.setInt(Prefs.IS_CHANNEL, user.isChannel);
    Prefs.setString(Prefs.PHONE, user.phone);
    Prefs.setInt(Prefs.OWNER_ID, user.owner_id);
    Prefs.setString(Prefs.AVATAR, user.avatar);

    Prefs.setBool(Prefs.LOGIN_STATUS, true);

    AppUtils.updateGcmToken();

    setState(() {
      expanded = false;
    });

    Navigator.of(context).pop();
    Navigator.of(context).pop();

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (c) => Home()));
  }

  User appUser;

  @override
  void initState() {
    appUser = Prefs.getUser();
    super.initState();
  }

  bool expanded = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomCircleAvatar(
                    radius: 25,
                    url: AppUtils.getUserAvatar(appUser.id, appUser.avatar),
                    onTap: () {
                      PixaliveVideoPlayer.pauseAll();
                      Navigator.pushNamed(
                        context,
                        Routes.profile,
                      );
                      //key.currentState.openDrawer();
                    },
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                _logoWidget(),
                Spacer(),
                IconButton(
                  icon: Icon(expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded),
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                  iconSize: 32,
                ),
                SizedBox(
                  width: 12,
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            if (expanded)
              StreamBuilder(
                stream: getIt<HeyPApiService>()
                    .getAccounts(
                        appUser.isChannel == 1 ? appUser.owner_id : appUser.id)
                    .asStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<Response<DetailChannel>> snap) {
                  if (snap.hasData) {
                    return Column(
                      children:
                          List.generate(snap.data.body.user.length, (index) {
                        final u = snap.data.body.user[index];
                        if (snap.data.body.user.length == 1) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: PublishButtonWidget(
                              text: 'Create Channel',
                              isLive: true,
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (b) => CreateChannel(null)));
                              },
                            ),
                          );
                        }
                        //if(u.id == Prefs.getID()) return Container();
                        return Container(
                          color: u.id != Prefs.getID()
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.2),
                          child: InkWell(
                            onTap: () {
                              if (u.id != Prefs.getID()) switchChannel(u.id);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: u.isChannel == 1 ? 6 : 12),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Colors.grey.withOpacity(
                                              u.isChannel == 1 && index != 0
                                                  ? 0.1
                                                  : 0.5),
                                          width: 0.7))),
                              child: Row(
                                children: [
                                  CustomCircleAvatar(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (b) => ProfilePage(
                                                    user: u,
                                                  )));
                                    },
                                    radius: 20,
                                    url: AppUtils.getUserAvatar(u.id, u.avatar),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(u.username),
                                      if (u.isChannel == 1)
                                        Text(
                                          u.description,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                          maxLines: 1,
                                        ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }
                  return LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
                  );
                },
              ),
            SizedBox(
              height: 12,
            ),
            Divider(
              height: 0.7,
            ),
            SizedBox(
              height: 12,
            ),
            //drawerItem('Home'),
            //Spacer(),
            drawerItem('Channels', Icons.live_tv),
            // drawerItem('Packages', Icons.play_circle_outline_sharp),

            drawerItem('Feedback', Icons.feedback),
            // drawerItem('My Contacts', Icons.contacts),
          ],
        ),
      ),
    );
  }

  drawerItem(route, icon) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            kColorPrimary.withOpacity(0.1),
            kColorPink.withOpacity(0.05)
          ], begin: Alignment.topLeft),
          borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        //tileColor: DC.withOpacity(0.1),
        title: Row(
          children: [
            Icon(
              icon,
              color: kColorPrimary,
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              route,
              style: TextStyle(color: kColorPrimary),
            ),
          ],
        ),
        onTap: () {
          PixaliveVideoPlayer.pauseAll();
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }

  Widget _logoWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Image.asset(
        'assets/images/text_logo.png',
        height: 30,
      ),
    );
  }
}

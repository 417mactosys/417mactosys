import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wilotv/presentation/mrgreen/pixalive_videoplayer.dart';
import 'package:wilotv/presentation/pages/agora/go_live_page.dart';

import '../../../application/post/post_bloc.dart';
import '../../../domain/entities/user.dart';
import '../../../infrastructure/api/api_service.dart';
import '../../../infrastructure/core/pref_manager.dart';
import '../../../injection.dart';
import '../../components/custom_circle_avatar.dart';
import '../../components/toast.dart';
import '../../components/waiting_dialog.dart';
import '../../utils/app_utils.dart';
import '../../utils/constants.dart';
import 'widgets/header_widget.dart';
import 'widgets/image_widget.dart';
import 'widgets/publish_button_widget.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController desc = TextEditingController();
  User user = Prefs.getUser();

  @override
  void initState() {
    //initialize();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ImageWidget.state.setVideoOff();
  }

  @override
  Widget build(BuildContext context) {
    channel_id = user.id;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return BlocProvider(
            create: (context) => getIt<PostBloc>(),
            child: BlocConsumer<PostBloc, PostState>(
              //listenWhen: (p, c) => p.isSubmitting != c.isSubmitting,
              listener: (context, state) {
                state.addPostFailureOrSuccessOption.fold(
                  () => null,
                  (either) {
                    Navigator.pop(context);
                    either.fold(
                      (failure) {
                        failure.map(
                          serverError: (_) => null,
                          apiFailure: (e) => showToast(e.msg),
                        );
                      },
                      (success) {
                        Navigator.of(context).pop(true);
                      },
                    );
                  },
                );

                if (state.isSubmitting) {
                  showWaitingDialog(context);
                }
              },
              builder: (context, state) {
                return Scaffold(
                  // appBar: AppBar(
                  //   title: Text('new_post'.tr()),
                  // ),
                  body: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SafeArea(
                              child: Row(children: [
                                IconButton(
                                  icon: Icon(Icons.close_rounded),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                Spacer(),
                                Text(
                                  'new_post'.tr(),
                                  style: TextStyle(fontSize: 17),
                                ),
                                Spacer(),
                                StreamBuilder(
                                    stream: HeyPApiService.create()
                                        .getAccounts(
                                            Prefs.getInt('isChannel') != 1
                                                ? Prefs.getID()
                                                : Prefs.getInt('owner_id'))
                                        .asStream(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data == null) {
                                        print("KHSHILPAUSBOO");
                                        return Container();
                                      }
                                      print("KHUSBOO");
                                      List<User> channels =
                                          snapshot.data.body.user ?? [];
                                      print(Prefs.getUsername());
                                      // if (Prefs.getInt('isChannel') != 1) {
                                      //   channels.add(User(
                                      //       id: Prefs.getID(),
                                      //       username: Prefs.getUsername()));
                                      // }

                                      print('Channel_ID');

                                      print(channel_id);

                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        width: 150,
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButtonFormField(
                                            isExpanded: true,
                                            hint: new Text(
                                              "Select Channel",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            iconEnabledColor: Colors.white,
                                            style: new TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                            ),
                                            value: channel_id,
                                            onChanged: (newValue) {
                                              setState(() {
                                                channel_id = newValue;
                                                channels.forEach((element) {
                                                  if (channel_id ==
                                                      element.id) {
                                                    setState(() {
                                                      user = element;
                                                    });
                                                  }
                                                });
                                                // channel_name =
                                                //     newValue.username;
                                                // channel_avatar =
                                                //     newValue.avatar;
                                              });
                                            },
                                            items: channels.map(
                                              (val) {
                                                print(val);
                                                print("HELLO");
                                                return DropdownMenuItem<
                                                    dynamic>(
                                                  value: val.id,
                                                  child: Row(
                                                    children: [
                                                      CustomCircleAvatar(
                                                        radius: 10,
                                                        url: AppUtils
                                                            .getUserAvatar(
                                                                val.id,
                                                                val.avatar),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          val.username,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Prefs
                                                                      .isDark()
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                            // items: cats.map((e) => null)),
                                          ),
                                        ),
                                      );
                                    }),
                                SizedBox(
                                  width: 56,
                                )
//=======
                              ]),
                            ),
                            HeaderWidget(user),
                            TextFormField(
                              controller: desc,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'write_something_here'.tr(),
                                hintStyle: TextStyle(
                                  color: Prefs.isDark()
                                      ? Colors.white.withOpacity(0.5)
                                      : kColorGrey.withOpacity(0.5),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 10,
                                ),
                              ),
                              style: Theme.of(context).textTheme.subtitle1,
                              minLines: 1,
                              maxLines: 5,
                              onChanged: (value) => context
                                  .bloc<PostBloc>()
                                  .add(PostEvent.bodyChanged(value)),
                            ),
                            ImageWidget(),
                            Expanded(
                              child: SizedBox(
                                height: 20,
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       left: 16, right: 180, bottom: 16),
                            //   child: ,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  floatingActionButton: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 52,
                        width: MediaQuery.of(context).size.width - 200,
                        child: PublishButtonWidget(
                          onPressed: () async {
                            print('BUTTON PRESSED');
                            // final result = await getIt<HeyPApiService>()
                            //     .checkPost(channel_id);

                            // print('checkpost');
                            // print(result.body.success);

                            PixaliveVideoPlayer.pauseAll();
                            // if (result.body.success) {
                            Future.delayed(Duration(seconds: 1), () {
                              print('After Delay');
                              if (desc.text.isNotEmpty ||
                                  ImageWidget.state.getImage() != null ||
                                  ImageWidget.state.getVideo() != null) {
                                // print('HERREE');
                                // print('PIYUSH');
                                //
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                context
                                    .bloc<PostBloc>()
                                    .add(PostEvent.addPost());
                                // Navigator.pop(context);
                                Navigator.pop(context);
                              } else {
                                showToast('Post cannot be empty');
                              }
                            });

                            // } else {
                            //   showToast(
                            //       'Kindly Upgrade Your Package To Upload Videos');
                            //   Navigator.pop(context);
                            //   Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (b) => Packages()));
                            // }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      SizedBox(
                        height: 52,
                        width: 150,
                        child: PublishButtonWidget(
                          onPressed: () async {
                            // Navigator.of(context).pop();
                            // //Navigator.of(context).pop();
                            // Navigator.of(context).pushReplacement(
                            //     MaterialPageRoute(builder: (_) => Live()));

                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => GoLiveScreen()));
                          },
                          isLive: true,
                          text: 'Start Live',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ));
      },
    );
  }
}

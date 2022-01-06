import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/post/post_bloc.dart';
import '../../../infrastructure/core/pref_manager.dart';
import '../../../injection.dart';
import '../../components/toast.dart';
import '../../components/waiting_dialog.dart';
import '../../utils/constants.dart';
import 'widgets/header_widget.dart';
import 'widgets/image_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../infrastructure/api/api_service.dart';
import '../../../domain/entities/user.dart';
import '../../mrgreen/pixalive_videoplayer.dart';
import 'widgets/publish_button_widget.dart';

import '../live/live.dart';

import '../../components/custom_button.dart';
import '../../components/custom_circle_avatar.dart';

import '../../utils/app_utils.dart';
import '../../../domain/entities/feed.dart';

class EditPostPage extends StatefulWidget {
  Feed feed;
  EditPostPage(this.feed);
  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  TextEditingController desc = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    desc.text = widget.feed.body ?? '';
    print('Widget category Id');
    print(widget.feed.category_id);
    category_id = widget.feed.category_id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('new_post'.tr()),
      // ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              // minHeight: viewportConstraints.maxHeight,
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
                    SizedBox(
                      width: 56,
                    )
                  ]),
                ),
                HeaderWidget(widget.feed.user),
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
                    onChanged: (value) {}),
                Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.1,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.maxFinite,
                                  color: Color(0xfff75356).withOpacity(0.1),
                                  // child: Image.network(widget.feed.image),
                                  child: widget.feed.image.contains('mp4')
                                      ? PixaliveVideoPlayer(
                                          widget.feed.image, true, 0, false)
                                      : Image.network(widget.feed.image),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                        stream: http
                            .get(
                                'https://wilotv.live:3443/api/get_category')
                            .asStream(),
                        builder: (context, snapshot) {
                          print('snapshotggggg');
                          print('ARNAV');
                          final List cats =
                              jsonDecode(snapshot.data.body)['categories'];
                          if (category_id == 0) {
                            print("category_id");
                            category_id = cats[0]['id'];
                            print(category_id);
                          }

                          cats.removeAt(2);

                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Select a category',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 20),
                                  width: double.maxFinite,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField(
                                      value: category_id == 0
                                          ? cats[0]['id']
                                          : category_id,
                                      onChanged: (newValue) {
                                        setState(() {
                                          category_id = newValue;
                                          print(category_id);
                                        });
                                      },
                                      items: cats.map(
                                        (val) {
                                          return DropdownMenuItem<dynamic>(
                                            value: val['id'],
                                            child: Text(
                                              val['name'],
                                              style: TextStyle(
                                                  color: Prefs.isDark()
                                                      ? Colors.white70
                                                      : Colors.black87),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      isExpanded: true,
                                      hint: new Text(
                                        "Select Category",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      iconEnabledColor: Prefs.isDark()
                                          ? Colors.white
                                          : Colors.black,
                                      style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    SizedBox(
                      height: 80,
                    )
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    height: 20,
                  ),
                ),
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
                final result = await HeyPApiService.create()
                    .editPost(widget.feed.id, desc.text, category_id);
                showToast(result.body.message);
                if (result.body.message == 'Post updated') {
                  Navigator.pop(context);
                }
                print('BUTTON PRESSED');
              },
            ),
          ),
        ],
      ),
    );
  }
}

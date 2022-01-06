import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wilotv/infrastructure/api/api_service.dart';
import 'package:wilotv/presentation/components/custom_button.dart';
import 'package:wilotv/presentation/mrgreen/pixalive_videoplayer.dart';
import 'package:wilotv/presentation/mrgreen/videoplyer.dart';

import '../../domain/entities/feed.dart';
import '../../infrastructure/core/pref_manager.dart';
import '../../presentation/components/confirm_dialog.dart';
import '../pages/live/live_view.dart';
import '../pages/post/editPostPage.dart';
import '../routes/routes.dart';
import '../utils/app_utils.dart';
import '../utils/constants.dart';
import 'custom_circle_avatar.dart';
import 'post_footer_buttons.dart';

class PostListItem extends StatefulWidget {
  final Feed feed;

  final bool scaff;

  final DC;

  PostListItem(
    this.DC, {
    Key key,
    @required this.feed,
    this.index = 1,
    this.scaff = false,
  }) : super(key: key);

  final int index;

  @override
  _PostListItemState createState() => _PostListItemState();
}

class _PostListItemState extends State<PostListItem> {
  var isVideo = false;
  bool follow = false;
  @override
  void initState() {
    // TODO: implement initState
    // print('FOLLOW OR NOT' + widget.feed.user.follow.toString());
    follow = widget.feed.user.follow == 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("THUMBNAIL" + widget.feed.thumbnail.toString());
    print(widget.feed.body);

    if (widget.feed.image == null) {
      return Container();
    }
    isVideo = widget.feed.image.contains('mp4') ||
        widget.feed.image.contains('3gp') ||
        widget.feed.image.contains('MOV') ||
        widget.feed.image.contains('WMV') ||
        widget.feed.image.contains('FLV') ||
        widget.feed.image.contains('AVI');

    // final view = Column(
    //   children: [
    //
    //   ],
    // );

    final view = SafeArea(
      child: Container(
        color: Prefs.isDark() ? Color(0xff121212) : Colors.white,
        // margin: EdgeInsets.symmetric(vertical: widget.scaff ? 30 : 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _header(context),
              desc(),
              if (widget.feed.image.isNotEmpty)
                ClipRect(
                  child: Container(
                      color: kColorGrey,
                      child: !isVideo
                          ? (widget.feed.is_live == 1)
                              ? Container(
                                  width: double.infinity,
                                  child: LiveView(widget.feed, true,
                                      widget.index, widget.scaff),
                                )
                              : GestureDetector(
                                  onTap: isVideo
                                      ? null
                                      : () => Navigator.pushNamed(
                                            context,
                                            Routes.preview,
                                            arguments: AppUtils.getPostImage(
                                                widget.feed.id,
                                                widget.feed.image),
                                          ),
                                  child: CachedNetworkImage(
                                    imageUrl: AppUtils.getPostImage(
                                        widget.feed.id, widget.feed.image),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )
                          :
                          // Container(
                          //     width: double.infinity,
                          //     child: PixaliveVideoPlayer(widget.feed.image, true,
                          //         widget.index, widget.scaff)),
                          Container(
                              child: CustomVideoPlayer(
                                widget.feed.image,
                                autoply: false,
                              ),
                            )),
                ),
              PostFooterButton(feed: widget.feed),
            ],
          ),
        ),
      ),
    );

    if (widget.scaff) return view;

    // return InViewNotifierWidget(
    //   id: widget.feed.id.toString(),
    //   builder: (BuildContext context, bool isInView, Widget child) {
    //
    //   },
    // );

    return Container(
      color: Prefs.isDark() ? Color(0xff121212) : Colors.white,
      margin: EdgeInsets.symmetric(vertical: widget.scaff ? 24 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 19),
            child: _header(context),
          ),
          desc(),
          if (widget.feed.image.isNotEmpty)
            Container(
              color: kColorGrey,
              width: double.infinity,
              //height: 300,
              child: !isVideo
                  ? widget.feed.is_live == 1
                      ? LiveView(widget.feed, true, widget.index, false)
                      // ? ClipRRect(
                      //     child: Container(
                      //       height: 300,
                      //         width: double.infinity,
                      //         child: PixaliveVideoPlayer(widget.feed.image,
                      //             true, widget.index, widget.scaff)),
                      //   )
                      : GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.preview,
                            arguments: AppUtils.getPostImage(
                                widget.feed.id, widget.feed.image),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: AppUtils.getPostImage(
                                widget.feed.id, widget.feed.image),
                            width: double.infinity,
                            // height: widget.scaff
                            //     ? (MediaQuery.of(context).size.height - 210)
                            //     : null,
                            fit: BoxFit.cover,
                          ),
                        )
                  : ClipRRect(
                      child:
                          // Container(
                          //     width: double.infinity,
                          //     child: PixaliveVideoPlayer(widget.feed.image, true,
                          //         widget.index, widget.scaff)),
                          Container(
                      child: CustomVideoPlayer(
                        widget.feed.image,
                        autoply: false,
                      ),
                    )),
            ),

          PostFooterButton(feed: widget.feed),
          //Divider()
          Container(
            height: 6,
            color: (Prefs.isDark() ? Colors.white : Colors.black)
                .withOpacity(0.05),
          )
        ],
      ),
    );
  }

  int lines = 2;
  desc() {
    return widget.feed.body.isNotEmpty
        ? AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
            child: ExpandableText(widget.feed.body,
                expandText: '  more',
                collapseText: '  less',
                maxLines: 2,
                linkColor: Prefs.isDark() ? Colors.white : Colors.black,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(height: 1.25, fontSize: 15)),
          )
        : SizedBox(
            height: 0,
          );
  }

  Widget _header(BuildContext context) {
    if (widget.feed.user == null) return Container();

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Row(
        children: <Widget>[
          if (widget.scaff)
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: (Prefs.isDark() ? Colors.white : Colors.black)
                    .withOpacity(0.8),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          CustomCircleAvatar(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.profile,
                arguments: widget.feed.user,
              );
              PixaliveVideoPlayer.pauseAll();
            },
            radius: 20,
            url: AppUtils.getUserAvatar(
                widget.feed.user.id, widget.feed.user.avatar),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 2,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.profile,
                      arguments: widget.feed.user,
                    );
                    PixaliveVideoPlayer.pauseAll();
                  },
                  child: Text(
                    capitalize(widget.feed.user.username),
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            Prefs.isDark() ? Colors.white : Color(0xff0d0e0e)),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    // SvgPicture.asset('assets/images/clock.svg', height: 10,  color: Color(0xff939393)),
                    // SizedBox(width: 2,),
                    Text(
                      '${AppUtils.timeAgo(widget.feed.date, numericDates: true)}',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 10, color: Color(0xff939393)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // CupertinoContextMenu(
          //   child: Icon(Icons.more_vert),
          //   actions: <Widget>[
          //     CupertinoContextMenuAction(
          //       child: const Text('Action one'),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       },
          //     ),
          //     CupertinoContextMenuAction(
          //       child: const Text('Action two'),
          //       onPressed: () {
          //         Navigator.pop(context);
          //       },
          //     ),
          //   ],
          //
          // ),
          //if (!follow && widget.feed.user.id != Prefs.getUser().id)
          if (widget.feed.user.id != Prefs.getUser().id)
            CustomButton(
                title: follow ? 'Following' : 'Follow',
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 13),
                onPressed: () {
                  showConfirmDialog(
                    context: context,
                    message: !follow
                        ? 'Are you sure you want to follow this user ?'
                        : 'Are you sure you want to Unfollow this user ?',
                    action1: 'no'.tr(),
                    action2: 'yes'.tr(),
                    onPressed: () async {
                      // final res = await HeyPApiService.create()
                      //     .deletePost(widget.feed.id);
                      // print(res.body.message);
                      // widget.DC();
                      HeyPApiService.create().followUser(widget.feed.user.id);
                      setState(() {
                        follow = !follow;
                        //user.follow = user.follow == 0 ? 1 : 0;
                      });
                      Navigator.pop(context);
                    },
                  );
                  // HeyPApiService.create().followUser(widget.feed.user.id);
                  // setState(() {
                  //   follow = !follow;
                  //   // user.follow = user.follow == 0 ? 1 : 0;
                  // });
                }),
          SizedBox(
            width: 50,
            height: 50,
            child: PopupMenuButton<String>(
              onSelected: (d) async {
                switch (d) {
                  case 'report':
                    showConfirmDialog(
                      context: context,
                      message: 'Are you sure you want to report this post ?',
                      action1: 'no'.tr(),
                      action2: 'yes'.tr(),
                      onPressed: () async {
                        // final res = await HeyPApiService.create()
                        //     .deletePost(widget.feed.id);
                        // print(res.body.message);
                        // widget.DC();
                        Navigator.pop(context);
                      },
                    );
                    break;
                  case 'delete':
                    showConfirmDialog(
                      context: context,
                      message: 'Are you sure you want to delete?',
                      action1: 'no'.tr(),
                      action2: 'yes'.tr(),
                      onPressed: () async {
                        final res = await HeyPApiService.create()
                            .deletePost(widget.feed.id);
                        print(res.body.message);
                        widget.DC();
                        Navigator.pop(context);
                      },
                    );
                    // final res = await HeyPApiService.create().deletePost(widget.feed.id);
                    // print(res.body.message);
                    // widget.DC();
                    break;
                  case 'edit':
                    showConfirmDialog(
                      context: context,
                      message: 'Are you sure you want to edit this post?',
                      action1: 'no'.tr(),
                      action2: 'yes'.tr(),
                      onPressed: () async {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (b) => EditPostPage(widget.feed)));
                      },
                    );

                    break;
                }
              },
              child: Icon(Icons.more_vert,
                  color: (Prefs.isDark() ? Colors.white : Color(0xffa5a5a5))
                      .withOpacity(0.8)),
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'report',
                  child: Text('Report'),
                ),
                Prefs.getUser().id == widget.feed.user.id
                    ? const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      )
                    : null,
                Prefs.getUser().id == widget.feed.user.id &&
                        widget.feed.is_live != 1
                    ? const PopupMenuItem<String>(
                        value: 'edit',
                        child: Text('Edit Post'),
                      )
                    : null,
              ],
            ),
          )
        ],
      ),
    );
  }
}

String capitalize(d) {
  return "${d[0].toUpperCase()}${d.substring(1)}";
}

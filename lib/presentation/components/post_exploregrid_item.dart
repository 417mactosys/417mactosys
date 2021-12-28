import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:wilotv/presentation/components/post_gridFooter.dart';

import '../../domain/entities/feed.dart';
import '../../infrastructure/core/pref_manager.dart';
import '../routes/routes.dart';
import '../utils/app_utils.dart';
import '../utils/constants.dart';
import 'custom_circle_avatar.dart';

import 'dart:ui' as ui;
import 'post_footer_buttons.dart';

import '../mrgreen/post_preview.dart';

import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PostExploreGridItem extends StatefulWidget {
  final Feed feed;
  final bool big;

  const PostExploreGridItem({Key key, @required this.feed, this.big})
      : super(key: key);

  @override
  _PostExploreGridItemState createState() => _PostExploreGridItemState();
}

class _PostExploreGridItemState extends State<PostExploreGridItem> {
  bool isVideo = false;
  CachedVideoPlayerController _videoPlayerController;

  @override
  void initState() {
    // if (widget.big) {
    //   _videoPlayerController =
    //       CachedVideoPlayerController.network(widget.feed.image);
    //   _videoPlayerController.initialize().then((value) {
    //     _videoPlayerController.play();
    //     _videoPlayerController.setVolume(0.0);
    //     _videoPlayerController.setLooping(true);
    //     setState(() {});
    //   });
    // }

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isVideo = widget.feed.image.contains('mp4') ||
        widget.feed.image.contains('3gp') ||
        widget.feed.image.contains('MOV') ||
        widget.feed.image.contains('WMV') ||
        widget.feed.image.contains('FLV') ||
        widget.feed.image.contains('AVI');
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        //margin: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: Prefs.isDark() ? Color(0xff121212) : Colors.white,
          //borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 1.0,
            ),
          ],
        ),
        child: widget.feed.image.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (c) => PostViewer(() {}, widget.feed)));
                },
                child: Container(
                  color: kColorGrey,
                  child: !isVideo
                      ? widget.feed.is_live == 1
                          ? Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(widget.feed.thumbnail),
                                      fit: BoxFit.cover)),
                              child: Icon(
                                Icons.live_tv_rounded,
                                color: Colors.white,
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: AppUtils.getPostImage(
                                  widget.feed.id, widget.feed.image),
                              width: double.infinity,
                              //height: double.infinity,
                              fit: BoxFit.cover,
                            )
                      : Container(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(widget.feed.thumbnail),
                                  fit: BoxFit.cover)),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                          ),
                        ),
                ),
              )
            : Container(),
      ),
    );
  }

  Future<String> getThumbnail() async {
    final fileName = '';
    // final fileName = await VideoThumbnail.thumbnailFile(
    //     video: 'http://ec2-3-6-250-92.ap-south-1.compute.amazonaws.com:3000/download/${widget.feed.sid}',
    //     thumbnailPath: (await getTemporaryDirectory()).path,
    //     imageFormat: ImageFormat.WEBP,
    //     maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    //     quality: 75,
    //     timeMs: 5000
    // );
    return widget.feed.thumbnail;
  }

  Padding _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 15),
      child: Row(
        children: <Widget>[
          CustomCircleAvatar(
            onTap: () => Navigator.pushNamed(
              context,
              Routes.profile,
              arguments: widget.feed.user,
            ),
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
                Text(
                  widget.feed.user.username,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '${AppUtils.timeAgo(widget.feed.date, numericDates: true)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

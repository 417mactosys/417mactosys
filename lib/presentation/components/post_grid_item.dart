import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wilotv/presentation/components/post_gridFooter.dart';
import 'package:wilotv/presentation/mrgreen/post_preview.dart';

import '../../domain/entities/feed.dart';
import '../../infrastructure/core/pref_manager.dart';
import '../routes/routes.dart';
import '../utils/app_utils.dart';
import '../utils/constants.dart';
import 'custom_circle_avatar.dart';
import 'post_footer_buttons.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PostGridItem extends StatelessWidget {
  final Feed feed;

  const PostGridItem({
    Key key,
    @required this.feed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool dark = Prefs.isDark();
    return Container(
      margin: EdgeInsets.all(1),
      // decoration: BoxDecoration(
      //     color: Prefs.isDark() ? Color(0xff121212) : Colors.white,
      //     borderRadius: BorderRadius.circular(10)),
      child: Stack(
        //crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
//          Padding(
//            padding: EdgeInsets.symmetric(horizontal: 19),
//            child: _header(context),
//          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (c) => PostViewer(() {}, this.feed)));
            },
            child: Container(
              color: kColorGrey,
              child: feed.is_live == 1 ?
                  FutureBuilder(
                    future: getThumbnail(),
                    initialData: feed.thumbnail,
                    builder: (BuildContext c, AsyncSnapshot<String> s){
                      return Image.network(
                        s.data,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: double.maxFinite,
                        //height: 100,
                      );
                    },
                  )
                  :(feed.image != null && feed.image.isNotEmpty)
                  ? CachedNetworkImage(
                imageUrl: feed.image.contains('mp4')
                    ? feed.thumbnail
                    : AppUtils.getPostImage(feed.id, feed.image),
                width: double.infinity,
                height: double.maxFinite,
                fit: BoxFit.cover,
                //height: 100,
              )
                  : Container(
                color: dark ? Colors.black38 : Colors.white,
                alignment: Alignment.center,
                child: Text(
                  feed.body,
                  style: TextStyle(color: dark ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),

          if(feed.is_live == 1) Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.live_tv_rounded, color: Colors.white,),
            ),
          ),

          if(feed.image.contains('.mp4')) Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.play_arrow_rounded, color: Colors.white,),
            ),
          )
        ],
      ),
    );
  }

  //String tp = '';

  Future<String> getThumbnail() async {
    final fileName = '';
    // final fileName = await VideoThumbnail.thumbnailFile(
    //   video: 'http://ec2-3-6-250-92.ap-south-1.compute.amazonaws.com:3000/download/${feed.sid}',
    //   thumbnailPath: (await getTemporaryDirectory()).path,
    //   imageFormat: ImageFormat.WEBP,
    //   maxHeight: 64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    //   quality: 75,
    //   timeMs: 5000
    // );
    return feed.thumbnail;
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
              arguments: feed.user,
            ),
            radius: 20,
            url: AppUtils.getUserAvatar(feed.user.id, feed.user.avatar),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  feed.user.username,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '${AppUtils.timeAgo(feed.date, numericDates: true)}',
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

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:wilotv/domain/entities/feed.dart';
import 'package:wilotv/presentation/components/confirm_dialog.dart';
import 'package:wilotv/presentation/components/custom_button.dart';
import 'package:wilotv/presentation/components/custom_circle_avatar.dart';
import 'package:wilotv/presentation/pages/agora/join_live_page.dart';
import 'package:wilotv/presentation/routes/routes.dart';
import 'package:wilotv/presentation/utils/app_utils.dart';
import '../../../components/post_list_item.dart';
import 'package:http/http.dart' as http;
import '../../../../infrastructure/api/api_service.dart';
import 'dart:convert';
import '../../../../infrastructure/core/pref_manager.dart';

class CategoryPage extends StatefulWidget {
  var category;
  bool isFromLive;
  CategoryPage(this.category, this.isFromLive);
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        // leading:
        titleSpacing: -10,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Image(
                image: NetworkImage(widget.category['image'] ?? ''),
                width: 35,
                height: 35,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.category['name'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
          stream: HeyPApiService.create()
              .getcategoryfeeds(widget.category['id'], Prefs.getID())
              .asStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            log(snapshot.data.toString());
            log(snapshot.data.body.feeds.toString());
            if (snapshot.data == null || snapshot.data.body.feeds == null) {
              return Center(
                child: Text('No Posts'),
              );
            }
            final List<dynamic> feeds = List();
            feeds.addAll(snapshot.data.body.feeds);
            return InViewNotifierList(
              // controller: _scrollController,
              // physics: BouncingScrollPhysics(),
              // shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),

              // shrinkWrap: true,
//      separatorBuilder: (context, index) => SizedBox(
//        height: 10,
//      ),
              isInViewPortCondition: (double deltaTop, double deltaBottom,
                  double viewPortDimension) {
                return deltaTop < (0.55 * viewPortDimension) &&
                    deltaBottom > (0.55 * viewPortDimension);
              },
              itemCount: feeds.length,
              builder: (context, index) {
                return widget.isFromLive
                    ? feeds[index].live_ended == 0
                        ? _header(context, feeds[index])
                        : null
                    : PostListItem(() {
                        setState(() {
                          feeds.remove(feeds[index]);
                        });
                      }, feed: feeds[index], index: index, scaff: false);
              },
            );
          }),
    );
  }

  Widget _header(BuildContext context, Feed feed) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Row(
        children: <Widget>[
          SizedBox(width: 10),
          CustomCircleAvatar(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.profile,
                arguments: feed.user,
              );
            },
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
                SizedBox(
                  height: 2,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.profile,
                      arguments: feed.user,
                    );
                  },
                  child: Text(
                    capitalize(feed.user.username),
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
                      '${AppUtils.timeAgo(feed.date, numericDates: true)}',
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
          CustomButton(
              title: 'Join Live',
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 13),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => JoinLive(
                        channelName: feed.channel_name,
                        channelId: feed.user.id,
                        username: feed.user.username,
                        hostImage: AppUtils.getUserAvatar(
                            feed.user.id, feed.user.avatar),
                        userImage: AppUtils.getAvatar())));
              }),
          SizedBox(width: 10)
        ],
      ),
    );
  }
}

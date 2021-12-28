import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../mrgreen/followers_following_page.dart';
import '../../../../domain/entities/user.dart';

class StatsWidget extends StatelessWidget {
  final int followers;
  final int following;
  final int posts;
  final User user;

  const StatsWidget(this.user, {
    Key key,
    @required this.followers,
    @required this.following,
    @required this.posts,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _infoWidget(context, 'posts'.tr(), posts, null),
          _infoWidget(context, 'followers'.tr(), followers, 'followers'),
          _infoWidget(context, 'following'.tr(), following, 'followings'),
        ],
      ),
    );
  }

  _infoWidget(BuildContext context, String title, int count, String type) {
    return InkWell(
      onTap: type != null ? (){
        Navigator.of(context).push(MaterialPageRoute(builder: (c) => FollowersFollowingPage(user, type)));
      } : null,
      child: Column(
        children: [
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}

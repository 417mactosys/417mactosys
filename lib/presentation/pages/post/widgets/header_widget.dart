import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../infrastructure/core/pref_manager.dart';
import '../../../utils/app_utils.dart';
import 'image_widget.dart';
import '../../../components/custom_circle_avatar.dart';
import '../../../../domain/entities/user.dart';

class HeaderWidget extends StatefulWidget {
  User user;
  HeaderWidget(this.user);

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(19, 18, 0, 18),
  //     child: Row(
  //       children: <Widget>[
  //         ClipOval(
  //           child: CachedNetworkImage(
  //             imageUrl: AppUtils.getAvatar(),
  //             width: 44,
  //             height: 44,
  //             fit: BoxFit.cover,
  //             errorWidget: (context, url, error) {
  //               return Image.asset(
  //                 'assets/images/empty_avatar.png',
  //                 width: 44,
  //                 height: 44,
  //               );
  //             },
  //           ),
  //         ),
  //         SizedBox(
  //           width: 10,
  //         ),
  //         channel_id == Prefs.getID()
  //             ? Expanded(
  //                 child: Text(
  //                   Prefs.getUsername(),
  //                   style: Theme.of(context)
  //                       .textTheme
  //                       .subtitle1
  //                       .copyWith(fontWeight: FontWeight.w500),
  //                 ),
  //               )
  //             : Expanded(
  //                 child: Text(
  //                   Prefs.getUsername(),
  //                   style: Theme.of(context)
  //                       .textTheme
  //                       .subtitle1
  //                       .copyWith(fontWeight: FontWeight.w500),
  //                 ),
  //               ),
  //       ],
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    print('THe headeer user');
    print(widget.user);
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 18, 0, 18),
      child: Row(
        children: <Widget>[
          // ClipOval(
          //   child: CachedNetworkImage(
          //     imageUrl:
          //         AppUtils.getUserAvatar(widget.user.id, widget.user.avatar),
          //     width: 44,
          //     height: 44,
          //     fit: BoxFit.cover,
          //     errorWidget: (context, url, error) {
          //       print('Image url error' + error.toString());
          //       return Image.asset(
          //         'assets/images/empty_avatar.png',
          //         width: 44,
          //         height: 44,
          //       );
          //     },
          //   ),
          // ),
          CustomCircleAvatar(
            radius: 22,
            url: AppUtils.getUserAvatar(widget.user.id, widget.user.avatar),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              widget.user.username ?? Prefs.getUsername(),
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }
}

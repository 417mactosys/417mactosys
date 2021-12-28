import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wilotv/infrastructure/api/api_service.dart';
import 'package:wilotv/injection.dart';
import 'package:wilotv/presentation/pages/home/home.dart';
import 'package:wilotv/presentation/utils/app_utils.dart';
import '../../../domain/entities/user.dart';
import 'package:wilotv/presentation/routes/routes.dart';
import 'createChannel.dart';

class ChannelItem extends StatefulWidget {
  User channel;
  ChannelItem(this.channel);
  @override
  _ChannelItemState createState() => _ChannelItemState();
}

class _ChannelItemState extends State<ChannelItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        try {
          User user =
              User(id: widget.channel.id, username: widget.channel.username);
          print('USER' + user.id.toString());
          // User user = User.fromJson(widget.user);
          // push(context, ConvoPage(doc, widget.user));
          Navigator.pushNamed(
            context,
            Routes.profile,
            arguments: user,
          );
        } catch (e) {
          print('EXECPTION' + e.toString());
        }
      },
      child: Container(
        // color: Colors.black,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.grey[300])),
        height: 70,
        // padding: EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        child: Row(
          children: [
            // Container(
            //   color: Colors.red,
            //   width: 100,
            //   height: 100,
            //   child: Image.network(
            //     widget.channel.avatar ?? '',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            SizedBox(
              width: 10,
            ),
            CachedNetworkImage(
              imageUrl:  AppUtils.getUserAvatar(widget.channel.id, widget.channel.avatar) ?? '',
              errorWidget: (context, url, error) {
                return Image.asset(
                  'assets/images/empty_avatar.png',
                  width: 48,
                  height: 48,
                );
              },
              imageBuilder: (context, imageProvider) =>
                  Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
            // SizedBox(
            //   width: 20,
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.channel.username,
                      style: TextStyle(
                          // color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Container(
                      width: 200,
                      child: Text(
                        widget.channel.description,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            // color: Colors.white,
                            // fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
            ),
           
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (b) => CreateChannel(widget.channel)));
              },
              child: Icon(
                Icons.edit,
                size: 20,
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {

                showDialog(
                    context: context,
                    builder: (c) {
                      return AlertDialog(
                        title: Text('Are sure you want delete channel?'),
                        actions: [
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(c).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () async {

                              await getIt<HeyPApiService>().deleteChannel(widget.channel.id);

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => Home()));
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Icon(
                Icons.delete,
                size: 20,
              ),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}

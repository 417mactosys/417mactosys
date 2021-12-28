import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../infrastructure/core/pref_manager.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double radius;
  final String url;
  final String errorImagePath;
  final Function onTap;

  final bool isSquare;

  const CustomCircleAvatar({
    Key key,
    @required this.radius,
    @required this.url,
    this.errorImagePath,
    this.onTap, this.isSquare = false
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(isSquare){
      return GestureDetector(
        onTap: onTap ?? () {},
        child: Container(
          height: radius * 2,
          width: radius * 2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius * 0.3),
            border: Border.all(color: Colors.grey, width: 1)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius * 0.29),
            child: CachedNetworkImage(
              imageUrl: url,
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) {
                return Image.asset(
                  errorImagePath ?? 'assets/images/empty_avatar.png',
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                );
              },
            ),
          )
        ),
      );
    }

    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 1)
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: url,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) {
              return Image.asset(
                errorImagePath ?? 'assets/images/empty_avatar.png',
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
    );
  }
}

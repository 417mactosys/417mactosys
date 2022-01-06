import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wilotv/infrastructure/core/pref_manager.dart';

import '../utils/constants.dart';

class EmptyListWidget extends StatelessWidget {
  final String icon;
  final String message;
  final String title;

  const EmptyListWidget({
    Key key,
    @required this.icon,
    @required this.message,
    this.title
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    spreadRadius: 10,
                    blurRadius: 20,
                    offset: Offset(-20, 10)
                )
              ],
              shape: BoxShape.circle
          ),
          child: Image.asset(
            'assets/images/$icon.png',
            width: 153,
            height: 153,
          ),
        ),

        SizedBox(
          height: 22,
        ),
        Text(
          title,
          style: TextStyle(
            //color: Prefs.isDark() ? Colors.white.withOpacity(0.87) : kColorGrey,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 22,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Opacity(
            opacity: 0.5,
            child: Text(
              message,
              style: TextStyle(
                //color: Prefs.isDark() ? Colors.white.withOpacity(0.4) : kColorGrey.withOpacity(0.4),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

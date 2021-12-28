import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wilotv/infrastructure/core/pref_manager.dart';

import '../utils/constants.dart';

class NoPostsWidget extends StatelessWidget {
  final String message;
  final String title;
  final Function onPressed;

  const NoPostsWidget({
    Key key,
    this.message,
    @required this.onPressed,
    this.title
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Prefs.isDark() ? Colors.black : Colors.white,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
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
                'assets/images/no_result.png',
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
            Opacity(
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
            SizedBox(
              height: 22,
            ),
            IconButton(
              onPressed: onPressed,
              icon: Icon(
                Icons.refresh_rounded,
                size: 32,
                color: kColorGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

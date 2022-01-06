import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class PublishButtonWidget extends StatelessWidget {
  final Function onPressed;
  final bool isLive;
  final String text;

  const PublishButtonWidget(
      {Key key, @required this.onPressed, this.isLive = false, this.text = ''})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      //padding: EdgeInsets.only(bottom: 12),
      child: RawMaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        padding: EdgeInsets.all(0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isLive ? kColorPink : kColorPrimary,
                isLive ? kColorPrimary : kColorPink,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Container(
            height: 52,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 14, bottom: 12, left: 19, right: 0),
                    child: Text(
                      isLive ? text : 'publish'.tr(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                  height: 52,
                  width: 56,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: 4, right: 4),
                        child: RotationTransition(
                          turns: isLive
                              ? AlwaysStoppedAnimation(0)
                              : AlwaysStoppedAnimation(-45 / 360),
                          child: Icon(
                            isLive ? Icons.live_tv_rounded : Icons.send_rounded,
                            color: Colors.white,
                            size: 27,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

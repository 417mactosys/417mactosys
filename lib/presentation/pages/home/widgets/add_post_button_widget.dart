import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

import '../../../../infrastructure/core/pref_manager.dart';

class AddPostButtonWidget extends StatelessWidget {
  final Function onPressed;

  const AddPostButtonWidget({
    Key key,
    @required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      width: 54,
      decoration: BoxDecoration(
        border: Border.all(color: Prefs.isDark() ? Color(0xFF0E0E0E) : Colors.white, width: 2.5),
        shape: BoxShape.circle
      ),
      child: RawMaterialButton(
        onPressed: onPressed,
        shape: CircleBorder(),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kColorPrimary,
                kColorPink,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Image.asset('assets/images/center-icon-logo.png', height: 32, width: 32,),
          ),
        ),
      ),
    );
  }
}

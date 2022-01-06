import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color titleColor;
  final Function onPressed;
  final EdgeInsets padding;

  const CustomButton({
    Key key,
    @required this.title,
    this.color,
    this.titleColor,
    @required this.onPressed,
    this.padding,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final rad = BorderRadius.circular(32);
    return Container(
      decoration: BoxDecoration(
        borderRadius: rad,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: Offset(0, 2))
        ],
      ),
      child: Material(

        shape: RoundedRectangleBorder(
          borderRadius: rad,
        ),
        //
        // padding: EdgeInsets.all(0),
        child: Ink(

          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                color ?? kColorPrimary,
                color ?? kColorPink,
              ],
              center: Alignment.topLeft,
              radius: 2.5,
              //begin: Alignment.topLeft,
              //end: Alignment.bottomRight,
            ),
            borderRadius: rad,

          ),
          child: InkWell(
            borderRadius: rad,
            onTap: onPressed,
            child: Container(
              padding:
                  padding ?? EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              alignment: Alignment.center,
              //width: double.maxFinite,
              //height: double.maxFinite,
              decoration: BoxDecoration(
                  // boxShadow: [
                  //   BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 3, blurRadius: 3, offset: Offset(0, 3))
                  // ],
                borderRadius: BorderRadius.circular(32),
              ),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: titleColor ?? Colors.white,
                    fontWeight: FontWeight.w600, fontSize: 14
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

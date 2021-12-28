import 'package:flutter/material.dart';
import '../../domain/entities/packages.dart';
import 'package:pay/pay.dart';


class PackageItem extends StatefulWidget {
  Package package;
  Color color;
  PackageItem(this.package, this.color);
  @override
  _PackageItemState createState() => _PackageItemState();
}

class _PackageItemState extends State<PackageItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
          
      },
          child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),

            decoration: BoxDecoration(
                color: widget.color, borderRadius: BorderRadius.circular(20)),

            // height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.package.name.toUpperCase(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$ ' + widget.package.price.toString(),
                      style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'per year',
                    ),
                  ],
                ),
                Text(
                  'Upload ' +
                      widget.package.video_count.toString() +
                      ' pre recorded videos',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 12),
            alignment: Alignment.center,
            width: 50,
            height: 50,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: Icon(
              Icons.near_me,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}

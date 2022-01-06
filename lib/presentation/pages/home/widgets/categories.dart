import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wilotv/presentation/pages/home/widgets/category_page.dart';
import 'package:wilotv/presentation/utils/constants.dart';
import '../home_page.dart';

class Categories extends StatefulWidget {
  final List<Live> arrLives;
  Categories(this.arrLives);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> with TickerProviderStateMixin {
  AnimationController _resizableController;

  @override
  void initState() {
    // TODO: implement initState

    _resizableController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 1000,
      ),
    );
    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();

    super.initState();
  }

  AnimatedBuilder getContainer() {
    return new AnimatedBuilder(
        animation: _resizableController,
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.only(left: 10),
            child: Container(
              height: 80,
              width: 80,
              padding: EdgeInsets.all(10),
              child: Center(
                child: Text(
                  //widget.arrLives.length == 1 ? '1 \n LIVE' : '1+ \n LIVE',
                  'Watch Live',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Colors.indigo, kColorPrimary],
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(40)),
                border: Border.all(
                    color: kColorPrimary,
                    width: _resizableController.value * 8),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 120,
      child: StreamBuilder(
          stream:
              http.get('https://wilotv.live:3443/api/get_category').asStream(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Container();
            }
            final List res = jsonDecode(snapshot.data.body)['categories'];
            return ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: List.generate(res.length, (index) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (b) => CategoryPage(
                                res[index], index == 0 ? true : false)));
                  },
                  child: catView(res, index),
                );
              }).toList(),
            );
          }),
    );
  }


  Widget catView(List res, int index) {
    return index == 0
        ? widget.arrLives.length != 0
            ? Column(
                children: [getContainer()],
              )
            : Container()
        : Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    width: 3,
                    color: Colors.red,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(
                    2,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: CachedNetworkImage(
                      imageUrl: res[index]['image'] ?? '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                res[index]['name'],
                // snapshot.data[index]['category_name'],
                //style: TextStyle(color: Colors.black),
              ),
            ],
          );
  }
}

import 'package:flutter/material.dart';
import '../../infrastructure/api/api_service.dart';

import 'packageItem.dart';
import 'package:pay/pay.dart';

class Packages extends StatefulWidget {
  @override
  _PackagesState createState() => _PackagesState();
}

class _PackagesState extends State<Packages> {
  List<Color> colors = [Colors.orange, Colors.blueAccent];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: false,
        title: Text('Packages'),
      ),
      // floatingActionButton: 
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future.value(true);
        },
        child: StreamBuilder(
            stream: HeyPApiService.create().getPackages().asStream(),
            builder: (context, snapshot) {
              if (snapshot.data == null ||
                  snapshot.data.body.packages.length == 0) {
                return Center(
                  child: Text('No Packages'),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.body.packages.length,
                  itemBuilder: (b, i) {
                    return PackageItem(
                        snapshot.data.body.packages[i], colors[i]);
                  });
            }),
      ),
    );
  }
}

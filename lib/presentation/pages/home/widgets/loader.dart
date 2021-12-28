import 'package:flutter/material.dart';

ValueNotifier<Map<String, dynamic>> UPLOADS = ValueNotifier({});

class UploadProgress extends StatefulWidget {
  @override
  _UploadProgressState createState() => _UploadProgressState();
}

class _UploadProgressState extends State<UploadProgress> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: UPLOADS,
        builder: (BuildContext context, Map<String, dynamic> data, _) {
          final keys = data.keys.toList();

          return Column(
            children: List.generate(keys.length, (i) {
              final id = keys[i];
              final v = data[id];
              return Container(
                height: 40,
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xFF282828),
                  // boxShadow: [
                  //   BoxShadow(blurRadius: 4, spreadRadius: 4, color: Colors.black12)
                  // ]
                ),
                child: Row(
                  children: [
                    Text(
                      'Upload post...',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: SizedBox(
                      height: 2.5,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white,
                        value: v,
                        valueColor: AlwaysStoppedAnimation(Colors.deepOrange),
                      ),
                    ))
                  ],
                ),
              );
            }),
          );
        });
  }
}

import 'dart:io';

//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';

import '../../../mrgreen/pixalive_videoplayer.dart';

import 'package:video_compress/video_compress.dart';

import '../../../../application/post/post_bloc.dart';
import '../../../components/image_chooser_dialog.dart';
import '../../../utils/constants.dart';

import 'package:permission_handler/permission_handler.dart';
import '../../../../infrastructure/core/pref_manager.dart';

class ImageWidget extends StatefulWidget {
  static _ImageWidgetState state = _ImageWidgetState();
  @override
  _ImageWidgetState createState() {
    state = _ImageWidgetState();
    return state;
  }
}

var category_id = 0;
var channel_id = Prefs.getID();
var channel_name = '';
var channel_avatar = '';

class _ImageWidgetState extends State<ImageWidget> {
  File _image;
  File _video;
  final picker = ImagePicker();
  //final videopicker = FilePicker();
  //VideoPlayerController _videoPlayerController;

  setVideoOff() {
    setState(() {
      //_videoPlayerController.dispose();
    });
  }

  getImage() {
    return _image;
  }

  getVideo() {
    return _video;
  }

  Future _getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    _image = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],

      //aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: Colors.pink,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      // iosUiSettings: IOSUiSettings(
      //   minimumAspectRatio: 1.0,
      // ),
    );

    context.bloc<PostBloc>().add(
        PostEvent.imageChanged(_image != null ? _image.path : pickedFile.path));
    setState(() {});
  }

  // Future _getImageorVideo() async {

//    FilePickerResult result = await FilePicker.platform.pickFiles(
//      type: FileType.custom,
//      allowedExtensions: ['jpg', 'png', 'mp4'],
//    );
//
//    var file= File(result.files.single.path);
//
//    file.path.contains('mp4') ? _video=file : _image=file;
//
//
//    context.bloc<PostBloc>().add(PostEvent.imageChanged(result.files.first.path));
//    setState(() {});
  //}
  var handyCam = false;
  //final _flutterVideoCompress = VideoCompress();
  var loading = false;
  Future _getVideo(source) async {
    // var pickedFiles = await FilePicker.platform.pickFiles(type: FileType.video);
    //
    // _video = File(pickedFiles.files.first.path);

    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }

    var pickedFile = await picker.getVideo(source: source);
    _video = File(pickedFile.path);
    print(pickedFile.path);

    if (_video != null) {
      if (source == ImageSource.gallery) {
        final filePath = pickedFile.path;

        if (!filePath.contains('mp4')) {
          var file = File(filePath.replaceAll('jpg', 'mp4'));
          file.createSync();
          _video = await _video.copy(file.path);
          print(file.path);
        }
      }

      setState(() {
        loading = true;
      });

      // final info = await VideoCompress.compressVideo(
      //   _video.path,
      //   quality:
      //   VideoQuality.LowQuality, // default(VideoQuality.DefaultQuality)
      //   deleteOrigin: false, // default(false)
      // );

      setState(() {
        loading = false;
      });

      // _videoPlayerController = VideoPlayerController.file(File(_video.path))
      //   ..initialize().then((_) {
      //     setState(() {});
      //     _videoPlayerController.play();
      //   });
      context.bloc<PostBloc>().add(PostEvent.imageChanged(_video.path));
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //_videoPlayerController.pause();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    category_id = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.maxFinite,
                      color: Color(0xfff75356).withOpacity(0.1),
                      child: _image != null
                          ? _imageWidget()
                          : _video != null
                              ? _videoWidget()
                              : _uploadImageWidget(),
                    ),
                  ),
                ],
              ),
              if (loading)
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black26,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(Colors.deepOrangeAccent),
                    ),
                  ),
                )
            ],
          ),
        ),
        StreamBuilder(
            stream: http
                .get(
                    'https://wilotv.live:3443/api/get_category')
                .asStream(),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Container();
              }
              print('snapshotaaaaaaa');
              final List cats = jsonDecode(snapshot.data.body)['categories'];

              category_id = category_id;
              print(category_id);
               cats.removeAt(0);

              // var catgeory;
              // if (_con.category != null) {
              //   list.forEach((element) {
              //     if (catgeory ==
              //         element['category_name']) {
              //       _con.category =
              //           element['category_id'];
              //     }
              //   });
              //   print(_con.category);
              // }

              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        'Select a category',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                      width: double.maxFinite,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          value: category_id == 0 ? cats[0]['id'] : category_id,
                          onChanged: (newValue) {
                            setState(() {
                              print("herererre");

                              category_id = newValue;
                              print(category_id);
                            });
                          },
                          items: cats.map(
                            (val) {
                              return DropdownMenuItem<dynamic>(
                                value: val['id'],
                                child: Text(
                                  val['name'],
                                  style: TextStyle(
                                      color: Prefs.isDark()
                                          ? Colors.white70
                                          : Colors.black87),
                                ),
                              );
                            },
                          ).toList(),
                          isExpanded: true,
                          hint: new Text(
                            "Select Category",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          iconEnabledColor:
                              Prefs.isDark() ? Colors.white : Colors.black,
                          style: new TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                          // items: cats.map((e) => null)),
                          //  ),
                          //  ),

                          // ),

                          // items: cats.map((e) => null)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        SizedBox(
          height: 80,
        )
      ],
    );
  }

  GestureDetector _uploadImageWidget() {
    return GestureDetector(
      onTap: () => showChooseDialog(
        context: context,
        onTapCamera: () => _getImage(ImageSource.camera),
        onTapGallery: () => _getImage(ImageSource.gallery),
        onTapVideo: () => _getVideo(ImageSource.camera),
        onTapVideoGallery: () => _getVideo(ImageSource.gallery),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 23,
          ),
          Text(
            'Upload photo/video',
            style: TextStyle(
              color: Color(0xffe25e31),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () => showChooseDialog(
              context: context,
              onTapCamera: () {
                handyCam = false;
                _getImage(ImageSource.camera);
              },
              onTapGallery: () {
                handyCam = false;
                _getImage(ImageSource.gallery);
              },
              onTapVideo: () {
                handyCam = true;
                _getVideo(ImageSource.camera);
              },
              onTapVideoGallery: () {
                handyCam = false;
                _getVideo(ImageSource.gallery);
              },
            ),
            child: Image.asset(
              'assets/images/icon_add_post.png',
              width: 70,
              height: 60,
            ),
          ),
        ],
      ),
    );
  }

  Stack _imageWidget() {
    return Stack(
      children: <Widget>[
        Image.file(
          _image,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _image = null;
              });
            },
            child: Image.asset(
              'assets/images/icon_delete.png',
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
    );
  }

  Stack _videoWidget() {
    return Stack(
      children: <Widget>[
//        Image.file(
//          _image,
//          width: double.infinity,
//          height: double.infinity,
//          fit: BoxFit.cover,
//        ),
//    videoPlayerController = VideoPlayerController.file(_video)..initialize().then(() {
//      setState(() { });
//      _videoPlayerController.play();
//    });
        PixaliveVideoPlayer(
          _video.path,
          true,
          0,
          true,
          file: true,
        ),
        // Container(
        //   width: double.infinity,
        //   height: double.infinity,
        //   child: VideoPlayer(
        //     _videoPlayerController,
        //   ),
        // ),
//
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: () {
              setState(() {
                //_videoPlayerController.pause();

                _image = null;
                _video = null;
              });
            },
            child: Image.asset(
              'assets/images/icon_delete.png',
              width: 30,
              height: 30,
            ),
          ),
        ),
      ],
    );
  }
}

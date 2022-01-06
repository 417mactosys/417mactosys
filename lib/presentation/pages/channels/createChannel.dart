import 'package:flutter/material.dart';
import 'package:wilotv/presentation/components/toast.dart';
import '../../components/labeled_text_form_field.dart';
import '../../../domain/entities/user.dart';
import '../../../injection.dart';
import '../../../infrastructure/api/api_service.dart';

import '../../utils/constants.dart';
import 'chageavatar.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/app_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../infrastructure/core/pref_manager.dart';

import 'dart:io';

import '../../components/image_chooser_dialog.dart';

import 'package:cached_network_image/cached_network_image.dart';

class CreateChannel extends StatefulWidget {
  User user;
  CreateChannel(this.user);
  @override
  _CreateChannelState createState() => _CreateChannelState();
}

class _CreateChannelState extends State<CreateChannel> {
  File _image;
  String imageUrl;
  final picker = ImagePicker();
  TextEditingController name = new TextEditingController();
  TextEditingController description = new TextEditingController();

  Future _getImage(ImageSource imageSource) async {
    var pickedFile = await picker.getImage(source: imageSource);

    var image = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: kColorPrimary,
          toolbarWidgetColor: Colors.white,
          //initAspectRatio: CropAspectRatioPreset.original,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    );

    setState(() {
      _image = image;
    });
    imageUrl = await _uploadImage(_image.path);
  }

  Future<String> _uploadImage(String filePath) async {
    try {
      var detailsfile = File(filePath);

      final task = await FirebaseStorage.instance.ref(
          //DateTime.now().millisecondsSinceEpoch.toString() +"/"+
          filePath.split('/').last).putFile(detailsfile);

      final url = await task.ref.getDownloadURL();
      print("URL $url");
      return url;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.user != null) {
      print(widget.user.id);
      name.text = widget.user.username;
      description.text = widget.user.description;
      imageUrl = widget.user.avatar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.user == null ? 'Create your channel' : 'Edit your channel'),
        elevation: 1,
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 103,
                height: 116,
                child: Stack(
                  children: <Widget>[
                    _image == null
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: widget.user == null
                                  ? ''
                                  : widget.user.avatar ?? '',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return Image.asset(
                                  'assets/images/empty_avatar.png',
                                  width: 100,
                                  height: 100,
                                );
                              },
                            ),
                          )
                        : ClipOval(
                            child: Image.file(
                              _image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipOval(
                        child: Material(
                          child: InkWell(
                            onTap: () => changeAvatarDialog(
                              context: context,
                              onTapCamera: () => _getImage(ImageSource.camera),
                              onTapGallery: () =>
                                  _getImage(ImageSource.gallery),
                            ),
                            child: Image.asset(
                              'assets/images/add_button.png',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              LabeledTextFormField(
                  title: 'Channel Name',
                  hintText: 'John',
                  controller: name,
                  onChanged: (value) {}),
              SizedBox(
                height: 20,
              ),
              LabeledTextFormField(
                  title: 'Channel Decription',
                  hintText: 'Description',
                  controller: description,
                  onChanged: (value) {}),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 52,
        width: 150,
        //padding: EdgeInsets.only(bottom: 12),
        child: RawMaterialButton(
          onPressed: () async {
            if (widget.user == null) {
              print('create channel');
              //create Channel code
              try {
                final user = User(
                    username: name.text,
                    description: description.text,
                    avatar: imageUrl,
                    isChannel: 1,
                    owner_id: Prefs.getUser().isChannel == 1 ? Prefs.getUser().owner_id : Prefs.getID());
                print(user);
                final result =
                    await getIt<HeyPApiService>().createChannel(user);
                print('Result ERROR');

                print(result.error);
                print(result.body.toString());
                if (result.body.success) {
                  showToast('Create Channel Successfully Done');
                  Navigator.pop(context);
                } else {
                  showToast(result.body.message);
                }
              } catch (e) {
                print('ERROR');
                print(e.toString());
              }
            } else {
              try {
                final user = User(
                    username: name.text,
                    description: description.text,
                    avatar: imageUrl,
                    id: widget.user.id);
                print(user);
                final result = await getIt<HeyPApiService>().editChannel(user);
                print('Result ERROR');

                print(result.error);
                print(result.body.toString());
                if (result.body.success) {
                  showToast('Channel updated');
                  Navigator.pop(context);
                } else {
                  showToast(result.body.message);
                }
              } catch (e) {
                print('ERROR');
                print(e.toString());
              }
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          padding: EdgeInsets.all(0),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kColorPrimary, kColorPink],
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
                        widget.user == null ? 'Create' : 'Save',
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
                            turns: AlwaysStoppedAnimation(0),
                            child: Icon(
                              widget.user == null ? Icons.create : Icons.edit,
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
      ),
    );
  }
}

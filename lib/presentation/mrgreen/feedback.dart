import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => new _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  List<String> attachment = <String>[];
  final TextEditingController _bodyController = TextEditingController(text: '');
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> send() async {
    if (Platform.isIOS) {
      final bool canSend = await FlutterMailer.canSendMail();
      if (!canSend) {
        const SnackBar snackbar =
        const SnackBar(content: Text('no Email App Available'));
        _scafoldKey.currentState.showSnackBar(snackbar);
        return;
      }
    }

    // Platform messages may fail, so we use a try/catch PlatformException.
    final MailOptions mailOptions = MailOptions(
      body: _bodyController.text,
      subject: "Pixalive Feedback",
      recipients: <String>['wilotv@gmail.com'],
      isHTML: true,
      // bccRecipients: ['other@example.com'],
      ccRecipients: <String>['wilotv@gmail.com.com'],
      attachments: attachment,
    );

    String platformResponse;

    try {
      await FlutterMailer.send(mailOptions);
      platformResponse = 'success';
    } on PlatformException catch (error) {
      platformResponse = error.toString();
      print(error);
      if (!mounted) {
        return;
      }
      await showDialog<void>(
          context: _scafoldKey.currentContext,
          builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Message',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(error.message),
              ],
            ),
            contentPadding: const EdgeInsets.all(26),
            title: Text(error.code),
          ));
    } catch (error) {
      platformResponse = error.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
    // _scafoldKey.currentState.showSnackBar(SnackBar(
    //   content: Text(platformResponse),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    final Widget imagePath = SizedBox(
      height: 200,
      child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: attachment.map((String file){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Image.file(File(file), width: 200,
                    fit: BoxFit.cover
                    , height: 200,),

                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.close),
                      onPressed: (){
                        setState(() {
                          attachment.remove(file);
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          }).toList()),
    );



    return Scaffold(
      key: _scafoldKey,
      appBar: new AppBar(
        backgroundColor: Color(0xfff58524),
        title: const Text(
          'Feedback',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: Colors.white,
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: send,
            icon: const Icon(Icons.send_rounded),
            color: Colors.white,
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _bodyController,
                      maxLines: 15,
                      decoration: const InputDecoration(
                        hintText: 'Type your queries here',
                        hintStyle: TextStyle(fontSize: 15, height: 4),
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.deepOrange)),
                        filled: true,
                        contentPadding: EdgeInsets.only(
                            bottom: 10.0, left: 10.0, right: 10.0),
                        labelText: 'Message',
                        labelStyle: TextStyle(color: Colors.deepOrangeAccent),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ),
                  imagePath,
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0.0,
        focusElevation: 0.0,
        highlightElevation: 0.0,
        hoverElevation: 0.0,
        disabledElevation: 0.0,
        backgroundColor: Color(0xffec6500),
        //backgroundColor: Theme.of(context).hintColor,
        icon: const Icon(Icons.upload_rounded),
        label: const Text('Add Image', style: TextStyle(color: Colors.white),),
        onPressed: _picker,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _picker() async {
    final File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      attachment.add(pick.path);
    });
  }

  /// create a text file in Temporary Directory to share.
  void _onCreateFile(BuildContext context) async {
    final TempFile tempFile = await _showDialog(context);
    final File newFile = await writeFile(tempFile.content, tempFile.name);
    setState(() {
      attachment.add(newFile.path);
    });
  }

  /// some A simple dialog and return fileName and content
  Future<TempFile> _showDialog(BuildContext context) {
    return showDialog<TempFile>(
      context: context,
      builder: (BuildContext context) {
        String content = '';
        String fileName = '';

        return SimpleDialog(
          title: const Text('write something to a file'),
          contentPadding: const EdgeInsets.all(8.0),
          children: <Widget>[
            TextField(
              onChanged: (String str) => fileName = str,
              autofocus: true,
              decoration: const InputDecoration(
                  suffix: const Text('.txt'), labelText: 'file name'),
            ),
            TextField(
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                labelText: 'Content',
              ),
              onChanged: (String str) => content = str,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: const Icon(Icons.save),
                  onPressed: () {
                    final TempFile tempFile =
                    TempFile(content: content, name: fileName);
                    // Map.from({'content': content, 'fileName': fileName});
                    Navigator.of(context).pop<TempFile>(tempFile);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<String> get _localPath async {
    final Directory directory = await getTemporaryDirectory();

    return directory.path;
  }

  Future<File> _localFile(String fileName) async {
    final String path = await _localPath;
    return File('$path/$fileName.txt');
  }

  Future<File> writeFile(String text, [String fileName = '']) async {
    fileName = fileName.isNotEmpty ? fileName : 'fileName';
    final File file = await _localFile(fileName);

    // Write the file
    return file.writeAsString('$text');
  }
}

class TempFile {
  TempFile({this.name, this.content});

  final String name, content;
}

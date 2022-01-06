import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
// import 'package:social_share/social_share.dart';
import 'package:wilotv/presentation/components/waiting_dialog.dart';
import 'toast.dart';

import '../../application/post/post_bloc.dart';
import '../../domain/entities/feed.dart';
import '../../infrastructure/core/pref_manager.dart';
import '../../injection.dart';
import '../routes/routes.dart';
import '../utils/app_utils.dart';

enum UrlType { IMAGE, VIDEO, UNKNOWN }

class PostFooterButton extends StatefulWidget {
  final Feed feed;
  const PostFooterButton({Key key, @required this.feed}) : super(key: key);
  @override
  _PostFooterButtonState createState() => _PostFooterButtonState();
}

class _PostFooterButtonState extends State<PostFooterButton> {
  bool _liked;
  int _likes;
  int _comments;

  @override
  void initState() {
    super.initState();
    _liked = widget.feed.liked == 1;
    _likes = widget.feed.likes;
    _comments = widget.feed.comments;
  }

  Future<String> _findPath(String imageUrl) async {
    showWaitingDialog(context);
    final cache = await DefaultCacheManager();

    print('IMAHE' + imageUrl);

    final file = await cache.getSingleFile(imageUrl);

    print(file.path);

    Navigator.of(context).pop();
    return file.path;
  }

  var isDark = false;
  @override
  Widget build(BuildContext context) {
    isDark = Prefs.getBool(Prefs.DARKTHEME, def: true);
    return BlocProvider(
      create: (context) => getIt<PostBloc>(),
      child: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {
          state.likePostFailureOrSuccessOption.fold(
            () => null,
            (either) => either.fold(
              (failure) {
                setState(() {
                  _liked = !_liked;
                  _liked ? _likes++ : _likes--;
                });
              },
              (success) => null,
            ),
          );
        },
        builder: (context, state) {
          return Container(
            color: Prefs.isDark() ? Color(0xff121212) : Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: <Widget>[
                _button(
                  title: _likes.toString(),
                  image: _liked ? 'icon_like_filled' : 'heart',
                  onPressed: () {
                    context
                        .bloc<PostBloc>()
                        .add(PostEvent.likePost(widget.feed.id));
                    setState(() {
                      _liked = !_liked;
                      _liked ? _likes++ : _likes--;
                    });
                  },
                ),
                // SizedBox(
                //   width: 10,
                // ),
                Transform(
                  transform: Matrix4.translationValues(-10, 0, 0),
                  child: _button(
                    title: _comments.toString(),
                    image: 'icon_comment',
                    icon: SvgPicture.asset(
                      'assets/images/comment.svg',
                      width: 22,
                      height: 22,
                      color: isDark ? Colors.white : Color(0xff979797),
                      //colorBlendMode: BlendMode.clear,
                    ),
                    onPressed: () async {
                      final result = await Navigator.of(context).pushNamed(
                          Routes.comments,
                          arguments: widget.feed.id);
                      if (result != null && result)
                        setState(() {
                          _comments++;
                        });
                    },
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                _button(
                  title: 'share'.tr(),
                  icon: Icon(
                    Icons.share,
                    size: 20,
                    color: isDark ? Colors.white : Color(0xff979797),
                  ),
                  onPressed: () {
                    print("herere");
                    print('https://wilotv.live:3444/play/${widget.feed.sid}');
                    if (widget.feed.is_live == 1) {
                      print("video");

                      Share.share(widget.feed.body.isNotEmpty
                          ? widget.feed.body +
                              " " +
                              "https://wilotv.live:3444/play/${widget.feed.sid}"
                          : 'app_name'.tr() + " " + "");
                    } else {
                      print("video,image,text");

                      if (widget.feed.image.isNotEmpty) {
                        print("video,image");
                        print(widget.feed.image);
                        print(getUrlType(widget.feed.image));
                        if (getUrlType(widget.feed.image) == UrlType.IMAGE) {
                          print("imageshare");
                          _findPath(AppUtils.getPostImage(
                                  widget.feed.id, widget.feed.image))
                              .then(
                            (value) => Share.shareFiles(
                              [value],
                              text: widget.feed.body.isNotEmpty
                                  ? widget.feed.body + " " + ""
                                  : 'app_name'.tr() + " " + "",
                            ),
                          );
                        } else if (getUrlType(widget.feed.image) ==
                            UrlType.VIDEO) {
                          print("videoshare");
                          Share.share(
                            widget.feed.body.isNotEmpty
                                ? widget.feed.body + " " + widget.feed.image
                                : 'app_name'.tr() + " " + "",
                          );
                        }
                      } else {
                        print("textshare");
                        Share.share(
                          widget.feed.body.isNotEmpty
                              ? widget.feed.body + " " + ""
                              : 'app_name'.tr() + " " + "",
                        );
                      }
                    } // widget.feed.sid != null
                    //     ?
                    //     : SocialShare.shareOptions(
                    //         widget.feed.body.isNotEmpty
                    //             ? widget.feed.body + " " + "https://wilotv.live:3444/play/${widget.feed.sid}"
                    //             : 'app_name'.tr() + " " + ""
                    //       );
                  },
                ),

                if (widget.feed.image != "" || widget.feed.live_ended == 1)
                  IconButton(
                      icon: Icon(Icons.download_outlined),
                      onPressed: () {
                        if (widget.feed.is_live == 1) {
                          //live video
                          downloadFromPath(
                              'https://wilotv.live:3444/play/${widget.feed.sid}');
                        } else {
                          if (widget.feed.thumbnail == "") {
                            //image
                            downloadFromPath(widget.feed.image);
                            // downloadFile(widget.feed.image);
                          } else {
                            downloadFromPath(widget.feed.image);
                          }
                        }
                      })
              ],
            ),
          );
        },
      ),
    );
  }

  Future downloadFile(String url) async {
    Dio dio = Dio();

    try {
      var dir = await getExternalStorageDirectory();
      await dio.download(url, "${dir.path}/myfile.png",
          onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
      });
    } catch (e) {
      print(e);
    }
    print("Download completed");
  }

  downloadFromPath(String pathUrl) async {
    try {
      // Saved with this method.
      // showWaitingDialog(context);
      showToast('Download in progress');

      var imageId = await ImageDownloader.downloadImage(pathUrl);
      // Navigator.of(context).pop();
      if (imageId == null) {
        showAlert('Something went wrong!');
        return;
      }
      showAlert('Download success!');
      // Below is a method of obtaining saved image information.
      // var fileName = await ImageDownloader.findName(imageId);
      // var path = await ImageDownloader.findPath(imageId);
      // var size = await ImageDownloader.findByteSize(imageId);
      // var mimeType = await ImageDownloader.findMimeType(imageId);
    } on PlatformException catch (error) {
      print(error);
      // Navigator.of(context).pop();
      showAlert(error.message);
    }
  }

  showAlert(String message) {
    showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: Text(message),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(c).pop();
                },
              )
            ],
          );
        });
  }

  UrlType getUrlType(String url) {
    Uri uri = Uri.parse(url);
    String typeString = uri.path.substring(uri.path.length - 3).toLowerCase();
    if (typeString == "jpg" || typeString == "png" || typeString == "jpeg") {
      return UrlType.IMAGE;
    }
    if (typeString == "mp4" ||
        typeString == "mov" ||
        typeString == "3gp" ||
        typeString == "wmv" ||
        typeString == "flv" ||
        typeString == "flv") {
      return UrlType.VIDEO;
    } else {
      return UrlType.UNKNOWN;
    }
  }

  Material _button({
    String title,
    String image,
    Function onPressed,
    Widget icon,
  }) {
    return Material(
      color: Prefs.isDark() ? Color(0xff121212) : Colors.white,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: image == 'icon_like_filled'
              ? Row(
                  children: <Widget>[
                    ShaderMask(
                      shaderCallback: (r) {
                        return LinearGradient(
                                colors: [Colors.pinkAccent, Colors.orange],
                                begin: Alignment.bottomRight, //radius: 0.1,
                                end: Alignment.topLeft)
                            .createShader(r);
                      },
                      child: Image.asset(
                        'assets/images/$image.png',
                        width: 19,
                        height: 19,
                        color: Colors.white,
                        //color:  isDark && image == 'icon_like' ? Colors.white : Color(0xff979797),
                        //colorBlendMode: BlendMode.clear,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: isDark ? Colors.white : Color(0xff979797),
                          ),
                    ),
                  ],
                )
              : Row(
                  children: <Widget>[
                    icon != null
                        ? icon
                        : image != 'heart'
                            ? Image.asset(
                                'assets/images/$image.png',
                                width: 19,
                                height: 19,
                                color: isDark && image == 'heart'
                                    ? Colors.white
                                    : Color(0xff979797),
                                //colorBlendMode: BlendMode.clear,
                              )
                            : SvgPicture.asset(
                                'assets/images/$image.svg',
                                width: 20,
                                height: 20,
                                color: isDark && image == 'heart'
                                    ? Colors.white
                                    : Color(0xff979797),
                                //colorBlendMode: BlendMode.clear,
                              ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: isDark ? Colors.white : Color(0xff979797),
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

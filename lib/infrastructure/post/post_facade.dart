import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:injectable/injectable.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wilotv/presentation/pages/home/home_page.dart';
import 'package:wilotv/presentation/pages/home/widgets/loader.dart';
import '../../presentation/pages/post/widgets/image_widget.dart';

import '../../domain/core/failures.dart';
import '../../domain/entities/api_response.dart';
import '../../domain/entities/detail_post.dart';
import '../../domain/post/i_post_facade.dart';
import '../../injection.dart';
import '../api/api_service.dart';

@LazySingleton(as: IPostFacade)
class PostFacade implements IPostFacade {
  @override
  Future<Either<ServerFailure, ApiResponse>> addPost(
      {String imagePath, String body, int categoryId}) async {
    String image;
    final uploadId = DateTime.now().millisecondsSinceEpoch.toString();

    imagePath.isNotEmpty
        ? image = await _uploadImage(imagePath, uploadId)
        : image = '';

    var thumbnail = '';

    if (imagePath.contains('mp4')) {
      final thu = await VideoThumbnail.thumbnailFile(
        video: imagePath,
        imageFormat: ImageFormat.JPEG,
        maxWidth:
            512, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 100,
      );

      thumbnail = await _uploadImage(thu, uploadId);
      print(thumbnail);
    }

    try {
      final result = await getIt<HeyPApiService>()
          .addPost(image, thumbnail, body, category_id, channel_id);
      categoryId = category_id;
      print('CATEGORY ID IN POST FACADE' + categoryId.toString());
      if (result.body.success) {
        UPLOADS.value.remove(uploadId);
        UPLOADS.notifyListeners();
        HomePage.state.getFeeds();
        return right(result.body);
      } else {
        UPLOADS.value.remove(uploadId);
        UPLOADS.notifyListeners();
        print(result.body.message);
        print('ADD POST ERROR1');
        print(result.bodyString);
        return left(ServerFailure.apiFailure(msg: result.body.message));
      }
    } catch (e) {
      UPLOADS.value.remove(uploadId);
      UPLOADS.notifyListeners();
      print('ADD POST ERROR2');

      print(e);
      return left(const ServerFailure.serverError());
    }
  }

  Future<String> _uploadImage(String filePath, uploadId) async {
    var detailsfile = File(filePath);

    // TaskSnapshot task = await FirebaseStorage.instance.ref(
    //     //DateTime.now().millisecondsSinceEpoch.toString() +"/"+
    //     filePath.split('/').last).putFile(detailsfile);

    final Reference postImageRef =
        FirebaseStorage.instance.ref().child(filePath.split('/').last);

    UploadTask uploadTask = postImageRef.putFile(detailsfile);

    // UploadTask  task = await FirebaseStorage.instance.ref(
    //     //DateTime.now().millisecondsSinceEpoch.toString() +"/"+
    //     filePath.split('/').last).putFile(detailsfile);

    uploadTask.snapshotEvents.listen((event) {
      UPLOADS.value[uploadId] = (event.bytesTransferred / event.totalBytes);
      UPLOADS.notifyListeners();
    });
    await uploadTask.whenComplete(() {});

    final url = await uploadTask.snapshot.ref.getDownloadURL();
    print("URL $url");
    return url;
  }

  @override
  Future<Either<ServerFailure, ApiResponse>> likePost({int id}) async {
    try {
      final result = await getIt<HeyPApiService>().likePost(id);
      if (result.body.success) {
        return right(result.body);
      } else {
        return left(ServerFailure.apiFailure(msg: result.body.message));
      }
    } catch (e) {
      print(e);
      return left(const ServerFailure.serverError());
    }
  }

  @override
  Future<Either<ServerFailure, DetailPost>> getPost({int id}) async {
    try {
      print('GET POSTS IS THIS');
      final result = await getIt<HeyPApiService>().getPost(id);
      if (result.body.success) {
        return right(result.body);
      } else {
        return left(ServerFailure.apiFailure(msg: result.body.message));
      }
    } catch (e) {
      print(e);
      return left(const ServerFailure.serverError());
    }
  }
}

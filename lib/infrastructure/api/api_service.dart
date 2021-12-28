import "dart:async";

import 'package:chopper/chopper.dart';
import 'dart:io';
import 'package:http/http.dart' show MultipartFile;

import '../../domain/entities/api_response.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/detail_comments.dart';
import '../../domain/entities/detail_feeds.dart';
import '../../domain/entities/detail_messages.dart';
import '../../domain/entities/detail_news.dart';
import '../../domain/entities/detail_notifications.dart';
import '../../domain/entities/detail_post.dart';
import '../../domain/entities/detail_packages.dart';

import '../../domain/entities/detail_user.dart';
import '../../domain/entities/detail_channels.dart';

import '../../domain/entities/feed.dart';
import '../../domain/entities/login_user.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/news.dart';
import '../../domain/entities/notification.dart';
import '../../domain/entities/user.dart';
import '../core/converter.dart';
import '../core/interceptor.dart';

import '../../infrastructure/core/pref_manager.dart';

part 'api_service.chopper.dart';

@ChopperApi(baseUrl: 'https://wilotv.live:3443/api/')
//@ChopperApi(baseUrl: 'https://pixalive.loca.lt/api/')
abstract class HeyPApiService extends ChopperService {
  /// import 'package:http/http.dart' show MultipartFile;

  // @Get()
  // Future<Response> getPosts();

  @Post(path: 'login/')
  Future<Response<DetailUser>> login(
    @body LoginUser user,
  );

  @Get(path: 'check_post/')
  Future<Response<ApiResponse>> checkPost(
    @Query('user_id') int user_id,
  );

  @Post(path: 'switch_account/')
  Future<Response<DetailUser>> switchAccount(
    @Field('id') int id,
  );

  @Post(path: 'signup/')
  Future<Response<ApiResponse>> register(
    @body User user,
  );

  @Post(path: 'create_channel/')
  Future<Response<ApiResponse>> createChannel(
    @body User user,
  );

  @Post(path: 'edit_channel/')
  Future<Response<ApiResponse>> editChannel(
    @body User user,
  );

  @Get(path: 'get_channels/')
  Future<Response<DetailChannel>> getChannels(
    @Query('user_id') int user_id,
  );

  @Get(path: 'packages/')
  Future<Response<DetailPackage>> getPackages();

  @Get(path: 'get_accounts/')
  Future<Response<DetailChannel>> getAccounts(
    @Field('id') int user_id,
  );

  @Post(path: 'change_password/')
  Future<Response<ApiResponse>> changePassword(
    @Field('old_password') String password,
    @Field('password') String newPassword,
    @Field('confirm_password') String confirmPassword,
  );

  @Post(path: 'reset_password_step_1/')
  Future<Response<ApiResponse>> sendCode(
    @Field('email') String email,
  );

  @Post(path: 'reset_password_step_2/')
  Future<Response<ApiResponse>> verifyCode(
    @Field('token') String token,
    @Field('code') String code,
  );

  @Post(path: 'reset_password/')
  Future<Response<ApiResponse>> updatePassword(
    @Field('token') String token,
    @Field('password') String password,
    @Field('confirm_password') String confirmPassword,
  );

  @Post(path: 'change_avatar/')
  @multipart
  Future<Response<ApiResponse>> updateAvatar(
    @PartFile() MultipartFile image,
  );

  @Post(path: 'upload_avatar/')
  @multipart
  Future<Response<ApiResponse>> uploadAvatar(
    @PartFile() MultipartFile image,
  );

  @Post(path: 'update_profile/')
  Future<Response<DetailUser>> updateProfile(
    @body User user,
  );

  @Get(path: 'all_feeds/{offset}/')
  Future<Response<DetailFeeds>> getFeeds(
    @Path() int offset,
  );

  @Get(path: 'category_posts/')
  Future<Response<DetailFeeds>> getcategoryfeeds(
    @Query() int category_id,
    @Query() int uid,
  );

  @Get(path: 'feeds/{offset}/')
  Future<Response<DetailFeeds>> getUserFeeds(
    @Path() int offset,
  );

  @Get(path: 'posts/{id}/')
  @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  Future<Response<DetailFeeds>> getPosts(
    @Path() int id,
  );

  @Post(path: 'post_image/')
  @multipart
  Future<Response<ApiResponse>> postImage(
    @PartFile() MultipartFile image,
  );

  @Post(path: 'post/')
  Future<Response<ApiResponse>> addPost(
    @Field('image') String image,
    @Field('thumbnail') String thumbnail,
    @Field('body') String body,
    @Field('category_id') int categoryId,
    @Field('id') int id,
  );

  @Post(path: 'edit_post/')
  Future<Response<ApiResponse>> editPost(
    @Field('id') int id,
    @Field('body') String body,
    @Field('category_id') int category_id,
  );

  @Post(path: 'like/')
  Future<Response<ApiResponse>> likePost(
    @Field('id') int id,
  );

  @Get(path: 'news/')
  Future<Response<DetailNews>> getNews();

  @Get(path: 'post/{id}/comments/')
  @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  Future<Response<DetailComments>> getComments(
    @Path() int id,
  );

  @Get(path: 'post/{id}/')
  @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  Future<Response<DetailPost>> getPost(
    @Path() int id,
  );

  @Put(path: 'user/{id}/report/')
  @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  Future<Response<ApiResponse>> reportUser(
    @Path() int id,
  );

  @Post(path: 'comment/')
  Future<Response<ApiResponse>> addComment(
    @Field('id') int id,
    @Field('comment') String body,
    @Field('time') String time,
  );

  @Delete(path: 'comment/{id}/')
  @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  Future<Response<ApiResponse>> deleteComment(
    @Path() int id,
  );

  @Get(path: 'notifications/')
  Future<Response<DetailNotifications>> getNotifications();

  @Get(path: 'read_notifications/')
  Future<Response<ApiResponse>> readNotification(
    @Query('id') int id,
  );

  @Get(path: 'notifications_count/')
  Future<Response<ApiResponse>> notificationsCount(
    @Query('id') int id,
  );

  @Post(path: 'update_gcm_token/')
  Future<Response<ApiResponse>> updateGcmToken(
    @Field('token') String token,
  );

  @Get(path: 'user/{id}/')
  @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  Future<Response<DetailUser>> getUserInfo(
    @Path() int id,
  );

  @Get(path: 'user_info/{id}/')
  @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  Future<Response<User>> getUserInfoLess(
    @Path() int id,
  );

  // @Get(path: 'followers/{id}/{uid}')
  // @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  // Future<Response<List<User>>> getFollowers(
  //   @Path() int id, @Path() int uid,
  // );

  @Post(path: 'follow/')
  Future<Response<ApiResponse>> followUser(
    @Field('id') int id,
  );

  @Post(path: 'verify_otp/')
  Future<Response<ApiResponse>> verifyOTP(
    @Field('otp') String otp,
    @Field('user_id') String user_id,
  );

  @Post(path: 'resendotp/')
  Future<Response<ApiResponse>> resendOTP(
    @Field('email') String email,
  );

  @Get(path: 'live/start/{channel}/')
  Future<Response<ApiResponse>> startLive(
    @Path() String channel,
    @Field('body') String body,
  );

  @Get(path: 'live/update_thumbnail/{channel}/')
  Future<Response<ApiResponse>> updateThumbnail(
    @Path() String channel,
    @Field('thumbnail') String thumbnail,
  );

  @Get(path: 'live/end/{channel}/')
  Future<Response<ApiResponse>> stopLive(
      @Path() String channel, @Query() String sid);

  @Get(path: 'live/join/{channel}/')
  Future<Response<ApiResponse>> joinLive(@Path() String channel);

  @Post(path: 'live/delete_the_footage/{channel}/')
  Future<Response<ApiResponse>> deleteLive(@Path() String channel);

  @Delete(path: 'deleteChannel/{channel}/')
  Future<Response<ApiResponse>> deleteChannel(@Path() int channel);

  @Post(path: 'delete_post/')
  Future<Response<ApiResponse>> deletePost(
    @Field('id') int id,
  );

  @Get(path: 'messages/')
  Future<Response<DetailMessages>> getMessages();

  @Get(path: 'read_messages/')
  Future<Response<ApiResponse>> readMessages(
    @Query('id') int id,
    @Query('sender') int sender,
  );

  @Get(path: 'messages_count/')
  Future<Response<ApiResponse>> messagesCount(
    @Query('id') int id,
  );

  @Get(path: 'messages/{id}/{offset}')
  @FactoryConverter(request: FormUrlEncodedConverter.requestFactory)
  Future<Response<DetailMessages>> getMessagesDetails(
    @Path() int id,
    @Path() int offset,
  );

  @Get(path: 'search/')
  Future<Response<DetailFeeds>> search(
    @Query('query') String query,
  );

  @Get(path: 'search_posts/')
  Future<Response<DetailFeeds>> searchPosts(
    @Query('query') String query,
  );

  static HeyPApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://wilotv.live:3443/api/',
      services: [
        _$HeyPApiService(),
      ],
      //converter: BuiltValueConverter(),
      //converter: FormUrlEncodedConverter(),
      converter: JsonSerializableConverter({
        ApiResponse: ApiResponse.fromJsonFactory,
        LoginUser: LoginUser.fromJsonFactory,
        DetailUser: DetailUser.fromJsonFactory,
        User: User.fromJsonFactory,
        DetailFeeds: DetailFeeds.fromJsonFactory,
        Feed: Feed.fromJsonFactory,
        DetailNews: DetailNews.fromJsonFactory,
        News: News.fromJsonFactory,
        DetailComments: DetailComments.fromJsonFactory,
        Comment: Comment.fromJsonFactory,
        DetailNotifications: DetailNotifications.fromJsonFactory,
        Notification: Notification.fromJsonFactory,
        DetailPost: DetailPost.fromJsonFactory,
        DetailChannel: DetailChannel.fromJsonFactory,
        DetailMessages: DetailMessages.fromJsonFactory,
        Message: Message.fromJsonFactory,
        DetailPackage: DetailPackage.fromJsonFactory,
      }),
      //errorConverter: BuiltValueConverter(),
      //converter: FormUrlEncodedConverter(),
      interceptors: [
        HttpLoggingInterceptor(),
        Interceptor(),
        (Response response) async {
          if (response.statusCode == 404) {
            chopperLogger.severe('404 NOT FOUND');
          }
          return response;
        },
      ],
    );
    return _$HeyPApiService(client);
  }
}

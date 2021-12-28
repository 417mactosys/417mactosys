// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$HeyPApiService extends HeyPApiService {
  _$HeyPApiService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = HeyPApiService;

  @override
  Future<Response<DetailUser>> login(LoginUser user) {
    final $url = 'https://wilotv.live:3443/api/login/';
    final $body = user;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<DetailUser, DetailUser>($request);
  }

  @override
  Future<Response<ApiResponse>> checkPost(int user_id) {
    final $url = 'https://wilotv.live:3443/api/check_post/';
    final $params = <String, dynamic>{'user_id': user_id};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<DetailUser>> switchAccount(int id) {
    final $url = 'https://wilotv.live:3443/api/switch_account/';
    final $body = <String, dynamic>{'id': id};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<DetailUser, DetailUser>($request);
  }

  @override
  Future<Response<ApiResponse>> register(User user) {
    final $url = 'https://wilotv.live:3443/api/signup/';
    final $body = user;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> createChannel(User user) {
    final $url = 'https://wilotv.live:3443/api/create_channel/';
    final $body = user;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> editChannel(User user) {
    final $url = 'https://wilotv.live:3443/api/edit_channel/';
    final $body = user;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<DetailChannel>> getChannels(int user_id) {
    final $url = 'https://wilotv.live:3443/api/get_channels/';
    final $params = <String, dynamic>{'user_id': user_id};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<DetailChannel, DetailChannel>($request);
  }

  @override
  Future<Response<DetailPackage>> getPackages() {
    final $url = 'https://wilotv.live:3443/api/packages/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<DetailPackage, DetailPackage>($request);
  }

  @override
  Future<Response<DetailChannel>> getAccounts(int user_id) {
    final $url = 'https://wilotv.live:3443/api/get_accounts/';
    final $body = <String, dynamic>{'id': user_id};
    final $request = Request('GET', $url, client.baseUrl, body: $body);
    return client.send<DetailChannel, DetailChannel>($request);
  }

  @override
  Future<Response<ApiResponse>> changePassword(
      String password, String newPassword, String confirmPassword) {
    final $url = 'https://wilotv.live:3443/api/change_password/';
    final $body = <String, dynamic>{
      'old_password': password,
      'password': newPassword,
      'confirm_password': confirmPassword
    };
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> sendCode(String email) {
    final $url = 'https://wilotv.live:3443/api/reset_password_step_1/';
    final $body = <String, dynamic>{'email': email};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> verifyCode(String token, String code) {
    final $url = 'https://wilotv.live:3443/api/reset_password_step_2/';
    final $body = <String, dynamic>{'token': token, 'code': code};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> updatePassword(
      String token, String password, String confirmPassword) {
    final $url = 'https://wilotv.live:3443/api/reset_password/';
    final $body = <String, dynamic>{
      'token': token,
      'password': password,
      'confirm_password': confirmPassword
    };
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> updateAvatar(MultipartFile image) {
    final $url = 'https://wilotv.live:3443/api/change_avatar/';
    final $parts = <PartValue>[PartValueFile<MultipartFile>('image', image)];
    final $request =
        Request('POST', $url, client.baseUrl, parts: $parts, multipart: true);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> uploadAvatar(MultipartFile image) {
    final $url = 'https://wilotv.live:3443/api/upload_avatar/';
    final $parts = <PartValue>[PartValueFile<MultipartFile>('image', image)];
    final $request =
        Request('POST', $url, client.baseUrl, parts: $parts, multipart: true);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<DetailUser>> updateProfile(User user) {
    final $url = 'https://wilotv.live:3443/api/update_profile/';
    final $body = user;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<DetailUser, DetailUser>($request);
  }

  @override
  Future<Response<DetailFeeds>> getFeeds(int offset) {
    final $url = 'https://wilotv.live:3443/api/all_feeds/$offset/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<DetailFeeds, DetailFeeds>($request);
  }

  @override
  Future<Response<DetailFeeds>> getcategoryfeeds(int category_id, int uid) {
    final $url = 'https://wilotv.live:3443/api/category_posts/';
    final $params = <String, dynamic>{'category_id': category_id, 'uid': uid};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<DetailFeeds, DetailFeeds>($request);
  }

  @override
  Future<Response<DetailFeeds>> getUserFeeds(int offset) {
    final $url = 'https://wilotv.live:3443/api/feeds/$offset/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<DetailFeeds, DetailFeeds>($request);
  }

  @override
  Future<Response<DetailFeeds>> getPosts(int id) {
    final $url = 'https://wilotv.live:3443/api/posts/$id/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<DetailFeeds, DetailFeeds>($request,
        requestConverter: FormUrlEncodedConverter.requestFactory);
  }

  @override
  Future<Response<ApiResponse>> postImage(MultipartFile image) {
    final $url = 'https://wilotv.live:3443/api/post_image/';
    final $parts = <PartValue>[PartValueFile<MultipartFile>('image', image)];
    final $request =
        Request('POST', $url, client.baseUrl, parts: $parts, multipart: true);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> addPost(
      String image, String thumbnail, String body, int categoryId, int id) {
    final $url = 'https://wilotv.live:3443/api/post/';
    final $body = <String, dynamic>{
      'image': image,
      'thumbnail': thumbnail,
      'body': body,
      'category_id': categoryId,
      'id': id
    };
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> editPost(int id, String body, int category_id) {
    final $url = 'https://wilotv.live:3443/api/edit_post/';
    final $body = <String, dynamic>{
      'id': id,
      'body': body,
      'category_id': category_id
    };
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> likePost(int id) {
    final $url = 'https://wilotv.live:3443/api/like/';
    final $body = <String, dynamic>{'id': id};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<DetailNews>> getNews() {
    final $url = 'https://wilotv.live:3443/api/news/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<DetailNews, DetailNews>($request);
  }

  @override
  Future<Response<DetailComments>> getComments(int id) {
    final $url = 'https://wilotv.live:3443/api/post/$id/comments/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<DetailComments, DetailComments>($request,
        requestConverter: FormUrlEncodedConverter.requestFactory);
  }

  @override
  Future<Response<DetailPost>> getPost(int id) {
    final $url = 'https://wilotv.live:3443/api/post/$id/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<DetailPost, DetailPost>($request,
        requestConverter: FormUrlEncodedConverter.requestFactory);
  }

  @override
  Future<Response<ApiResponse>> reportUser(int id) {
    final $url = 'https://wilotv.live:3443/api/user/$id/report/';
    final $request = Request('PUT', $url, client.baseUrl);
    return client.send<ApiResponse, ApiResponse>($request,
        requestConverter: FormUrlEncodedConverter.requestFactory);
  }

  @override
  Future<Response<ApiResponse>> addComment(int id, String body, String time) {
    final $url = 'https://wilotv.live:3443/api/comment/';
    final $body = <String, dynamic>{'id': id, 'comment': body, 'time': time};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> deleteComment(int id) {
    final $url = 'https://wilotv.live:3443/api/comment/$id/';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send<ApiResponse, ApiResponse>($request,
        requestConverter: FormUrlEncodedConverter.requestFactory);
  }

  @override
  Future<Response<DetailNotifications>> getNotifications() {
    final $url = 'https://wilotv.live:3443/api/notifications/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<DetailNotifications, DetailNotifications>($request);
  }

  @override
  Future<Response<ApiResponse>> readNotification(int id) {
    final $url = 'https://wilotv.live:3443/api/read_notifications/';
    final $params = <String, dynamic>{'id': id};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> notificationsCount(int id) {
    final $url = 'https://wilotv.live:3443/api/notifications_count/';
    final $params = <String, dynamic>{'id': id};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> updateGcmToken(String token) {
    final $url = 'https://wilotv.live:3443/api/update_gcm_token/';
    final $body = <String, dynamic>{'token': token};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<DetailUser>> getUserInfo(int id) {
    final $url = 'https://wilotv.live:3443/api/user/$id/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<DetailUser, DetailUser>($request,
        requestConverter: FormUrlEncodedConverter.requestFactory);
  }

  @override
  Future<Response<User>> getUserInfoLess(int id) {
    final $url = 'https://wilotv.live:3443/api/user_info/$id/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<User, User>($request,
        requestConverter: FormUrlEncodedConverter.requestFactory);
  }

  @override
  Future<Response<ApiResponse>> followUser(int id) {
    final $url = 'https://wilotv.live:3443/api/follow/';
    final $body = <String, dynamic>{'id': id};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> verifyOTP(String otp, String user_id) {
    final $url = 'https://wilotv.live:3443/api/verify_otp/';
    final $body = <String, dynamic>{'otp': otp, 'user_id': user_id};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> resendOTP(String email) {
    final $url = 'https://wilotv.live:3443/api/resendotp/';
    final $body = <String, dynamic>{'email': email};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> startLive(String channel, String body) {
    final $url = 'https://wilotv.live:3443/api/live/start/$channel/';
    final $body = <String, dynamic>{'body': body};
    final $request = Request('GET', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> updateThumbnail(
      String channel, String thumbnail) {
    final $url = 'https://wilotv.live:3443/api/live/update_thumbnail/$channel/';
    final $body = <String, dynamic>{'thumbnail': thumbnail};
    final $request = Request('GET', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> stopLive(String channel, String sid) {
    final $url = 'https://wilotv.live:3443/api/live/end/$channel/';
    final $params = <String, dynamic>{'sid': sid};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> joinLive(String channel) {
    final $url = 'https://wilotv.live:3443/api/live/join/$channel/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> deleteLive(String channel) {
    final $url =
        'https://wilotv.live:3443/api/live/delete_the_footage/$channel/';
    final $request = Request('POST', $url, client.baseUrl);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> deleteChannel(int channel) {
    final $url = 'https://wilotv.live:3443/api/deleteChannel/$channel/';
    final $request = Request('DELETE', $url, client.baseUrl);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> deletePost(int id) {
    final $url = 'https://wilotv.live:3443/api/delete_post/';
    final $body = <String, dynamic>{'id': id};
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<DetailMessages>> getMessages() {
    final $url = 'https://wilotv.live:3443/api/messages/';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<DetailMessages, DetailMessages>($request);
  }

  @override
  Future<Response<ApiResponse>> readMessages(int id, int sender) {
    final $url = 'https://wilotv.live:3443/api/read_messages/';
    final $params = <String, dynamic>{'id': id, 'sender': sender};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<ApiResponse>> messagesCount(int id) {
    final $url = 'https://wilotv.live:3443/api/messages_count/';
    final $params = <String, dynamic>{'id': id};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<ApiResponse, ApiResponse>($request);
  }

  @override
  Future<Response<DetailMessages>> getMessagesDetails(int id, int offset) {
    final $url = 'https://wilotv.live:3443/api/messages/$id/$offset';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<DetailMessages, DetailMessages>($request,
        requestConverter: FormUrlEncodedConverter.requestFactory);
  }

  @override
  Future<Response<DetailFeeds>> search(String query) {
    final $url = 'https://wilotv.live:3443/api/search/';
    final $params = <String, dynamic>{'query': query};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<DetailFeeds, DetailFeeds>($request);
  }

  @override
  Future<Response<DetailFeeds>> searchPosts(String query) {
    final $url = 'https://wilotv.live:3443/api/search_posts/';
    final $params = <String, dynamic>{'query': query};
    final $request = Request('GET', $url, client.baseUrl, parameters: $params);
    return client.send<DetailFeeds, DetailFeeds>($request);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:firebase_messaging/firebase_messaging.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'application/changepassword/change_password_bloc.dart' as _i37;
import 'application/comment/comment_bloc.dart' as _i38;
import 'application/feed/feed_bloc.dart' as _i39;
import 'application/login/login_bloc.dart' as _i26;
import 'application/messages/messages_bloc.dart' as _i27;
import 'application/news/news_bloc.dart' as _i29;
import 'application/notification/notification_bloc.dart' as _i30;
import 'application/post/post_bloc.dart' as _i31;
import 'application/profile/profile_bloc.dart' as _i32;
import 'application/search/search_bloc.dart' as _i34;
import 'application/signup/signup_bloc.dart' as _i35;
import 'application/socket/socket_bloc.dart' as _i36;
import 'domain/changepassword/i_change_password_facade.dart' as _i4;
import 'domain/comment/i_comment_facade.dart' as _i6;
import 'domain/feed/i_feed_facade.dart' as _i8;
import 'domain/login/i_login_facade.dart' as _i10;
import 'domain/messages/i_messages_facade.dart' as _i12;
import 'domain/news/i_news_facade.dart' as _i14;
import 'domain/notification/i_notification_facade.dart' as _i16;
import 'domain/post/i_post_facade.dart' as _i18;
import 'domain/profile/i_profile_facade.dart' as _i20;
import 'domain/search/i_search_facade.dart' as _i22;
import 'domain/signup/i_signup_facade.dart' as _i24;
import 'infrastructure/changepassword/change_password_facade.dart' as _i5;
import 'infrastructure/comment/comment_facade.dart' as _i7;
import 'infrastructure/core/firebase_injectable_module.dart' as _i40;
import 'infrastructure/feed/feed_facade.dart' as _i9;
import 'infrastructure/login/login_facade.dart' as _i11;
import 'infrastructure/messages/messages_facade.dart' as _i13;
import 'infrastructure/news/news_facade.dart' as _i15;
import 'infrastructure/notification/notification_facade.dart' as _i17;
import 'infrastructure/post/post_facade.dart' as _i19;
import 'infrastructure/profile/profile_facade.dart' as _i21;
import 'infrastructure/search/search_facade.dart' as _i23;
import 'infrastructure/services/push_notification_service.dart' as _i33;
import 'infrastructure/signup/signup_facade.dart' as _i25;
import 'navigation_service.dart'
    as _i28; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String environment, _i2.EnvironmentFilter environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final firebaseInjectableModule = _$FirebaseInjectableModule();
  gh.lazySingleton<_i3.FirebaseMessaging>(() => firebaseInjectableModule.fcm);
  gh.lazySingleton<_i4.IChangePasswordFacade>(() => _i5.ChangePasswordFacade());
  gh.lazySingleton<_i6.ICommentFacade>(() => _i7.CommentFacade());
  gh.lazySingleton<_i8.IFeedFacade>(() => _i9.FeedFacade());
  gh.lazySingleton<_i10.ILoginFacade>(() => _i11.LoginFacade());
  gh.lazySingleton<_i12.IMessagesFacade>(() => _i13.MessagesFacade());
  gh.lazySingleton<_i14.INewsFacade>(() => _i15.NewsFacade());
  gh.lazySingleton<_i16.INotificationFacade>(() => _i17.NotificationFacade());
  gh.lazySingleton<_i18.IPostFacade>(() => _i19.PostFacade());
  gh.lazySingleton<_i20.IProfileFacade>(() => _i21.ProfileFacade());
  gh.lazySingleton<_i22.ISearchFacade>(() => _i23.SearchFacade());
  gh.lazySingleton<_i24.ISignUpFacade>(() => _i25.SignUpFacade());
  gh.factory<_i26.LoginBloc>(() => _i26.LoginBloc(get<_i10.ILoginFacade>()));
  gh.factory<_i27.MessagesBloc>(
      () => _i27.MessagesBloc(get<_i12.IMessagesFacade>()));
  gh.lazySingleton<_i28.NavigationService>(() => _i28.NavigationService());
  gh.factory<_i29.NewsBloc>(() => _i29.NewsBloc(get<_i14.INewsFacade>()));
  gh.factory<_i30.NotificationBloc>(
      () => _i30.NotificationBloc(get<_i16.INotificationFacade>()));
  gh.factory<_i31.PostBloc>(() => _i31.PostBloc(get<_i18.IPostFacade>()));
  gh.factory<_i32.ProfileBloc>(
      () => _i32.ProfileBloc(get<_i20.IProfileFacade>()));
  gh.factory<_i33.PushNotificationService>(
      () => _i33.PushNotificationService());
  gh.factory<_i34.SearchBloc>(() => _i34.SearchBloc(get<_i22.ISearchFacade>()));
  gh.factory<_i35.SignUpBloc>(() => _i35.SignUpBloc(get<_i24.ISignUpFacade>()));
  gh.factory<_i36.SocketBloc>(() => _i36.SocketBloc());
  gh.factory<_i37.ChangePasswordBloc>(
      () => _i37.ChangePasswordBloc(get<_i4.IChangePasswordFacade>()));
  gh.factory<_i38.CommentBloc>(
      () => _i38.CommentBloc(get<_i6.ICommentFacade>()));
  gh.factory<_i39.FeedBloc>(() => _i39.FeedBloc(get<_i8.IFeedFacade>()));
  return get;
}

class _$FirebaseInjectableModule extends _i40.FirebaseInjectableModule {}

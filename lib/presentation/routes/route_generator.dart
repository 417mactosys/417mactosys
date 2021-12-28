import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/news.dart';
import '../mrgreen/packages.dart';
import '../../domain/entities/user.dart';
import '../pages/changelanguage/change_language_page.dart';
import '../pages/changepassword/change_password_page.dart';
import '../pages/comments/comments_page.dart';
import '../pages/editprofile/edit_profile_page.dart';
import '../pages/forgotpassword/forgot_password_page.dart';
import '../pages/home/home.dart';
import '../pages/login/login_page.dart';
import '../pages/messages/messages_details_page.dart';
import '../pages/messages/messages_page.dart';
import '../pages/news/news_details_page.dart';
import '../pages/photos_preview_page.dart';
import '../pages/post/add_post_page.dart';
import '../pages/post/post_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/search/search_page.dart';
import '../pages/signup/signup_page.dart';
import '../pages/splash/splash_page.dart';
import '../pages/channels/channels.dart';
import '../pages/notifications/notifications_page.dart';
import '../mrgreen/contacts_friends.dart';
import '../mrgreen/feedback.dart';
import '../mrgreen/otp_screen.dart';
import 'routes.dart';

//import '../../webrtc/call_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.splash:
        return CupertinoPageRoute(builder: (_) => SplashPage());

      case Routes.login:
        return CupertinoPageRoute(
          builder: (_) => LoginPage(),
          settings: RouteSettings(name: Routes.login),
        );

      // case Routes.otp:
      //   return CupertinoPageRoute(
      //     builder: (_) => OTPScreen(),
      //   );

      case Routes.signup:
        return CupertinoPageRoute(builder: (_) => SignupPage());

      case Routes.forgotPassword:
        return CupertinoPageRoute(builder: (_) => ForgotPasswordPage());

      case Routes.editProfile:
        return CupertinoPageRoute(builder: (_) => EditProfilePage());

      case Routes.home:
        return CupertinoPageRoute(builder: (_) => Home());
      //return CupertinoPageRoute(builder: (_) => CallScreen(ip: '3.6.250.92'));

      case Routes.addPost:
        return CupertinoPageRoute(
          builder: (_) => AddPostPage(),
          fullscreenDialog: true,
        );

      case Routes.newsDetails:
        if (args is News) {
          return CupertinoPageRoute(
            builder: (_) => NewsDetailsPage(
              news: args,
            ),
          );
        }
        return _errorRoute();

      case Routes.changePassword:
        return CupertinoPageRoute(builder: (_) => ChangePasswordPage());

      case Routes.notification:
        return CupertinoPageRoute(builder: (_) => NotificationsPage());

      case Routes.comments:
        if (args is int) {
          return CupertinoPageRoute(
            builder: (_) => CommentsPage(
              id: args,
            ),
            fullscreenDialog: true,
          );
        }
        return _errorRoute();

      case Routes.post:
        if (args is int) {
          return CupertinoPageRoute(
            builder: (_) => PostPage(
              id: args,
            ),
          );
        }
        return _errorRoute();

      case Routes.profile:
        return CupertinoPageRoute(
            builder: (_) => ProfilePage(
                  user: args,
                ));

      case Routes.language:
        return CupertinoPageRoute(builder: (_) => ChangeLanguagePage());
      case Routes.packages:
        return CupertinoPageRoute(builder: (_) => Packages());

      case Routes.messages:
        return CupertinoPageRoute(builder: (_) => MessagesPage());

      case Routes.messagesDetails:
        if (args is User) {
          return CupertinoPageRoute(
            builder: (_) => MessagesDetailsPage(
              user: args,
            ),
          );
        }
        return _errorRoute();

      case Routes.preview:
        if (args is String) {
          return CupertinoPageRoute(
            builder: (_) => PhotosPreviewPage(
              url: args,
            ),
            fullscreenDialog: true,
          );
        }
        return _errorRoute();

      case Routes.contacts:
        return CupertinoPageRoute(
          builder: (_) => ContactsList(),
        );
        return _errorRoute();

      case Routes.feedback:
        return CupertinoPageRoute(
          builder: (_) => FeedBack(),
        );
        return _errorRoute();

      case Routes.channels:
        return CupertinoPageRoute(
          builder: (_) => ChannelsPage(),
        );
        return _errorRoute();

      case Routes.search:
        if (args is Map) {
          return CupertinoPageRoute(
            builder: (_) => SearchPage(
              query: args['query'],
              showAppBar: args['show_app_bar'],
            ),
          );
        }
        return _errorRoute();

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error'),
        ),
      );
    });
  }
}

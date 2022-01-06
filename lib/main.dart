import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:injectable/injectable.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'navigation_service.dart';
import 'injection.dart';
import 'presentation/routes/route_generator.dart';
import 'presentation/routes/routes.dart';
import 'presentation/utils/themebloc/theme_bloc.dart';
import 'socket_provider.dart';
import 'package:firebase_core/firebase_core.dart';
// import '/apple_sign_in_available.dart';
import 'apple_sign_in_available.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import './presentation/mrgreen/contacts_repo.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Crashlytics.instance.enableInDevMode = true;
  // Pass all uncaught errors from the framework to Crashlytics.
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;
  // Future<void>.delayed(const Duration(seconds: 0), () {
  //   throw StateError("");
  //   // or  Crashlytics.instance.crash();
  // });
  final appleSignInAvailable = await AppleSignInAvailable.check();
  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: EasyLocalization(
      child: MyApp(),
      supportedLocales: [
        Locale('en'),
        Locale('de'),
        Locale('ar'),
        Locale('es'),
        Locale('pt'),
        Locale('it'),
        Locale('fr'),
      ],
      useOnlyLangCode: true,
      path: 'assets/languages',
    ),
  ));
  configureInjection(Environment.prod);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: _buildWithTheme,
      ),
    );

    // return MultiProvider(
    //   providers: [
    //   BlocProvider(
    //     create: (context) => ThemeBloc(),
    //     child: BlocBuilder<ThemeBloc, ThemeState>(
    //       builder: _buildWithTheme,
    //     ),
    //   ),
    //
    // Provider<AuthService>(
    // create: (_) => AuthService(),
    // child: MaterialApp(
    // title: 'Apple Sign In with Firebase',
    // debugShowCheckedModeBanner: false,
    // theme: ThemeData(
    // primarySwatch: Colors.indigo,
    // ),
    // home: LoginPage(),
    // ),
    // )
    //   ],
    //
    // );
  }

/*ScrollConfiguration(
          behavior: MyBehavior(),`
          child: SocketProvider(
            child: child,
          ),
        );*/

  Widget _buildWithTheme(BuildContext context, ThemeState state) {
    return MaterialApp(
      builder: (ctx, child) {
        return Provider<AuthService>(
          create: (_) => AuthService(),
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SocketProvider(
              child: child,
            ),
          ),
        );
      },
      title: 'app_name'.tr(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        EasyLocalization.of(context).delegate,
      ],
      supportedLocales: EasyLocalization.of(context).supportedLocales,
      locale: EasyLocalization.of(context).locale,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,
      navigatorKey: getIt<NavigationService>().navigatorKey,
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: state.themeData,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//
//   Widget _buildWithTheme(BuildContext context, ThemeState state) {
//     return MaterialApp(
//       builder: (ctx, child) {
//         return ScrollConfiguration(
//           behavior: MyBehavior(),
//           child: SocketProvider(
//             child: child,
//           ),
//         );
//       },
//       title: 'app_name'.tr(),
//       localizationsDelegates: [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//         DefaultCupertinoLocalizations.delegate,
//         EasyLocalization.of(context).delegate,
//       ],
//       supportedLocales: EasyLocalization.of(context).supportedLocales,
//       locale: EasyLocalization.of(context).locale,
//       debugShowCheckedModeBanner: false,
//       initialRoute: Routes.splash,
//       navigatorKey: getIt<NavigationService>().navigatorKey,
//       onGenerateRoute: RouteGenerator.generateRoute,
//       theme: state.themeData,
//     );
//   }
// }

class NavKeys {
  static final navigator = GlobalKey<NavigatorState>();
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

/*
password: com.sataware.wilotv1
Alias : key0
key name ni file 6
*/

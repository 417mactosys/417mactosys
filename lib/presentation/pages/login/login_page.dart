import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../infrastructure/api/api_service.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../../application/login/login_bloc.dart';
import '../../../domain/entities/detail_user.dart';
import '../../../domain/entities/user.dart';
import '../../../infrastructure/core/pref_manager.dart';
import '../../../injection.dart';
import '../../../main.dart';
import '../../../apple_sign_in_available.dart';
import '../../../auth_service.dart';
import '../../components/custom_button_icon.dart';
import '../../components/server_error.dart';
import '../../components/toast.dart';
import '../../components/waiting_dialog.dart';
import '../../routes/routes.dart';
import '../../utils/app_utils.dart';
import '../../utils/constants.dart';
import 'widgets/input_widget.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter/material.dart' hide ButtonStyle;

// import 'package:apple_sign_in_firebase_flutter/apple_sign_in_available.dart';
// import 'package:apple_sign_in_firebase_flutter/auth_service.dart';

import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  void _saveUserData(DetailUser success) async {
    User user = success.user;

    Prefs.setString(Prefs.ACCESS_TOKEN, success.accessToken);
    Prefs.setInt(Prefs.ID, user.id);
    Prefs.setInt(Prefs.PACKAGE_ID, user.package_id);

    Prefs.setString(Prefs.USERNAME, user.username);
    Prefs.setString(Prefs.FIRST_NAME, user.firstName);
    Prefs.setString(Prefs.LAST_NAME, user.lastName);
    Prefs.setString(Prefs.EMAIL, user.email);
    Prefs.setString(Prefs.PHONE, user.phone);
    Prefs.setString(Prefs.AVATAR, user.avatar);

    Prefs.setBool(Prefs.LOGIN_STATUS, true);

    AppUtils.updateGcmToken();
  }



  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      print(authService);
      final user1 = await authService.signInWithApple(scopes: [Scope.email, Scope.fullName]);
      print('khushboo45');
      print(user1);
      print('uid: ${user1.uid}');

      var userName = user1.displayName ;


      final user = User(
          username:
          userName.toString().toLowerCase().replaceAll(' ', '_'),
          password: 'apple123',
          confirmPassword: 'apple123',
          firstName: userName.toString(),
          lastName: "",
          avatar: "",
          phone: "",
          email: user1.email.toString());

      context
          .bloc<LoginBloc>()
          .add(LoginEvent.emailChanged(user.email));
      context
          .bloc<LoginBloc>()
          .add(LoginEvent.passwordChanged(user.password));


      try {
        final result = await getIt<HeyPApiService>().register(user);
        print(result.error);
        print(result.body.toString());
        if (result.body.success) {
          print(result.body);

          context
              .bloc<LoginBloc>()
              .add(LoginEvent.signInWithEmailAndPasswordPressed());
        } else {
          print('eeee');
          context
              .bloc<LoginBloc>()
              .add(LoginEvent.signInWithEmailAndPasswordPressed());
        }
      } catch (e) {
        print(e);
      }

    } catch (e) {
      // TODO: Show alert here
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: BlocProvider(
                      create: (context) => getIt<LoginBloc>(),
                      child: BlocConsumer<LoginBloc, LoginState>(
                        listenWhen: (p, c) => p.isSubmitting != c.isSubmitting,
                        listener: (context, state) {
                          state.authFailureOrSuccessOption.fold(
                            () => null,
                            (either) {
                              Navigator.pop(context);
                              either.fold(
                                (failure) {
                                  failure.map(
                                    serverError: (_) => serverError(),
                                    apiFailure: (e) => showToast(e.msg),
                                  );
                                },
                                (success) {
                                  _saveUserData(success);
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      Routes.home,
                                      (Route<dynamic> route) => false);
                                },
                              );
                            },
                          );

                          if (state.isSubmitting) {
                            showWaitingDialog(context);
                          }
                        },
                        builder: (context, state) {
                          return _bodyWidget(
                              context, state.showErrorMessages, state);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Column _bodyWidget(
      BuildContext context, bool autovalidate, LoginState state) {
   final appleSignInAvailable =
   Provider.of<AppleSignInAvailable>(context, listen: false);
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 30,
          ),
        ),
        Image.asset(
          'assets/images/splash.png',
          width: 153,
          height: 153,
        ),
        Expanded(
          child: SizedBox(
            height: 30,
          ),
        ),
        Form(
          // autovalidateMode: autovalidate
          //     ? AutovalidateMode.onUserInteraction
          //     : AutovalidateMode.disabled,
          child: InputWidget(),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          child: CustomButtonIcon(
            title: 'login'.tr(),
            icon: 'icon_login',
            iconSize: 19,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              context
                  .bloc<LoginBloc>()
                  .add(LoginEvent.signInWithEmailAndPasswordPressed());
            },
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          width: double.infinity,
          child: CustomButtonIcon(
            title: 'login_with_facebook'.tr(),
            icon: 'icon_facebook',
            color: Color(0xff3c5a99),
            iconSize: 19,
            onPressed: () async {
              final facebookLogin = await FacebookAuth.instance;
              final token = (await facebookLogin.isLogged);
              if (token != null) {
                await facebookLogin.logOut();
              }
              facebookLogin.login(permissions: [
                'email',
                'public_profile',
                "user_friends"
              ]).then((value) async {
                showWaitingDialog(context);
                var d = await facebookLogin.getUserData(
                    fields:
                        'name, email, picture.width(100).height(100), first_name, last_name');
                final res = await get(d['picture']['data']['url']);
                Directory tempDir = await getTemporaryDirectory();
                //final pic = await File(tempDir.path + "/" +DateTime.now().millisecondsSinceEpoch.toString()+".jpg").writeAsBytes(res.bodyBytes);

                // MultipartFile file = await MultipartFile.fromPath(
                //   'avatar',
                //   pic.path,
                //   contentType: MediaType('image', '*'),
                // );
                //final uploadRes = await getIt<HeyPApiService>().uploadAvatar(file);

                final user = User(
                    username:
                        d['name'].toString().toLowerCase().replaceAll(' ', '_'),
                    password: 'facebook',
                    confirmPassword: 'facebook',
                    firstName: d['first_name'],
                    lastName: d['last_name'],
                    avatar: d['picture']['data']['url'],
                    phone: d['id'].toString().substring(0, 10),
                    email: d['email']);

                context
                    .bloc<LoginBloc>()
                    .add(LoginEvent.emailChanged(user.email));
                context
                    .bloc<LoginBloc>()
                    .add(LoginEvent.passwordChanged(user.password));

                //print(uploadRes.body);

                try {
                  final result = await getIt<HeyPApiService>().register(user);
                  print(result.error);
                  print(result.body.toString());
                  if (result.body.success) {
                    print(result.body);

                    context
                        .bloc<LoginBloc>()
                        .add(LoginEvent.signInWithEmailAndPasswordPressed());
                  } else {
                    print('eeee');
                    context
                        .bloc<LoginBloc>()
                        .add(LoginEvent.signInWithEmailAndPasswordPressed());
                  }
                } catch (e) {
                  print(e);
                }
              }, onError: (e) {
                print(e.message);
              });
              //print((facebookLogin as FacebookAuthException).message);
              //final result = await facebookLogin.logInWithReadPermissions([]);
              //print(facebookLogin.token);
              //print(result.errorMessage);
              //print(result.accessToken.permissions.toString());
            },
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 0,
          ),
        ),


        if (Platform.isIOS) Container(
          width: double.infinity,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (appleSignInAvailable.isAvailable)
                AppleSignInButton(
                  //style: ButtonStyle.black,
                  type: ButtonType.signIn,
                  onPressed: () => _signInWithApple(context),
                ),
            ],
          ),
        ),


//
        Expanded(
          child: SizedBox(
            height: 30,
          ),
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Text(
              'you_dont_have_any_account'.tr(),
              style: TextStyle(
                color: Color(0xff757575),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pushNamed(Routes.signup),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Text(
                  'register'.tr(),
                  style: TextStyle(
                    color: kColorPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  exception(String s) {}
}

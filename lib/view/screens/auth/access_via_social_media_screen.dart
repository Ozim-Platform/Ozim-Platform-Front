import 'dart:io';

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/components/bottom_modal_sheet.dart';
import 'package:charity_app/view/components/btn_ui_icon.dart';
import 'package:charity_app/view/components/text_field_ui.dart';
import 'package:charity_app/view/screens/auth/login_screen.dart';
import 'package:charity_app/view/screens/auth/permission_for_notification.dart';
import 'package:charity_app/view/screens/auth/register_screen.dart';
import 'package:charity_app/view/screens/other/privacy_policy_screen.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/widgets/app_bar_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> logOutGoogle() async {
  try {
    await googleSignIn.disconnect();
  } catch (e) {}
  try {
    await FirebaseAuth.instance.signOut();
  } catch (e) {}
}

class AccessViaSocialMediaScreen extends StatefulWidget {
  @override
  _AccessViaSocialMediaScreen createState() => _AccessViaSocialMediaScreen();
}

class _AccessViaSocialMediaScreen extends State<AccessViaSocialMediaScreen> {
  ApiProvider _apiProvider = new ApiProvider();
  UserData _userData = new UserData();

  bool _isSignIn = false;
  User _user;

  bool _isLoading = false;
  bool _isLoadingFacebook = false;

  bool showSocial = false;

  TextEditingController emailController = new TextEditingController();
  TextEditingController emailController2 = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  void initState() {
    checkSocialSignIn();
    super.initState();
  }

  void checkSocialSignIn() {
    final RemoteConfig remoteConfig = RemoteConfig.instance;
    showSocial = remoteConfig.getBool("show_social_sign_in");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/image/auth_background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: widgetAppBarTitle(context),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: SizeConfig.screenHeight,
                width: SizeConfig.screenWidth,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80),
                        child: Container(
                            child: SvgPicture.asset(
                          'assets/svg/logo.svg',
                        )),
                      ),
                      SizedBox(height: SizeConfig.calculateBlockVertical(30.0)),
                      FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 80,
                          ),
                          child: SvgPicture.asset(
                            'assets/svg/family.svg',
                            width: SizeConfig.calculateBlockHorizontal(318),
                            height: SizeConfig.calculateBlockVertical(318),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(
                            SizeConfig.calculateBlockHorizontal(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Platform.isIOS && showSocial
                                ? BtnUIIcon(
                                    height:
                                        SizeConfig.calculateBlockVertical(45),
                                    isLoading: false,
                                    textColor: Colors.white,
                                    color: AppColor.primary,
                                    text: getTranslated(context, 'via_apple'),
                                    icon: SvgPicture.asset(
                                        'assets/svg/auth/apple.svg'),
                                    onTap: () async {
                                      if (Platform.isAndroid) {
                                        ToastUtils.toastInfoGeneral(
                                            "Работает только в приложении для iOS",
                                            context);
                                      } else {
                                        loginViaApple();
                                      }
                                    },
                                  )
                                : const SizedBox.shrink(),
                            Platform.isIOS && showSocial
                                ? SizedBox(
                                    height:
                                        SizeConfig.calculateBlockVertical(15.0))
                                : const SizedBox.shrink(),
                            if (showSocial)
                              BtnUIIcon(
                                height: SizeConfig.calculateBlockVertical(45),
                                isLoading: _isSignIn,
                                textColor: Colors.white,
                                color: AppColor.google,
                                text: getTranslated(context, 'via_google'),
                                icon: SvgPicture.asset(
                                    'assets/svg/auth/google.svg'),
                                onTap: () {
                                  if (_user != null) {
                                    print(_user.toString());
                                    gotoNextScreen(_user);
                                  } else {
                                    loginViaGoogle();
                                  }
                                },
                              ),
                            if (showSocial)
                              SizedBox(
                                  height:
                                      SizeConfig.calculateBlockVertical(15.0)),
                            // if (showSocial)
                            //   BtnUIIcon(
                            //     height: SizeConfig.calculateBlockVertical(45),
                            //     isLoading: _isLoadingFacebook,
                            //     textColor: Colors.white,
                            //     color: AppColor.sometimes,
                            //     text: getTranslated(context, 'via_facebook'),
                            //     icon: SvgPicture.asset('assets/svg/auth/facebook.svg'),
                            //     onTap: () {
                            //       loginViaFacebook();
                            //       //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
                            //     },
                            //   ),
                            if (showSocial)
                              SizedBox(
                                  height:
                                      SizeConfig.calculateBlockVertical(15.0)),
                            BtnUIIcon(
                              height: SizeConfig.calculateBlockVertical(45),
                              isLoading: false,
                              textColor: Colors.white,
                              color: AppColor.gmail,
                              text: getTranslated(context, 'via_email'),
                              icon:
                                  SvgPicture.asset('assets/svg/auth/gmail.svg'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                              },
                            ),
                            SizedBox(
                                height:
                                    SizeConfig.calculateBlockVertical(20.0)),
                          ],
                        ),
                      ),
                      StreamBuilder(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            User user = FirebaseAuth.instance.currentUser;
                            _user = user;
                            //print('${user.displayName} Email ${user.email}');
                            return Text('');
                          }
                          return Text('');
                        },
                      ),
                      // const SizedBox(height: 32.0),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: SizeConfig.calculateBlockVertical(10.0),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                // HomeScreen()),
                                PrivacyPolicyScreen()),
                      ),
                      child: Opacity(
                        opacity: 0.5,
                        child: Text(
                          getTranslated(context, 'confidential'),
                          style: TextStyle(
                            fontSize: SizeConfig.calculateTextSize(14),
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _forgotPassword(context) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: const Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (builder) {
          return forgotPassModalSheet(context);
        });
    // _auth.sendPasswordResetEmail(email: email);
  }

  _sendEmail() async {
    String email = emailController2.text;
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (exeption) {
      ToastUtils.toastInfoGeneral(exeption.toString(), context);
      return false;
    }
    ToastUtils.toastInfoGeneral('Вам отправлено письмо на почту', context);
    Navigator.of(context).pop();
  }

  Widget forgotPassModalSheet(BuildContext context) {
    return BottomModalSheet(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            24.0, 24.0, 24.0, MediaQuery.of(context).viewInsets.bottom),
        child: new Column(
          children: [
            TextFieldUI(
              controller: emailController2,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              inputAction: TextInputAction.done,
              text: getTranslated(context, 'email'),
              hintText: getTranslated(context, 'send_reset_pass_email'),
            ),
            SizedBox(height: SizeConfig.calculateBlockVertical(25)),
            BtnUIIcon(
              height: 55,
              isLoading: _isLoading,
              textColor: Colors.white,
              color: AppColor.gmail,
              text: getTranslated(context, 'send_email'),
              icon: SvgPicture.asset('assets/svg/auth/gmail.svg'),
              onTap: () {
                if (checkTextFieldEmptyOrNot2(context)) {
                  _sendEmail();
                }
              },
            ),
            SizedBox(height: SizeConfig.calculateBlockVertical(25)),
          ],
        ),
      ),
    );
  }

  Widget rejectBottomModalSheet(BuildContext context) {
    return BottomModalSheet(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            24.0, 24.0, 24.0, MediaQuery.of(context).viewInsets.bottom),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFieldUI(
              controller: emailController,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              inputAction: TextInputAction.done,
              text: getTranslated(context, 'email'),
              hintText: getTranslated(context, 'email_low'),
            ),
            SizedBox(height: SizeConfig.calculateBlockVertical(5)),
            TextFieldUI(
              controller: passwordController,
              obscureText: true,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              inputAction: TextInputAction.done,
              text: getTranslated(context, 'password'),
              hintText: getTranslated(context, 'password_low'),
            ),
            SizedBox(height: SizeConfig.calculateBlockVertical(10)),
            GestureDetector(
              onTap: () {
                _forgotPassword(context);
              },
              child: Text(
                getTranslated(context, 'forgot_password'),
                style: TextStyle(
                    color: AppColor.sometimes,
                    decoration: TextDecoration.underline,
                    fontSize: 16),
              ),
            ),
            SizedBox(height: SizeConfig.calculateBlockVertical(10)),
            BtnUIIcon(
              height: 55,
              isLoading: _isLoading,
              textColor: Colors.white,
              color: AppColor.gmail,
              text: getTranslated(context, 'via_email'),
              icon: SvgPicture.asset('assets/svg/auth/gmail.svg'),
              onTap: () {
                if (checkTextFieldEmptyOrNot(context)) {
                  _signInWithEmailAndPassword();
                }
              },
            ),
            SizedBox(height: SizeConfig.calculateBlockVertical(10)),
          ],
        ),
      ),
    );
  }

  bool checkTextFieldEmptyOrNot(BuildContext context) {
    if (passwordController.text.isEmpty) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'password_is_empty'), context);
      return false;
    }
    if (passwordController.text.length < 6) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'password_less_six'), context);
      return false;
    }
    if (emailController.text.isEmpty) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'email_is_empty'), context);
      return false;
    }
    bool emailValid = emailRegExp.hasMatch(emailController.text.trim());
    if (!emailValid) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'email_not_valid'), context);
      return false;
    }
    return true;
  }

  bool checkTextFieldEmptyOrNot2(BuildContext context) {
    if (emailController2.text.isEmpty) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'email_is_empty'), context);
      return false;
    }
    bool emailValid = emailRegExp.hasMatch(emailController.text.trim());
    if (!emailValid) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'email_not_valid'), context);
      return false;
    }
    return true;
  }

  Future<void> gotoNextScreen(User user) async {
    _apiProvider
        .authorization(user.email ?? "")
        .then((value) => {
              // print(value.auth_token),
              if (value.auth_token != null)
                {
                  _userData.setToken(value.auth_token),
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PermissionForNotification())),
                }
              else if (value.error == "Создайте аккаунт")
                {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterScreen(
                            username: user.displayName ?? "",
                            email: user.email ?? "",
                            password: "",
                          )))
                }
            })
        .catchError((onError) {
      print(onError, level: 1);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RegisterScreen(
            username: user.displayName ?? "",
            email: user.email ?? "",
            password: "",
          ),
        ),
      );
    }).whenComplete(() => {});
  }

  Future<void> loginViaApple() async {
    setState(() {
      _isSignIn = true;
    });
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    if (appleCredential == null) {
      setState(() {
        _isSignIn = false;
      });
    } else {
      final oAuthProvider = OAuthProvider('apple.com');
      final oCredential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(oCredential);
      if (userCredential != null) {
        setState(() {
          _isSignIn = false;
        });
        String displayName;
        if (appleCredential.givenName != null) {
          displayName = appleCredential.givenName;
          if (appleCredential.familyName != null) {
            displayName += ' ${appleCredential.familyName}';
          }
        }
        final userEmail = appleCredential.email ??
            userCredential.additionalUserInfo.profile['email'];
        User userData = userCredential.user;
        if (displayName != null) {
          await userData.updateDisplayName(displayName);
        }
        if (userEmail != null) {
          await userData.updateEmail(userEmail);
        }
        _authorize(FirebaseAuth.instance.currentUser);
      } else {
        ToastUtils.toastErrorGeneral('Ошибка авторизации', context);
      }
      // gotoNextScreen(userData);
    }
  }

  Future<void> loginViaGoogle() async {
    setState(() {
      _isSignIn = true;
    });
    final user = await googleSignIn.signIn();
    if (user == null) {
      setState(() {
        _isSignIn = false;
      });
    } else {
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User userData = userCredential.user;
      if (userData != null) {
        setState(() {
          _isSignIn = false;
        });
        _authorize(userData);
      } else {
        ToastUtils.toastErrorGeneral('Ошибка авторизации', context);
      }
      // gotoNextScreen(userData);
    }
  }

  // Future<void> loginViaFacebook() async {
  //   setState(() {
  //     _isLoadingFacebook = true;
  //   });
  //   FacebookLogin facebookLogin = FacebookLogin();
  //   final result = await facebookLogin.logIn(['email']);
  //   if (result != null) {
  //     final token = result.accessToken.token;
  //     final graphResponse = await http.get(Uri.parse(
  //         'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));
  //     var profile = jsonDecode(graphResponse.body);
  //     //print(graphResponse.body);
  //     switch (result.status) {
  //       case FacebookLoginStatus.loggedIn:
  //         final credential = FacebookAuthProvider.credential(token);
  //         _auth.signInWithCredential(credential);
  //         _apiProvider
  //             .authorization(profile['email'] ?? "")
  //             .then((value) => {
  //                   //print(value),
  //                   if (value.auth_token != null)
  //                     {
  //                       _userData.setToken(value.auth_token),
  //                       Navigator.of(context).push(
  //                           MaterialPageRoute(builder: (context) => PermissionForNotification())),
  //                     }
  //                   else if (value.error == "Создайте аккаунт")
  //                     {
  //                       Navigator.of(context).push(MaterialPageRoute(
  //                           builder: (context) => RegisterScreen(
  //                                 username: profile['name'] ?? "",
  //                                 email: profile['email'] ?? "",
  //                                 password: "",
  //                                 phoneNumber: "",
  //                               )))
  //                     }
  //                 })
  //             .catchError((onError) {
  //           //print(onError);
  //         }).whenComplete(() => {});
  //         break;
  //       case FacebookLoginStatus.cancelledByUser:
  //         ToastUtils.toastInfoGeneral("${FacebookLoginStatus.cancelledByUser}", context);
  //         break;
  //       case FacebookLoginStatus.error:
  //         ToastUtils.toastInfoGeneral("${FacebookLoginStatus.error}", context);
  //         break;
  //     }
  //   }
  //   setState(() {
  //     _isLoadingFacebook = false;
  //   });
  // }

  void _authorize(User user) {
    try {
      _apiProvider
          .authorization(user.email ?? "")
          .then((value) => {
                if (value.success != null || value.error == null)
                  {
                    _userData.setToken(value.auth_token),
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PermissionForNotification())),
                  }
                else
                  {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterScreen(
                              username: user.displayName ?? "",
                              email: user.email ?? "",
                              password: passwordController.text.toString(),
                            )))
                  }
              })
          .catchError((onError, trace) {
        print(onError, level: 1);
        // print(trace, level: 1);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RegisterScreen(
                  username: user.displayName ?? "",
                  email: user.email ?? "",
                  password: passwordController.text.toString(),
                )));
      }).whenComplete(() => {});
      setState(() {});
    } catch (ex) {
      print(ex, level: 1);
      ToastUtils.toastInfoGeneral('Exception: $ex', context);
    }
  }

  void _signInWithEmailAndPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final User user = (await _auth.signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text))
          .user;
      print(user);

      if (user != null) {
        _authorize(user);
      } else {
        setState(() {});
      }
    } catch (ex) {
      bool showError = true;
      switch (ex.code) {
        case "user-not-found":
          showError = false;
          _signUpWithEmailAndPassword(
              emailController.text, passwordController.text);
          break;
        case "wrong-password":
          break;
        default:
          break;
      }
      if (showError) {
        print(ex, level: 1);
        ToastUtils.toastInfoGeneral('Exception: $ex', context);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _signUpWithEmailAndPassword(email, password) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      if (user != null) {
        _authorize(user);
      } else {
        setState(() {});
      }
    } catch (ex) {
      print(ex, level: 1);
      ToastUtils.toastInfoGeneral('Exception: $ex', context);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

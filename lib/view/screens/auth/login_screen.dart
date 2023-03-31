import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/components/bottom_modal_sheet.dart';
import 'package:charity_app/view/components/btn_ui.dart';
import 'package:charity_app/view/components/btn_ui_icon.dart';
import 'package:charity_app/view/components/text_field_ui.dart';
import 'package:charity_app/view/screens/auth/login_viewmodel.dart';
import 'package:charity_app/view/screens/auth/permission_for_notification.dart';
import 'package:charity_app/view/screens/auth/register_screen.dart';
import 'package:charity_app/view/screens/other/hide_keyboard_widget.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:charity_app/view/widgets/app_bar_auth.dart';
import 'package:charity_app/view/widgets/custom/getWidgetLogoHorizontal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    print(_size.height);
    print(_size.width);
    final _padding = MediaQuery.of(context).padding;
    final _height =
        _size.height - kToolbarHeight - _padding.bottom - _padding.top;

    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) => Material(
        child: HideKeyboardWidget(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/login_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: widgetAppBarTitle(context),
              body: Container(
                width: _size.width,
                height: _height,
                alignment: Alignment.center,
                constraints: BoxConstraints(maxWidth: 550),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: _size.width,
                      height: _height,
                      padding: EdgeInsets.fromLTRB(
                          SizeConfig.calculateBlockHorizontal(10),
                          0,
                          SizeConfig.calculateBlockHorizontal(10),
                          SizeConfig.calculateBlockVertical(33)),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: SvgPicture.asset('assets/svg/welcome.svg',
                                height: SizeConfig.calculateBlockVertical(200)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: SizeConfig.calculateBlockHorizontal(25),
                        right: SizeConfig.calculateBlockHorizontal(25),
                      ),
                      child: ListView(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.calculateBlockHorizontal(40),
                            ),
                            child: Align(
                                alignment: Alignment.center,
                                child: _size.height < 600
                                    ? Container(
                                        height: 18,
                                        child: getWidgetLogoHorizontal,
                                      )
                                    : getWidgetLogoHorizontal),
                          ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(
                                  _size.height > 600 ? 25 : 8)),
                          Text(
                            getTranslated(context, 'enter'),
                            style: TextStyle(
                                // fontFamily: 'Arial',
                                fontSize: SizeConfig.calculateTextSize2(
                                    _size.height > 600 ? 30.0 : 21),
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(10)),
                          _size.height > 600
                              ? TextField(
                                  controller: model.emailController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: getTranslated(context, 'email'),
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          SizeConfig.calculateTextSize2(14),
                                      // fontFamily: 'Arial',
                                    ),
                                    prefixIcon: SvgPicture.asset(
                                      'assets/svg/icons/mail.svg',
                                      width:
                                          SizeConfig.calculateBlockHorizontal(
                                              24),
                                      height:
                                          SizeConfig.calculateBlockVertical(24),
                                      fit: BoxFit.scaleDown,
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 25,
                                  child: TextField(
                                    controller: model.emailController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: getTranslated(context, 'email'),
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.calculateTextSize2(14),
                                      ),
                                      prefixIconConstraints: BoxConstraints(
                                        minHeight: 15,
                                        minWidth: 32,
                                        maxWidth: 32,
                                        maxHeight: 18,
                                      ),
                                      prefixIcon: SvgPicture.asset(
                                        'assets/svg/icons/mail.svg',
                                        fit: BoxFit.scaleDown,
                                      ),
                                      enabledBorder: new UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: new UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(10)),
                          _size.height > 600
                              ? TextField(
                                  obscureText: _obscure,
                                  controller: model.passwordController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText:
                                        getTranslated(context, 'password'),
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          SizeConfig.calculateTextSize2(14),
                                      // fontFamily: 'Arial',
                                    ),
                                    prefixIcon: SvgPicture.asset(
                                      'assets/svg/icons/lock.svg',
                                      width:
                                          SizeConfig.calculateBlockHorizontal(
                                              24),
                                      height:
                                          SizeConfig.calculateBlockVertical(24),
                                      fit: BoxFit.scaleDown,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () =>
                                          setState(() => _obscure = !_obscure),
                                      icon: SvgPicture.asset(
                                        'assets/image/eye.svg',
                                        width:
                                            SizeConfig.calculateBlockHorizontal(
                                                24),
                                        height:
                                            SizeConfig.calculateBlockVertical(
                                                24),
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 30,
                                  child: TextField(
                                      obscureText: _obscure,
                                      controller: model.passwordController,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText:
                                            getTranslated(context, 'password'),
                                        hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              SizeConfig.calculateTextSize2(14),
                                        ),
                                        prefixIconConstraints: BoxConstraints(
                                          minHeight: 15,
                                          minWidth: 32,
                                          maxWidth: 32,
                                          maxHeight: 18,
                                        ),
                                        prefixIcon: SvgPicture.asset(
                                          'assets/svg/icons/lock.svg',
                                          width: SizeConfig
                                              .calculateBlockHorizontal(24),
                                          height:
                                              SizeConfig.calculateBlockVertical(
                                                  24),
                                          fit: BoxFit.scaleDown,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () => setState(
                                              () => _obscure = !_obscure),
                                          icon: SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: SvgPicture.asset(
                                              'assets/image/eye.svg',
                                              width: SizeConfig
                                                  .calculateBlockHorizontal(24),
                                              height: SizeConfig
                                                  .calculateBlockVertical(24),
                                              fit: BoxFit.scaleDown,
                                            ),
                                          ),
                                        ),
                                        enabledBorder: new UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: new UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                      )),
                                ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(15)),
                          InkWell(
                            onTap: () {
                              _forgotPassword(context, model);
                            },
                            child: Text(
                              getTranslated(context, 'forgot_password'),
                              style: TextStyle(
                                  fontSize: SizeConfig.calculateTextSize2(15.0),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(120)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  SizeConfig.calculateBlockHorizontal(15.0),
                            ),
                            child: BtnUI(
                              height: SizeConfig.calculateBlockVertical(55),
                              isLoading: _isLoading,
                              textColor: Colors.white,
                              color: AppThemeStyle.primaryColor,
                              text:
                                  getTranslated(context, 'enter').toUpperCase(),
                              onTap: () {
                                if (_isLoading) return;
                                if (checkTextFieldEmptyOrNot(context, model)) {
                                  _signInWithEmailAndPassword(model);
                                }
                              },
                            ),
                          ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(16)),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  SizeConfig.calculateBlockHorizontal(15.0),
                            ),
                            child: BtnUI(
                              height: SizeConfig.calculateBlockVertical(55),
                              isLoading: false,
                              textColor: Colors.white,
                              color: AppThemeStyle.orangeColor,
                              text: getTranslated(context, 'register')
                                  .toUpperCase(),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(50)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }

  void _signInWithEmailAndPassword(LoginViewModel viewModel) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userCredentials = await viewModel.login();
      _authorize(userCredentials.user, viewModel);
    } catch (ex) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'check_your_inputs'), context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _authorize(User user, LoginViewModel viewModel) async {
    viewModel.authroize(
      user: user,
      onSuccess: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PermissionForNotification()));
      },
      onError: () {
        ToastUtils.toastInfoGeneral(
            getTranslated(context, 'check_your_inputs'), context);
      },
    );
  }

  bool checkTextFieldEmptyOrNot(BuildContext context, LoginViewModel model) {
    if (model.passwordController.text.isEmpty) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'password_is_empty'), context);
      return false;
    }
    if (model.passwordController.text.length < 6) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'password_less_six'), context);
      return false;
    }
    if (model.emailController.text.isEmpty) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'email_is_empty'), context);
      return false;
    }
    bool emailValid = emailRegExp.hasMatch(model.emailController.text.trim());
    if (!emailValid) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'email_not_valid'), context);
      return false;
    }
    return true;
  }

  void _forgotPassword(BuildContext context, LoginViewModel model) {
    ///этот поп ломал контекст
    // Navigator.of(context).pop();
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(
            top: const Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (builder) {
          return forgotPassModalSheet(context, model);
        });
    // _auth.sendPasswordResetEmail(email: email);
  }

  Widget forgotPassModalSheet(BuildContext context, LoginViewModel model) {
    return BottomModalSheet(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          SizeConfig.calculateBlockHorizontal(24.0),
          SizeConfig.calculateBlockVertical(24.0),
          SizeConfig.calculateBlockHorizontal(24.0),
          SizeConfig.calculateBlockVertical(
              MediaQuery.of(context).viewInsets.bottom),
        ),
        child: new Column(
          children: [
            TextFieldUI(
              controller: model.emailController,
              onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              inputAction: TextInputAction.done,
              text: getTranslated(context, 'email'),
              hintText: getTranslated(context, 'send_reset_pass_email'),
            ),
            SizedBox(height: SizeConfig.calculateBlockVertical(25)),
            BtnUIIcon(
              height: SizeConfig.calculateBlockVertical(55),
              isLoading: _isLoading,
              textColor: Colors.white,
              color: AppColor.gmail,
              text: getTranslated(context, 'send_email'),
              icon: SvgPicture.asset('assets/svg/auth/gmail.svg'),
              onTap: () {
                if (checkTextFieldEmptyOrNot2(context, model)) {
                  model.sendEmail(context);
                }
              },
            ),
            SizedBox(height: SizeConfig.calculateBlockVertical(25)),
          ],
        ),
      ),
    );
  }

  bool checkTextFieldEmptyOrNot2(BuildContext context, LoginViewModel model) {
    if (model.emailController.text.isEmpty) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'email_is_empty'), context);
      return false;
    }
    bool emailValid = emailRegExp.hasMatch(model.emailController.text.trim());
    if (!emailValid) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'email_not_valid'), context);
      return false;
    }
    return true;
  }
}

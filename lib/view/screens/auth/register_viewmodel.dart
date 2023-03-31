import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/model/user/user_type.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/view/screens/auth/permission_for_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked/stacked.dart';

import 'access_via_social_media_screen.dart';

class RegisterViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();
  UserData _userData = new UserData();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String type;

  int _radioValue2 = 0;
  int get radioValue2 => _radioValue2;

  List<UserType> _listType;
  List<UserType> get listType => _listType;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool dataAgree = false;
  // var _phoneController = new MaskedTextController(text: '', mask: '+0-000-000-00-00');
  var _phoneFormatter = new MaskTextInputFormatter(
      mask: '+#-###-###-##-##', filter: {"#": RegExp(r'[0-9]')});

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get phoneController => _phoneController;

  MaskTextInputFormatter get phoneFormatter => _phoneFormatter;

  void dataAgreeClick() {
    dataAgree = !dataAgree;
    notifyListeners();
  }

  void handleRadioValueChange(int value) {
    _radioValue2 = value;
    notifyListeners();
  }

  Future<void> initStates(String username, String email, String password,) async {
    _usernameController.text = username;
    _emailController.text = email;
    // _phoneController.text = phoneNumber;
    _passwordController.text = password;
    notifyListeners();
  }

  Future<void> getUserType(BuildContext context) async {
    _isLoading = true;
    _apiProvider
        .getUserType()
        .then((value) => {_listType = value})
        .catchError((onError) {
      ToastUtils.toastErrorGeneral('$onError', context);
    }).whenComplete(() => {
              _isLoading = false,
              notifyListeners(),
            });
  }

  Future<void> registration(BuildContext context) async {
    if (!dataAgree) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'agree_personal_warning'), context);
      return;
    }
    if (checkTextFieldEmptyOrNot(context)) {
      _isLoading = true;
      notifyListeners();
      switch (_radioValue2) {
        case 0:
          type = "parent";
          break;
        case 1:
          type = "specialist";
          break;
        case 2:
          type = "organization";
          break;
        default:
          type = "parent";
          break;
      }
      var lang = await _userData.getLang();
      lang = lang == "uz" ? "kz" : "ru";

      String email = _emailController.text.trim();
      Map<String, dynamic> data = Map<String, dynamic>();
      // data["phone"] = _phoneController.text;
      data["name"] = _usernameController.text.trim();
      data["email"] = email;
      data["password"] = _passwordController.text.trim();
      data["type"] = type;
      data["language"] = lang;

      _apiProvider.registration(data).then((value) async {
        if (value.error == null || value.error.isEmpty) {
          if (_auth.currentUser != null) {
            _auth.currentUser.updatePassword(_passwordController.text);
            try {
              await googleSignIn.disconnect();
            } catch (e) {}
          } else {
            await _auth.createUserWithEmailAndPassword(
                email: email, password: _passwordController.text);
          }
          ToastUtils.toastInfoGeneral("${value.success}", context);
          auth(context, email);
          //gotoNextPage(context)
        } else
          ToastUtils.toastInfoGeneral("${value.error}", context);
      }).catchError((onError) {
        ToastUtils.toastErrorGeneral('$onError', context);
      }).whenComplete(() => {
            _isLoading = false,
            notifyListeners(),
          });
    }
  }

  Future<void> auth(BuildContext context, String username) async {
    _apiProvider
        .authorization(username)
        .then((value) => {
              _userData.setToken(value.auth_token),
              gotoNextPage(context),
              //print(value)
            })
        .catchError((onError) {
      ToastUtils.toastErrorGeneral("Error $onError", context);
    }).whenComplete(() => {});
  }

  Future<void> gotoNextPage(BuildContext context) async {
    // _userData.setUsername(_usernameController.text.toString().trim());
    // _userData.setEmail(_emailController.text.toString().trim());
    // _userData.setPassword(_passwordController.text.toString().trim());
    // _userData.setPhoneNumber(_phoneController.text.toString().trim());
    _userData.setUserType(type??'');
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PermissionForNotification()));
  }

  bool checkTextFieldEmptyOrNot(BuildContext context) {
    if (_usernameController.text.isEmpty) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'username_is_empty'), context);
      return false;
    }
    if (_passwordController.text.isEmpty) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'password_is_empty'), context);
      return false;
    }
    if (_passwordController.text.length < 6) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'password_less_six'), context);
      return false;
    }
    if (_emailController.text.isEmpty) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'email_is_empty'), context);
      return false;
    }
    bool emailValid = emailRegExp.hasMatch(_emailController.text.trim());
    if (!emailValid) {
      ToastUtils.toastInfoGeneral(
          getTranslated(context, 'email_not_valid'), context);
      return false;
    }
    // if (_phoneController.text.isEmpty) {
    //   ToastUtils.toastInfoGeneral(getTranslated(context, 'phone_number_is_empty'), context);
    //   return false;
    // }
    return true;
  }
}

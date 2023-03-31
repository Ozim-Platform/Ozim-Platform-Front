import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();
  UserData _userData = new UserData();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  Future<UserCredential> login() async {
    return _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(), password: _passwordController.text.trim());
  }

  Future<void> authroize({
    @required User user,
    @required VoidCallback onSuccess,
    @required VoidCallback onError,
  }) async {
    try {
      final response = await _apiProvider.authorization(user.email ?? "");
      if (response.success != null || response.error == null) {
        _userData.setToken(response.auth_token);
        onSuccess();
      } else {
        onError();
      }
    } catch (e) {
      onError();
    }
    return _apiProvider.authorization(user.email ?? "");
  }

  Future<void> sendEmail(BuildContext context) async {
    String email = _emailController.text.trim();
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (exeption) {
      ToastUtils.toastInfoGeneral(exeption.toString(), context);
      return false;
    }

    ToastUtils.toastInfoGeneral('Вам отправлено письмо на почту', context);
    Navigator.of(context).pop();
  }
}

import 'package:charity_app/localization/language.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';


class WelcomeViewModel extends BaseViewModel {
  int _selectLanguage = 0;
  Language language;
  var langCode = ["uz", "ru"];

  Future<void> changeLanguage(BuildContext context, int position) async {
    _selectLanguage = position;

    Utils.changeLanguage(context, langCode[_selectLanguage]);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}

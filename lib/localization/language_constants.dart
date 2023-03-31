import 'package:charity_app/localization/user_data.dart';
import 'package:flutter/material.dart';

import 'demo_localizations.dart';

//languages code
const String RUSSIAN = 'ru';
const String KAZAK_KZ = 'kz';
const String KAZAK_UZ = 'uz';

Future<Locale> setLocale(String languageCode) async {
  UserData _userData = UserData();
  _userData.setLang(languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  UserData _userData = UserData();
  String languageCode = (await _userData.getLang()) ?? "ru";
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  switch (languageCode) {
    case KAZAK_UZ:
      return Locale(KAZAK_UZ, 'UZ');
    case KAZAK_KZ:
      return Locale(KAZAK_UZ, 'UZ');
    case RUSSIAN:
      return Locale(RUSSIAN, "RU");
    default:
      return Locale(RUSSIAN, 'RU');
  }
}

String getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context).translate(key);
}

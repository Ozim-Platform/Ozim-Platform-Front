import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  // fontFamily: 'Arial',
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(color: Color(0xffF6F6FA)),
  primaryColor: Color.fromRGBO(98, 190, 184, 1),
  primaryColorBrightness: Brightness.light,
  accentColor: Color.fromRGBO(98, 190, 184, 1),
  backgroundColor: Color(0xffF6F6FA),
  scaffoldBackgroundColor: Color(0xffF6F6FA),
  cardColor: Color(0xffFFFFFF),
  buttonColor: Color(0xff333333),
  focusColor: Color.fromRGBO(98, 190, 184, 1),
  primaryIconTheme: IconThemeData(color: Color.fromRGBO(98, 190, 184, 1)),
  bottomAppBarColor: Color.fromRGBO(98, 190, 184, 1),
  cupertinoOverrideTheme: CupertinoThemeData(
    barBackgroundColor: Color(0xffECECEF),
    primaryColor: Color.fromRGBO(98, 190, 184, 1),
  ),
);

TextTheme textTheme = TextTheme(
    headline1: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xff325ECD)),
    headline2: TextStyle(
        fontSize: 20, color: Color(0xff325ECD), fontWeight: FontWeight.w600),
    headline5: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    bodyText2: TextStyle(fontSize: 14.0));

class AppThemeStyle {
  AppThemeStyle._();

  // static Color primaryColor2 = Color.fromRGBO(98, 190, 184, 1);
  static Color primaryColor = Color(0xff7BCBC5);
  static Color primaryColor2 = Color(0xff46BCB3);
  static Color pinkColor = Color(0xffF08390);
  static Color orangeColor = Color(0xffff1bc62);
  static Color colorSuccess = Color(0xff00BA88);
  static Color colorGrey = Color(0xffACB1B4);

  static BorderRadiusGeometry topRadius = const BorderRadius.only(
      topLeft: const Radius.circular(30.0),
      topRight: const Radius.circular(30.0));

  static TextStyle appBarStyle20 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.1,
  );

  static TextStyle appBarStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.1,
  );

  static TextStyle appBarStyle17 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle appBarStyle16 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.1,
  );

  static TextStyle headingColorStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headline1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static TextStyle titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle resendCodeStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleFormStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle titleStyleColor = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleSuccess = TextStyle(
    fontSize: 14,
    color: colorSuccess,
    fontWeight: FontWeight.w400,
  );

  static TextStyle buttonWhite = TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static TextStyle boldTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  static TextStyle buttonWhite14 = TextStyle(
    fontSize: 14.0,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  // static TextStyle normalTextWhite = TextStyle(
  //     fontSize: 16.0,
  //     color: Colors.white,
  //     fontWeight: FontWeight.w500,
  //     fontFamily: 'Arial');

  static TextStyle buttonNormal =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Arial');

  static TextStyle listStyle = TextStyle(
    fontSize: 20,
    // fontFamily: 'Arial',
    fontWeight: FontWeight.bold,
  );

  static TextStyle text14_600 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static TextStyle text10_400 = TextStyle(
    fontSize: 10,
    // fontFamily: 'Arial',
    fontWeight: FontWeight.w400,
  );

  static TextStyle titleListGrey = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );

  static TextStyle subtitleList = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle subtitleList2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleListPrimary = TextStyle(
    fontSize: 14,
    color: Colors.grey,
    fontWeight: FontWeight.w500,
    // fontFamily: 'Arial',
  );

  static TextStyle title14 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle title12 = TextStyle(
    fontSize: 13,
    // fontFamily: 'Arial',
    fontWeight: FontWeight.w500,
  );
  static TextStyle title12Grey = TextStyle(
      fontSize: 13,
      // fontFamily: 'Arial',
      fontWeight: FontWeight.w500,
      color: Colors.grey);

  static TextStyle titleColor14 = TextStyle(
    fontSize: 14,
    // fontFamily: 'Arial',
    // color: primaryColor,
    fontWeight: FontWeight.w500,
  );

  static TextStyle linkStyle = TextStyle(
    fontSize: 14,
    // fontFamily: 'Arial',
    // color: Color(0xff333333),
    fontWeight: FontWeight.w500,
  );

  static TextStyle balance = TextStyle(
    fontSize: 24,
    // fontFamily: 'Arial',
    fontWeight: FontWeight.w700,
  );

  ///refactor
  static TextStyle headerPrimaryColor = TextStyle(
    // fontFamily: 'Arial',
    fontSize: 23,
    letterSpacing: 0.1,
    color: Constants.mainTextColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headerPrimaryColorWithoutSize = TextStyle(
    // fontFamily: 'Arial',
    letterSpacing: 0.1,
    color: Constants.mainTextColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headerWhite = TextStyle(
      // fontFamily: 'Arial',
      fontSize: SizeConfig.calculateTextSize(23),
      letterSpacing: 0.1,
      fontWeight: FontWeight.bold,
      color: Colors.white);

  static TextStyle subHeader = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(16),
    letterSpacing: 0.1,
    color: Color(0XFF7F878B),
    fontWeight: FontWeight.w400,
  );

  static TextStyle subHeaderLigther = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(16),
    letterSpacing: 0.1,
    color: Constants.ligtherMainTextColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subHeaderBigger = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(18),
    letterSpacing: 0.1,
    color: Constants.mainTextColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subHeaderPrimary = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(16),
    letterSpacing: 0.1,
    color: AppThemeStyle.primaryColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subHeaderWhite = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(16),
    letterSpacing: 0.1,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static TextStyle subHeaderWhiteBigger = TextStyle(
    // fontFamily: 'Arial',
    fontSize: 19,
    letterSpacing: 0.1,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static TextStyle normalText = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(16),
    color: Constants.mainTextColor,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normalTextNoColor = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(16),
    fontWeight: FontWeight.normal,
  );

  static TextStyle normalTextWitoutSize = TextStyle(
    // fontFamily: 'Arial',
    color: Constants.mainTextColor,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normalTextItalic = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(16),
    color: Constants.ligtherMainTextColor,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
  );

  static TextStyle normalTextSmaller = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(15),
    color: Constants.mainTextColor,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normalTextSmallerNoColor = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(15),
    fontWeight: FontWeight.normal,
  );

  static TextStyle normalTextSmallerPrimary = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(15),
    color: AppColor.primary,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normalTextSmallerLigther = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(14),
    color: Constants.ligtherMainTextColor,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normalTextLighter = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(16),
    color: Constants.ligtherMainTextColor,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normalTextWhite = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(16),
    color: Colors.white,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normalTextWhiteBigger = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(17),
    color: Colors.white,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normalTextBigger = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(18),
    color: Constants.mainTextColor,
    fontWeight: FontWeight.normal,
  );

  static TextStyle ligtherText = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(15),
    color: Constants.ligtherMainTextColor,
    fontWeight: FontWeight.normal,
  );

  static TextStyle ligtherSmallerText = TextStyle(
    // fontFamily: 'Arial',
    fontSize: SizeConfig.calculateTextSize(14),
    color: Constants.ligtherMainTextColor,
    fontWeight: FontWeight.normal,
  );
}

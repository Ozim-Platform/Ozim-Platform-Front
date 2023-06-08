import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizeConfig {
  // values from figma
  static double mockupWidth = 390;
  static double mockupHeight = 844;

  // values from device
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;
  static double screenPercentage;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth / 100 - _safeAreaHorizontal / 100);
    safeBlockVertical = (screenHeight / 100 - _safeAreaVertical / 100);
  }

  static double getFullWidth() {
    return screenWidth;
  }

  static double textScaleFactor() {
    log((screenWidth / mockupWidth).toString());
    return screenWidth / mockupWidth;
  }

  static double calculateTextSize(int fontSize) {
    return fontSize.sp;
  }

  static double calculateTextSize2(double fontSize) {
    return fontSize.sp;
  }

  static double calculateBlockVertical(double blockSize) {
    return blockSize.h;
  }

  static double calculateBlockHorizontal(double blockSize) {
    return blockSize.h;
  }
}

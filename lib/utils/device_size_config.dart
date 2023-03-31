import 'package:flutter/cupertino.dart';

class SizeConfig {
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
    // screenWidth=375;
    // screenHeight=812;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth / 100 - _safeAreaHorizontal / 100);
    safeBlockVertical = (screenHeight / 100 - _safeAreaVertical / 100);
  }

  static double getFullWidth() {
    return screenWidth;
  }

  static double calculateTextSize(int fontSize) {
    return fontSize.toDouble();
  }

  static double calculateTextSize2(double fontSize) {
    return fontSize;
  }

  static double calculateBlockVertical(double blockSize) {
    return blockSize;
  }

  static double calculateBlockHorizontal(double blockSize) {
    return blockSize;
  }
}

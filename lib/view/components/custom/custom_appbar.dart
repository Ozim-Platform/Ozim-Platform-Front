import 'package:charity_app/utils/device_size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar appBarPage(
    {BuildContext context,
    String appBarTitle,
    String appBarIncome,
    PreferredSizeWidget bottom,
    bool existArrow}) {
  return AppBar(
    elevation: 1.0,
    shadowColor: Colors.black45,
    automaticallyImplyLeading: false,
    leading: existArrow
        ? CupertinoButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              size: 22,
              color: Color(0xff758084),
            ),
          )
        : SizedBox(),
    centerTitle: true,
    title: Column(
      children: [
        Opacity(
          opacity: 0.5,
          child: Text(
            appBarTitle,
            style: TextStyle(
              fontSize: SizeConfig.calculateTextSize(18),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: SizeConfig.calculateBlockVertical(30)),
        Text(
          appBarIncome,
          style: TextStyle(
            fontSize: 24,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.calculateBlockVertical(20)),
      ],
    ),
    bottom: bottom,
  );
}

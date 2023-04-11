import 'package:charity_app/localization/language_constants.dart';
// import 'package:charity_app/model/child/child.dart';
// import 'package:charity_app/utils/device_size_config.dart';
// import 'package:charity_app/utils/formatters.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customAppbarForQuestionaire({
  @required BuildContext context,
  @required String appBarTitle,
  @required String appBarIncome,
  @required String appBarIncome2,
  controller,
  VoidCallback callback,
  int age,
}) {
  final _size = MediaQuery.of(context).size;

  return AppBar(
    elevation: 0.0,
    centerTitle: true,
    backgroundColor: Color(
      0XFFF1BC62,
    ),
    title: Column(
      children: [
        if (appBarTitle != null) ...[
          Text(
            appBarTitle,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 23,
            ),
          ),
        ],
      ],
    ),
    leading: CupertinoButton(
      onPressed: () => callback(),
      child: Icon(
        Icons.arrow_back_ios,
        size: 25,
        color: Colors.white,
        semanticLabel: getTranslated(context, "back"),
      ),
    ),
    bottom: PreferredSize(
      preferredSize: Size(
        _size.width,
        73.0,
      ),
      child: Container(
        width: _size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(
              40,
            ),
            topRight: const Radius.circular(
              40,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8,
              ),
              child: Text(
                appBarIncome,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF778083),
                  fontWeight: FontWeight.w500,
                  fontSize: 23,
                ),
              ),
            ),
            Text(
              appBarIncome2,
              // textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0XFF777F83),
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

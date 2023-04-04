import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/child/child.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/formatters.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar customAppbarForQuestionaire({
  @required BuildContext context,
  @required String appBarTitle,
  @required String appBarIncome,
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
        Text(
          appBarTitle,
          style: TextStyle(
            fontSize: SizeConfig.calculateTextSize(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        if (appBarIncome != null) ...[
          Text(
            appBarIncome,
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
      preferredSize: Size.fromHeight(70.0), // here the desired height

      child: Container(
        height: 64.0,
        width: _size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
        ),
        decoration: BoxDecoration(
          // color: Color(0XFFf4f4f4),
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
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
              ),
              child: Text(
                getTranslated(context, "questionaire_result"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF778083),
                  fontWeight: FontWeight.w500,
                  fontSize: 23,
                ),
              ),
            ),
            Text(
              getTranslated(context, "for_age") +
                  " "     +
                  getAgeString(
                    context,
                    ChildAge.fromInteger(age),
                  ),
              // "для возраста 6 месяцев",
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

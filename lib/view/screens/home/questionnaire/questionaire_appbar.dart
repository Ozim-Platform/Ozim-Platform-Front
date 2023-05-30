import 'package:charity_app/localization/language_constants.dart';
// import 'package:charity_app/model/child/child.dart';
// import 'package:charity_app/utils/device_size_config.dart';
// import 'package:charity_app/utils/formatters.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget customAppbarForQuestionaire({
  @required BuildContext context,
  @required String appBarTitle,
  @required String appBarIncome,
  String appBarIncome2,
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
        70.0.w,
      ),
      child: Container(
        width: _size.width,
        padding: EdgeInsets.symmetric(
          horizontal: 32.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              40.w,
            ),
            topRight: Radius.circular(
              40.w,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: appBarIncome2 == null ? 43.0.w : 25.2.w,
                bottom: 4.3.w,
              ),
              child: Text(
                appBarIncome,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0XFF778083),
                  fontWeight: FontWeight.w500,
                  fontSize: 23.sp,
                ),
              ),
            ),
            appBarIncome2 != null
                ? Text(
                    appBarIncome2,
                    style: TextStyle(
                      color: Color(0XFF777F83),
                      fontWeight: FontWeight.w400,
                      fontSize: 16.sp,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    ),
  );
}

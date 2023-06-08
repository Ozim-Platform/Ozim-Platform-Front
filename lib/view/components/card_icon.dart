import 'dart:math';

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CardIcon extends StatefulWidget {
  final String operation;
  final String iconPath;
  final String category;
  final GestureTapCallback onTap;

  const CardIcon(
      {Key key, this.operation, this.iconPath, this.onTap, this.category});

  @override
  _CardIcon createState() => _CardIcon();
}

class _CardIcon extends State<CardIcon> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = SizeConfig.screenWidth;
    String category = getTranslated(context, widget.category);
    final pattern = RegExp('^(Видео уроки|Бейне сабақтар)\$');
    String toDisplay =
        pattern.hasMatch(category) ? category.replaceAll(' ', '\n') : category;
    final double containerSize = max(
      screenWidth / 6,
      73,
    );

    final double iconSize = MediaQuery.of(context).size.width > 500 ? 80 : 60;

    return InkWell(
      splashColor: Colors.transparent,
      onTap: widget.onTap,
      child: IgnorePointer(
        child: Container(
          height: 95.h,
          width: containerSize.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.h),
            color: colorDecider(widget.category),
          ),
          padding: EdgeInsets.only(
            bottom: 5.07.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              iconDecider(widget.iconPath, iconSize.h),
              FittedBox(
                fit: BoxFit.contain,
                child: Padding(
                  padding: EdgeInsets.only(left: 5.0.h, right: 5.0.h),
                  child: Text(
                    toDisplay,
                    maxLines: 2,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: "Inter",
                      fontSize: 15.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color colorDecider(String category) {
    Color color = const Color.fromARGB(0, 255, 255, 255);
    switch (category) {
      case 'diagnosis':
        color = const Color(0XFF8DC9C4);
        break;
      case 'skill':
        color = const Color(0XFFF1BC62);
        break;
      case 'link':
        color = const Color(0XFFBDD280);
        break;
      case 'service_provider':
        color = const Color(0XFFBDD280);
        break;
      case 'right':
        color = const Color(0XFF8DC9C4);
        break;
      case 'inclusion':
        color = const Color(0XFF8DC9C4);
        break;
      case 'article':
        color = const Color(0XFFF1BC62);
        break;
      case 'forum':
        color = const Color(0XFFF1BC62);
        break;
      case 'for_parent':
        color = const Color(0XFFF1BC62);
        break;
      default:
        throw Exception('Invalid category: $category');
    }
    return color;
  }

  Widget iconDecider(String iconPath, double iconSize) {
    Widget icon;

    switch (iconPath) {
      case 'assets/svg/services/diagnosis.svg':
        icon = SvgPicture.asset(
          iconPath,
          height: iconSize,
        );
        break;
      case 'assets/svg/services/skill.svg':
        icon = Padding(
          padding: EdgeInsets.only(top: 7.0.h),
          child: SvgPicture.asset(
            iconPath,
            height: iconSize - 15.h,
          ),
        );
        break;
      case 'assets/svg/services/link.svg':
        icon = SvgPicture.asset(
          iconPath,
          height: iconSize,
        );
        break;
      case 'assets/svg/services/service_provider.svg':
        icon = SvgPicture.asset(
          iconPath,
          height: iconSize,
        );
        break;
      case 'assets/svg/services/right.svg':
        icon = SvgPicture.asset(
          iconPath,
          height: iconSize,
        );
        break;
      case 'assets/svg/services/inclusion.svg':
        icon = SvgPicture.asset(
          iconPath,
          height: iconSize,
        );
        break;
      case 'assets/svg/services/article.svg':
        icon = SvgPicture.asset(
          iconPath,
          height: iconSize,
        );
        break;
      case 'assets/svg/services/forum.svg':
        icon = SvgPicture.asset(
          iconPath,
          height: iconSize,
        );
        break;
      case 'assets/svg/services/for_parent.svg':
        icon = SvgPicture.asset(
          iconPath,
          height: iconSize,
        );
        break;
      default:
        throw Exception('Invalid category: $iconPath');
    }
    return icon;
  }
}

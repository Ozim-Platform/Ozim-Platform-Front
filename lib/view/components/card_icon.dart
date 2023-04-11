import 'dart:math';

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:flutter/material.dart';
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

    final pattern = RegExp('^Видео уроки\$');
    String toDisplay =
        pattern.hasMatch(category) ? category.replaceAll(' ', '\n') : category;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: widget.onTap,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth / 23),
            color: colorDecider(widget.category),
          ),
          padding: EdgeInsets.all(4),
          width: screenWidth / 4,
          height: screenWidth / 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SvgPicture.asset(
                widget.iconPath,
              ),
              Text(
                toDisplay,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: "Inter",
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
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
}

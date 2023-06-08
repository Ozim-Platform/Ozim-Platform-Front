import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ignore: must_be_immutable
class BadgeMessagesNotice extends StatefulWidget {
  final int count;
  final int shape;
  final bool isBottomBar;
  static const int oval = 0;
  static const int ellipsis = 1;

  BadgeMessagesNotice(
    this.count, {
    Key key,
    this.shape = BadgeMessagesNotice.oval,
    this.isBottomBar = false,
  }) : super(key: key);

  @override
  State<BadgeMessagesNotice> createState() => _BadgeMessagesNoticeState();
}

class _BadgeMessagesNoticeState extends State<BadgeMessagesNotice> {
  @override
  Widget build(BuildContext context) {
    if (widget.isBottomBar) {
      return widget.count != 0
          ? SvgPicture.asset(
              "assets/svg/icons/has_message.svg",
              width: 9.w,
              height: 9.w,
              color: Color(0XFF79BCB7),
            )
          : Container();
    } else
      return Container(
        width:
            (this.widget.shape == BadgeMessagesNotice.oval && widget.count != 0)
                ? 30
                : 25,
        height:
            (this.widget.shape == BadgeMessagesNotice.oval && widget.count != 0)
                ? 30
                : 15,
        alignment: Alignment.center,
        child: Text(
          widget.count != 0
              ? (widget.count > 9 ? "9+" : widget.count.toString())
              : "",
          style: TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
        ),
        decoration: widget.count != 0
            ? BoxDecoration(
                color: AppThemeStyle.orangeColor,
                borderRadius: BorderRadius.circular(15))
            : null,
      );
  }
}

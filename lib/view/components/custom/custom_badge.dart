import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/material.dart';

class BadgeMessagesNotice extends StatelessWidget {
  final int count;
  final int shape;

  static const int oval = 0;
  static const int ellipsis = 1;

  const BadgeMessagesNotice(this.count,
      {Key key, this.shape = BadgeMessagesNotice.oval})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (count == 0) return SizedBox();

    return Container(
      width: this.shape == BadgeMessagesNotice.oval ? 30 : 25,
      height: this.shape == BadgeMessagesNotice.oval ? 30 : 15,
      alignment: Alignment.center,
      child: Text(
        count > 9 ? "9+" : count.toString(),
        style: TextStyle(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
      ),
      decoration: BoxDecoration(
          color: AppThemeStyle.orangeColor,
          borderRadius: BorderRadius.circular(15)),
    );
  }
}

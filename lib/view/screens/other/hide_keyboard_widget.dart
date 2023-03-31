import 'package:charity_app/utils/utils.dart';
import 'package:flutter/material.dart';

class HideKeyboardWidget extends StatelessWidget {
  const HideKeyboardWidget({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Utils.hideKeyboard(context);
      },
      child: child,
    );
  }
}

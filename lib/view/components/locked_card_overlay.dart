import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LockedCardOverlay extends StatelessWidget {
  const LockedCardOverlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          15.0,
        ),
        color: const Color.fromARGB(204, 255, 255, 255),
      ),
      height: 75,
      child: Center(
        child: SvgPicture.asset(
          'assets/svg/icons/lock_icon.svg',
        ),
      ),
    );
  }
}

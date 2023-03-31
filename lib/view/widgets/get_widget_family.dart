import 'package:charity_app/utils/device_size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

Widget getWidgetLogo = Container(
    child: SvgPicture.asset(
  'assets/svg/family.svg',
  width: SizeConfig.calculateBlockHorizontal(318),
  height: SizeConfig.calculateBlockVertical(318),
));

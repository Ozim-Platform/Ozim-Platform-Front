import 'package:charity_app/view/theme/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

///@deprecated
class CustomTabs extends StatelessWidget {
  const CustomTabs({
    Key key,
    @required this.category,
  }) : super(key: key);

  final List category;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(40),
            topRight: const Radius.circular(40),
          ),
        ),
        child: TabBar(
          tabs: List<Widget>.generate(category.length, (int index) {
            var item = category[index];
            return new Tab(text: item.name);
          }),
          isScrollable: true,
          labelPadding:
              const EdgeInsets.only(left: 30.0, right: 30.0, top: 3, bottom: 3),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.4),
          labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          indicator: MaterialIndicator(
              height: 4,
              topLeftRadius: 4,
              topRightRadius: 4,
              bottomLeftRadius: 0,
              bottomRightRadius: 0,
              tabPosition: TabPosition.bottom,
              color: AppColor.primary),
        ),
      ),
    );
  }
}

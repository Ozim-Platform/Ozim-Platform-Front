import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

AppBar customAppbar(
    {@required BuildContext context,
    @required String appBarTitle,
    @required String appBarIncome,
    @required List category,
    bool existArrow = true,
    bool withTabs = true,
    controller}) {
  final _size = MediaQuery.of(context).size;

  return AppBar(
    elevation: 1.0,
    shadowColor: Colors.black45,
    centerTitle: true,
    title: Column(
      children: [
        Opacity(
          opacity: 0.5,
          child: Text(
            appBarTitle,
            style: TextStyle(
              fontSize: SizeConfig.calculateTextSize(18),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (appBarIncome != null) ...[
          Text(
            appBarIncome,
            style: AppThemeStyle.headerPrimaryColor,
          ),
        ],
      ],
    ),
    leading: existArrow
        ? CupertinoButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: Color(0xff758084),
              semanticLabel: getTranslated(context, "back"),
            ),
          )
        : const SizedBox.shrink(),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(70.0), // here the desired height
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 64.0,
          width: _size.width,
          padding: const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: const BorderRadius.only(
              topLeft: const Radius.circular(40),
              topRight: const Radius.circular(40),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 55.0,
              ),
              if (withTabs)
                Column(
                  children: [
                    Container(
                      width: _size.width,
                      child: TabBar(
                        controller: controller,
                        tabs: List<Widget>.generate(
                          category.length,
                          (int index) {
                            var item = category[index].name;
                            return new Tab(text: item);
                          },
                        ),
                        isScrollable: true,
                        labelPadding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                        ),
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white.withOpacity(0.4),
                        labelStyle: AppThemeStyle.subHeaderWhiteBigger.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle:
                            AppThemeStyle.subHeaderWhiteBigger.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                        indicator: MaterialIndicator(
                          height: 4,
                          topLeftRadius: 4,
                          topRightRadius: 4,
                          bottomLeftRadius: 0,
                          bottomRightRadius: 0,
                          tabPosition: TabPosition.bottom,
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                    if (controller != null)
                      DottedTabbarIndicator(
                        tabController: controller,
                      )
                  ],
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class DottedTabbarIndicator extends StatefulWidget {
  final TabController tabController;

  DottedTabbarIndicator({@required this.tabController});

  @override
  _DottedTabbarIndicatorState createState() => _DottedTabbarIndicatorState();
}

class _DottedTabbarIndicatorState extends State<DottedTabbarIndicator> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_handleTabSelection);
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = widget.tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.tabController.length,
        (index) => Container(
          width: 6,
          height: 6,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: index == _currentIndex
                ? Colors.white
                : Color.fromARGB(102, 255, 255, 255),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

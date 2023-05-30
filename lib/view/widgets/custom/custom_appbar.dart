import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  double startX;
  double sensitivity = 0.01;
  return AppBar(
    elevation: 1.0,
    shadowColor: Colors.black45,
    centerTitle: true,
    toolbarHeight: 40.w,
    title: Column(
      children: [
        Opacity(
          opacity: 0.5,
          child: Text(
            appBarTitle,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (appBarIncome != null) ...[
          Text(
            appBarIncome,
            style: AppThemeStyle.headerPrimaryColor.copyWith(
              fontSize: 18.sp,
            ),
          ),
        ],
      ],
    ),
    leading: existArrow
        ? CupertinoButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios,
              size: 25.w,
              color: Color(0xff758084),
              semanticLabel: getTranslated(context, "back"),
            ),
          )
        : const SizedBox.shrink(),
    bottom: PreferredSize(
      preferredSize: MediaQuery.of(context).size.width > 500
          ? Size.fromHeight(
              100.0.w,
            )
          : Size.fromHeight(
              60.0.w,
            ),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: _size.width,
          height: 47.7.w,
          padding: EdgeInsets.symmetric(horizontal: 38.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.w),
              topRight: Radius.circular(40.w),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (withTabs)
                Column(
                  children: [
                    Container(
                      width: _size.width,
                      alignment: Alignment.center,
                      child: Listener(
                        onPointerDown: (event) {
                          startX = event.position.dx;
                        },
                        onPointerMove: (event) {
                          double newX = event.position.dx;
                          double offset =
                              ((startX - newX) * sensitivity).clamp(-1.0, 1.0);
                          // if (!controller.indexIsChanging) {
                          //   controller.offset = offset;
                          // }
                          if (offset == 1.0 &&
                              controller.index < controller.length - 1) {
                            double distance = startX - newX;
                            if (distance >= 50) {
                              // check if the distance swiped is greater than or equal to swipeDistance
                              controller.animateTo(controller.index + 1,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.easeIn);
                              startX = newX;
                            }
                          }
                          if (offset == -1.0 && controller.index > 0) {
                            double distance = newX - startX;
                            if (distance >= 50) {
                              // check if the distance swiped is greater than or equal to swipeDistance
                              controller.animateTo(controller.index - 1,
                                  duration: Duration(seconds: 1),
                                  curve: Curves.easeIn);
                              startX = newX;
                            }
                          }
                        },
                        child: TabBar(
                          controller: controller,
                          isScrollable: true,
                          physics: ScrollPhysics(),
                          tabs: List<Widget>.generate(
                            category.length,
                            (int index) {
                              var item = category[index].name;
                              return Tab(
                                text: item,
                                height: 30.w,
                              );
                            },
                          ),
                          labelPadding: EdgeInsets.only(
                            left: 20.0.w,
                            right: 20.0.w,
                            top: 5.w,
                          ),
                          indicatorSize: TabBarIndicatorSize.label,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white.withOpacity(0.4),
                          labelStyle:
                              AppThemeStyle.subHeaderWhiteBigger.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 19.sp,
                          ),
                          unselectedLabelStyle:
                              AppThemeStyle.subHeaderWhiteBigger.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 19.sp,
                          ),
                          indicator: MaterialIndicator(
                            height: 4,
                            topLeftRadius: 4,
                            topRightRadius: 4,
                            bottomLeftRadius: 0,
                            bottomRightRadius: 0,
                            tabPosition: TabPosition.top,
                            color: AppColor.primary,
                          ),
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
    _currentIndex = widget.tabController.index;
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
          width: 6.w,
          height: 6.w,
          margin: EdgeInsets.only(left: 4.h, right: 4.h, bottom: 4.h),
          decoration: BoxDecoration(
            color: index == _currentIndex
                ? Colors.white
                : Color.fromARGB(
                    102,
                    255,
                    255,
                    255,
                  ),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

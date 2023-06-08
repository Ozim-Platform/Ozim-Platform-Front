import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/screens/home/home_without_drawer_screen.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import 'drawer/cabinet_drawer.dart';
import 'drawer/drawer_user_controller.dart';
import 'home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  DrawerIndex drawerIndex;

  @override
  initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  onOpen(bool isOpen) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) {
        if (model.isLoadingCategory || model.isLoadingBanner) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        return SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            body: DrawerUserController(
              screenIndex: drawerIndex,
              drawerWidth: MediaQuery.of(context).size.width * 0.80,
              onDrawerCall: (DrawerIndex drawerIndexData) {},
              menuView: Semantics(
                label: getTranslated(context, "menu"),
                child: SvgPicture.asset(
                  'assets/svg/icons/menu.svg',
                  width: 24.w,
                  height: 24.w,
                  fit: BoxFit.scaleDown,
                ),
              ),
              username: model.username,
              screenView: HomeWithoutDrawerScreen(model.banner),
              drawerIsOpen: onOpen,
            ),
          ),
        );
      },
      onModelReady: (model) {
        model.initData();
        model.getCategory();
        Constants.listnablemodels.add(model);
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }

  Widget customAppbar(BuildContext context) {
    return AppBar(
      title: Text(
        '',
        style: AppThemeStyle.appBarStyle,
      ),
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: SvgPicture.asset(
            'assets/svg/Icon_notification_outline.svg',
            height: 24.h,
            width: 24.h,
          ),
        )
      ],
    );
  }
}

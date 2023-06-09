import 'dart:async';

import 'package:charity_app/custom_icons_icons.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/post_url_helper.dart';
import 'package:charity_app/view/components/notification_button.dart';
import 'package:charity_app/view/screens/home/favourite/favourite_screen.dart';
import 'package:charity_app/view/screens/home/general_search_screen.dart';
import 'package:charity_app/view/screens/home/home_screen.dart';
import 'package:charity_app/view/screens/home/profile/profile_screen.dart';
import 'package:charity_app/view/screens/other/notification/notification_screen.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uni_links/uni_links.dart';

class BottomNavigation extends StatefulWidget {
  bool isFromNotification;
  int childId;
  BottomNavigation({this.isFromNotification = false, this.childId});

  @override
  BottomNavigationState createState() => BottomNavigationState();

  static void setItem(BuildContext context, int itemId) {
    BottomNavigationState state =
        context.findAncestorStateOfType<BottomNavigationState>();
    if (state != null) {
      state._onItemTap(itemId);
    }
  }
}

class BottomNavigationState extends State<BottomNavigation> {
  static bool rebuild = false;
  bool _isFromNotification = false;
  int _childId = 0;

  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
  GlobalKey<ConvexAppBarState> _bottomAppBarKey =
      GlobalKey<ConvexAppBarState>();

  int selectedItem = 0;
  ApiProvider _apiProvider = new ApiProvider();
  List<Category> _category = [];
  List<Data> _folders = [];
  StreamSubscription _uriSub;
  RemoteMessage messageWhenTerminated;

  void _onItemTap(int index) async {
    if (index == 2) {
      var someValue = Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationScreen(),
        ),
      );

      someValue.then((value) {
        setState(
          () {
            selectedItem = 0;
            _bottomAppBarKey.currentState.animateTo(
              0,
            );
          },
        );
      });
    } else {
      setState(
        () {
          selectedItem = index;
        },
      );
    }
  }

  Future<void> getMessageWhenClosed() async {
    messageWhenTerminated =
        await FirebaseMessaging.instance.getInitialMessage();
    if (messageWhenTerminated != null) {
      if (messageWhenTerminated.data["child_id"] != null) {
        _isFromNotification = true;
        _childId = int.parse(messageWhenTerminated.data["child_id"]);
        selectedItem = 4;
        _bottomAppBarKey.currentState.animateTo(
          selectedItem,
        );
      }
    }
  }

  @override
  void initState() {
    _isFromNotification = widget.isFromNotification;
    _childId = widget.childId;

    getMessageWhenClosed();
    _uriSub = uriLinkStream.listen(
      (Uri link) {
        PostUrlHelper.handleUrl(link, context);
      },
      onError: (err) {
        // ignore
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        PostUrlHelper.handleUrl(initialUri, context);
      }
    });
    getCategory();
    getBookmarksFolders();
    if (_isFromNotification) {
      selectedItem = 4;
    }
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = <Widget>[
      HomeScreen(),
      GeneralSearchScreen(),
      NotificationScreen(),
      FavouriteScreen(folders: _folders),
      ProfileScreen(
        childId: _isFromNotification ? _childId : null,
      ),
    ];
    return Builder(
      builder: (BuildContext context) {
        Color color = Constants.ligtherMainTextColor;
        return Scaffold(
          body: tabs[selectedItem],
          bottomNavigationBar: ConvexAppBar(
            key: _bottomAppBarKey,
            style: TabStyle.reactCircle,
            top: -20,
            curve: Curves.easeInOut,
            curveSize: 75,
            height: 50.h,
            color: AppThemeStyle.colorGrey,
            activeColor: AppColor.primary,
            elevation: 0,
            backgroundColor: Colors.white,
            onTabNotify: (index) => true,
            items: [
              TabItem(
                icon: Icon(CustomIcons.home,
                    size: selectedItem == 0
                        ? (MediaQuery.of(context).size.width > 500 ? 40 : 31)
                        : (MediaQuery.of(context).size.width > 500 ? 30 : 23),
                    color: color,
                    semanticLabel: getTranslated(context, "on_main")),
                isIconBlend: true,
              ),
              TabItem(
                icon: Icon(CustomIcons.search,
                    size: selectedItem == 1
                        ? (MediaQuery.of(context).size.width > 500 ? 35 : 27)
                        : (MediaQuery.of(context).size.width > 500 ? 30 : 22),
                    color: color,
                    semanticLabel: getTranslated(context, "search_vo")),
                isIconBlend: true,
              ),
              TabItem(
                icon: NotificationButton(
                  size: 24.w,
                  icon: SvgPicture.asset(
                    "assets/svg/icons/messenger.svg",
                    width: 24.w,
                    height: 24.w,
                    fit: BoxFit.scaleDown,
                    color: color,
                  ),
                  isBottomBar: true,
                ),
              ),
              TabItem(
                icon: Icon(CustomIcons.favorite_outline,
                    size: selectedItem == 3
                        ? (MediaQuery.of(context).size.width > 500 ? 40 : 32)
                        : ((MediaQuery.of(context).size.width > 500 ? 35 : 26)),
                    color: color,
                    semanticLabel: getTranslated(context, "favourite")),
                isIconBlend: true,
              ),
              TabItem(
                icon: SvgPicture.asset(
                  "assets/svg/icons/profile.svg",
                  width: selectedItem == 4
                      ? (MediaQuery.of(context).size.width > 500 ? 10 : 32)
                      : ((MediaQuery.of(context).size.width > 500 ? 35 : 26)),
                  height: selectedItem == 4
                      ? (MediaQuery.of(context).size.width > 500 ? 10 : 32)
                      : ((MediaQuery.of(context).size.width > 500 ? 35 : 26)),
                  fit: BoxFit.scaleDown,
                  color: color,
                ),
                isIconBlend: true,
              ),
            ],
            initialActiveIndex: selectedItem,
            onTap: (int i) => {
              _onItemTap(i),
            },
          ),
        );
      },
    );
  }

  Widget customAppbar(BuildContext context) {
    return AppBar(
      title: Text(
        '',
        style: AppThemeStyle.appBarStyle,
      ),
      leading: IconButton(
        splashRadius: 20,
        icon: SvgPicture.asset(
          'assets/svg/icons/menu.svg',
          width: 24,
          height: 24,
          fit: BoxFit.scaleDown,
        ),
        // icon: Icon(Icons.menu_outlined),
        onPressed: () => {},
      ),
      elevation: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SvgPicture.asset('assets/svg/Icon_notification_outline.svg',
              height: 24, width: 24),
        )
      ],
    );
  }

  Future<void> getCategory() async {
    _apiProvider
        .getCategory()
        .then((value) => {
              setState(() {
                _category = value;
              }),
            })
        .catchError((error) {})
        .whenComplete(() => {});
  }

  Future<void> getBookmarksFolders() async {
    _apiProvider
        .getBookMarkFolders()
        .then((value) => {
              setState(() {
                _folders = value;
              }),
            })
        .catchError((error) {})
        .whenComplete(() => {});
  }

  @override
  void dispose() {
    _uriSub?.cancel();
    super.dispose();
  }
}

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/components/bottom_modal_sheet.dart';
import 'package:charity_app/view/components/notification_button.dart';
import 'package:charity_app/view/components/user_image.dart';
import 'package:charity_app/view/screens/home/article/article_screen.dart';
import 'package:charity_app/view/screens/home/diagnose/diagnose_screen.dart';
import 'package:charity_app/view/screens/home/drawer_pages/about_us.dart';
import 'package:charity_app/view/screens/home/drawer_pages/faq_screen.dart';
import 'package:charity_app/view/screens/home/drawer_pages/settings_screen.dart';
import 'package:charity_app/view/screens/home/favourite/favourite_screen.dart';
import 'package:charity_app/view/screens/home/for_mother/for_mother_screen.dart';
import 'package:charity_app/view/screens/home/forum/forum_screen.dart';
import 'package:charity_app/view/screens/home/inclusion/inclusion_screen.dart';
import 'package:charity_app/view/screens/home/resource/resource_screen.dart';
import 'package:charity_app/view/screens/home/rights/rights_screen.dart';
import 'package:charity_app/view/screens/home/service_provider/service_provider_screen.dart';
import 'package:charity_app/view/screens/home/skill/skill_screen.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:charity_app/view/widgets/exit_modal_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

import 'drawer_viewmodel.dart';

class CabinetDrawer extends StatelessWidget {
  const CabinetDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              backgroundColor: AppColor.primary,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: SizeConfig.calculateBlockHorizontal(10),
                    color: Colors.white,
                  ),
                  Container(
                    height: 153,
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 4),
                          child: NotificationButton(removePaddings: true),
                        ),
                        // SizedBox(
                        //     height: SizeConfig.calculateBlockVertical(50)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: SizeConfig.calculateBlockHorizontal(35)),
                            UserImage(
                              userUrl: model.avatar,
                              size: 70,
                            ),
                            SizedBox(
                                width: SizeConfig.calculateBlockHorizontal(10)),
                            Expanded(
                              child: Text(
                                model.username ?? '',
                                textAlign: TextAlign.start,
                                style: AppThemeStyle.subHeader,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: SizeConfig.calculateBlockVertical(30)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 30,
                            top: 25,
                            bottom: SizeConfig.calculateBlockVertical(30)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AboutUseScreen()));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        SizeConfig.calculateBlockVertical(10),
                                    left: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/info_icon.svg',
                                      color: Colors.white,
                                      height: 23,
                                      width: 23,
                                    ),
                                    SizedBox(
                                        width:
                                            SizeConfig.calculateBlockHorizontal(
                                                15)),
                                    Text(getTranslated(context, 'about_us'),
                                        style: AppThemeStyle.normalTextWhite),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                height: SizeConfig.calculateBlockVertical(5)),
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Divider(
                                height: 2,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(
                                height: SizeConfig.calculateBlockVertical(5)),
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {},
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.calculateBlockVertical(10),
                                    bottom:
                                        SizeConfig.calculateBlockVertical(10),
                                    left: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/svg/home_icon.svg',
                                        color: Colors.white),
                                    SizedBox(
                                        width:
                                            SizeConfig.calculateBlockHorizontal(
                                                10)),
                                    Text(getTranslated(context, 'home'),
                                        style: AppThemeStyle.normalTextWhite),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 42,
                                top: SizeConfig.calculateBlockVertical(10),
                                bottom: SizeConfig.calculateBlockVertical(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  getSubElement(context, model, 'diagnosis'),
                                  devider(),
                                  getSubElement(context, model, 'skill'),
                                  devider(),
                                  getSubElement(context, model, 'link'),
                                  devider(),
                                  getSubElement(
                                      context, model, 'service_provider'),
                                  devider(),
                                  getSubElement(context, model, 'right'),
                                  devider(),
                                  getSubElement(context, model, 'for_parent'),
                                  devider(),
                                  getSubElement(context, model, 'inclusion'),
                                  devider(),
                                  getSubElement(context, model, 'article'),
                                  devider(),
                                  getSubElement(context, model, 'forum'),
                                  devider(),
                                  getSubElement(
                                      context, model, 'questionnaire'),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Divider(
                                height: 2,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(
                                height: SizeConfig.calculateBlockVertical(20)),
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FavouriteScreen(
                                          needBackArrow: true,
                                          folders: model.folders,
                                        )));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        SizeConfig.calculateBlockVertical(10),
                                    left: 10),
                                child: Row(
                                  children: [
                                    // Icon(FlevaIcons.bookmark_outline,
                                    //     color: Colors.white),
                                    SizedBox(
                                        width:
                                            SizeConfig.calculateBlockHorizontal(
                                                10)),
                                    Text(
                                      getTranslated(context, 'favourite'),
                                      style: AppThemeStyle.normalTextWhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                height: SizeConfig.calculateBlockVertical(5)),
                            InkWell(splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FaqScreen()));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        SizeConfig.calculateBlockVertical(10),
                                    left: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/question_icon.svg',
                                        color: Colors.white),
                                    SizedBox(
                                        width:
                                            SizeConfig.calculateBlockHorizontal(
                                                10)),
                                    Text(
                                      getTranslated(context, 'faq'),
                                      style: AppThemeStyle.normalTextWhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                height: SizeConfig.calculateBlockVertical(5)),
                            InkWell(splashColor: Colors.transparent,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        SettingsScreen(model)));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        SizeConfig.calculateBlockVertical(10),
                                    left: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/settings_icon.svg',
                                        color: Colors.white),
                                    SizedBox(
                                        width:
                                            SizeConfig.calculateBlockHorizontal(
                                                10)),
                                    Text(
                                      getTranslated(context, 'settings'),
                                      style: AppThemeStyle.normalTextWhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                height: SizeConfig.calculateBlockVertical(5)),
                            InkWell(splashColor: Colors.transparent,
                              onTap: () {
                                _modalInfo(context, model);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom:
                                        SizeConfig.calculateBlockVertical(10),
                                    left: 10),
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/svg/exit_icon.svg',
                                        color: Colors.white),
                                    SizedBox(
                                        width:
                                            SizeConfig.calculateBlockHorizontal(
                                                10)),
                                    Text(
                                      getTranslated(context, 'close'),
                                      style: AppThemeStyle.normalTextWhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                height: SizeConfig.calculateBlockVertical(5)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(25))
                ],
              ),
            ),
        onViewModelReady: (model) {
          model.initData();
          model.getBookmarksFolders();
          model.getCategory();
          Constants.listnablemodels.add(model);
        },
        viewModelBuilder: () => DrawerViewModel());
  }

  SizedBox devider() {
    return SizedBox(height: SizeConfig.calculateBlockVertical(10));
  }

  InkWell getSubElement(
      BuildContext context, DrawerViewModel model, String element) {
    Widget widget;
    List<Category> category = getCategoryOfType(model.category, element);
    switch (element) {
      case 'diagnosis':
        widget = DiagnoseScreen(category: category);
        break;
      case 'skill':
        widget = SkillScreen(category: category);
        break;
      case 'link':
        widget = ResourceScreen(category: category);
        break;
      case 'service_provider':
        widget = ServiceProviderScreen(category: category);
        break;
      case 'right':
        widget = RightScreen(category: category);
        break;
      case 'for_parent':
        widget = ForMotherScreen(category: category);
        break;
      case 'inclusion':
        widget = InclusionScreen(category: category);
        break;
      case 'article':
        widget = ArticleScreen(
          category: category,
          existArrow: true,
        );
        break;
      case 'forum':
        widget = ForumScreen(existArrow: true);
        break;
      // case 'questionnaire':
      //   widget = QuestionnaireCategoryScreen(category: category);
      //   break;
    }

    return InkWell(splashColor: Colors.transparent,
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => widget));
      },
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(right: 11),
              child: SvgPicture.asset(
                "assets/image/dot.svg",
                color: Colors.white,
              )),
          Text(getTranslated(context, element),
              style: AppThemeStyle.normalTextWhite),
        ],
      ),
    );
  }

  void _modalInfo(BuildContext context, DrawerViewModel model) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: const Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (builder) {
        return BottomModalSheet(
          child: Wrap(
            children: [
              ExitModalView(
                onTapExit: () {
                  model.logOut(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

enum DrawerIndex {
  HOME,
  Services,
  Help,
  Share,
  Message,
  Settings,
  About,
  Calendar,
  Report
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.svgName,
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String svgName;
  DrawerIndex index;
}

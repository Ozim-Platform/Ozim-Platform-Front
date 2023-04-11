import 'dart:io';

import 'package:charity_app/data/in_app_purchase/in_app_purchase_data_repository.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/components/custom/custom_radio_widget.dart';
import 'package:charity_app/view/screens/home/drawer/drawer_viewmodel.dart';
import 'package:charity_app/view/screens/home/drawer_pages/settings_viewmodel.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:charity_app/view/widgets/blurred_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

import 'change_username_screen.dart';

class SettingsScreen extends StatelessWidget {
  final DrawerViewModel model;

  SettingsScreen(this.model);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text('', style: AppThemeStyle.appBarStyle),
            leading: IconButton(
              iconSize: 18.0,
              splashRadius: 20,
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 30),
                    InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          model.pickFile();
                        },
                        child: model.processloadingImage
                            ? CupertinoActivityIndicator(
                                radius: 25,
                              )
                            : Semantics(
                                label: getTranslated(context, 'add_user_photo'),
                                child: BlurredAvatar(
                                    imageUrl: model.imageUrl, size: 70.0))),
                    SizedBox(width: 10),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChangeUsernameScreen()));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.username,
                            textAlign: TextAlign.start,
                            style: AppThemeStyle.listStyle,
                          ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(10)),
                          Text(
                            getTranslated(context, 'change_username'),
                            textAlign: TextAlign.start,
                            style: AppThemeStyle.titleListPrimary,
                          ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(10)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.calculateBlockVertical(40)),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated(context, 'choose_language'),
                        textAlign: TextAlign.start,
                        style: AppThemeStyle.listStyle,
                      ),
                      SizedBox(height: SizeConfig.calculateBlockVertical(10)),
                      Divider(
                        height: 2,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                      SizedBox(height: SizeConfig.calculateBlockVertical(20)),
                      CustomRadioWidget(
                        title: getTranslated(context, 'kz_language'),
                        value: 1,
                        groupValue: model.radioValue,
                        onChanged: model.handleRadioValueChange,
                        width: 25,
                        height: 25,
                        titleStyle: AppThemeStyle.subtitleList,
                        titleInStart: true,
                      ),
                      CustomRadioWidget(
                        value: 2,
                        groupValue: model.radioValue,
                        onChanged: model.handleRadioValueChange,
                        title: getTranslated(context, 'ru_language'),
                        titleStyle: AppThemeStyle.subtitleList,
                        titleInStart: true,
                        width: 25,
                        height: 25,
                      ),
                      SizedBox(height: SizeConfig.calculateBlockVertical(30)),
                      Text(
                        getTranslated(context, 'settings_notification'),
                        textAlign: TextAlign.start,
                        style: AppThemeStyle.listStyle,
                      ),
                      SizedBox(height: SizeConfig.calculateBlockVertical(10)),
                      Divider(
                        height: 2,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                      SizedBox(height: SizeConfig.calculateBlockVertical(20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated(context, 'new_comment'),
                            textAlign: TextAlign.start,
                            style: AppThemeStyle.subtitleList,
                          ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(20)),
                          CupertinoSwitch(
                              value: model.newComment,
                              activeColor: AppColor.primary,
                              onChanged: (newValue) {
                                model.newCommentFunc(newValue);
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated(context, 'reply_to_comment'),
                            textAlign: TextAlign.start,
                            style: AppThemeStyle.subtitleList,
                          ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(20)),
                          CupertinoSwitch(
                              value: model.replyComment,
                              activeColor: AppColor.primary,
                              onChanged: (newValue) {
                                model.replyCommentFunc(newValue);
                              }),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated(context, 'give_permission'),
                            textAlign: TextAlign.start,
                            style: AppThemeStyle.subtitleList,
                          ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(20)),
                          CupertinoSwitch(
                              value: model.permissionNotification,
                              activeColor: AppColor.primary,
                              onChanged: (newValue) {
                                model.permissionNotificationFunc(newValue);
                              }),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         // get user subscription id
                      //         if (Platform.isAndroid) {
                      //           launchUrl(
                      //             Uri.parse(
                      //                 "https://play.google.com/store/account/subscriptions?sku=${InAppPurchaseDataRepository().sku}&package=com.ozim.platform&pli=1"),
                      //             // "https://play.google.com/store/account/subscriptions?&package=com.ozim.platform&pli=1"),
                      //           );
                      //         } else {
                      //           launchUrl(
                      //             Uri.parse(
                      //                 "https://apps.apple.com/account/subscriptions"),
                      //           );
                      //         }
                      //       },
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text(
                      //             // getTranslated(context, 'unsubscribe'),
                      //             "отписаться",
                      //             textAlign: TextAlign.start,
                      //             style: AppThemeStyle.subtitleList,
                      //           ),
                      //           SizedBox(
                      //             height: SizeConfig.calculateBlockVertical(20),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      onViewModelReady: (model) => {model.setContext(context)},
      viewModelBuilder: () => SettingsViewModel(model),
    );
  }
}

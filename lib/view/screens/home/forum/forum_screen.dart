import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/forum/forum_sub_category.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/formatters.dart';
import 'package:charity_app/view/components/btn_ui.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/screens/home/forum/forum_viewmodel.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'forum_detail.dart';

class ForumScreen extends StatelessWidget {
  final bool existArrow;

  const ForumScreen({Key key, this.existArrow}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumViewModel>.reactive(
      builder: (context, model, child) => ModalProgressHUD(
        inAsyncCall: model.isLoading,
        color: Colors.white,
        dismissible: false,
        progressIndicator: CupertinoActivityIndicator(),
        child: Scaffold(
          backgroundColor: AppColor.primary,
          appBar: AppBar(
            toolbarHeight: 82.0,
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Column(
              children: [
                const SizedBox(
                  height: 42.0,
                ),
                Text(
                  getTranslated(context, 'forum'),
                  style: AppThemeStyle.headerWhite.copyWith(
                    // fontFamily: 'Arial',
                    letterSpacing: .2,
                  ),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
            leading: existArrow
                ? Column(
                    children: [
                      IconButton(
                        iconSize: 25.0,
                        splashRadius: 20,
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  )
                : null,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(40), topRight: const Radius.circular(40)),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    color: AppColor.greyDisabled,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 30.0,
                      ),
                      child: getMainUI(model, context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          /*     bottomNavigationBar: ConvexAppBar(
            elevation: 0.2,
            style: TabStyle.fixedCircle,
            color: Colors.black45,
            activeColor: AppColor.primary,
            backgroundColor: Colors.white,
            items: [
              TabItem(icon: Icon(Icons.add, size: 32, color: Colors.white)),
            ],
            initialActiveIndex: 0,
            onTap: _addNewForum,
          ),*/
        ),
      ),
      onModelReady: (model) {
        model.fetchAllData();
      },
      viewModelBuilder: () => ForumViewModel(),
    );
  }

  Widget getMainUI(ForumViewModel model, BuildContext context) {
    if (model.isLoading) {
      return Container();
    }
    if (model.forumSubCategory != null && model.forumCategory != null) {
      return ListView.builder(
          itemCount: model.forumCategory.length,
          shrinkWrap: true,
          itemBuilder: (context, i) {
            List<ForumSubCategory> list = [];
            list.addAll(model.forumSubCategory.where((element) {
              return element.category.sysName == model.forumCategory[i].sysName;
            }));
            if (list.length > 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BtnUI(
                    height: 45.0,
                    align: Alignment.centerLeft,
                    isLoading: false,
                    textColor: Colors.white,
                    color: AppColor.primary,
                    text: model.forumCategory[i].name,
                    onTap: () {},
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(5.0)),
                  ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 5),
                        child: InkWell(
                          onTap: () {
                            ForumSubCategory forum = list[i];
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => ForumDetailScreen(
                                          title: forum.name,
                                          subcategory: forum.sysName,
                                          forumSubCategory: forum,
                                        )))
                                .then((value) {
                              model.notifyListeners();
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      list[i].name,
                                      maxLines: 2,
                                      style: AppThemeStyle.normalText.copyWith(
                                        fontWeight: FontWeight.bold,
                                        // fontFamily: 'Arial',
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: Constants.ligtherMainTextColor,
                                  )
                                ],
                              ),
                              SizedBox(height: 6.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      list[i].record_count.toString() +
                                          " " +
                                          getTranslated(context, 'theme'),
                                      textAlign: TextAlign.start,
                                      style: AppThemeStyle.ligtherSmallerText.copyWith(
                                          // fontFamily: 'Arial',
                                          ),
                                    ),
                                  ),
                                  if (list[i].last_comment != null)
                                    Text(
                                      getTranslated(context, 'last_message') +
                                          ' ' +
                                          dateFormatter2(DateTime.fromMillisecondsSinceEpoch(
                                              list[i].last_comment * 1000)),
                                      textAlign: TextAlign.start,
                                      style: AppThemeStyle.ligtherSmallerText.copyWith(
                                          // fontFamily: 'Arial',
                                          ),
                                    ),
                                ],
                              ),
                              SizedBox(height: SizeConfig.calculateBlockVertical(5.0)),
                              Divider(
                                thickness: 1,
                                color: Constants.ligtherMainTextColor,
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return Container(child: EmptyData());
          });
    } else {
      return Container(child: EmptyData());
    }
  }
}

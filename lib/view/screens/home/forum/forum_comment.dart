import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/formatters.dart';
import 'package:charity_app/view/components/btn_ui.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/components/user_image.dart';
import 'package:charity_app/view/screens/home/forum/forum_add_screen.dart';
import 'package:charity_app/view/screens/home/forum/forume_comment_viewmodel.dart';
import 'package:charity_app/view/screens/home/forum/forume_detail_viewmodel.dart';
import 'package:charity_app/view/screens/home/resource/resource_screen.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:charity_app/view/widgets/app_bar_auth.dart';
import 'package:charity_app/view/widgets/avatar_iamge.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForumCommentScreen extends StatelessWidget {
  final forum;

  const ForumCommentScreen({Key key, this.forum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumCommentViewModel>.reactive(
      builder: (context, model, child) => ModalProgressHUD(
        inAsyncCall: model.isLoading,
        color: Colors.white,
        dismissible: false,
        progressIndicator: CupertinoActivityIndicator(),
        child: Scaffold(
          backgroundColor: AppColor.primary,
          appBar: widgetAppBarTitle(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(getTranslated(context, 'forum'),
                  style: AppThemeStyle.headerWhite),
              SizedBox(height: SizeConfig.calculateBlockVertical(30)),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(40),
                      topRight: const Radius.circular(40)),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Container(
                          //   width: double.infinity,
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 25, vertical: 15),
                          //   margin: const EdgeInsets.only(bottom: 10),
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     title,
                          //     style: AppThemeStyle.subHeaderWhite,
                          //   ),
                          //   decoration: BoxDecoration(
                          //       color: AppThemeStyle.primaryColor,
                          //       borderRadius: BorderRadius.circular(25)),
                          // ),
                          // Expanded(
                          //     child: BuilderList(
                          //         category: subcategory, model: model)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: ConvexAppBar(
            elevation: 0.2,
            style: TabStyle.reactCircle,
            color: Colors.black45,
            activeColor: AppColor.primary,
            backgroundColor: Colors.white,
            items: [
              TabItem(icon: Icon(Icons.add, size: 32, color: Colors.white)),
            ],
            initialActiveIndex: 0,
            onTap: (int i) => {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) =>
              //         ForumAddScreen(subCategory: subcategory))),
            },
          ),
        ),
      ),
      onModelReady: (model) {
        // model.getForumCategory(subcategory);
      },
      viewModelBuilder: () => ForumCommentViewModel(),
    );
  }
}

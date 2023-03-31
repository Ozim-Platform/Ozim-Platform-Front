import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/links.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/components/custom/custom_container.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/screens/common/custom_tab_controller.dart';
import 'package:charity_app/view/screens/home/resource/resource_viewmodel.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:charity_app/view/widgets/custom/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ResourceScreen extends StatelessWidget {
  final List<Category> category;

  ResourceScreen({Key key, @required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResourceViewModel>.reactive(
      builder: (context, model, child) => CustomTabController(
        title: getTranslated(context, 'link'),
        list: category,
        model: model,
        buildMethod: getMainUI,
      ),
      onModelReady: (model) {
        model.getLinks(category);
      },
      viewModelBuilder: () => ResourceViewModel(),
    );
  }

  Widget getMainUI(BuildContext context, ResourceViewModel model,
      String category, List<Category> allCategories) {
    return CustomContainer(child: getListUI(context, model, category));
  }

  getListUI(context, ResourceViewModel model, String category) {
    if (model.isLoading) {
      return CupertinoActivityIndicator();
    } else {
      if (model.links?.data != null && model.links.data.length > 0) {
        List list = getListOfInstancesByCategory(model.links.data, category);
        return ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, i) {
              LinksData data = list[i];
              return Padding(
                padding:
                    const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => model.launchURL(data.link.trim(), context),
                      child: Text(
                        data.name != null ? data.name : data.link,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.sometimes,
                          letterSpacing: 0.2,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: SizeConfig.calculateBlockVertical(5)),
                    Text(
                      data.description != null
                          ? parseHtmlString(data.description)
                          : '',
                      textAlign: TextAlign.start,
                      style: AppThemeStyle.ligtherSmallerText,
                    ),
                    Divider(
                        thickness: 1,
                        color: Constants.mainTextColor.withOpacity(0.2)),
                    SizedBox(height: SizeConfig.calculateBlockVertical(5)),
                  ],
                ),
              );
            });
      } else {
        return Container(child: EmptyData());
      }
    }
  }
}

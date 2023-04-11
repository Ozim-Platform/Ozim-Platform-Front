import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/article/article.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/diagnoses.dart';
import 'package:charity_app/model/for_mother.dart';
import 'package:charity_app/model/inclusion.dart';
import 'package:charity_app/model/right.dart';
import 'package:charity_app/model/skill.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/components/card_icon.dart';
import 'package:charity_app/view/components/notification_button.dart';
import 'package:charity_app/view/screens/common/bottom_bar_detail.dart';
import 'package:charity_app/view/screens/home/article/article_screen.dart';
import 'package:charity_app/view/screens/home/diagnose/diagnose_screen.dart';
import 'package:charity_app/view/screens/home/for_mother/for_mother_screen.dart';
import 'package:charity_app/view/screens/home/forum/forum_screen.dart';
import 'package:charity_app/view/screens/home/home_viewmodel.dart';
import 'package:charity_app/view/screens/home/inclusion/inclusion_screen.dart';
import 'package:charity_app/view/screens/home/resource/resource_screen.dart';
import 'package:charity_app/view/screens/home/rights/rights_screen.dart';
import 'package:charity_app/view/screens/home/service_provider/service_provider_screen.dart';
import 'package:charity_app/view/screens/home/skill/skill_screen.dart';
import 'package:charity_app/view/widgets/custom/cutom_image_listview.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeWithoutDrawerScreen extends StatelessWidget {
  HomeWithoutDrawerScreen(this.banner);

  final CommonModel banner;
  final List<String> imgList = [];

  _goToBanner(int index, context) {
    try {
      if (banner != null) {
        Map<String, dynamic> data = {
          'page': 1,
          'pages': 1,
          'data': [banner.data[index].toJson()]
        };

        if (data != null) {
          var model;
          switch (banner.data[index].type) {
            case 'article':
              model = Article.fromJson(data);
              break;
            case 'diagnosis':
              model = Diagnosis.fromJson(data);
              break;
            case 'for_parent':
              model = For_Parent.fromJson(data);
              break;
            case 'skill':
              model = Skill.fromJson(data);
              break;
            case 'inclusion':
              model = Inclusion.fromJson(data);
              break;
            case 'right':
              model = Right.fromJson(data);
              break;
            default:
              break;
          }

          if (model != null && model.data != null && model.data.length > 0) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BottomBarDetail(
                  data: model.data[0],
                  needTabBars: false,
                  type: banner.data[index].type,
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      print(e, level: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (banner != null) {
      banner.data.forEach((element) {
        if (element.preview != null) {
          imgList.add(Constants.MAIN_HTTP + '/' + element.preview.path);
        } else if (element.image != null) {
          imgList.add(Constants.MAIN_HTTP + '/' + element.image.path);
        }
      });
    }

    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: getAppBar(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (imgList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: ImageListview(
                  imgList: imgList,
                  context: context,
                  goToBanner: _goToBanner,
                ),
              ),
            SizedBox(height: SizeConfig.calculateBlockVertical(15) + 10),
            Expanded(
              child: Center(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(left: 24, right: 24),
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    buildCard(
                      context,
                      model,
                      'diagnosis',
                    ),
                    buildCard(
                      context,
                      model,
                      'skill',
                    ),
                    buildCard(
                      context,
                      model,
                      'link',
                    ),
                    buildCard(
                      context,
                      model,
                      'article',
                    ),
                    buildCard(
                      context,
                      model,
                      'inclusion',
                    ),
                    buildCard(
                      context,
                      model,
                      'for_parent',
                    ),
                    buildCard(
                      context,
                      model,
                      'service_provider',
                    ),
                    buildCard(
                      context,
                      model,
                      'forum',
                    ),
                    buildCard(
                      context,
                      model,
                      'right',
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   height: 10,
            // )
          ],
        ),
      ),
      onViewModelReady: (model) {
        model.getCategory();
        Constants.listnablemodels.add(model);
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }

  CardIcon buildCard(
    BuildContext context,
    HomeViewModel model,
    String category,
  ) {
    List<Category> _categories = getCategoryOfType(model.category, category);
    String iconPath = "assets/svg/services/" + category + ".svg";
    Widget Function(BuildContext context) _builder =
        getRouteBuilder(category, _categories);

    return CardIcon(
        category: category,
        operation: (getTranslated(context, category)),
        iconPath: iconPath,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: _builder));
        });
  }

  Widget Function(BuildContext context) getRouteBuilder(
      String routName, List<Category> category) {
    Widget Function(BuildContext context) builder;
    switch (routName) {
      case 'diagnosis':
        builder = (BuildContext context) => DiagnoseScreen(category: category);
        break;
      case 'skill':
        builder = (BuildContext context) => SkillScreen(category: category);
        break;
      case 'link':
        builder = (BuildContext context) => ResourceScreen(category: category);
        break;
      case 'service_provider':
        builder =
            (BuildContext context) => ServiceProviderScreen(category: category);
        break;
      case 'right':
        builder = (BuildContext context) => RightScreen(category: category);
        break;
      case 'inclusion':
        builder = (BuildContext context) => InclusionScreen(category: category);
        break;
      case 'article':
        builder = (BuildContext context) => ArticleScreen(
              category: category,
              existArrow: true,
            );
        break;
      case 'forum':
        builder = (BuildContext context) => ForumScreen(existArrow: true);
        break;
      case 'for_parent':
        builder = (BuildContext context) => ForMotherScreen(category: category);
        break;
      default:
        throw Exception('Invalid route: $routName');
    }
    return builder;
  }

  Widget getAppBar(context) {
    return AppBar(
      elevation: 2.0,
      centerTitle: true,
      shadowColor: Colors.black26,
      automaticallyImplyLeading: false,
      title: Text(''),
      actions: <Widget>[
        Align(
          alignment: Alignment.center,
          child: NotificationButton(),
        ),
      ],
    );
  }
}

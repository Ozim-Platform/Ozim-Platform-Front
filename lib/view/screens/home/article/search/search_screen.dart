import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/article/article.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/diagnoses.dart';
import 'package:charity_app/model/skill_provider.dart';
import 'package:charity_app/view/screens/common/custom_record_list.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/screens/common/custom_tab_controller.dart';
import 'package:charity_app/view/screens/home/article/search/search_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen(this.article, this.service, this.diagnosis, {this.canPop});

  final TextEditingController search = new TextEditingController();
  final Article article;
  final ServiceProvider service;
  final Diagnosis diagnosis;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    Category cat = Category.fromJson({
      "name": getTranslated(context, 'search_result'),
      "sysName": getTranslated(context, 'search')
    });
    return ViewModelBuilder<SearchViewModel>.reactive(
      builder: (context, model, child) => CustomTabController(
        title: getTranslated(context, 'search'),
        list: [cat],
        model: model,
        buildMethod: getSecondMainUI,
      ),
      onModelReady: (model) {
        model.initData();
      },
      viewModelBuilder: () => SearchViewModel(article, service, diagnosis),
    );
  }

  getSecondMainUI(
      context, SearchViewModel viewmodel, String category, List allCategories) {
    if (viewmodel.article.data.isEmpty &&
        viewmodel.service.data.isEmpty &&
        viewmodel.diagnosis.data.isEmpty) {
      String message = getTranslated(context, 'search_empty');
      Widget image = Image.asset(
        "assets/image/search.png",
        height: 80,
        width: 93,
      );
      return Container(
        child: EmptyData(
          text: message,
          image: image,
        ),
      );
    }
    return CustomRecordList<SearchViewModel>(
      model: viewmodel,
      category: category,
      type: 'search',
      allCategories: allCategories,
    );
  }
}

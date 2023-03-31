import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/view/screens/common/custom_record_list.dart';
import 'package:charity_app/view/screens/common/custom_tab_controller.dart';
import 'package:charity_app/view/screens/home/article/article_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ArticleScreen extends StatefulWidget {
  final List<Category> category;
  final bool existArrow;

  const ArticleScreen({Key key, this.category, this.existArrow})
      : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.category.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ArticleViewModel>.reactive(
      builder: (context, model, child) => CustomTabController(
        title: getTranslated(context, 'article'),
        list: widget.category,
        needBackArrow: widget.existArrow,
        model: model,
        buildMethod: getSecondMainUI,
        controller: _tabController,
      ),
      onModelReady: (model) {
        model.initModel(widget.category);
      },
      viewModelBuilder: () => ArticleViewModel(),
    );
  }

  Widget getSecondMainUI(context, ArticleViewModel viewmodel, String category,
      List<Category> allCategories) {
    return CustomRecordList<ArticleViewModel>(
        model: viewmodel,
        category: category,
        allCategories: allCategories,
        parentController: _tabController);
  }
}

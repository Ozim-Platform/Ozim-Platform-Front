import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/view/screens/common/custom_record_list.dart';
import 'package:charity_app/view/screens/common/custom_tab_controller.dart';
import 'package:charity_app/view/screens/home/skill/skill_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SkillScreen extends StatefulWidget {
  final List<Category> category;

  SkillScreen({Key key, @required this.category}) : super(key: key);

  @override
  _SkillScreenState createState() => _SkillScreenState();
}

class _SkillScreenState extends State<SkillScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.category.length, vsync: this);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SkillViewModel>.reactive(
      builder: (context, model, child) => CustomTabController(
        title: getTranslated(context, 'skill'),
        list: widget.category,
        model: model,
        buildMethod: getSecondMainUI,
        controller: _tabController,
      ),
      onViewModelReady: (model) {
        model.initModel(widget.category);
      },
      viewModelBuilder: () => SkillViewModel(),
    );
  }

  getSecondMainUI(context, SkillViewModel viewmodel, String category,
      List<Category> allCategories) {
    return CustomRecordList<SkillViewModel>(
      model: viewmodel,
      category: category,
      allCategories: allCategories,
      parentController: _tabController,
    );
  }
}

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/view/screens/common/custom_record_list.dart';
import 'package:charity_app/view/screens/common/custom_tab_controller.dart';
import 'package:charity_app/view/screens/home/inclusion/inclusion_viewmodel.dart';
import 'package:charity_app/view/widgets/custom/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class InclusionScreen extends StatefulWidget {
  final List<Category> category;

  InclusionScreen({Key key, @required this.category}) : super(key: key);

  @override
  _InclusionScreenState createState() => _InclusionScreenState();
}

class _InclusionScreenState extends State<InclusionScreen>
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
    return ViewModelBuilder<InclusionViewModel>.reactive(
      builder: (context, model, child) => CustomTabController(
        title: getTranslated(context, 'inclusion'),
        list: widget.category,
        model: model,
        buildMethod: getSecondMainUI,
        controller: _tabController,
      ),
      onModelReady: (model) {
        model.initModel(widget.category);
      },
      viewModelBuilder: () => InclusionViewModel(),
    );
  }

  getSecondMainUI(context, InclusionViewModel viewmodel, String category,
      List<Category> allCategories) {
    return CustomRecordList<InclusionViewModel>(
      model: viewmodel,
      category: category,
      allCategories: allCategories,
      parentController: _tabController,
    );
  }
}

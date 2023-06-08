import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/view/screens/common/custom_record_list.dart';
import 'package:charity_app/view/screens/common/custom_tab_controller.dart';
import 'package:charity_app/view/screens/home/diagnose/diagnose_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DiagnoseScreen extends StatefulWidget {
  final List<Category> category;

  DiagnoseScreen({Key key, @required this.category}) : super(key: key);

  @override
  _DiagnoseScreenState createState() => _DiagnoseScreenState();
}

class _DiagnoseScreenState extends State<DiagnoseScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.category.length, vsync: this);
    super.initState();
  }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DiagnosisViewModel>.reactive(
      builder: (context, model, child) => CustomTabController(
        title: getTranslated(context, 'diagnosis'),
        list: widget.category,
        model: model,
        buildMethod: getSecondMainUI,
        controller: _tabController,
      ),
      onViewModelReady: (model) {
        model.initModel(widget.category);
      },
      viewModelBuilder: () => DiagnosisViewModel(),
    );
  }

  getSecondMainUI(context, DiagnosisViewModel viewmodel, String category,
      List<Category> allCategories) {
    return CustomRecordList<DiagnosisViewModel>(
      model: viewmodel,
      category: category,
      allCategories: allCategories,
      parentController: _tabController,
    );
  }
}

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/view/screens/common/custom_record_list.dart';
import 'package:charity_app/view/screens/common/custom_tab_controller.dart';
import 'package:charity_app/view/screens/home/for_mother/for_mother_viewmodel.dart';
import 'package:charity_app/view/widgets/custom/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ForMotherScreen extends StatefulWidget {
  final List<Category> category;

  ForMotherScreen({Key key, @required this.category}) : super(key: key);

  @override
  _ForMotherScreenState createState() => _ForMotherScreenState();
}

class _ForMotherScreenState extends State<ForMotherScreen>
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
    return ViewModelBuilder<For_ParentViewModel>.reactive(
      builder: (context, model, child) => CustomTabController(
        title: getTranslated(context, 'for_parent'),
        list: widget.category,
        model: model,
        buildMethod: getSecondMainUI,
        controller: _tabController,
      ),
      onViewModelReady: (model) {
        model.initModel(widget.category);
      },
      viewModelBuilder: () => For_ParentViewModel(),
    );
  }

  getSecondMainUI(context, For_ParentViewModel viewmodel, String category,
      List<Category> allCategories) {
    return CustomRecordList<For_ParentViewModel>(
      model: viewmodel,
      category: category,
      allCategories: allCategories,
      parentController: _tabController,
    );
  }
}

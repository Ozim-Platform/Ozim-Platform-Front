import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/view/screens/common/custom_record_list.dart';
import 'package:charity_app/view/screens/common/custom_tab_controller.dart';
import 'package:charity_app/view/screens/home/resource/resource_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ResourceScreen extends StatefulWidget {
  final List<Category> category;

  ResourceScreen({Key key, @required this.category}) : super(key: key);

  @override
  State<ResourceScreen> createState() => _ResourceScreenState();
}

class _ResourceScreenState extends State<ResourceScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  void initState() {
    _tabController = TabController(length: widget.category.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ResourceViewModel>.reactive(
      builder: (context, model, child) => CustomTabController(
        title: getTranslated(context, 'link'),
        list: widget.category,
        model: model,
        buildMethod: getMainUI,
        controller: _tabController,
      ),
      onViewModelReady: (model) {
        model.getLinks(widget.category);
      },
      viewModelBuilder: () => ResourceViewModel(),
    );
  }

  Widget getMainUI(context, ResourceViewModel viewmodel, String category,
      List<Category> allCategories) {
    return CustomRecordList<ResourceViewModel>(
        model: viewmodel,
        category: category,
        allCategories: allCategories,
        parentController: _tabController,);
  }

  
}

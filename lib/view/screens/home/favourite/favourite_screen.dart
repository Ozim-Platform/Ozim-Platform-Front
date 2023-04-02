import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/view/screens/common/custom_record_list.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/widgets/custom/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'favourite_viewmodel.dart';

class FavouriteScreen extends StatefulWidget {
  final List<Data> folders;
  final bool needBackArrow;

  const FavouriteScreen({Key key, this.folders, this.needBackArrow = false})
      : super(key: key);

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    if (widget.folders != null) {
      _tabController =
          TabController(length: widget.folders.length, vsync: this);
    }
    super.initState();
  }

  @override
  void dispose() {
    if (_tabController != null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FavouriteViewModel>.reactive(
      builder: (context, model, child) {
        if (model.isLoading) {
          return Container(
              color: AppColor.scaffoldBackground,
              child: Center(child: CupertinoActivityIndicator()));
        }
        return DefaultTabController(
          length: model.folders.length,
          child: Scaffold(
            backgroundColor: AppColor.primary,
            appBar: customAppbar(
              context: context,
              category: model.folders,
              existArrow: widget.needBackArrow,
              appBarTitle: '',
              appBarIncome: getTranslated(context, 'favourite'),
              // controller: _tabController,
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: List<Widget>.generate(
                model.folders.length,
                (int index) {
                  return getSecondMainUI(
                      context, model, model.folders[index].name, model.folders);
                },
              ),
            ),
          ),
        );
      },
      onViewModelReady: (model) {
        model.init();
        model.getFavourite();
      },
      viewModelBuilder: () => FavouriteViewModel(),
    );
  }

  getSecondMainUI(
      context, FavouriteViewModel viewmodel, String category, List folders) {
    return CustomRecordList<FavouriteViewModel>(
      model: viewmodel,
      category: category,
      type: 'folder',
      allCategories: folders,
      enableSwipe: true,
      onForceUpdateList: () => viewmodel.getFavourite(),
      // parentController: _tabController,
    );
  }
}

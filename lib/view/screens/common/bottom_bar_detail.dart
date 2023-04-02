import 'package:charity_app/custom_icons_icons.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/screens/common/bottom_bar_detail_viemodel.dart';
import 'package:charity_app/view/screens/common/custom_recrod_details.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:charity_app/view/widgets/custom/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BottomBarDetail extends StatefulWidget {
  final Data data;
  final instance;
  final String type;
  final List allcategories;
  final String category;
  final TabController parentController;
  final bool needTabBars;
  final Function disposeCallback;

  const BottomBarDetail(
      {Key key,
      @required this.data,
      this.type,
      this.instance,
      this.allcategories,
      this.category,
      this.parentController,
      this.needTabBars = true,
      this.disposeCallback})
      : super(key: key);

  @override
  _BottomBarDetailState createState() => _BottomBarDetailState();
}

class _BottomBarDetailState extends State<BottomBarDetail>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  bool canPop = true;
  int _initIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.needTabBars) {
      _controller =
          TabController(length: widget.allcategories.length, vsync: this);
      _initIndex = getCategoryIndex(widget.allcategories, widget.category);
      _controller.index = _initIndex;
      _controller.addListener(_handleTabSelection);
    }
  }

  @override
  void dispose() {
    if (_controller != null) _controller.dispose();
    if (widget.disposeCallback != null) widget.disposeCallback();
    super.dispose();
  }

  _handleTabSelection() {
    ///avoid triggering - TabController's bag
    if (canPop) {
      ///Возврат к родительскому списку и выбор в родительском таб контроллере индекса выбранной категории
      Navigator.of(context).pop();
      if (widget.parentController != null) {
        widget.parentController.index = _controller.index;
      }
      canPop = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomBarDetailViewModel>.reactive(
      builder: (context, model, child) {
        if (!widget.needTabBars) {
          return Scaffold(
            appBar: customAppbar(
                controller: null,
                context: context,
                category: [],
                appBarTitle: '',
                appBarIncome: getTranslated(context, widget.type),
                withTabs: false),
            body: fakeBlock(context, model),
          );
        }
        return DefaultTabController(
          length: widget.allcategories.length,
          child: Scaffold(
            appBar: customAppbar(
              controller: _controller,
              context: context,
              category: widget.allcategories,
              appBarTitle: '',
              appBarIncome: getTranslated(context, widget.type),
            ),
            body: TabBarView(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              children: List<Widget>.generate(widget.allcategories.length,
                  (int index) {
                return fakeBlock(context, model);
              }),
            ),
          ),
        );
      },
      onViewModelReady: (model) {
        model.initContext(context, widget.data);
        model.view();
      },
      viewModelBuilder: () =>
          BottomBarDetailViewModel(instance: widget.instance),
    );
  }

  Widget fakeBlock(context, model) {
    final size = SizeConfig.calculateBlockVertical(22);
    return ModalProgressHUD(
      inAsyncCall: model.isLoading,
      color: Colors.white,
      dismissible: false,
      progressIndicator: CupertinoActivityIndicator(),
      child: Scaffold(
        backgroundColor: AppColor.primary,

        // appBar: widgetAppBarTitle(context),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: const Radius.circular(40),
                    topRight: const Radius.circular(40)),
                child: Container(
                  color: AppColor.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: mainUI(model, context),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 70,
          child: BottomNavigationBar(
            onTap: model.onTabTapped,
            type: BottomNavigationBarType.fixed,
            currentIndex: model.currentIndex,
            selectedItemColor: AppThemeStyle.primaryColor,
            items: [
              BottomNavigationBarItem(
                label: '',
                icon: widget.data.isLiked == true
                    ? Icon(
                        CustomIcons.heart,
                        semanticLabel: getTranslated(context, "leave_like"),
                        color: AppThemeStyle.primaryColor,
                        size: size,
                      )
                    : Icon(
                        CustomIcons.heart_outline,
                        semanticLabel: getTranslated(context, "leave_like"),
                        color: Constants.ligtherMainTextColor,
                        size: size,
                      ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  CustomIcons.sending,
                  color: Constants.ligtherMainTextColor,
                  semanticLabel: getTranslated(context, "leave_comment"),
                  size: size,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(
                  Icons.share_outlined,
                  color: Constants.ligtherMainTextColor,
                  size: size,
                  semanticLabel: getTranslated(context, "share_publication"),
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: widget.data.inBookmarks == true
                    ? Icon(
                        CustomIcons.favorite,
                        color: AppThemeStyle.primaryColor,
                        semanticLabel:
                            getTranslated(context, "add_to_favorite"),
                        size: size + 5,
                      )
                    : Icon(
                        Icons.bookmark_outline,
                        size: size + 5,
                        semanticLabel:
                            getTranslated(context, "add_to_favorite"),
                        color: Constants.ligtherMainTextColor,
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget mainUI(BottomBarDetailViewModel viewModel, BuildContext context) {
    if (viewModel.isLoading) {
      return Container();
    } else {
      return CustomRecordDetails(data: widget.data, model: viewModel);
    }
  }
}

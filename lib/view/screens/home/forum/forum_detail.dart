import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/forum/forum_sub_category.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/formatters.dart';
import 'package:charity_app/view/components/btn_ui.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/components/user_image.dart';
import 'package:charity_app/view/screens/home/forum/forum_add_viewmodel.dart';
import 'package:charity_app/view/screens/home/forum/forume_detail_viewmodel.dart';
import 'package:charity_app/view/screens/other/comment_screen.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForumDetailScreen extends StatefulWidget {
  final String title;
  final String subcategory;
  final Function disposeCallback;
  final ForumSubCategory forumSubCategory;

  const ForumDetailScreen(
      {Key key,
      this.title,
      this.subcategory,
      this.disposeCallback,
      this.forumSubCategory})
      : super(key: key);

  @override
  _ForumDetailScreenState createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  @override
  void dispose() {
    if (widget.disposeCallback != null) widget.disposeCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumDetailViewModel>.reactive(
      builder: (context, model, child) => ModalProgressHUD(
        inAsyncCall: model.isLoading,
        color: Colors.white,
        dismissible: false,
        progressIndicator: CupertinoActivityIndicator(),
        child: Scaffold(
          backgroundColor: AppColor.primary,
          appBar: AppBar(
            toolbarHeight: 82.0,
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Column(
              children: [
                const SizedBox(
                  height: 42.0,
                ),
                Text(
                  getTranslated(context, 'forum'),
                  style: AppThemeStyle.headerWhite,
                ),
                const SizedBox(height: 30.0),
              ],
            ),
            leading: Column(
              children: [
                IconButton(
                  iconSize: 25.0,
                  splashRadius: 20,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(40),
                      topRight: const Radius.circular(40)),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 30.0,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            height: 45.0,
                            margin: const EdgeInsets.only(bottom: 10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              widget.title,
                              style: AppThemeStyle.subHeaderWhite,
                            ),
                            decoration: BoxDecoration(
                                color: AppThemeStyle.primaryColor,
                                borderRadius: BorderRadius.circular(25)),
                          ),
                          Expanded(
                              child: BuilderList(
                                  category: widget.subcategory, model: model)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // bottomNavigationBar: Container(
          //   height: 74.0,
          //   width: MediaQuery.of(context).size.width,
          //   color: Colors.red,
          // ),
          bottomNavigationBar: Container(
            color: Colors.transparent,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // TODO: EXAMINE this widget
              ConvexAppBar(
                elevation: 0.2,
                style: TabStyle.reactCircle,
                color: Colors.black45,
                activeColor: AppColor.primary,
                backgroundColor: Colors.white,
                height: 25,
                items: [
                  TabItem(
                    icon: Semantics(
                      label: getTranslated(context, 'create_post'),
                      child: const Icon(
                        Icons.add,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                initialActiveIndex: 0,
                onTap: (int i) =>
                    {model.showModalForNewForum(context, widget.subcategory)},
              ),
              Container(height: 16.0, color: Colors.white),
            ]),
          ),
        ),
      ),
      onViewModelReady: (model) {
        model.forumSubCategory = widget.forumSubCategory;
        model.getForumCategory(widget.subcategory);
      },
      viewModelBuilder: () => ForumDetailViewModel(),
    );
  }
}

class AddPopUp extends StatefulWidget {
  final String subcategory;

  const AddPopUp({Key key, this.subcategory}) : super(key: key);

  @override
  _AddPopUpState createState() => _AddPopUpState();
}

class _AddPopUpState extends State<AddPopUp> {
  String get subcategory => widget.subcategory;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumAddViewModel>.reactive(
      builder: (context, model, child) => Material(
        child: Container(
          width: 256.w,
          height: 320.w,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.calculateBlockVertical(10)),
              Align(
                alignment: Alignment.center,
                child: Text(
                  getTranslated(context, 'new_post'),
                  style: AppThemeStyle.headerPrimaryColor,
                ),
              ),
              SizedBox(height: SizeConfig.calculateBlockVertical(10)),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    getTranslated(context, 'new_post_desc'),
                    textAlign: TextAlign.center,
                    style: AppThemeStyle.normalText,
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.calculateBlockVertical(15)),
              TextField(
                controller: model.titleController,
                minLines: 1,
                maxLines: 2,
                style: AppThemeStyle.normalTextLighter,
                decoration: InputDecoration(
                  hintText: getTranslated(context, 'post_theme'),
                  hintStyle: AppThemeStyle.normalTextLighter,
                  enabledBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.mainTextColor),
                  ),
                  focusedBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.mainTextColor),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.calculateBlockVertical(10)),
              TextField(
                controller: model.noteController,
                style: AppThemeStyle.normalTextLighter,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: getTranslated(context, 'post_desc'),
                  hintStyle: AppThemeStyle.normalTextLighter,
                  enabledBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.mainTextColor),
                  ),
                  focusedBorder: new UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.mainTextColor),
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BtnUI(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 55,
                    width: 115,
                    isLoading: false,
                    textColor: Colors.white,
                    color: AppColor.primary,
                    text: getTranslated(context, 'cancel'),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  BtnUI(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 55,
                    width: 115,
                    isLoading: model.isLoading,
                    textColor: Colors.white,
                    color: AppColor.primary,
                    text: getTranslated(context, 'ok'),
                    onTap: () {
                      model.postForum(context, subcategory);
                    },
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(8)),
                ],
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ForumAddViewModel(),
    );
  }
}

class BuilderList extends StatefulWidget {
  final ForumDetailViewModel model;
  final String category;

  const BuilderList({
    this.model,
    this.category,
    Key key,
  }) : super(key: key);

  @override
  _BuilderListState createState() => _BuilderListState();
}

class _BuilderListState extends State<BuilderList> {
  ForumDetailViewModel get viewModel => widget.model;
  ScrollController _scrollController = ScrollController();
  int page = 1;
  int pages = 1;

  @override
  void initState() {
    super.initState();
    // if (viewModel.forumDetail != null) {
    //   page = viewModel.forumDetail.page;
    //   pages = viewModel.forumDetail.pages;
    // }
    // print(viewModel.forumDetail);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (page < pages) {
          page++;
          _getMoreData(widget.category, page);
        }
      }
    });
  }

  _getMoreData(String category, int page) {
    viewModel.getMore(category, page);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    if (_scrollController != null) _scrollController.dispose();
    super.dispose();
  }

  Widget _buildComment(List<DataComment> comments) {
    if (comments.isEmpty) return SizedBox.shrink();
    DateTime t, n;
    for (DataComment c in comments) {
      n = DateTime.fromMillisecondsSinceEpoch(c.created_at * 1000);
      if (t == null) {
        t = DateTime.fromMillisecondsSinceEpoch(c.created_at * 1000);
        continue;
      }
      if (n.isAfter(t)) t = n;
      for (DataComment cc in c.replies) {
        n = DateTime.fromMillisecondsSinceEpoch(cc.created_at * 1000);
      }
      if (n.isAfter(t)) t = n;
    }
    // print(t.toString());
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        getTranslated(context, 'last_message') + ' ' + dateFormatter2(t),
        textAlign: TextAlign.start,
        style: AppThemeStyle.ligtherSmallerText.copyWith(
            // fontFamily: 'Arial',
            ),
      ),
      // Text(
      //   "${dateFormatter(DateTime.fromMillisecondsSinceEpoch(data.createdAt * 1000))}",
      //   textAlign: TextAlign.end,
      //   style: AppThemeStyle.titleListGrey,
      // ),
    );
  }

  String _commentCount(List<DataComment> comments) {
    int count = comments.length;
    for (DataComment c in comments) {
      count += c.repliesCount;
      for (DataComment cc in c.replies) {
        count += cc.repliesCount;
        for (DataComment ccc in cc.replies) {
          count += ccc.repliesCount;
        }
      }
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return Container();
    } else {
      if (viewModel.forumDetail.data != null &&
          viewModel.forumDetail.data.length > 0) {
        page = viewModel.forumDetail.page;
        pages = viewModel.forumDetail.pages;
        return ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: viewModel.forumDetail.data.length + 1,
          itemBuilder: (context, i) {
            if (i == viewModel.forumDetail.data.length) {
              if (page < pages) {
                return Padding(
                    padding: const EdgeInsets.all(10),
                    child: CupertinoActivityIndicator(
                      radius: 15,
                    ));
              } else {
                return SizedBox();
              }
            }

            var data = viewModel.forumDetail.data[i];
            return GestureDetector(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => ForumCommentScreen(
                //           forum: data,
                //         )));
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CommentScreen(
                          viewModel.forumDetail,
                          data,
                          detailsModel: CommentDetailsModel(
                              title: data.title,
                              description: data.description,
                              userData: data.user),
                        )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: SizeConfig.calculateBlockVertical(5)),
                  Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.calculateBlockHorizontal(15),
                        right: SizeConfig.calculateBlockHorizontal(15),
                        top: SizeConfig.calculateBlockVertical(10),
                        bottom: SizeConfig.calculateBlockVertical(5)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserImage(
                          userUrl: data?.user?.avatar,
                          size: 50,
                        ),
                        SizedBox(
                            width: SizeConfig.calculateBlockHorizontal(10)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                data?.user?.name ?? "",
                                textAlign: TextAlign.start,
                                style: AppThemeStyle.ligtherSmallerText,
                              ),
                              SizedBox(
                                  height: SizeConfig.calculateBlockVertical(5)),
                              Text(
                                data.title != null ? data.title : '',
                                style: AppThemeStyle.subHeader,
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                  height: SizeConfig.calculateBlockVertical(5)),
                              Text(
                                data.description,
                                textAlign: TextAlign.start,
                                style: AppThemeStyle.normalText,
                                maxLines: 3,
                              ),
                              SizedBox(
                                  height:
                                      SizeConfig.calculateBlockVertical(10)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  data.comments.isNotEmpty
                                      ? Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/svg/icons/comment.svg',
                                              width: 15,
                                              height: 15,
                                              color: Colors.grey,
                                              fit: BoxFit.scaleDown,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3),
                                              child: Text(
                                                _commentCount(data.comments),
                                                style:
                                                    AppThemeStyle.titleListGrey,
                                              ),
                                            )
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                  _buildComment(data.comments),
                                ],
                              ),
                              SizedBox(
                                  height: SizeConfig.calculateBlockVertical(5)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Constants.mainTextColor.withOpacity(0.2),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        return Container(
          child: EmptyData(),
        );
      }
    }
  }
}

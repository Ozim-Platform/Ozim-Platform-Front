import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_app/data/downloader/downloader.dart';
import 'package:charity_app/data/in_app_purchase/in_app_purchase_data_repository.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/formatters.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/components/favorite_link.dart';
import 'package:charity_app/view/components/locked_card_overlay.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/screens/common/bottom_bar_detail.dart';
import 'package:charity_app/view/screens/home/service_provider/service_provider_screen.dart';
import 'package:charity_app/view/screens/home/subscription/subscription_screen.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class CustomRecordList<T extends BaseViewModel> extends StatefulWidget {
  final T model;
  final String category;
  final String type;
  final List allCategories;
  final TabController parentController;
  final bool enableSwipe;
  final Function onForceUpdateList;

  CustomRecordList({
    Key key,
    this.model,
    this.category,
    this.type = 'category',
    this.allCategories,
    this.parentController,
    this.enableSwipe = false,
    this.onForceUpdateList,
  }) : super(key: key);

  @override
  _CustomRecordListState<T> createState() => _CustomRecordListState<T>();
}

class _CustomRecordListState<T extends BaseViewModel>
    extends State<CustomRecordList<T>> {
  ApiProvider _apiProvider = ApiProvider();

  T get viewmodel => widget.model;

  String get category => widget.category;

  List get allCategories => widget.allCategories;
  ScrollController _scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    dynamic _model = viewmodel as dynamic;

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _model.paginate();
      log('paginating');
    }
  }

  @override
  setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primary,
        border: Border(
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Color.fromRGBO(244, 244, 244, 1.0),
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(40),
            topRight: const Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.w, 10.w, 10.w, 10.w),
          child: getListUI(
            context,
            viewmodel,
            category,
            allCategories,
          ),
        ),
      ),
    );
  }

  Widget getListUI(
      BuildContext context, model, String category, List allcategories) {
    if (model.isLoading) {
      return CupertinoActivityIndicator();
    }

    if (model.instance?.data != null && model.instance.data.length > 0) {
      List list = [];
      if (widget.type == 'category') {
        list = getListOfInstancesByCategory(
          model.instance.data,
          category,
        );
      } else if (widget.type == 'folder') {
        list = getListOfInstancesByFolder(
          model.instance.data,
          category,
        );
        if (list.isEmpty)
          return Center(
            child: Text(
              getTranslated(context, 'data_not_found'),
              style: AppThemeStyle.normalTextLighter,
            ),
          );
      } else if (widget.type == 'search') {
        list = model.article.data + model.service.data + model.diagnosis.data;
      }

      return ListView.builder(
        itemCount: list.length,
        controller: _scrollController,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          var data = list[i];
          return CardBuilder(
            model: model,
            data: data,
            // folders: model.folders,
            allcategories: allCategories,
            category: category,
            enableSwipe: widget.enableSwipe,
            parentController: widget.parentController,
            onForceUpdateList: widget.onForceUpdateList ?? () {},
          );
        },
      );
    } else {
      String message;
      Widget image;
      if (widget.type == 'search') {
        message = getTranslated(context, 'search_empty');
        image = Image.asset(
          "assets/image/search.png",
          height: 80,
          width: 93,
        );
      }

      return Container(
        child: EmptyData(
          text: message,
          image: image,
        ),
      );
    }
  }
}

class CardBuilder extends StatefulWidget {
  const CardBuilder(
      {Key key,
      this.data,
      this.model,
      this.folders,
      this.allcategories,
      this.category,
      this.parentController,
      this.enableSwipe,
      this.onForceUpdateList})
      : super(key: key);

  final model;
  final Data data;
  final List<Data> folders;
  final TabController parentController;
  final bool enableSwipe;
  final Function onForceUpdateList;

  ///Не обязательно категории
  final List allcategories;
  final String category;

  @override
  _CardBuilderState createState() => _CardBuilderState();
}

class _CardBuilderState extends State<CardBuilder> {
  Data get data => widget.data;

  get model => widget.model;

  List get allCategories => widget.allcategories;

  bool _swiped = false;

  @override
  initState() {
    InAppPurchaseDataRepository().hasActiveSubscription.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  dispose() {
    InAppPurchaseDataRepository().hasActiveSubscription.removeListener(() {});
    super.dispose();
  }

  swipedLeft() {
    setState(() {
      _swiped = true;
    });
  }

  swipedRight() {
    setState(() {
      _swiped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data.type != null &&
        (data.type == 'service' || data.type == 'service_provider')) {
      return BuildListServices(
        list: [data],
      );
    }
    return Column(
      children: [
        Stack(
          alignment: Alignment.centerRight,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: () async {
                if (data.isPaid == false ||
                    InAppPurchaseDataRepository().hasActiveSubscription.value ==
                        true) {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => BottomBarDetail(
                        instance: model,
                        data: data,
                        type: getTypeFromModel(model),
                        allcategories: allCategories,
                        category: widget.category,
                        parentController: widget.parentController,
                      ),
                    ),
                  )
                      .then((value) {
                    setState(() {});
                  });
                }
              },
              child: Stack(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0.w),
                    ),
                    child: Container(
                      height: 75.w,
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                width: 75.w,
                                height: 75.w,
                                margin: EdgeInsets.only(
                                  left: 15.w,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    15.w,
                                  ),
                                  color: Color(0xFFF4F4F4),
                                ),
                                transform: Matrix4.rotationZ(
                                  10.67 * 3.1415926536 / 180,
                                ),
                              ),
                              Container(
                                height: 75.w,
                                width: 75.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    15.w,
                                  ),
                                  image: DecorationImage(
                                    image: data.preview != null
                                        ? CachedNetworkImageProvider(
                                            Constants.MAIN_HTTP +
                                                data.preview.path)
                                        : (data.image == null
                                            ? AssetImage(
                                                'assets/image/article_image.png')
                                            : CachedNetworkImageProvider(
                                                Constants.MAIN_HTTP +
                                                    data.image.path,
                                              )),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                data.name != null
                                    ? data.name
                                    : (data.title != null ? data.title : ''),
                                style: AppThemeStyle.subHeader,
                                textAlign: TextAlign.start,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          (data.type != "link")
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: FavoriteLink(
                                    data: data,
                                    swipeLeft:
                                        widget.enableSwipe ? swipedLeft : () {},
                                    swipeRight: swipedRight,
                                    onForceUpdateList: widget.onForceUpdateList,
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.bottomRight,
                                  child: DownloadLink(
                                    data: data,
                                    swipeLeft:
                                        widget.enableSwipe ? swipedLeft : () {},
                                    swipeRight: swipedRight,
                                    onForceUpdateList: widget.onForceUpdateList,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  (data.isPaid == true &&
                          (InAppPurchaseDataRepository()
                                      .hasActiveSubscription
                                      .value ==
                                  false ||
                              InAppPurchaseDataRepository()
                                      .hasActiveSubscription
                                      .value ==
                                  null))
                      ? InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SubscriptionScreen(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(
                                4), // default margin value for the Flutter Card widget
                            child: LockedCardOverlay(),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        ),
        data.type != "link"
            ? Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Row(children: <Widget>[
                        SvgPicture.asset(
                          'assets/svg/icons/eye.svg',
                          width: 14.w,
                          height: 14.w,
                          color: AppColor.lightGrey,
                          // fit: BoxFit.scaleDown,
                        ),
                        SizedBox(
                          width: 12.w,
                        ),
                        Text(
                          '${data.views}',
                          style: AppThemeStyle.normalTextSmallerLigther,
                        )
                      ]),
                    ),
                    Expanded(
                      flex: 6,
                      child: Row(children: <Widget>[
                        SvgPicture.asset(
                          'assets/svg/icons/heart.svg',
                          width: 14.w,
                          height: 14.w,
                          color: AppColor.lightGrey,
                          // fit: BoxFit.scaleDown,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          '${data.likes}',
                          style: AppThemeStyle.normalTextSmallerLigther,
                        )
                      ]),
                    ),
                    Expanded(
                      flex: 6,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/icons/comment.svg',
                            width: 14.w,
                            height: 14.w,
                            // autoadjust height
                            color: AppColor.lightGrey,
                            // fit: BoxFit.scaleDown,
                          ),
                          data.comments.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.only(left: 3.w),
                                  child: Text(
                                    data.comments.length.toString(),
                                    style:
                                        AppThemeStyle.normalTextSmallerLigther,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(left: 3.w),
                                  child: Text(
                                    "0",
                                    style:
                                        AppThemeStyle.normalTextSmallerLigther,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svg/icons/clock.svg',
                            width: 14.w,
                            height: 14.w,
                            color: AppColor.lightGrey,
                            // fit: BoxFit.scaleDown,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "${dateFormatter2(DateTime.fromMillisecondsSinceEpoch(data.createdAt * 1000))}",
                            style: AppThemeStyle.normalTextSmallerLigther,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(),
        SizedBox(height: SizeConfig.calculateBlockVertical(10)),
      ],
    );
  }
}

class DownloadLink extends StatelessWidget {
  const DownloadLink({
    Key key,
    @required this.data,
    @required this.swipeLeft,
    @required this.swipeRight,
    @required this.onForceUpdateList,
  }) : super(key: key);

  final Data data;
  final Function swipeLeft;
  final Function swipeRight;
  final Function onForceUpdateList;

  onFavClick(BuildContext context) async {
    if (data.bookInformation != null && data.link.isNotEmpty) {
      Downloader().downloadFile(
        data.bookInformation.path,
        data.bookInformation.originalName,
        context,
      );
    } else {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: GestureDetector(
        excludeFromSemantics: true,
        onTap: () => onFavClick(context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/image/favorite_shadow.png',
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 22.h,
                top: 5.h,
              ),
              child: data.bookInformation != null
                  ? SvgPicture.asset(
                      "assets/svg/icons/download_icon.svg",
                    )
                  : SvgPicture.asset(
                      "assets/svg/icons/download_icon_disabled.svg"),
            ),
          ],
        ),
      ),
    );
  }
}

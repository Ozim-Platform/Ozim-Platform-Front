import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_app/custom_icons_icons.dart';
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
import 'package:charity_app/view/components/swipet_container_favorite.dart';
import 'package:charity_app/view/screens/common/bottom_bar_detail.dart';
import 'package:charity_app/view/screens/home/service_provider/service_provider_screen.dart';
import 'package:charity_app/view/screens/home/subscription/subscription_screen.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  initState() {
    super.initState();
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
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: getListUI(context, viewmodel, category, allCategories),
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
        list = getListOfInstancesByCategory(model.instance.data, category);
      } else if (widget.type == 'folder') {
        list = getListOfInstancesByFolder(model.instance.data, category);
        if (list.isEmpty)
          return Center(
              child: Text(getTranslated(context, 'data_not_found'),
                  style: AppThemeStyle.normalTextLighter));
      } else if (widget.type == 'search') {
        list = model.article.data + model.service.data + model.diagnosis.data;
      }
      list = list.reversed.toList();
      return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          var data = list[i];
          return CardBuilder(
            model: model,
            data: data,
            folders: model.folders,
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
              onTap: () {
                if (data.isPaid == false) {
                  Navigator.of(context).push(
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
                  );
                }
              },
              child: Stack(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.white,
                    child: Container(
                      height: 75,
                      child: Row(
                        children: [
                          Container(
                            width: 110,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/icons/article_badge.svg',
                                ),
                                Container(
                                  height: 75.0,
                                  width: 75.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
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
                                                      data.image.path)),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                        ],
                      ),
                    ),
                  ),
                  // TODO: Check if paid, and whether user has a subscription
                  (data.isPaid == true)
                      ? InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SubscriptionScreen(),
                              ),
                            );
                          },
                          child: LockedCardOverlay())
                      : SizedBox(),
                ],
              ),
            ),
            Positioned(
              bottom: 3,
              right: -1,
              child: FavoriteLink(
                data: data,
                swipeLeft: widget.enableSwipe ? swipedLeft : () {},
                swipeRight: swipedRight,
                onForceUpdateList: widget.onForceUpdateList,
              ),
            ),
            // SwipedContainerFavorite(
            //   _swiped,
            //   widget.onForceUpdateList,
            //   swipedRight,
            //   data: data,
            // ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Row(children: <Widget>[
                  Icon(
                    CustomIcons.eye,
                    size: 12,
                    color: AppColor.lightGrey,
                  ),
                  SizedBox(
                    width: 12,
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
                  Icon(
                    CustomIcons.heart_outline,
                    size: 14,
                    color: AppColor.lightGrey,
                  ),
                  SizedBox(
                    width: 5,
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
                        width: 14,
                        height: 14,
                        color: AppColor.lightGrey,
                        fit: BoxFit.scaleDown,
                      ),
                      data.comments.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Text(
                                data.comments.length.toString(),
                                style: AppThemeStyle.normalTextSmallerLigther,
                              ),
                            )
                          : SizedBox(),
                    ],
                  )),
              Expanded(
                flex: 7,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(CustomIcons.clock,
                          size: 14, color: AppColor.lightGrey),
                      SizedBox(width: 5),
                      Text(
                        "${dateFormatter2(DateTime.fromMillisecondsSinceEpoch(data.createdAt * 1000))}",
                        style: AppThemeStyle.normalTextSmallerLigther,
                      ),
                    ]),
              ),
            ],
          ),
        ),
        SizedBox(height: SizeConfig.calculateBlockVertical(10)),
      ],
    );
  }
}

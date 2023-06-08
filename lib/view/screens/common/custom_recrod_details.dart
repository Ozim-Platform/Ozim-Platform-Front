import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_app/data/downloader/downloader.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/formatters.dart';
import 'package:charity_app/view/components/custom/custom_html.dart';
import 'package:charity_app/view/screens/common/bottom_bar_detail_viemodel.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomRecordDetails extends StatefulWidget {
  final Data data;
  final BottomBarDetailViewModel model;
  KeyedSubtree player;

  CustomRecordDetails({Key key, this.data, this.model, this.player})
      : super(key: key);

  @override
  _CustomRecordDetailsState createState() => _CustomRecordDetailsState();
}

class _CustomRecordDetailsState extends State<CustomRecordDetails> {
  Data get data => widget.data;
  BottomBarDetailViewModel get bottomNavigation => widget.model;
  ApiProvider _apiProvider = ApiProvider();

  Timer _timer;
  @override
  void initState() {
    if (data.type == "skill") {
      receivePoints();
    }
    ;
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  receivePoints() async {
    // this is a workaround solution, since we cannot see, whether user had watched a video completely or not
    // we will give him points for watching a video, and if he will watch it again, he will not get any points
    // this is a temporary solution, we will change it later
    _timer = Timer(
      Duration(minutes: 5),
      () {
        _apiProvider.receivePoints(50);
      },
    );
  }

  Widget widgetDecider(
      String type, Data data, BottomBarDetailViewModel bottomNavigation) {
    if (type == "skill" || type == "inclusion") {
      return ExcludedRecordDetailInformation(
        data: data,
        bottomNavigation: bottomNavigation,
        player: widget.player,
      );
    } else {
      return RecordDetailInformation(
        data: data,
        bottomNavigation: bottomNavigation,
        player: widget.player,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widgetDecider(data.type, data, bottomNavigation);
  }
}

class RecordDetailInformation extends StatelessWidget {
  KeyedSubtree player;

  RecordDetailInformation({
    Key key,
    @required this.data,
    @required this.bottomNavigation,
    this.player,
  }) : super(key: key);

  final Data data;
  final BottomBarDetailViewModel bottomNavigation;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: 20.w,
      ),
      physics: BouncingScrollPhysics(),
      child: Container(
        width: SizeConfig.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Text(
                data.name != null
                    ? data.name
                    : (data.title != null ? data.title : ''),
                style:
                    AppThemeStyle.headerPrimaryColor.copyWith(fontSize: 23.sp),
              ),
            ),
            SizedBox(
              height: SizeConfig.calculateBlockVertical(
                MediaQuery.of(context).size.width > 500 ? 10.w : 20.w,
              ),
            ),
            data.type != 'link'
                ? Padding(
                    padding: EdgeInsets.only(
                      left: 20.w,
                      right: 20.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Semantics(
                          label: getTranslated(
                            context,
                            "pub_date",
                          ),
                          child: Row(children: <Widget>[
                            SvgPicture.asset(
                              'assets/svg/icons/clock.svg',
                              width: 14.w,
                              height: 14.w,
                              color: AppColor.lightGrey,
                              // fit: BoxFit.scaleDown,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "${dateFormatterEng(DateTime.fromMillisecondsSinceEpoch(data.createdAt * 1000))}",
                              style: AppThemeStyle.normalTextSmallerLigther,
                            ),
                          ]),
                        ),
                        Semantics(
                          label: getTranslated(
                            context,
                            "whatches",
                          ),
                          child: Row(children: <Widget>[
                            SvgPicture.asset(
                              'assets/svg/icons/eye.svg',
                              width: 14.w,
                              height: 14.w,
                              color: AppColor.lightGrey,
                              // fit: BoxFit.scaleDown,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "${data.views}",
                              style: AppThemeStyle.normalTextSmallerLigther,
                            )
                          ]),
                        ),
                        Semantics(
                          label: getTranslated(
                            context,
                            "likes",
                          ),
                          child: Row(children: <Widget>[
                            SvgPicture.asset(
                              'assets/svg/icons/heart.svg',
                              width: 14.w,
                              height: 14.w,
                              color: AppColor.lightGrey,
                              // fit: BoxFit.scaleDown,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              '${data.likes}',
                              style: AppThemeStyle.normalTextSmallerLigther,
                            )
                          ]),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: SizeConfig.calculateBlockVertical(
                15.w,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    28.w,
                  ),
                  child: data.image != null
                      ? CachedNetworkImage(
                          imageUrl: Constants.MAIN_HTTP + data.image.path,
                        )
                      : Image.asset('assets/image/home_image2.png'),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.calculateBlockVertical(
                15.w,
              ),
            ),
            (data.author != null)
                ? Padding(
                    padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: data.authorPhoto == null
                              ? Image.asset(
                                  'assets/image/avatar.png',
                                  width: 55.w,
                                  height: 55.w,
                                )
                              : Image.network(
                                  Constants.MAIN_HTTP + data.authorPhoto.path,
                                  width: 55.w,
                                  height: 55.w,
                                ),
                        ),
                        SizedBox(
                          width: SizeConfig.calculateBlockHorizontal(
                            10.w,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                data.author ?? '',
                                textAlign: TextAlign.start,
                                style: AppThemeStyle.subHeader.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.calculateBlockVertical(
                                  10.w,
                                ),
                              ),
                              Text(
                                data.authorPosition ?? '',
                                style: AppThemeStyle.titleListPrimary.copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(
              height: SizeConfig.calculateBlockVertical(
                15.w,
              ),
            ),
            CustomHtml(
              data: data.description,
              player: player,
            ),
            SizedBox(
              height: SizeConfig.calculateBlockVertical(
                12,
              ),
            ),
            if (data.type != 'link')
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  /**открыть комментарии*/
                  bottomNavigation.onTabTapped(
                    1,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.w,
                    horizontal: 8.w,
                  ),
                  child: Text(
                    'Посмотреть все комментарии (' +
                        (data.comments.length).toString() +
                        ')',
                    style: AppThemeStyle.normalText,
                  ),
                ),
              )
            else if (data.bookInformation != null)
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Downloader().downloadFile(
                    data.bookInformation.path,
                    data.bookInformation.originalName,
                    context,
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.w,
                    horizontal: 8.w,
                  ),
                  child: Row(
                    children: [
                      Text(
                        getTranslated(context, "download"),
                        style: AppThemeStyle.normalText,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      SvgPicture.asset('assets/svg/icons/download_icon.svg'),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ExcludedRecordDetailInformation extends StatelessWidget {
  KeyedSubtree player;
  ExcludedRecordDetailInformation(
      {Key key,
      @required this.data,
      @required this.bottomNavigation,
      this.player})
      : super(key: key);

  final Data data;
  final BottomBarDetailViewModel bottomNavigation;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: 20.w,
      ),
      physics: BouncingScrollPhysics(),
      child: Container(
        width: SizeConfig.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: Text(
                data.name != null
                    ? data.name
                    : (data.title != null ? data.title : ''),
                style: AppThemeStyle.headerPrimaryColor.copyWith(),
              ),
            ),
            SizedBox(
              height: SizeConfig.calculateBlockVertical(
                20,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    label: getTranslated(
                      context,
                      "pub_date",
                    ),
                    child: Row(children: <Widget>[
                      SvgPicture.asset(
                        'assets/svg/icons/clock.svg',
                        width: 14.w,
                        height: 14.w,
                        color: AppColor.lightGrey,
                        // fit: BoxFit.scaleDown,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "${dateFormatterEng(DateTime.fromMillisecondsSinceEpoch(data.createdAt * 1000))}",
                        style: AppThemeStyle.normalTextSmallerLigther,
                      ),
                    ]),
                  ),
                  Semantics(
                    label: getTranslated(
                      context,
                      "whatches",
                    ),
                    child: Row(children: <Widget>[
                      SvgPicture.asset(
                        'assets/svg/icons/eye.svg',
                        width: 14.w,
                        height: 14.w,
                        color: AppColor.lightGrey,
                        // fit: BoxFit.scaleDown,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "${data.views}",
                        style: AppThemeStyle.normalTextSmallerLigther,
                      )
                    ]),
                  ),
                  Semantics(
                    label: getTranslated(
                      context,
                      "likes",
                    ),
                    child: Row(children: <Widget>[
                      SvgPicture.asset(
                        'assets/svg/icons/heart.svg',
                        width: 14.w,
                        height: 14.w,
                        color: AppColor.lightGrey,
                        // fit: BoxFit.scaleDown,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        '${data.likes}',
                        style: AppThemeStyle.normalTextSmallerLigther,
                      )
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.calculateBlockVertical(
                15.w,
              ),
            ),
            CustomHtml2(
              data: data.description,
              player: player,
            ),

            SizedBox(
              height: SizeConfig.calculateBlockVertical(
                12.w,
              ),
            ),
            // if (data.comments != null && data.comments.isNotEmpty)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                /**открыть комментарии*/
                bottomNavigation.onTabTapped(
                  1,
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.w,
                  horizontal: 10.w,
                ),
                child: Text(
                  'Посмотреть все комментарии (' +
                      (data.comments.length).toString() +
                      ')',
                  style: AppThemeStyle.normalText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

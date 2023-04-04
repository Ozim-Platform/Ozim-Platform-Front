import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_app/custom_icons_icons.dart';
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

class CustomRecordDetails extends StatefulWidget {
  final Data data;
  final BottomBarDetailViewModel model;

  const CustomRecordDetails({Key key, this.data, this.model}) : super(key: key);

  @override
  _CustomRecordDetailsState createState() => _CustomRecordDetailsState();
}

class _CustomRecordDetailsState extends State<CustomRecordDetails> {
  Data get data => widget.data;
  BottomBarDetailViewModel get bottomNavigation => widget.model;
  ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    if (data.type == "skill") {
      receivePoints();
    }
    ;
    super.initState();
  }


  receivePoints() async {
    // this is a workaround solution, since we cannot see, whether user had watched a video completely or not
    // we will give him points for watching a video, and if he will watch it again, he will not get any points
    // this is a temporary solution, we will change it later

    await Future.delayed(Duration(minutes: 5));
    await _apiProvider.receivePoints();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      physics: BouncingScrollPhysics(),
      child: Container(
        width: SizeConfig.screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                data.name != null
                    ? data.name
                    : (data.title != null ? data.title : ''),
                style: AppThemeStyle.headerPrimaryColor.copyWith()),
            SizedBox(height: SizeConfig.calculateBlockVertical(20)),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    label: getTranslated(context, "pub_date"),
                    child: Row(children: <Widget>[
                      Icon(CustomIcons.clock,
                          size: 15, color: AppColor.lightGrey),
                      SizedBox(width: 4),
                      Text(
                          "${dateFormatterEng(DateTime.fromMillisecondsSinceEpoch(data.createdAt * 1000))}",
                          style: AppThemeStyle.normalTextSmallerLigther),
                    ]),
                  ),
                  Semantics(
                    label: getTranslated(context, "whatches"),
                    child: Row(children: <Widget>[
                      Icon(CustomIcons.eye,
                          size: 12, color: AppColor.lightGrey),
                      SizedBox(width: 10),
                      Text("${data.views}",
                          style: AppThemeStyle.normalTextSmallerLigther)
                    ]),
                  ),
                  Semantics(
                    label: getTranslated(context, "likes"),
                    child: Row(children: <Widget>[
                      Icon(CustomIcons.heart_outline,
                          size: 14, color: AppColor.lightGrey),
                      SizedBox(width: 4),
                      Text('${data.likes}',
                          style: AppThemeStyle.normalTextSmallerLigther)
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.calculateBlockVertical(15)),
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: data.image != null
                  ? CachedNetworkImage(
                      imageUrl: Constants.MAIN_HTTP + data.image.path)
                  : Image.asset('assets/image/home_image2.png'),
            ),
            SizedBox(height: SizeConfig.calculateBlockVertical(15)),
            if (data.author != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: data.authorPhoto == null
                        ? Image.asset(
                            'assets/image/avatar.png',
                            width: 55,
                            height: 55,
                          )
                        : Image.network(
                            Constants.MAIN_HTTP + data.authorPhoto.path,
                            width: 55,
                            height: 55,
                          ),
                  ),
                  SizedBox(width: SizeConfig.calculateBlockHorizontal(10)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          data.author ?? '',
                          textAlign: TextAlign.start,
                          style: AppThemeStyle.subHeader,
                        ),
                        SizedBox(height: SizeConfig.calculateBlockVertical(10)),
                        Text(
                          data.authorPosition ?? '',
                          style: AppThemeStyle.titleListPrimary.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            SizedBox(height: SizeConfig.calculateBlockVertical(15)),
            CustomHtml(data: data.description),
            SizedBox(height: SizeConfig.calculateBlockVertical(12)),
            // if (data.comments != null && data.comments.isNotEmpty)
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                /**открыть комментарии*/
                bottomNavigation.onTabTapped(1);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
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

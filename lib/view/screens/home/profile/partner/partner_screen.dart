import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/partner.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/components/custom/custom_html.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:charity_app/view/widgets/custom/cutom_image_listview.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PartnerScreen extends StatefulWidget {
  Partner partner;
  int userPoints;
  PartnerScreen({Key key, this.partner, this.userPoints}) : super(key: key);

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  ApiProvider _apiProvider = ApiProvider();
  List<String> imgList = [];

  @override
  void initState() {
    widget.partner.images.forEach((element) {
      imgList.add(Constants.MAIN_HTTP + "/" + element.path);
    });
    super.initState();
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Color(
              0XFF777F83,
            ),
            size: 22.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 16.w,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                imgList.isNotEmpty
                    ? Container(
                        width: SizeConfig.screenWidth,
                        child: ImageListview(
                          imgList: imgList,
                        ),
                      )
                    : SizedBox(),
                Padding(
                  padding: EdgeInsets.only(left: 37.0.w, right: 37.0.w),
                  child: PartnerCard(
                    partner: widget.partner,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 37.0.w, right: 37.0.w),
                  child: CustomHtml(
                    data: widget.partner.description,
                  ),
                ),
              ],
            ),
            if (_isLoading)
              const Opacity(
                opacity: 0.8,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.reactCircle,
        top: -20,
        curve: Curves.easeInOut,
        curveSize: 75,
        height: 50.h,
        color: AppThemeStyle.colorGrey,
        activeColor: widget.partner.exchangedPoints != true
            ? AppColor.primary
            : Colors.grey[400],
        elevation: 0,
        backgroundColor: Colors.white,
        onTabNotify: (index) => true,
        onTap: (index) {
          if (widget.partner.exchangedPoints != true) {
            if (widget.userPoints < widget.partner.price) {
              _showAlertDialogNotEnoughPoints(context);
            } else if (widget.partner.exchangedPoints == true) {
              _showAlertDialogAlreadyExchanged(context);
            } else {
              _showAlertDialogExchangeConfirmation(context);
            }
          }
        },
        items: [
          TabItem(
            icon: SvgPicture.asset(
              'assets/svg/icons/exchange_points.svg',
              width: 24.w,
              height: 24.w,
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
        initialActiveIndex: 0,
      ),
    );
  }

  _showAlertDialogNotEnoughPoints(BuildContext context) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(getTranslated(context, "unsuccessful_points_exchange")),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
            child: Text(
              "OK",
            ),
          ),
        ],
      ),
    );
  }

  _showAlertDialogExchangeConfirmation(BuildContext context) async {
    bool isLoading = false;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(getTranslated(context, "points_exchange_confirmation")),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              getTranslated(context, 'no'),
            ),
          ),
          CupertinoDialogAction(
            child: Text(
              getTranslated(context, 'yes'),
            ),
            isDefaultAction: true,
            onPressed: () async {
              if (isLoading == false) {
                isLoading = true;
                bool operationIsSuccessful =
                    await _apiProvider.exchangePoints(widget.partner.id);

                if (operationIsSuccessful) {
                  successfulResponseStatus(context);
                } else {
                  unsuccessfulResponseStatus(context);
                }
              } else {
                log("Loading is true");
              }
            },
          ),
        ],
      ),
    );
  }

  unsuccessfulResponseStatus(BuildContext context) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(getTranslated(context, "unsuccessful_points_exchange")),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text(
              "Ok",
            ),
          ),
        ],
      ),
    );
  }

  successfulResponseStatus(BuildContext context) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(getTranslated(context, "successful_points_exchange")),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              widget.partner.exchangedPoints = true;
              Navigator.pop(context, true);
              Navigator.pop(context, true);
            },
            child: Text(
              "OK",
            ),
          ),
        ],
      ),
    );
  }

  _showAlertDialogAlreadyExchanged(context) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(getTranslated(context, "already_exchanged")),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
            child: Text(
              "OK",
            ),
          ),
        ],
      ),
    );
  }
}

class PartnerCard extends StatelessWidget {
  final Partner partner;
  const PartnerCard({Key key, this.partner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 60.0.w,
                  width: 60.0.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: partner.image != null
                          ? CachedNetworkImageProvider(
                              Constants.MAIN_HTTP + partner.image.path,
                            )
                          : (partner.image == null
                              ? AssetImage('assets/image/article_image.png')
                              : CachedNetworkImageProvider(
                                  Constants.MAIN_HTTP + partner.image.path,
                                )),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(17.0.w, 0, 17.0, 0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        partner.name != null
                            ? partner.name
                            : (partner.title != null ? partner.title : ''),
                        // textScaleFactor: SizeConfig.textScaleFactor(),
                        style: TextStyle(
                          fontFamily: "Helvetica Neue",
                          fontSize: 23.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0XFF6B6F72),
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.calculateBlockVertical(
            10.w,
          ),
        ),
      ],
    );
  }
}

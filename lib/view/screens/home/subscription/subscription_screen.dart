import 'dart:developer';
import 'dart:io';

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/screens/home/subscription/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              const SubscriptionImageWidget(),
              const SubscriptionTextWidget(),
              // Container(
              //   height: SizeConfig.screenHeight * 0.5,
              // ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SubscriptionPriceWidget(),
          ),
        ],
      ),
    );
  }
}

class SubscriptionImageWidget extends StatelessWidget {
  const SubscriptionImageWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 26.w, right: 26.w),
      child: SvgPicture.asset(
        "assets/svg/subscription.svg",
        height: 247.37.w,
      ),
    );
  }
}

class SubscriptionTextWidget extends StatelessWidget {
  const SubscriptionTextWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 26.0.w,
        right: 26.w,
        top: 18.w,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated(context, "subscription_text_widget_1"),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Color(0XFF6B6F72),
            ),
          ),
          SizedBox(
            height: 10.w,
          ),
          Text(
            getTranslated(context, "subscription_text_widget_2"),
            style: TextStyle(
              fontSize: 15.sp,
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.w400,
              color: Color(0XFF6B6F72),
            ),
          ),
          Text(
            getTranslated(context, "subscription_text_widget_3"),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: Color(0XFF6B6F72),
            ),
          ),
          Text(
            getTranslated(context, "subscription_text_widget_4"),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: Color(0XFF6B6F72),
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionPriceWidget extends StatefulWidget {
  const SubscriptionPriceWidget({Key key}) : super(key: key);

  @override
  State<SubscriptionPriceWidget> createState() =>
      _SubscriptionPriceWidgetState();
}

class _SubscriptionPriceWidgetState extends State<SubscriptionPriceWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubscriptionViewModel>.reactive(
      viewModelBuilder: () => SubscriptionViewModel(),
      onViewModelReady: (model) async {
        await model.init();
      },
      builder: (context, model, child) {
        model.isLoading.addListener(() {
          setState(() {});
        });
        if (model.isBusy) {
          return CircularProgressIndicator();
        } else
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Color(0XFF79BCB7),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: model.subscriptions.length,
                  padding: EdgeInsets.only(
                    bottom: 8.w,
                  ),
                  itemBuilder: (context, index) {
                    return Subscription(
                      subscriptionItem: model.subscriptions[index],
                      model: model,
                    );
                  },
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    model.purchaseSubscription(
                      context,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: model.isLoading.value == false ? 19.w : 0,
                      left: 86.w,
                      right: 86.w,
                      bottom: model.isLoading.value == false ? 19.w : 0,
                    ),
                    height: 57.w,
                    width: 310.w,
                    decoration: BoxDecoration(
                      color: const Color(0XFFF1BC62),
                      borderRadius: BorderRadius.circular(
                        27.5,
                      ),
                    ),
                    child: model.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            getTranslated(context, "continue").toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Inter",
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 20.w,
                          left: 40.w,
                          bottom: 20.w,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            getTranslated(
                              context,
                              "skip",
                            ),
                            style: TextStyle(
                              fontFamily: "Helvetica Neue",
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        model.restorePurchases(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 20.w,
                          right: 40.w,
                          bottom: 20.w,
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Localizations.localeOf(context).languageCode ==
                                  "ru"
                              ? FittedBox(
                                  fit: BoxFit.contain,
                                  child: Container(
                                    // width: 173.w,
                                    child: Text(
                                      getTranslated(
                                          context, "restore_purchase"),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "Helvetica Neue",
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 173.w,
                                  child: Text(
                                    getTranslated(context, "restore_purchase"),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Helvetica Neue",
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
      },
    );
  }
}

class Subscription extends StatefulWidget {
  final IAPItem subscriptionItem;
  SubscriptionViewModel model;
  Subscription({
    Key key,
    this.subscriptionItem,
    this.model,
  }) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        widget.model.selectSubscription(
          widget.subscriptionItem,
        );
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(57.w, 15.w, 57.w, 15.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (widget.model.selectedSubscription ==
                        widget.subscriptionItem)
                    ? Color(
                        0XFFF1BC62,
                      )
                    : Colors.transparent,
                border: Border.all(
                  width: 2.w,
                  color: Color(
                    0XFFFFFFFF,
                  ),
                ),
              ),
              child:
                  widget.model.selectedSubscription == widget.subscriptionItem
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 22,
                        )
                      : SizedBox(),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16.0.w,
              ),
              child: Text(
                getTranslated(
                      context,
                      widget.subscriptionItem.productId,
                    ) +
                    (widget.subscriptionItem.currency == "KZT"
                        ? " / т "
                        : "/ " + widget.subscriptionItem.currency + " ") +
                    widget.subscriptionItem.price,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

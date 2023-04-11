import 'dart:developer';

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/view/screens/home/subscription/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 50,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          const SubscriptionImageWidget(),
          const SubscriptionTextWidget(),
          const Spacer(),
          SubscriptionPriceWidget(),
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
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: SvgPicture.asset(
          "assets/svg/subscription.svg",
        ));
  }
}

class SubscriptionTextWidget extends StatelessWidget {
  const SubscriptionTextWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16,
        top: 32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getTranslated(context, "subscription_text_widget_1"),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0XFF6B6F72),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            getTranslated(context, "subscription_text_widget_2"),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0XFF6B6F72),
            ),
          ),
          Text(
            getTranslated(context, "subscription_text_widget_3"),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color(0XFF6B6F72),
            ),
          ),
          Text(
            getTranslated(context, "subscription_text_widget_4"),
            style: TextStyle(
              fontSize: 15,
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
        if (model.isBusy) {
          return CircularProgressIndicator();
        } else
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Color(0XFF79BCB7),
            ),
            child: model.isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(
                            top: 16, left: 16, right: 16, bottom: 16),
                        itemCount: model.subscriptions.length,
                        itemBuilder: (context, index) {
                          return Subscription(
                            subscriptionItem: model.subscriptions[index],
                            model: model,
                          );
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            top: 16, left: 100, right: 100, bottom: 16),
                        margin: const EdgeInsets.only(
                            top: 16, left: 16, right: 16, bottom: 16),
                        decoration: BoxDecoration(
                          color: const Color(0XFFF1BC62),
                          borderRadius: BorderRadius.circular(27.5),
                        ),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () async {
                            model.purchaseSubscription(context);
                          },
                          child: Text(
                            getTranslated(context, "continue"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: "Inter",
                              color: Colors.white,
                              fontSize: 16,
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
                              // dispose viewmodel
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  getTranslated(context, "skip"),
                                  style: const TextStyle(
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
                            onTap: () async {
                              // trigger a callback function from a viewmodel
                              await model.restorePurchases();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  getTranslated(context, "restore_purchase"),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
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
        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (widget.model.selectedSubscription ==
                        widget.subscriptionItem)
                    ? Color(
                        0XFFF1BC62,
                      )
                    : Colors.transparent,
                border: Border.all(
                  width: 2,
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
              padding: const EdgeInsets.only(
                left: 16.0,
              ),
              child: Text(
                getTranslated(
                      context,
                      widget.subscriptionItem.subscriptionPeriodAndroid,
                    ) +
                    " / т " +
                    widget.subscriptionItem.price,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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

import 'dart:async';
import 'dart:developer';

import 'package:charity_app/persistance/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

// this is a singleton class, it will be initialized only at launch.
// It will get subscription status from sotreAPI once and will be used throughout the app

// firstly we need to get subscription ids from the backend

// we need to check whether a user has an active subscription from the backend
// if not
// need to fetch available subscriptions from the storeAPI
// need to check if user has an active subscription

// if both of these check fail, we set subscription status to false

class InAppPurchaseDataRepository {
  FlutterInappPurchase _inAppPurchase = FlutterInappPurchase.instance;

  ApiProvider _apiProvider = ApiProvider();

  ValueNotifier<bool> _hasActiveSubscription = ValueNotifier<bool>(false);

  ValueNotifier<bool> get hasActiveSubscription => _hasActiveSubscription;

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;

  List<String> _subscriptionIds = [];

  Set<IAPItem> _items = {};

  Set<IAPItem> get items => _items;

  String sku;

  static final InAppPurchaseDataRepository _instance =
      InAppPurchaseDataRepository._internal();

  InAppPurchaseDataRepository.init() {
    fetchAvailableSubscriptions();
  }

  InAppPurchaseDataRepository._internal() {
    _inAppPurchase = FlutterInappPurchase.instance;

    _inAppPurchase.initialize();

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen(
      (productItem) {
        checkCurrentSubscription();
        // if subscription is bought, we need to update subscription status in the backend
        // DateTime expirationDate = calculateExpirationDate(
        //   productItem.productId,
        // );
        _apiProvider.updateSubscriptionStatus(
          status: true,
          // expirationDate: expirationDate.toString(),
          expirationDate: productItem.transactionDate.toString().substring(
                0,
                10,
              ),
        );
      },
    );

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen(
      (purchaseError) {
        log("purchase-error: $purchaseError");
        //
      },
    );

    _conectionSubscription = FlutterInappPurchase.connectionUpdated.listen(
      (connected) {
        log("connected: $connected");
        //
      },
    );
  }

  factory InAppPurchaseDataRepository() {
    return _instance;
  }

  checkCurrentSubscription() async {
    await _inAppPurchase.initialize();

    bool _isReady = await _inAppPurchase.isReady();

    if (_isReady == true && hasActiveSubscription.value == false) {
      List<PurchasedItem> purchasedItems =
          await _inAppPurchase.getAvailablePurchases();
      for (int i = 0; i < purchasedItems.length; i++) {
        bool isSubscribed = await _inAppPurchase.checkSubscribed(
          sku: purchasedItems[i].productId,
        );

        if (isSubscribed) {
          hasActiveSubscription.value = true;
          sku = purchasedItems[i].productId;
        }

        // update subscription value in the backend
      }
      if (hasActiveSubscription == null) {
        hasActiveSubscription.value = false;
      }

      // check subscription status from the backend
    }
    if (hasActiveSubscription.value == false) {
      _apiProvider.getUser().then(
        (value) {
          if (value.subscription != null) {
            hasActiveSubscription.value = value.subscription;
          } else {
            hasActiveSubscription.value = false;
          }
        },
      );

      ;
    }
  }

  buySubscription(IAPItem item) {
    FlutterInappPurchase.instance.requestSubscription(item.productId);
  }

  // I need to fetch them only once
  Future<void> fetchAvailableSubscriptions() async {
    await _inAppPurchase.initialize();

    bool _isReady = await _inAppPurchase.isReady();
    if (_isReady == true) {
      if (_items.length != 3) {
        for (int i = 0; i < _subscriptionIds.length; i++) {
          List<IAPItem> items =
              await _inAppPurchase.getSubscriptions([_subscriptionIds[i]]);
          _items.add(items[0]);
        }
      }
    }
  }

  getSubscriptionIds() async {
    _subscriptionIds = await _apiProvider.getSubscriptionIds();
  }

  restorePurchases() {
    _inAppPurchase.getAvailablePurchases();
    
  }

  cancelSubscription() {
    // _inAppPurchase.
  }
}

DateTime calculateExpirationDate(String productId) {
  DateTime now = DateTime.now();
  DateTime expirationDate;
  if (productId == "com.charityapp.monthly") {
    expirationDate = now.add(
      Duration(days: 30),
    );
  } else if (productId == "com.charityapp.halfyearly") {
    expirationDate = now.add(
      Duration(days: 180),
    );
  } else if (productId == "com.charityapp.yearly") {
    expirationDate = now.add(
      Duration(days: 365),
    );
  }
  return expirationDate;
}

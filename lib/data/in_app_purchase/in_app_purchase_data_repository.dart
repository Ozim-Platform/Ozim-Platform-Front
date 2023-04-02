import 'dart:async';
import 'dart:developer';

import 'package:charity_app/persistance/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

// this is a singleton class, it will be initialized only at launch.
// It will get subscription status from sotreAPI and will be used throughout the app

class InAppPurchaseDataRepository {
  FlutterInappPurchase _inAppPurchase = FlutterInappPurchase.instance;

  ApiProvider _apiProvider = ApiProvider();

  ValueNotifier<bool> _hasActiveSubscription = ValueNotifier<bool>(false);

  ValueNotifier<bool> get hasActiveSubscription => _hasActiveSubscription;

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;

  List<String> _subscriptionIds = [];

  List<IAPItem> _items = [];

  List<IAPItem> get items => _items;

  static final InAppPurchaseDataRepository _instance =
      InAppPurchaseDataRepository._internal();

  InAppPurchaseDataRepository._internal() {
    _inAppPurchase = FlutterInappPurchase.instance;

    _inAppPurchase.initialize();

    _purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen((productItem) {
      checkCurrentSubscription();
      log("purchase-updated: $productItem");
    });

    _purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen((purchaseError) {
      log("purchase-error: $purchaseError");
    });

    _conectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {
      log("connected: $connected");
    });
  }

  factory InAppPurchaseDataRepository() {
    return _instance;
  }

  checkCurrentSubscription() async {
    await _inAppPurchase.initialize();

    bool _isReady = await _inAppPurchase.isReady();

    if (_isReady == true) {
      List<PurchasedItem> purchasedItems =
          await _inAppPurchase.getAvailablePurchases();
      for (int i = 0; i < purchasedItems.length; i++) {
        bool isSubscribed = await _inAppPurchase.checkSubscribed(
          sku: purchasedItems[i].productId,
        );
        if (isSubscribed) {
          hasActiveSubscription.value = true;
        }
      }
      if (hasActiveSubscription == null) {
        hasActiveSubscription.value = false;
      }
    }
    ;
  }

  buySubscription(IAPItem item) {
    FlutterInappPurchase.instance.requestSubscription(item.productId);
  }

  Future<void> fetchAvailableSubscriptions() async {
    await _inAppPurchase.initialize();

    bool _isReady = await _inAppPurchase.isReady();
    if (_isReady == true) {
      List<IAPItem> items =
          await _inAppPurchase.getSubscriptions(_subscriptionIds);
      _items = items;
    } else {
      await _inAppPurchase.initialize();
      fetchAvailableSubscriptions();

      log("InAppPurchase is not ready");
    }
  }

  getSubscriptionIds() async {
    _subscriptionIds = await _apiProvider.getSubscriptionIds();
  }

  

  restorePurchases() {}
}

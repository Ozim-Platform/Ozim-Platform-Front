import 'dart:async';
import 'dart:developer';

import 'package:charity_app/persistance/api_provider.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class InAppPurchaseDataRepository {
  // this is a singleton class, it will be initialized only at launch.
  // It will get subscription status from sotreAPI and will be used throughout the app

  FlutterInappPurchase _inAppPurchase = FlutterInappPurchase.instance;
  ApiProvider _apiProvider = ApiProvider();

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;

  bool hasActiveSubscription = false;
  Stream<bool> subscriptionStatus;
  

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
      purchasedItems.forEach(
        (element) async {
          await _inAppPurchase.checkSubscribed(
            sku: element.productId,
          );
        },
      );
    } else {
      await _inAppPurchase.initialize();
      checkCurrentSubscription();
      log("InAppPurchase is not ready");
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

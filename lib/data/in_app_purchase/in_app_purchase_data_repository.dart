import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:charity_app/persistance/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

class InAppPurchaseDataRepository {
  FlutterInappPurchase _inAppPurchase = FlutterInappPurchase.instance;

  ApiProvider _apiProvider = ApiProvider();

  ValueNotifier<bool> hasActiveSubscription = ValueNotifier<bool>(false);

  StreamSubscription _purchaseUpdatedSubscription;
  StreamSubscription _purchaseErrorSubscription;
  StreamSubscription _conectionSubscription;

  List<String> _subscriptionIds = [];

  Set<IAPItem> _items = {};

  Set<IAPItem> get items => _items;

  static final InAppPurchaseDataRepository _instance =
      InAppPurchaseDataRepository._internal();

  factory InAppPurchaseDataRepository() {
    return _instance;
  }

  InAppPurchaseDataRepository._internal() {
    _inAppPurchase = FlutterInappPurchase.instance;

    _inAppPurchase.initialize();

    _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen(
      (productItem) {
        log("new productItemIs listened");
        if (Platform.isAndroid) {
          _handlePurchaseUpdateAndroid(productItem);
        } else {
          _handlePurchaseUpdateIOS(productItem);
        }
      },
    );

    _purchaseErrorSubscription = FlutterInappPurchase.purchaseError.listen(
      (purchaseError) {
        log("purchase-error: $purchaseError");
      },
    );

    _conectionSubscription = FlutterInappPurchase.connectionUpdated.listen(
      (connected) {
        log("connected: $connected");
      },
    );
  }

  Future<void> checkSubscriptionFromStore() async {
    log("checkingSubscriptionFromStore");
    for (String id in _subscriptionIds) {
      if (await _inAppPurchase.checkSubscribed(
            sku: id,
            grace: Duration(
              minutes: 1,
            ),
          ) ==
          true) {
        log("User has active ${id} subscription in the store");
        hasActiveSubscription.value = true;
        return;
      }
    }

    log("User does not have any active subscriptions in the store");

    hasActiveSubscription.value = false;

    await _apiProvider.updateSubscriptionStatus(
      status: false,
      expirationDate: DateTime.now().toString(),
    );
    return;
  }

  void checkSubscriptionFromBackend() {
    _apiProvider.getUser().then(
      (value) async {
        if (value.subscription != null) {
          log("value.madePurchaseFrom: " + value.madePurchaseFrom);
          log("subscriptionMapperValue: " +
              value.subscriptionMapperValue.toString());
          if (Platform.isAndroid && value.madePurchaseFrom == "playStore") {
            await checkSubscriptionFromStore();
            return;
          } else if (Platform.isIOS && value.madePurchaseFrom == "appStore") {
            await checkSubscriptionFromStore();
            return;
          } else {
            log("Subscription value was retrieved from backend");
            hasActiveSubscription.value = value.subscriptionMapperValue;
          }
        } else {
          hasActiveSubscription.value = false;
        }
      },
    );
  }

  // need to fetch them only once
  Future<void> fetchAvailableSubscriptions() async {
    await _inAppPurchase.initialize();

    bool _isReady = await _inAppPurchase.isReady();
    if (_isReady == true) {
      List<IAPItem> iapItems =
          await _inAppPurchase.getSubscriptions(_subscriptionIds);

      iapItems.sort(
          (a, b) => double.parse(a.price).compareTo(double.parse(b.price)));
      _items = iapItems.toSet();
    }
  }

  getSubscriptionIds() async {
    _subscriptionIds = await _apiProvider.getSubscriptionIds();
  }

  buySubscription(IAPItem item) async {
    // check the history of purchases made from this appstore or google account
    // List<PurchasedItem> history = await _inAppPurchase.getAvailablePurchases();

    // check whether current google/appstore account has a subscription
    for (String sku in _subscriptionIds) {
      if (await _inAppPurchase.checkSubscribed(sku: sku) == true) {
        return false;
      }
    }

    FlutterInappPurchase.instance.requestSubscription(item.productId);
    return true;
  }

  restorePurchases() async {
    // get user purchase tokens from backend
    _apiProvider.getUser().then(
      (user) async {
        if (user.subscription != null) {
          log("value.madePurchaseFrom: " + user.madePurchaseFrom);
          log("subscriptionMapperValue: " + user.subscriptionMapperValue);
          if (Platform.isAndroid && user.madePurchaseFrom == "playStore") {
            await checkSubscriptionFromStore();
            return;
          } else if (Platform.isIOS && user.madePurchaseFrom == "appStore") {
            await checkSubscriptionFromStore();
            return;
          } else {
            log("Subscription value was retrieved from backend");
            hasActiveSubscription.value = user.subscriptionMapperValue;
          }
        } else {
          hasActiveSubscription.value = false;
        }
      },
    );

    // check whether Store account has any of these active tokens in the user list

    // if yes, then restore purchase

    // if not, say that user needs to change account

    // await checkSubscriptionFromStore();
  }

  cancelSubscription() {}

  Future<void> _handlePurchaseUpdateIOS(PurchasedItem purchasedItem) async {
    switch (purchasedItem.transactionStateIOS) {
      case TransactionState.deferred:
        // FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.failed:
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.purchased:
        DateTime expirationDate = calculateExpirationDate(
          purchasedItem.productId,
        );
        await _apiProvider.updateSubscriptionStatus(
          status: true,
          expirationDate: expirationDate.toString(),
          store: "appStore",
          // add purchase token to the subscription information
          // and when user is restoring subscription, check whether a user has this token.
          // if not, then user should make a payment from another account
          purchaseToken: purchasedItem.purchaseToken,
        );
        FlutterInappPurchase.instance.finishTransactionIOS(
          purchasedItem.transactionId,
        );

        hasActiveSubscription.value = true;
        hasActiveSubscription.notifyListeners();
        break;
      case TransactionState.purchasing:
        break;
      case TransactionState.restored:
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      default:
    }
  }

  Future<void> _handlePurchaseUpdateAndroid(PurchasedItem purchasedItem) async {
    switch (purchasedItem.purchaseStateAndroid.index) {
      case 1:
        if (!purchasedItem.isAcknowledgedAndroid) {
          DateTime expirationDate = calculateExpirationDate(
            purchasedItem.productId,
          );

          // add purchase token to the subscription information
          // and when user is restoring subscription, check whether a user has this token.
          // if not, then user should make a payment from another account
          FlutterInappPurchase.instance.finishTransaction(purchasedItem);

          await _apiProvider.updateSubscriptionStatus(
            status: true,
            expirationDate: expirationDate.toString(),
            store: "playStore",
            purchaseToken: purchasedItem.transactionId,
          );

          hasActiveSubscription.value = true;
          hasActiveSubscription.notifyListeners();

          break;
        } else {
          FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        }
        break;
      case 2:
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
    }
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

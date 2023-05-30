import 'dart:developer';
import 'dart:io';

import 'package:charity_app/data/in_app_purchase/in_app_purchase_data_repository.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:stacked/stacked.dart';

class SubscriptionViewModel extends BaseViewModel {
  InAppPurchaseDataRepository _inAppPurchaseDataRepository;

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  List<IAPItem> subscriptions = [];
  IAPItem _selectedSubscription;

  IAPItem get selectedSubscription => _selectedSubscription;
  // listen for subscription updates

  SubscriptionViewModel() {
    setBusy(true);
    _inAppPurchaseDataRepository = InAppPurchaseDataRepository();
    setBusy(false);
  }

  init() async {
    setBusy(true);
    if (_inAppPurchaseDataRepository.items.isNotEmpty) {
      _inAppPurchaseDataRepository.items.forEach(
        (element) {
          log(element.toString());
          subscriptions.add(element);
        },
      );
    } else {
      await _inAppPurchaseDataRepository.getSubscriptionIds();
      _inAppPurchaseDataRepository.items.forEach(
        (element) {
          log(element.toString());
          subscriptions.add(element);
        },
      );
    }

    setBusy(false);
    notifyListeners();
  }

  Future<PurchasedItem> restorePurchases() async {
    // isLoading.value = true;
    // notifyListeners();

    // PurchasedItem purchasedItem =
    //     await _inAppPurchaseDataRepository.checkCurrentSubscription();
    // isLoading.value = false;
    // notifyListeners();
    // return purchasedItem;
  }

  Future<PurchasedItem> purchaseSubscription(BuildContext context) async {
    isLoading.value = true;
    notifyListeners();
    if (_selectedSubscription != null) {
      if (await _inAppPurchaseDataRepository
              .buySubscription(_selectedSubscription) !=
          false) {
        notifyListeners();
        _inAppPurchaseDataRepository.hasActiveSubscription.addListener(
          () {
            Navigator.of(context).pop();
          },
        );
      } else {
        ToastUtils.toastErrorGeneral(
            getTranslated(context, "account_has_subscription"), context);
        sleep(
          Duration(seconds: 3),
        );
        Navigator.of(context).pop();
      }
    } else {
      log("No subscription selected");
      log(isLoading.value.toString());

      isLoading.value = false;
    }
  }

  selectSubscription(IAPItem item) {
    _selectedSubscription = item;
    notifyListeners();
  }
}

import 'dart:developer';

import 'package:charity_app/data/in_app_purchase/in_app_purchase_data_repository.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:stacked/stacked.dart';

class SubscriptionViewModel extends BaseViewModel {
  InAppPurchaseDataRepository _inAppPurchaseDataRepository;

  bool isLoading = false;
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
    _inAppPurchaseDataRepository.items.forEach(
      (element) {
        subscriptions.add(element);
      },
    );
    setBusy(false);
    notifyListeners();
  }

  Future<PurchasedItem> restorePurchases() async {
    isLoading = true;
    notifyListeners();
    
    PurchasedItem purchasedItem =
        await _inAppPurchaseDataRepository.checkCurrentSubscription();
    isLoading = false;
    notifyListeners();
    return purchasedItem;
  }
  
  Future<PurchasedItem> purchaseSubscription() async {
    isLoading = true;
    notifyListeners();
    if (_selectedSubscription != null) {
      PurchasedItem purchasedItem = await _inAppPurchaseDataRepository
          .buySubscription(_selectedSubscription);
      isLoading = false;

      notifyListeners();
      return purchasedItem;
    } else {
      
      log("No subscription selected");
    }
  }

  selectSubscription(IAPItem item) {
    _selectedSubscription = item;
    notifyListeners();
  }
}

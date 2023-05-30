import 'package:flutter/foundation.dart';

class IAPModule {
  ValueNotifier<bool> hasActiveSubcription = ValueNotifier(false);
  bool revenueCatIsAvailable = false;

  IAPModule init() {
    // check whether revenue cat is available
    // init revenue cat
    // check if user has active subscription
    // if yes, set hasActiveSubcription to true
    // else set it to false
    return this;
  }

  static getUserSubscriptionStatus() {
    try {
      // use revenue cat to check if user has active subscription
    } catch (e) {
      // on error, we will fetch it from the flutter sdk
    }
  }

  static buySubcription() {
    //  when user buys a subscription, regardless of the method,
    //  we need to store it in the backend

    try {} catch (e) {}
  }

  static fetchAvailableOffers() {
    try {} catch (e) {}
  }

  static cancelSubscription() {
    try {} catch (e) {}
  }
}

// import 'dart:io';

// import 'package:charity_app/data/in_app_purchase/store_config.dart';
// import 'package:charity_app/utils/constants.dart';
// import 'package:flutter/services.dart';

// import 'package:purchases_flutter/purchases_flutter.dart';

// class RevenueCatIAP {
//   static Future<void> init(String appUserId) async {
//     PurchasesConfiguration configuration;

//     if (Platform.isIOS || Platform.isMacOS) {
//       StoreConfig(
//         store: revenueCatStore.appleStore,
//         apiKey: Constants.appleKey,
//       );
//     } else if (Platform.isAndroid) {
//       StoreConfig(
//         store: revenueCatStore.googlePlay,
//         apiKey: Constants.googleKey,
//       );
//     }
//     configuration = PurchasesConfiguration(
//       StoreConfig.instance.apiKey,
//     )..appUserID = appUserId;

//     await Purchases.configure(
//       configuration,
//     );

//     await Purchases.enableAdServicesAttributionTokenCollection();
//   }

//   static Future<bool> checkSubscriptionStatus() async {
//     final purchaseInfo = await Purchases.getCustomerInfo();
//     if (purchaseInfo.activeSubscriptions.isNotEmpty) {
//       return true;
//     }
//     return false;
//   }

//   static Future<void> buySubscription(Package userSelectedPackage) async {
//     try {
//       final customerInfo = await Purchases.purchasePackage(userSelectedPackage);
//       final isPro = customerInfo.entitlements.all['premium']
//           .isActive; 
//       if (isPro) {
//         // update has active subscription status in the IAP module
//         return true;
//       }
//     } on PlatformException catch (e) {
//       final errorCode = PurchasesErrorHelper.getErrorCode(e);
//       if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
//         print('User cancelled');
//       } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
//         print('User not allowed to purchase');
//       } else if (errorCode == PurchasesErrorCode.paymentPendingError) {
//         print('Payment is pending');
//       }
//     }
//   }

//   static Future<List<Package>> fetchIAPItems() async {
//     try {
//       final offerings = await Purchases.getOfferings();
//       final packages = offerings.current.availablePackages;
//       return packages;
//     } catch (e) {
//       throw e;
//     }
//   }

//   static Future<void> restoreSubscription() async {
//     try {
//       await Purchases.restorePurchases();
//     } catch (e) {
//       // Handle restore error
//     }
//   }

//   // static loginUser(String appUserID) async {
//   //   await Purchases.logIn(appUserID);
//   // }

//   static logoutUser() async {
//     await Purchases.logOut();
//   }

//   static Future<void> cancelSubscription() async {
//     try {} catch (e) {
//       // Handle cancel error
//     }
//   }
// }

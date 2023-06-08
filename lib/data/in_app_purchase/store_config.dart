// import 'package:flutter/foundation.dart';

// enum revenueCatStore { appleStore, googlePlay, amazonAppstore }

// class StoreConfig {
//   final revenueCatStore store;
//   final String apiKey;
//   static StoreConfig _instance;

//   factory StoreConfig({@required revenueCatStore store, @required String apiKey}) {
//     _instance ??= StoreConfig._internal(store, apiKey);
//     return _instance;
//   }

//   StoreConfig._internal(this.store, this.apiKey);

//   static StoreConfig get instance {
//     return _instance;
//   }

//   static bool isForAppleStore() => _instance.store == revenueCatStore.appleStore;

//   static bool isForGooglePlay() => _instance.store == revenueCatStore.googlePlay;

//   static bool isForAmazonAppstore() => _instance.store == revenueCatStore.amazonAppstore;
// }
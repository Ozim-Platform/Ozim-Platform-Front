import 'package:charity_app/data/in_app_purchase/in_app_purchase_data_repository.dart';
import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();
  UserData _userData = new UserData();

  String _username = '';

  String get username => _username;

  String _imagePath = '';

  String get imagePath => _imagePath;

  TextEditingController _search = new TextEditingController();

  TextEditingController get search => _search;

  List<Category> _category;

  List<Category> get category => _category;

  bool _isLoadingCategory = true;
  bool get isLoadingCategory => _isLoadingCategory;

  bool _isLoadingBanner = true;
  bool get isLoadingBanner => _isLoadingBanner;

  CommonModel _banner;

  CommonModel get banner => _banner;

  Future<void> initData() async {
    _username = await _userData.getUsername();
    await InAppPurchaseDataRepository().getSubscriptionIds();
    // InAppPurchaseDataRepository().init();
    await InAppPurchaseDataRepository().checkCurrentSubscription();
    await InAppPurchaseDataRepository().fetchAvailableSubscriptions();
    notifyListeners();
  }

  Future<void> getBanner() async {
    _isLoadingBanner = true;
    _apiProvider
        .getBanner()
        .then((value) => _banner = value)
        .catchError((error, trace) {
      // print("Error: $error", level: 1);
      // print(trace, level: 1);
    }).whenComplete(
      () => {
        _isLoadingBanner = false,
        notifyListeners(),
      },
    );
  }

  Future<void> getCategory() async {
    _isLoadingCategory = true;

    getBanner();

    _apiProvider
        .getCategory()
        .then((value) => {
              _category = value,
            })
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoadingCategory = false, notifyListeners()});
  }
}

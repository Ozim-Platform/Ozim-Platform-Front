import 'package:charity_app/model/partner.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ExchangePointsViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();
  ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  int _points;
  List<Partner> _partners = [];

  int get points => _points;

  List<Partner> get partners => _partners;

  ExchangePointsViewModel() {
      setBusy(true);
  }

  Future<void> init() async {
    setBusy(true);
    _isLoading.notifyListeners();
    await _apiProvider.getUser().then((value) {
      _points = value.points;
    });
    await _apiProvider.fetchAllPartners().then((value) {
      _partners = value;
    });
    _isLoading.notifyListeners();
    notifyListeners();
    setBusy(false);
  }
}

import 'dart:developer';

import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:toast/toast.dart';

class AddChildViewModel extends BaseViewModel {
  final ApiProvider _apiProvider = new ApiProvider();
  ValueNotifier<bool> _isGirl = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isGirl => _isGirl;

  String _name = '';

  String get name => _name;

  DateTime _birthDate;

  DateTime get birthDate => _birthDate;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController get nameController => _nameController;

  void setBirthDate(DateTime value) {
    _birthDate = value;
    notifyListeners();
  }

  setName(String value) {
    _name = value;
    notifyListeners();
  }

  setIsGirl(bool value) {
    _isGirl.value = !_isGirl.value;
    isGirl.notifyListeners();
  }

  void setIsBoy(bool value) {
    _isGirl.value = !value;
    isGirl.notifyListeners();
  }

  createChild(context) async {
    log(name);
    log(birthDate.toString());
    if (name != "" && birthDate != null) {
      var result = await _apiProvider.createChild(
        _name,
        (_birthDate.toString()).substring(0, 10),
        _isGirl.value ? 1 : 2,
      );
      log("we sent request for creating a child");
      if (result == true) {
        ToastUtils.toastSuccessGeneral("Child Added Successfully", context);
        Navigator.of(context).pop();
        
        return true;
      } else {
        ToastUtils.toastErrorGeneral(
            "There was an error while adding child", context);
        Navigator.of(context).pop();
        return false;
      }
    } else {
      return false;
    }
  }
}

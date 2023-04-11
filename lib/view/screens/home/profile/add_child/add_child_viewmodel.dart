import 'dart:developer';

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/child/child.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/view/screens/home/profile/child_results/child_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddChildViewModel extends BaseViewModel {
  final ApiProvider _apiProvider = new ApiProvider();

  ValueNotifier<bool> _isGirl = ValueNotifier<bool>(false);

  ValueNotifier<bool> get isGirl => _isGirl;

  String _name = '';

  String get name => _name;

  ValueNotifier<DateTime> _birthDate = ValueNotifier(
    DateTime.now(),
  );

  ValueNotifier<DateTime> get birthDate => _birthDate;

  TextEditingController _nameController = new TextEditingController();

  TextEditingController get nameController => _nameController;

  Child child;

  AddChildViewModel({Child child}) {
    if (child != null) {
      this.child = child;
      _name = child.name;
      log(child.birthDate);
      _birthDate.value = DateTime.parse(child.birthDate);
      _isGirl.value = child.isGirl;
    }
  }

  void setBirthDate(DateTime value) {
    // check whether a child is null or not
    _birthDate.value = value;
    notifyListeners();
  }

  void resetBirthDate(DateTime value) {
    if (child != null) {
      _birthDate.value = DateTime.parse(child.birthDate);
    } else {
      _birthDate.value = value;
    }
  }

  setName(String value) {
    _name = value;
    notifyListeners();
  }

  setIsGirl(bool value) {
    if (child == null) {
      _isGirl.value = !_isGirl.value;
      isGirl.notifyListeners();
    }
  }

  setIsBoy(bool value) {
    if (child == null) {
      _isGirl.value = !value;
      isGirl.notifyListeners();
    }
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
        ToastUtils.toastSuccessGeneral(
            getTranslated(context, "success"), context);
        // Navigator.of(context).pop();
        // push screen with all children
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ChildResultsScreen()),
          (Route<dynamic> route) => route.isFirst,
        );

        return true;
      } else {
        ToastUtils.toastErrorGeneral(
          getTranslated(context, "error"),
          context,
        );
        Navigator.of(context).pop();
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> updateChild(
    BuildContext context,
  ) async {
    var response =
        await _apiProvider.updateChild(birthDate.value, child.childId);
    if (response.statusCode == 200) {
      ToastUtils.toastSuccessGeneral("success", context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ChildResultsScreen()),
        (Route<dynamic> route) => route.isFirst,
      );
    } else {
      ToastUtils.toastErrorGeneral(
        response.body.toString(),
        context,
      );
    }
  }

  Future<void> sendRequest(BuildContext context) {
    if (child == null) {
      return createChild(
        context,
      );
    } else {
      // make sure that the user has changed the date
      return updateChild(
        context,
      );
    }
  }
}

import 'dart:developer';

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/child/child.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/view/screens/home/profile/child_results/child_results_screen.dart';
import 'package:charity_app/view/screens/home/profile/profile_screen_viewmodel.dart';
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

  bool isLoading = false;

  ProfileViewModel _profileScreenViewModel;

  AddChildViewModel(Child child, [ProfileViewModel profileScreenViewModel]) {
    if (child != null) {
      this.child = child;
      _name = child.name;
      log(child.birthDate);
      _birthDate.value = DateTime.parse(child.birthDate);
      _isGirl.value = child.isGirl;
    }
    profileScreenViewModel != null
        ? _profileScreenViewModel = profileScreenViewModel
        : null;
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
    isLoading = true;

    log(name);
    log(birthDate.toString());
    if (name != "" && birthDate != null) {
      var result = await _apiProvider.createChild(
        _name,
        (_birthDate.value.toString()).substring(0, 10),
        _isGirl.value ? 1 : 2,
      );
      if (result == true) {
        ToastUtils.toastSuccessGeneral(
            getTranslated(context, "success"), context);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ChildResultsScreen()),
          (Route<dynamic> route) => route.isFirst,
        );
        if (_profileScreenViewModel != null) {
          _profileScreenViewModel.getChildren();
        }
        isLoading = false;

        return true;
      } else {
        ToastUtils.toastErrorGeneral(
          getTranslated(context, "error"),
          context,
        );
        Navigator.of(context).pop();
        isLoading = false;
        return false;
      }
    } else {
      isLoading = false;
      return false;
    }
  }

  Future<void> updateChild(
    BuildContext context,
  ) async {
    isLoading = true;

    var response =
        await _apiProvider.updateChild(birthDate.value, child.childId);
    if (response.statusCode == 200) {
      ToastUtils.toastSuccessGeneral(
          getTranslated(context, "success"), context);
      isLoading = false;
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
      isLoading = false;
    }
  }

  Future<void> sendRequest(BuildContext context) {
    if (isLoading == false) {
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

      // call getChildren function from the profileViewModel
    }
  }
}

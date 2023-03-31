import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/view/screens/auth/access_via_social_media_screen.dart';
import 'package:charity_app/view/screens/auth/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stacked/stacked.dart';

class DrawerViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();
  UserData _userData = new UserData();

  TextEditingController _search = new TextEditingController();

  TextEditingController get search => _search;

  List<Category> _category;

  List<Category> get category => _category;

  List<Data> _folders = [];

  List<Data> get folders => _folders;

  String _username = '';

  String get username => _username;

  String _avatar;

  String get avatar => _avatar;

  bool _isLoadingCategory = false;

  bool get isLoadingCategory => _isLoadingCategory;

  Future<void> getCategory() async {
    _isLoadingCategory = true;
    _apiProvider
        .getCategory()
        .then((value) => {
              _category = value,
            })
        .catchError((error) {
      //print("Error: $error");
    }).whenComplete(() => {_isLoadingCategory = false, notifyListeners()});
  }

  update() async {
    _avatar = await _userData.getAvatar();
    notifyListeners();
  }

  Future<void> initData() async {
    _username = await _userData.getUsername();
    _avatar = await _userData.getAvatar();
    notifyListeners();
  }

  Future<void> logOut(BuildContext context) async {
    _userData.clearData();
    logOutGoogle();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashScreen()),
            (Route<dynamic> route) => false);
  }

  Future<void> getBookmarksFolders() async {
    _apiProvider
        .getBookMarkFolders()
        .then((value) => {_folders = value})
        .catchError((error) {})
        .whenComplete(() => {});
  }
}

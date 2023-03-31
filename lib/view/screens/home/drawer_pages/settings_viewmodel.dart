import 'dart:convert';
import 'dart:io';

import 'package:charity_app/localization/language.dart';
import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/screens/home/drawer/drawer_viewmodel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class SettingsViewModel extends BaseViewModel {
  final DrawerViewModel drawerModel;

  SettingsViewModel(this.drawerModel);

  UserData _userData = new UserData();
  ApiProvider _apiProvider = ApiProvider();
  FirebaseStorage storage = FirebaseStorage.instance;

  BuildContext context;
  int _selectLanguage = 0;
  Language language;
  var langCode = ["uz", "ru"];

  int _radioValue = 1;

  int get radioValue => _radioValue;

  bool _newComment = true;

  bool get newComment => _newComment;
  bool _replyComment = true;

  bool get replyComment => _replyComment;
  bool _permissionNotification = true;

  bool get permissionNotification => _permissionNotification;

  bool _processloadingImage = false;

  bool get processloadingImage => _processloadingImage;

  String _lang = '';

  String get lang => _lang;

  String _username = '';

  String get username => _username;

  String _imageUrl = '';

  String get imageUrl => _imageUrl;

  // image settings
  File _imageFile;
  final _picker = ImagePicker();
  var fileName = "", fileSource, fileSize, fileExt;

  void setContext(BuildContext context) async {
    this.context = context;
    initData();
  }

  Future<void> initData() async {
    _lang = await _userData.getLang();
    if (_lang == "ru") {
      _radioValue = 2;
    } else {
      _radioValue = 1;
    }
    _username = await _userData.getUsername();
    _imageUrl = await _userData.getAvatar();
    notifyListeners();
  }

  Future<void> newCommentFunc(bool data) async {
    _newComment = data;
    notifyListeners();
  }

  Future<void> replyCommentFunc(bool data) async {
    _replyComment = data;
    notifyListeners();
  }

  Future<void> permissionNotificationFunc(bool data) async {
    if (!data) {
      _newComment = data;
      _replyComment = data;
    }
    _permissionNotification = data;
    notifyListeners();
  }

  Future<void> changeLanguage(int position) async {
    _selectLanguage = position;
    Utils.changeLanguage(context, langCode[_selectLanguage]);
  }

  Future<void> handleRadioValueChange(int value) async {
    _radioValue = value;

    switch (_radioValue) {
      case 1:
        changeLanguage(0);
        break;
      case 2:
        changeLanguage(1);
        break;
    }
    notifyListeners();
  }

  Future<void> pickFile() async {
    final PickedFile pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // File croppedFile = await ImageCropper.cropImage(
      //     sourcePath: pickedFile.path,
      //     maxHeight: 512,
      //     maxWidth: 512,
      //     aspectRatioPresets: [
      //       CropAspectRatioPreset.square,
      //     ],
      //     androidUiSettings: AndroidUiSettings(
      //         toolbarTitle: 'Cropper',
      //         toolbarColor: Colors.deepOrange,
      //         toolbarWidgetColor: Colors.white,
      //         initAspectRatio: CropAspectRatioPreset.original,
      //         lockAspectRatio: true),
      //     iosUiSettings: IOSUiSettings(
      //       minimumAspectRatio: 1.0,
      //     ));
      // _processloadingImage = true;
      // notifyListeners();
      // _imagePicked(croppedFile);
    }
  }

  Future<void> _imagePicked(File pickedFile) async {
    if (pickedFile?.path != null) {
      var tempImage = File(pickedFile.path);
      fileSize = tempImage.lengthSync().toString();
      var byt = tempImage.readAsBytesSync();
      fileSource = base64Encode(byt);
      fileName = pickedFile.path.split("/").last;
      fileExt = fileName.split(".").last;

      String email = await _userData.getEmail();

      try {
        await FirebaseStorage.instance.ref('users/$email/avatar.png').putFile(tempImage);

        try {
          await _apiProvider.changeUserAvatar(tempImage, pickedFile.path);
        } catch (e) {
          ToastUtils.toastErrorGeneral('Не удалось в БД Ozim. ${e}', context);
        }

        String newavatarurl = (await _apiProvider.getUser()).avatar ?? "";
        _userData.setAvatar(newavatarurl);
        _imageUrl = await _userData.getAvatar();
        _processloadingImage = false;
        await drawerModel.update();
        notifyListeners();
      } on FirebaseException catch (e) {
        ToastUtils.toastErrorGeneral('Не удалось сохранить в Firebase. ${e}', context);
        print(e, level: 1);
      }
    } else {
      _processloadingImage = false;
      notifyListeners();
      ToastUtils.toastErrorGeneral('Не найден файл', context);
    }
  }
}

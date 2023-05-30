import 'dart:developer';
import 'dart:io';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Downloader {
  HttpClient httpClient = new HttpClient();
  final baseUrl = 'https://ozimplatform.kz/';

  Future<String> getDownloadPath() async {
    Directory directory;

    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');

        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<bool> _requestPermission() async {
    bool permissionGranted = false;
    if (Platform.isAndroid) {
      var accessMediaStatus = await Permission.accessMediaLocation.request();
      // var status = await Permission.manageExternalStorage.request();
      var status = await Permission.storage.request();
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else if (status.isGranted) {
        permissionGranted = true;
      } else {
        status = await Permission.storage.request();
        permissionGranted = status.isGranted;
      }

      permissionGranted = status.isGranted;
    } else {
      // var accessMediaStatus = await Permission.accessMediaLocation.request();
      // var status = await Permission.manageExternalStorage.request();
      var status = await Permission.storage.request();
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else if (status.isGranted) {
        permissionGranted = true;
      } else {
        status = await Permission.storage.request();
        permissionGranted = status.isGranted;
      }

      permissionGranted = status.isGranted;
    }
    return permissionGranted;
  }

  Future<String> downloadFile(
    String url,
    String fileName,
    BuildContext context,
  ) async {
    File file;
    String filePath = '';

    if (await _requestPermission() == true) {
      try {
        var dir = await getDownloadPath();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(getTranslated(context, "download_started")),
        ));
        var request = await httpClient.getUrl(
          Uri.parse(
            baseUrl + "/" + url,
          ),
        );
        var response = await request.close();
        if (response.statusCode == 200) {
          try {
            var bytes = await consolidateHttpClientResponseBytes(response);
            filePath = '$dir/$fileName';
            file = File(filePath);
            await file.writeAsBytes(bytes);
            ToastUtils.toastSuccessGeneral(
                getTranslated(context, "download_successful"), context);
          } catch (e) {
            ToastUtils.toastErrorGeneral(
                getTranslated(context, "error"), context);
            filePath = 'Error code: ' + response.statusCode.toString();
            throw e;
          }
        } else {
          ToastUtils.toastErrorGeneral(
              getTranslated(context, "error"), context);
          filePath = 'Error code: ' + response.statusCode.toString();
        }
      } catch (ex) {
        filePath = 'Can not fetch url';
        ToastUtils.toastErrorGeneral(getTranslated(context, "error"), context);
      }
      return filePath;
    }
  }
}

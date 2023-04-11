import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
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
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  Future<bool> _requestPermission() async {
    bool permissionGranted = false;
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      permissionGranted = status.isGranted;
      if (!permissionGranted) {
        status = await Permission.storage.request();
        permissionGranted = status.isGranted;
      }
    } else {
      permissionGranted = true;
    }
    return permissionGranted;
  }

  Future<String> downloadFile(
    String url,
    String fileName,
  ) async {
    File file;
    String filePath = '';

    var dir = await getDownloadPath();
    _requestPermission();
    try {
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
        } catch (e) {
          throw e;
        } 
      } else {
        filePath = 'Error code: ' + response.statusCode.toString();
      }
    } catch (ex) {
      filePath = 'Can not fetch url';
    }
    log(filePath);

    return filePath;
  }
}


class NotificationService {
  //Hanle displaying of notifications.
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('ic_launcher');

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal() {
    init();
  }

  void init() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: _androidInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void createNotification(int count, int i, int id) {
    //show the notifications.
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'progress channel', 'progress channel',
        channelDescription: 'progress channel description',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: count,
        progress: i);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    _flutterLocalNotificationsPlugin.show(id, 'progress notification title',
        'progress notification body', platformChannelSpecifics,
        payload: 'item x');
  }
}

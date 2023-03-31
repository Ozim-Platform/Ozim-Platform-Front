import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/main.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/persistance/hive_boxes.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:html/parser.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static void changeLanguage(BuildContext context, String language) async {
    UserData userData = UserData();
    userData.setLang(language);
    Locale _locale = await setLocale(language);
    // MyApp.setLocale(context, _locale);
    // BottomNavigationState.rebuild = true;
    Constants.listnablemodels.forEach((element) {
      element.getCategory();
    });
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

class MyPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    return [event.message];
  }
}

class MyConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach((el) {
      log((event.level.toString()).replaceAll('Level.', '') + el, level: 600);
    });
  }
}

print(message, {level: 'd'}) {
  var levels = ['e', 'w', 'v', 'i', 'd', 'wtf'];
  if (level is int) {
    if (level > levels.length) {
      return print('Не правильно указан уровень ошибки', level: 1);
    }
    level = levels[level - 1];
  }

  int count = 2;
  switch (level) {
    case 'd':
      break;
    case 'e':
      count = 10;
      break;
    case 'i':
      count = 3;
      break;
    case 'v':
      count = 2;
      break;
    case 'w':
      count = 5;
      break;
    case 'wtf':
      count = 20;
      break;
  }

  var logger = Logger(
    filter: MyFilter(),
    output: MyConsoleOutput(),
    printer: PrettyPrinter(
      methodCount: count,
      errorMethodCount: count,
      lineLength: 120,
      colors: false,
      printEmojis: true,
      // printTime: true
    ),
  );

  switch (level) {
    case 'd':
      logger.d(message);
      break;
    case 'e':
      logger.e(message);
      break;
    case 'i':
      logger.i(message);
      break;
    case 'v':
      logger.v(message);
      break;
    case 'w':
      logger.w(message);
      break;
    case 'wtf':
      logger.wtf(message);
      break;
  }
}

int toInt(item) {
  if (item is int) return item;
  if (item is bool) return item ? 1 : 0;
  if (item == null) return 0;
  if (item is double) return item.round();
  return int.parse(item.toString());
}

String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  if (document.body != null) {
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  } else
    return htmlString;
}

num getTimestamp(dynamic time) {
  if (time is num) return time;
  DateTime dateTime = DateTime.parse(time);
  return Timestamp.fromDate(dateTime).seconds;
}

String cutString(String string, int count) {
  if (string.length <= count) return string;
  string = string.substring(0, count) + '...';
  return string;
}

String getTypeFromModel(model) {
  String type = model.runtimeType.toString();
  type = type.replaceAll('ViewModel', '');
  type = type.toLowerCase();
  return type;
}

List<Category> getCategoryOfType(List<Category> categories, String type) {
  List<Category> result = [];
  if (categories == null) return result;
  categories.forEach((category) {
    if (category.type != null) {
      if (category.type.type == type) {
        result.add(category);
      }
    }
  });
  return result;
}

int getCategoryIndex(List categories, String category) {
  int result = 0;
  if (categories == null) return result;
  categories.asMap().forEach((index, cat) {
    if (cat.runtimeType == Category) {
      if (cat.sysName == category) {
        result = index;
      }
    } else if (cat.runtimeType == Data) {
      if (cat.name == category) {
        result = index;
      }
    }
  });
  return result;
}

String getFirstTypeOfCategory(List<Category> category) {
  String cat;
  if (category.length > 0) {
    cat = category[0].sysName != null ? category[0].sysName : null;
  }
  return cat;
}

String getCatUrl(Category category) {
  String url = category != null ? '&category=' + category.sysName : '';
  // print(url, level: 2);
  return url;
}

List getListOfInstancesByCategory(List instances, String category) {
  List list = [];
  if (instances == null) return list;

  instances.forEach((element) {
    var instance = element.toJson();
    if (instance['category'] == category) {
      list.add(element);
    }
  });
  return list;
}

List getListOfInstancesByFolder(List instances, String folder) {
  List list = [];
  if (instances == null) return list;
  instances.forEach((element) {
    var instance = element.toJson();
    if (instance['bookmark_folder'] == folder) {
      list.add(element);
    }
  });
  return list;
}

// initNotices(Future<dynamic> Function(String payload) _onSelectNotification) async {
//   try {
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     final android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final iOS = IOSInitializationSettings();
//     final initSettings = InitializationSettings(android: android, iOS: iOS);
//     if (flutterLocalNotificationsPlugin != null) {
//       flutterLocalNotificationsPlugin.initialize(initSettings,
//           onSelectNotification: _onSelectNotification);
//     }
//   } catch (e) {
//     print('Error', level: 1);
//   }
// }

initFCM() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    ///Getting permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    ///Allow foreground notifications for IOS
    if (Platform.isIOS) {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        ///Do some thing when FCM is coming for foreground
      });

      ///Allow foreground notifications for Android
    } else if (Platform.isAndroid) {
      ///Register High level messaging channel for fcm
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel_id', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', // description
        importance: Importance.max,
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          .createNotificationChannel(channel);
      final box = await Hive.openBox<int>(HiveBoxes.countBox);
      final n = Notif(box);

      ///Create local notification when FCM is coming for foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showLocalNotification(channel, message);
        n.increment();
      });
    }

    var fcmToken = await messaging.getToken();
    print('TOKEN IS: $fcmToken');
    if (fcmToken != null) {
      await saveFCM(fcmToken);
    }

    messaging.onTokenRefresh.listen(saveFCM);
  } catch (e) {}
}

_showLocalNotification(channel, message) {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  RemoteNotification notification = message.notification;
  AndroidNotification android = message.notification.android;
  if (notification != null && android != null) {
    if (flutterLocalNotificationsPlugin != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name, channelDescription :channel.description,
              icon: android.smallIcon, color: AppColor.primary
              // other properties...
              ),
        ),
      );
    }
  }
}

Future<void> saveFCM(fcmtoken) async {
  ApiProvider apiProvider = ApiProvider();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  prefs.setString('fcmtoken', fcmtoken);
  await apiProvider.saveFCM(fcmtoken);
}

Future<String> getFCM() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  var fcm = prefs.getString('fcmtoken');
  return fcm;
}

Future<void> goToUrl(String url, context) async {
  if (!url.contains('http://') && !url.contains('https://')) {
    url = "https://" + url;
  }
  print(url);
  if (await canLaunch(url.trim())) {
    await launch(url);
  } else {
    ToastUtils.toastErrorGeneral('Не возможно перейти по ссылке', context);
  }
}

Timer setTimeout(callback, [int duration = 1000]) {
  return Timer(Duration(milliseconds: duration), callback);
}

Future<void> setCommentsCount(int count) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  prefs.setInt('comment_count', count);
}

Future<void> setForumCount(int count) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  prefs.setInt('forum_count', count);
}

Future<int> getCommentsCount() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  int count = prefs.getInt('comment_count');
  return count ?? 0;
}

Future<int> getForumCount() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;
  int count = prefs.getInt('forum_count');
  return count ?? 0;
}

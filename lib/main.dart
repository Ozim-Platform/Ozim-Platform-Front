import 'dart:io';

import 'package:charity_app/data/in_app_purchase/store_config.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/persistance/hive_boxes.dart';
import 'package:charity_app/providers/locator.dart';
import 'package:charity_app/service/network_service.dart';
import 'package:charity_app/service/network_status.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/screens/auth/splash_screen.dart';
import 'package:charity_app/view/theme/my_themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'localization/demo_localizations.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox<int>(HiveBoxes.countBox);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseApp app = await Firebase.initializeApp();
  Constants.db = FirebaseFirestore.instanceFor(
    app: app,
  );

  // await initNotices(_onSelectNotification);
  await initFCM();
  setupLocator();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
    (_) => runApp(
      MyApp(),
    ),
  );
}

Future<dynamic> _onSelectNotification(String json) async {
  if (json != null) {
    print(json);
    // final obj = jsonDecode(json);
    // if (obj['isSuccess']) {
    //   OpenFile.open(obj['filePath']);
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (_) => AlertDialog(
    //       title: Text('Error'),
    //       content: Text('${obj['error']}'),
    //     ),
    //   );
    // }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<NetworkStatus>(
      initialData: NetworkStatus.Offline,
      create: (context) => NetworkService().networkStatusController.stream,
      child: ThemeProvider(
        defaultThemeId: 'light',
        themes: <AppTheme>[
          AppTheme(
            id: 'light',
            data: MyThemes.lightTheme,
            description: 'light',
          ),
          AppTheme(id: 'dark', data: MyThemes.lightTheme, description: 'dark'),
        ],
        saveThemesOnChange: true,
        loadThemeOnInit: false,
        // Do not load the saved view.theme(use onInitCallback callback)
        onInitCallback: (controller, previouslySavedThemeFuture) async {
          // UserData _userData = UserData();
          // final _locale = await _userData.getLang();
          // MyApp.setLocale(context, _locale);

          String savedTheme = await previouslySavedThemeFuture;

          if (savedTheme != null) {
            // If previous view.theme saved, use saved view.theme
            controller.setTheme(savedTheme);
          } else {
            // If previous view.theme not found, use platform default
            Brightness platformBrightness =
                SchedulerBinding.instance.window.platformBrightness;
            if (platformBrightness == Brightness.dark) {
              controller.setTheme('light');
            } else {
              controller.setTheme('light');
            }
            // Forget the saved view.theme(which were saved just now by previous lines)
            controller.forgetSavedTheme();
          }
        },

        child: ThemeConsumer(
          child: Builder(
            builder: (themeContext) => ScreenUtilInit(
                designSize: Size(
                  390,
                  844,
                ),
                builder: (context, child) {

                  return MaterialApp(
                    navigatorKey: navigatorKey,
                    theme: ThemeProvider.themeOf(themeContext).data,
                    debugShowCheckedModeBanner: false,
                    title: 'Charity App',
                    home: SplashScreen(),
                    locale: _locale,
                    supportedLocales: [
                      Locale('kk', 'KK'),
                      Locale('ru', 'RU'),
                    ],
                    localizationsDelegates: [
                      DemoLocalization.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    localeResolutionCallback: (locale, supportedLocales) {
                      for (var supportedLocale in supportedLocales) {
                        if (supportedLocale.languageCode ==
                                locale.languageCode &&
                            supportedLocale.countryCode == locale.countryCode) {
                          return supportedLocale;
                        }
                        // //print(supportedLocale);
                      }

                      return supportedLocales.first;
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }
}

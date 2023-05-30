import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/view/components/btn_ui.dart';
import 'package:charity_app/view/screens/home/bottom_navigation.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notification_permissions/notification_permissions.dart';

class PermissionForNotification extends StatefulWidget {
  @override
  _PermissionForNotification createState() => _PermissionForNotification();
}

class _PermissionForNotification extends State<PermissionForNotification>
    with WidgetsBindingObserver {
  UserData _userData = new UserData();
  ApiProvider _apiProvider = new ApiProvider();

  Future<String> permissionStatusFuture;
  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";

  @override
  void initState() {
    super.initState();
    permissionStatusFuture = getCheckNotificationPermStatus();
    WidgetsBinding.instance.addObserver(this);
    _userData.getToken().then((value) => {
          getUser(context, value),
        });
  }

  @override
  setState(fn) {
    if (mounted) {
      super.setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        permissionStatusFuture = getCheckNotificationPermStatus();
      });
    }
  }

  /// Checks the notification permission status
  Future<String> getCheckNotificationPermStatus() {
    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      switch (status) {
        case PermissionStatus.denied:
          return permDenied;
        case PermissionStatus.granted:
          return permGranted;
        case PermissionStatus.unknown:
          return permUnknown;
        case PermissionStatus.provisional:
          return permProvisional;
        default:
          return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/image/permission_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Container(
              // constraints: BoxConstraints(maxWidth: 450),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: SizeConfig.calculateBlockVertical(5)),
                  Container(
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: SizeConfig.calculateBlockVertical(20)),
                            Text(
                              getTranslated(context, 'give_permission'),
                              // textScaleFactor: SizeConfig.textScaleFactor(),

                              style: TextStyle(
                                // fontFamily: 'Arial',
                                fontSize: 23.0.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF758084),
                              ),
                            ),
                            SizedBox(
                                height: SizeConfig.calculateBlockVertical(20)),
                            SvgPicture.asset('assets/svg/permission.svg'),
                            SizedBox(
                                height: SizeConfig.calculateBlockVertical(20)),
                            Text(
                              getTranslated(context, 'permission_info'),
                              // textScaleFactor: SizeConfig.textScaleFactor(),
                              style: TextStyle(
                                // fontFamily: 'Arial',
                                fontSize: 16.0.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF758084),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                                height: SizeConfig.calculateBlockVertical(30)),
                            BtnUI(
                              height: 55.w,
                              isLoading: false,
                              textColor: Colors.white,
                              color: AppColor.primary,
                              text: getTranslated(context, 'permission'),
                              onTap: () {
                                var string = getCheckNotificationPermStatus();
                                string.then((value) => {
                                      if (permGranted == value)
                                        {
                                          _userData.setFirstTime(false),
                                          Navigator.of(
                                                  context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BottomNavigation()),
                                                  (Route<dynamic> route) =>
                                                      false),
                                        }
                                      else
                                        {
                                          NotificationPermissions
                                                  .requestNotificationPermissions(
                                                      iosSettings:
                                                          const NotificationSettingsIos(
                                                              sound: true,
                                                              badge: true,
                                                              alert: true))
                                              .then((_) {
                                            setState(() {
                                              permissionStatusFuture =
                                                  getCheckNotificationPermStatus();
                                            });
                                          }),
                                        }
                                    });
                              },
                            ),
                            SizedBox(
                                height:
                                    SizeConfig.calculateBlockVertical(20.h)),
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                _userData.setFirstTime(false);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BottomNavigation()),
                                    (Route<dynamic> route) => false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  getTranslated(context, 'no_permission'),
                                  // textScaleFactor: SizeConfig.textScaleFactor(),
                                  style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontWeight: FontWeight.normal,
                                    // fontFamily: 'Arial',
                                    color: const Color(0xFF758084),
                                  ),
                                ),
                              ),
                            ),
                            FutureBuilder(
                                future: permissionStatusFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  if (snapshot.hasData) {
                                    var textWidget = Text(
                                      "The permission status is ${snapshot.data}",
                                      softWrap: true,
                                      // textScaleFactor:
                                      // SizeConfig.textScaleFactor(),
                                      textAlign: TextAlign.center,
                                    );
                                    // The permission is granted, then just show the text
                                    if (snapshot.data == permGranted) {
                                      return Text('');
                                      // return textWidget;
                                    }
                                  }
                                  return Text('');
                                  // return Text("No permission status yet");
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getUser(BuildContext context, String token) async {
    _apiProvider
        .getUser()
        .then((value) => {
              _userData.setUsername(value.name ?? ''),
              _userData.setEmail(value.email ?? ''),
              _userData.setPhoneNumber(value.phone ?? ''),
              _userData.setAvatar(value.avatar ?? ""),
              _userData.setUserType(value.type ?? ""),
            })
        .catchError((onError) {
      ToastUtils.toastErrorGeneral("Error $onError", context);
    }).whenComplete(() => {});
  }
}

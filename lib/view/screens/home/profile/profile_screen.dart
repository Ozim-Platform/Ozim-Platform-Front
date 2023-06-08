import 'dart:convert';
import 'dart:io';

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/view/components/user_image.dart';
import 'package:charity_app/view/screens/home/drawer/drawer_viewmodel.dart';
import 'package:charity_app/view/screens/home/profile/add_child/add_child_screen.dart';
import 'package:charity_app/view/screens/home/profile/child_results/child_results_screen.dart';
import 'package:charity_app/view/screens/home/profile/exchange_points/exchange_points_screen.dart';
import 'package:charity_app/view/screens/home/profile/profile_screen_viewmodel.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_viewmodel.dart';
import 'package:charity_app/view/screens/other/notification/notification_screen.dart';
import 'package:charity_app/view/widgets/blurred_avatar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';

class ProfileScreen extends StatefulWidget {
  int childId;
  ProfileScreen({Key key, this.childId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppBar appBar;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(),
        onViewModelReady: (model) => model.initModel(widget.childId),
        builder: (context, model, snapshot) {
          profileScreenAppBar(
            context,
            false,
            model,
          ).then(
            (value) => setState(
              () {
                appBar = value;
              },
            ),
          );

          return Scaffold(
            appBar: appBar,
            body: model.shouldShowChildQuestionaire.value == true
                ? NewQuestionaireAvailableWidget(
                    model: model,
                  )
                : ListView(
                    padding: EdgeInsets.only(
                      top: 76.h,
                    ),
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () async {
                          if (model.navigateToAddChild.value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddChildScreen(
                                  profileScreenViewModel: model,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChildResultsScreen(),
                              ),
                            );
                          }

                          ;
                        },
                        child: ProfileScreenListWidget(
                          type: "child_results",
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationScreen(),
                            ),
                          );
                        },
                        child: ProfileScreenListWidget(
                          type: "discussions",
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExchangePointsScreen(),
                            ),
                          );
                        },
                        child: ProfileScreenListWidget(
                          type: "exchange_points",
                        ),
                      ),
                    ],
                  ),
          );
        });
  }
}

class ProfileScreenListWidget extends StatefulWidget {
  final String type;
  final String text;

  ProfileScreenListWidget({Key key, this.type, this.text}) : super(key: key);

  @override
  State<ProfileScreenListWidget> createState() =>
      _ProfileScreenListWidgetState();
}

class _ProfileScreenListWidgetState extends State<ProfileScreenListWidget> {
  Color color;

  SvgPicture icon;

  @override
  void initState() {
    switch (widget.type) {
      case 'child_results':
        color = Color(0XFFF1BC62);
        icon = SvgPicture.asset('assets/svg/icons/profile_results.svg');
        break;
      case 'discussions':
        color = Color(0XFF6CBBD9);
        icon = SvgPicture.asset('assets/svg/icons/profile_discussion.svg');
        break;
      case 'exchange_points':
        color = Color(0XFFF08390);
        icon = SvgPicture.asset('assets/svg/icons/profile_points.svg');
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 33.0.w, right: 33.0.w, bottom: 8.w),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: icon,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 16.w,
                bottom: 16.w,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25.w),
                  bottomRight: Radius.circular(25.w),
                  topLeft: Radius.circular(25.w),
                ),
                color: color,
              ),
              child: Text(
                getTranslated(context, widget.type).toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Helvetica Neue",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<AppBar> profileScreenAppBar(BuildContext context, bool showLeadingIcon,
    [ProfileViewModel model]) async {
  UserData _userData = new UserData();
  final _picker = ImagePicker();

  String _username = await _userData.getUsername();

  ValueNotifier<String> _avatar = ValueNotifier(await _userData.getAvatar());

  String _userType = await _userData.getUserType();

  ApiProvider _apiProvider = ApiProvider();

  Future<void> _imagePicked(
      CroppedFile pickedFile, BuildContext context) async {
    if (pickedFile?.path != null) {
      var tempImage = File(pickedFile.path);
      var fileSize = tempImage.lengthSync().toString();
      var byt = tempImage.readAsBytesSync();
      var fileSource = base64Encode(byt);
      var fileName = pickedFile.path.split("/").last;
      var fileExt = fileName.split(".").last;

      String email = await _userData.getEmail();

      try {
        await FirebaseStorage.instance
            .ref('users/$email/avatar.png')
            .putFile(tempImage);
        try {
          await _apiProvider.changeUserAvatar(tempImage, pickedFile.path);
        } catch (e) {
          ToastUtils.toastErrorGeneral('Не удалось в БД Ozim. $e', context);
        }

        String newavatarurl = (await _apiProvider.getUser()).avatar ?? "";
        _userData.setAvatar(newavatarurl);
        String _imageUrl = await _userData.getAvatar();
        _avatar.value = _imageUrl;
      } on FirebaseException catch (e) {
        ToastUtils.toastErrorGeneral(
          'Не удалось сохранить в Firebase. $e',
          context,
        );
      }
    } else {
      ToastUtils.toastErrorGeneral(
        'Не найден файл',
        context,
      );
    }
  }

  Future<void> pickFile(BuildContext context) async {
    final XFile pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        maxHeight: 512,
        maxWidth: 512,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        ],
      );

      await _imagePicked(croppedFile, context);
    }
  }

  return AppBar(
    elevation: 0.0,
    backgroundColor: Color(0xFF79BCB7),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(40),
      ),
    ),
    // toolbarHeight: 40.w,

    toolbarHeight: 80.h,
    automaticallyImplyLeading: false,
    leading: showLeadingIcon == true
        ? Padding(
            padding: EdgeInsets.all(8.0.w),
            child: IconButton(
              iconSize: 20.0.sp,
              splashRadius: 20.sp,
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          )
        : SizedBox(),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(80.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 30.w, bottom: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () async {
                    await pickFile(context);
                  },
                  child: ValueListenableBuilder(
                    valueListenable: _avatar,
                    builder: (BuildContext context, String url, Widget child) {
                      return BlurredAvatar(
                        imageUrl: url,
                        size: 70.0,
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        _username,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: "Helvetica Neue",
                          color: Colors.white,
                          fontSize: 23.sp,
                        ),
                      ),
                      Text(
                        _userType == null ? "" : _userType,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Helvetica Neue",
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 32.0.w),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddChildScreen(),
                        ),
                      ).then(
                        (value) => model.initModel(false),
                      );
                      ;
                    },
                    child: SvgPicture.asset(
                      "assets/svg/icons/add_child.svg",
                      height: 35.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class NewQuestionaireAvailableWidget extends StatefulWidget {
  ProfileViewModel model;
  NewQuestionaireAvailableWidget({Key key, this.model}) : super(key: key);

  @override
  State<NewQuestionaireAvailableWidget> createState() =>
      _NewQuestionaireAvailableWidgetState();
}

class _NewQuestionaireAvailableWidgetState
    extends State<NewQuestionaireAvailableWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 22.w, right: 22.w),
        padding:
            EdgeInsets.only(left: 16.w, right: 16.w, top: 32.h, bottom: 32.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("assets/svg/icons/Group 86.svg"),
            SizedBox(
              height: 16.h,
            ),
            Localizations.localeOf(context).languageCode == "ru"
                ? Text(
                    getTranslated(context, "new_questionaire_available1"),
                    style: TextStyle(
                      fontFamily: "Helvetica Neue",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF7B8387),
                    ),
                  )
                : Text(
                    widget.model.childToDisplay.name +
                        getTranslated(context, "new_questionaire_available1"),
                    style: TextStyle(
                      fontFamily: "Helvetica Neue",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF7B8387),
                    ),
                  ),
            Localizations.localeOf(context).languageCode == "ru"
                ? Text(
                    getTranslated(context, "new_questionaire_available2") +
                        widget.model.childToDisplay.name,
                    style: TextStyle(
                      fontFamily: "Helvetica Neue",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF7B8387),
                    ),
                  )
                : Text(
                    getTranslated(context, "new_questionaire_available2"),
                    style: TextStyle(
                      fontFamily: "Helvetica Neue",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF7B8387),
                    ),
                  ),
            Container(
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.only(
                left: 22,
                right: 22,
                top: 16,
                bottom: 22,
              ),
              padding: EdgeInsets.only(
                left: 22,
                right: 22,
                top: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
                color: Color(0XFF79BCB7),
              ),
              child: InkWell(
                onTap: () {
                  // String email = await UserData().getEmail();
                  QuestionnaireViewModel questionaireModel =
                      QuestionnaireViewModel(
                    passedQuestionnaireData:
                        widget.model.questionnaireDataToDisplay,
                    childId: widget.model.childToDisplay.childId,
                    isResultModel: false,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuestionnaireScreen(
                        viewModel: questionaireModel,
                        data: widget.model.questionnaireDataToDisplay,
                      ),
                    ),
                  );
                },
                child: Text(
                  getTranslated(context, "proceed"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Helvetica Neue",
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                // on diabling the notification for the questionnaire
                widget.model.doNotShowNotification();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  getTranslated(context, "skip"),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Color(0xFF777F83),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/child/child.dart';
import 'package:charity_app/view/screens/home/profile/add_child/add_child_viewmodel.dart';
import 'package:charity_app/view/screens/home/profile/add_child/components/child_type_widget.dart';
import 'package:charity_app/view/screens/home/profile/profile_screen.dart';
import 'package:charity_app/view/screens/home/profile/profile_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';

class AddChildScreen extends StatefulWidget {
  Child child;

  ProfileViewModel profileScreenViewModel;
  AddChildScreen({Key key, this.child, this.profileScreenViewModel})
      : super(key: key);

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  AppBar appBar;

  @override
  void initState() {
    profileScreenAppBar(context, true, widget.profileScreenViewModel).then(
      (value) => setState(
        () {
          appBar = value;
        },
      ),
    );

    super.initState();
  }

  DateTime _dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: ViewModelBuilder<AddChildViewModel>.reactive(
          viewModelBuilder: () => AddChildViewModel(
                widget.child,
                widget.profileScreenViewModel,
              ),
          builder: (
            context,
            model,
            child,
          ) {
            return ListView(
              padding: EdgeInsets.only(
                left: 40.w,
                right: 40.w,
                top: 43.h,
              ),
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    getTranslated(
                      context,
                      "your_child",
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.sp,
                      color: Color(
                        0XFF778083,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 40.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChildTypeWidget(
                        type: "girl",
                        isActiveNotifier: model.isGirl,
                        isGirl: true,
                        onSelected: () {
                          model.setIsGirl(
                            model.isGirl.value,
                          );
                        },
                      ),
                      SizedBox(
                        width: 24.w,
                      ),
                      ChildTypeWidget(
                        type: "boy",
                        isActiveNotifier: (model.isGirl),
                        isGirl: false,
                        onSelected: () {
                          model.setIsGirl(
                            model.isGirl.value,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ChildNameInputWidget(
                  controller: model.nameController,
                  model: model,
                ),
                SizedBox(
                  height: 16.h,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () async {
                    _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: widget.child != null
                            ? DateTime.parse(widget.child.birthDate)
                            : DateTime.now(),
                        mode: CupertinoDatePickerMode.date,
                        maximumDate: DateTime.now(),
                        use24hFormat: true,
                        onDateTimeChanged: (DateTime newDate) {
                          model.setBirthDate(
                            newDate,
                          );
                        },
                      ),
                      model,
                    );
                  },
                  child: Container(
                    height: 50.w,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(
                      left: 20.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          25.w,
                        ),
                      ),
                      color: Colors.white,
                      border: Border.all(
                        width: 1.0,
                        color: Color(
                          0XFFCECECE,
                        ),
                      ),
                    ),
                    child: Text(
                      model.birthDate != null
                          ? (model.birthDate.value.toString()).substring(
                              0,
                              10,
                            )
                          : getTranslated(
                              context,
                              "date_of_birth",
                            ),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        color: Color(
                          0XFFADB1B3,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    model.sendRequest(
                      context,
                    );
                  },
                  child: SaveChildWidget(),
                ),
              ],
            );
          }),
    );
  }

  void _showDialog(Widget datePicker, AddChildViewModel model) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 220.w,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              left: 0,
              top: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // if childs date is not null then I need to put it to the childs birthday
                  CupertinoButton(
                    padding: EdgeInsets.all(0),
                    minSize: 55.w,
                    // color: Colors.black,
                    child: Container(
                        margin: EdgeInsets.all(8.w),
                        padding: EdgeInsets.all(8.w),
                        child: Text(getTranslated(context, "cancel"))),
                    onPressed: () {
                      model.setBirthDate(
                        DateTime.parse(model.child.birthDate),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.all(0),
                    minSize: kMinInteractiveDimensionCupertino + 10,
                    // color: Colors.black,
                    child: Container(
                        margin: EdgeInsets.all(8.w),
                        padding: EdgeInsets.all(8.w),
                        child: Text(getTranslated(context, "done"))),
                    onPressed: () {
                      Navigator.pop(
                        context,
                      );
                    },
                  ),
                ],
              ),
            ),
            SafeArea(child: datePicker),
          ],
        ),
      ),
    );
  }
}

class ChildNameInputWidget extends StatelessWidget {
  ChildNameInputWidget({
    Key key,
    @required TextEditingController controller,
    @required AddChildViewModel model,
  })  : _controller = controller,
        model = model,
        super(key: key);

  final TextEditingController _controller;
  AddChildViewModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.w,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            25.w,
          ),
        ),
        color: Colors.white,
        border: Border.all(
          width: 1.0,
          color: Color(
            0XFFCECECE,
          ),
        ),
      ),
      child: Center(
        child: TextField(
          readOnly: model.child != null ? true : false,
          controller: _controller,
          onChanged: (value) {
            if (model.child == null) {
              model.setName(
                value,
              );
            }
          },
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16.sp,
            color: Color(
              0XFFADB1B3,
            ),
          ),
          obscureText: false,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
              left: 20.w,
            ),
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  25,
                ),
              ),
              borderSide: BorderSide.none,
            ),
            hintText: model.child == null
                ? getTranslated(
                    context,
                    "name",
                  )
                : model.child.name,
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16.sp,
              color: Color(
                0XFFADB1B3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SaveChildWidget extends StatelessWidget {
  const SaveChildWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.w,
      width: 215.w,
      margin: EdgeInsets.only(
        left: 48.w,
        right: 48.w,
        top: 48.w,
      ),
      padding: EdgeInsets.only(
        top: 15.w,
        bottom: 15.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            25.w,
          ),
        ),
        color: Color(
          0XFF79BCB7,
        ),
      ),
      child: Text(
        getTranslated(
          context,
          "save",
        ).toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: Color(0XFFFFFFFF),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

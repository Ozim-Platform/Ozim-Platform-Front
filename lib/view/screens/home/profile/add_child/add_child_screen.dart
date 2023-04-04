import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/view/screens/home/profile/add_child/add_child_viewmodel.dart';
import 'package:charity_app/view/screens/home/profile/add_child/components/child_type_widget.dart';
import 'package:charity_app/view/screens/home/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AddChildScreen extends StatefulWidget {
  AddChildScreen({Key key}) : super(key: key);

  @override
  State<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  AppBar appBar;

  @override
  void initState() {
    profileScreenAppBar(context, true).then((value) => setState(() {
          appBar = value;
        }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: ViewModelBuilder<AddChildViewModel>.reactive(
          viewModelBuilder: () => AddChildViewModel(),
          builder: (context, model, child) {
            return ListView(
              padding: EdgeInsets.only(left: 40, right: 40, top: 43),
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    getTranslated(context, "your_child"),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Color(0XFF778083),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChildTypeWidget(
                        type: "girl",
                        isActiveNotifier: model.isGirl,
                        isGirl: true,
                        onSelected: () => model.setIsGirl(model.isGirl.value),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      ChildTypeWidget(
                        type: "boy",
                        isActiveNotifier: (model.isGirl),
                        isGirl: false,
                        onSelected: () => model.setIsGirl(model.isGirl.value),
                      ),
                    ],
                  ),
                ),
                ChildNameInputWidget(
                  controller: model.nameController,
                  model: model,
                ),
                SizedBox(
                  height: 16,
                ),
                InkWell(splashColor: Colors.transparent,
                  onTap: () async {
                    DateTime _dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        Duration(days: 365 * 10),
                      ),
                      lastDate: DateTime.now().add(
                        Duration(days: 365 * 10),
                      ),
                      locale: await getLocale(),
                    );
                    // set the value inside the view model
                    model.setBirthDate(_dateTime);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                      color: Colors.white,
                      border: Border.all(
                        width: 1.0,
                        color: Color(0XFFCECECE),
                      ),
                    ),
                    child: Text(
                      // get the value from the viewmodel
                      model.birthDate != null
                          ? (model.birthDate.toString()).substring(0, 10)
                          : getTranslated(context, "date_of_birth"),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Color(0XFFADB1B3),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () => model.createChild(context),
                  child: SaveChildWidget(),
                ),
              ],
            );
          }),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            25,
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
      child: TextField(
        controller: _controller,
        onChanged: (value) => model.setName(
          value,
        ),
        obscureText: false,
        decoration: InputDecoration(
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                25,
              ),
            ),
            borderSide: BorderSide.none,
          ),
          hintText: getTranslated(
            context,
            "name",
          ),
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(
              0XFFADB1B3,
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
      margin: EdgeInsets.only(
        left: 48,
        right: 48,
        top: 20,
        bottom: 20,
      ),
      padding: EdgeInsets.all(
        16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(
            25,
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
        ),
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Color(0XFFFFFFFF),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/components/btn_ui.dart';
import 'package:charity_app/view/components/custom/custom_radio_widget.dart';
import 'package:charity_app/view/components/custom_expansion_tile.dart';
import 'package:charity_app/view/screens/auth/register_viewmodel.dart';
import 'package:charity_app/view/screens/other/hide_keyboard_widget.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:charity_app/view/widgets/app_bar_auth.dart';
import 'package:charity_app/view/widgets/custom/getWidgetLogoHorizontal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

class RegisterScreen extends StatefulWidget {
  final String username;
  final String email;
  final String password;

  RegisterScreen({
    Key key,
    this.username,
    this.email,
    this.password,
  }) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObscured = true;

  togglePassword() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return ViewModelBuilder<RegisterViewModel>.reactive(
      builder: (context, model, child) => Material(
        child: HideKeyboardWidget(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image/register_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: widgetAppBarTitle(context),
              body: Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: SizeConfig.calculateBlockHorizontal(25),
                      right: SizeConfig.calculateBlockHorizontal(25),
                    ),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 450),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.calculateBlockHorizontal(40)),
                            child: Align(
                                alignment: Alignment.center,
                                child: _size.height < 600
                                    ? Container(
                                        height: 18,
                                        child: getWidgetLogoHorizontal)
                                    : getWidgetLogoHorizontal),
                          ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(
                                  _size.height > 600 ? 25 : 8)),
                          Text(
                            getTranslated(context, 'add_account'),
                            style: TextStyle(
                                // fontFamily: 'Arial',
                                fontSize: SizeConfig.calculateTextSize2(
                                    _size.height > 600 ? 30.0 : 21),
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(5)),
                          _size.height > 600
                              ? TextField(
                                  controller: model.usernameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText:
                                        getTranslated(context, 'username'),
                                    hintStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.calculateTextSize(14)),
                                    prefixIcon: SvgPicture.asset(
                                      'assets/svg/icons/person_outline_white.svg',
                                      width:
                                          SizeConfig.calculateBlockHorizontal(
                                              24),
                                      height:
                                          SizeConfig.calculateBlockVertical(24),
                                      fit: BoxFit.scaleDown,
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 30,
                                  child: TextField(
                                    controller: model.usernameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 
                                      getTranslated(context, 'username'),
                                      hintStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              SizeConfig.calculateTextSize(14)),
                                      prefixIconConstraints: BoxConstraints(
                                        minHeight: 15,
                                        minWidth: 32,
                                        maxWidth: 32,
                                        maxHeight: 18,
                                      ),
                                      prefixIcon: SizedBox(
                                        width: 10,
                                        height: 10,
                                        child: SvgPicture.asset(
                                          'assets/svg/icons/person_outline_white.svg',
                                          width: 10,
                                          height: 10,
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(5)),
                          _size.height > 600
                              ? Container(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: TextField(
                                          controller: model.passwordController,
                                          style: const TextStyle(
                                              color: Colors.white),
                                          obscureText: _isObscured,
                                          decoration: InputDecoration(
                                            hintText: getTranslated(
                                                context, 'password'),
                                            hintStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                            prefixIcon: SvgPicture.asset(
                                              'assets/svg/icons/lock.svg',
                                              width: 24,
                                              height: 24,
                                              fit: BoxFit.scaleDown,
                                            ),
                                            enabledBorder:
                                                const UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                            ),
                                            focusedBorder:
                                                const UnderlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: togglePassword,
                                        child: Container(
                                          child: SvgPicture.asset(
                                            "assets/image/eye.svg",
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: const Border(
                                      bottom: const BorderSide(
                                          color: Colors.white, width: 1.0),
                                    ),
                                  ),
                                )
                              : Container(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          height: 30,
                                          child: TextField(
                                            controller:
                                                model.passwordController,
                                            style: const TextStyle(
                                                color: Colors.white),
                                            obscureText: _isObscured,
                                            decoration: InputDecoration(
                                              hintText: getTranslated(
                                                  context, 'password'),
                                              hintStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: SizeConfig
                                                      .calculateTextSize(14)),
                                              prefixIconConstraints:
                                                  BoxConstraints(
                                                minHeight: 15,
                                                minWidth: 32,
                                                maxWidth: 32,
                                                maxHeight: 18,
                                              ),
                                              prefixIcon: SvgPicture.asset(
                                                'assets/svg/icons/lock.svg',
                                                width: 15,
                                                height: 15,
                                                fit: BoxFit.scaleDown,
                                              ),
                                              enabledBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 1.0,
                                                ),
                                              ),
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: togglePassword,
                                        child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: SvgPicture.asset(
                                            "assets/image/eye.svg",
                                            width: 15,
                                            height: 15,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    border: const Border(
                                      bottom: const BorderSide(
                                          color: Colors.white, width: 1.0),
                                    ),
                                  ),
                                ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(5)),
                          if (widget.email == null || widget.email.isEmpty)
                            _size.height > 600
                                ? TextField(
                                    controller: model.emailController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: getTranslated(context, 'email'),
                                      hintStyle: const TextStyle(
                                          color: Colors.white, fontSize: 14),
                                      prefixIcon: SvgPicture.asset(
                                        'assets/svg/icons/mail.svg',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.scaleDown,
                                      ),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 30,
                                    child: TextField(
                                      controller: model.emailController,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText:
                                            getTranslated(context, 'email'),
                                        hintStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                SizeConfig.calculateTextSize(
                                                    14)),
                                        prefixIconConstraints: BoxConstraints(
                                          minHeight: 15,
                                          minWidth: 32,
                                          maxWidth: 32,
                                          maxHeight: 18,
                                        ),
                                        prefixIcon: SvgPicture.asset(
                                          'assets/svg/icons/mail.svg',
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.scaleDown,
                                        ),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                          SizedBox(
                              height: SizeConfig.calculateBlockVertical(20)),
                          CustomExpansionTile(
                            maintainState: true,
                            initiallyExpanded: true,
                            backgroundColor: Colors.transparent,
                            collapsedBackgroundColor: Colors.transparent,
                            title: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/icons/person.svg',
                                      width: _size.height > 600 ? 24 : 18,
                                      height: _size.height > 600 ? 24 : 18,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        getTranslated(context, 'user_type'),
                                        style: TextStyle(
                                          // fontFamily: 'Arial',
                                          fontSize:
                                              SizeConfig.calculateTextSize(14),
                                          color: const Color(0xFF758084),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // decoration:
                            ),
                            titleDecoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.0),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    CustomRadioWidget(
                                      value: 0,
                                      groupValue: model.radioValue2,
                                      onChanged: model.handleRadioValueChange,
                                      width:
                                          SizeConfig.calculateBlockHorizontal(
                                              25),
                                      height:
                                          SizeConfig.calculateBlockHorizontal(
                                              25),
                                      title: getTranslated(context, 'parents')
                                          .toUpperCase(),
                                    ),
                                    CustomRadioWidget(
                                      value: 1,
                                      groupValue: model.radioValue2,
                                      onChanged: model.handleRadioValueChange,
                                      width:
                                          SizeConfig.calculateBlockHorizontal(
                                              25),
                                      height:
                                          SizeConfig.calculateBlockHorizontal(
                                              25),
                                      title:
                                          getTranslated(context, 'specialist')
                                              .toUpperCase(),
                                    ),
                                    CustomRadioWidget(
                                      value: 2,
                                      groupValue: model.radioValue2,
                                      onChanged: model.handleRadioValueChange,
                                      width:
                                          SizeConfig.calculateBlockHorizontal(
                                              25),
                                      height:
                                          SizeConfig.calculateBlockHorizontal(
                                              25),
                                      title:
                                          getTranslated(context, 'organization')
                                              .toUpperCase(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: model.dataAgreeClick,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.calculateBlockHorizontal(
                                          7),
                                      right:
                                          SizeConfig.calculateBlockHorizontal(
                                              3)),
                                  child: Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: model.dataAgree,
                                    onChanged: (newValue) {
                                      model.dataAgreeClick();
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    getTranslated(
                                        context, 'agree_personal_data'),
                                    style: TextStyle(
                                      fontSize:
                                          SizeConfig.calculateTextSize(16),
                                      color: const Color(0xFF758084),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    SizeConfig.calculateBlockVertical(10)),
                            child: BtnUI(
                              height: SizeConfig.calculateBlockVertical(55),
                              isLoading: model.isLoading,
                              textColor: Colors.white,
                              color: AppThemeStyle.primaryColor,
                              text: getTranslated(context, 'create'),
                              onTap: () {
                                model.registration(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      onViewModelReady: (model) {
        if (widget.username != null) {
          model.initStates(
            widget.username,
            widget.email,
            widget.password,
          );
        }
        model.getUserType(context);
      },
      viewModelBuilder: () => RegisterViewModel(),
    );
  }
}

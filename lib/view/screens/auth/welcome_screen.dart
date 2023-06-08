import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/components/btn_ui.dart';
import 'package:charity_app/view/screens/auth/welcome_viewmodel.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/widgets/get_widget_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/get_widget_logo.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WelcomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Container(
          child: Stack(children: [
            Image.asset(
              "assets/image/welcome_background.png",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: EdgeInsets.all(45.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  getWidgetLogoVertical,
                  SizedBox(
                    height: SizeConfig.calculateBlockVertical(20),
                  ),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
                  BtnUI(
                    isLoading: false,
                    textColor: Colors.white,
                    color: AppColor.primary,
                    text: getTranslated(context, 'kz_language'),
                    onTap: () {
                      model.changeLanguage(context, 0);
                    },
                  ),
                  SizedBox(height: 8.w),
                  BtnUI(
                    isLoading: false,
                    textColor: Colors.white,
                    color: AppColor.primary,
                    text: getTranslated(context, 'ru_language'),
                    onTap: () {
                      model.changeLanguage(context, 1);
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ]),
        ),
      ),
      viewModelBuilder: () => WelcomeViewModel(),
    );
  }
}

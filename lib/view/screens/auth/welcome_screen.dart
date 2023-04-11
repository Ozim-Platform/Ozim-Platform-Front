import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/components/btn_ui.dart';
import 'package:charity_app/view/screens/auth/welcome_viewmodel.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/widgets/get_widget_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/get_widget_logo.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WelcomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/image/welcome_background.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(45),
                  child: Stack(children: [
                    Center(
                      child: Container(
                        width: SizeConfig.calculateBlockHorizontal(168),
                        child: Image.asset("assets/image/family_icon.png"),
                      ),
                    ),
                    Column(
                      children: [
                        const Spacer(),
                        getWidgetLogoVertical,
                        SizedBox(height: SizeConfig.calculateBlockVertical(20)),
                        Padding(
                            padding: const EdgeInsets.only(left: 35, right: 35),
                            child: getWidgetLogo),
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
                        const SizedBox(height: 8),
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
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => WelcomeViewModel(),
    );
  }
}

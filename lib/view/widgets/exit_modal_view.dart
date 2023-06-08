import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/view/theme/my_themes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ExitModalView extends StatelessWidget {
  const ExitModalView({this.onTapExit});

  final GestureTapCallback onTapExit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24.0, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: getTextInfo(context),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                    height: 50,
                    child: TextButton(
                        // height: 50,
                        // textColor: MyThemes.lightTheme.primaryColor,
                        child: Text(
                          getTranslated(context, 'cancel'),
                          style: TextStyle(
                              color: MyThemes.lightTheme.primaryColor),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              MyThemes.lightTheme.primaryColor.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        })),
              ),
              SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextButton(
                      // height: 50,
                      // textColor: MyThemes.lightTheme.primaryColor,
                      child: Text(
                        getTranslated(context, 'close'),
                        style:
                            TextStyle(color: MyThemes.lightTheme.primaryColor),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor:
                            MyThemes.lightTheme.primaryColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                      ),
                      onPressed: onTapExit),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column getTextInfo(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: SizedBox(
            height: 80.0,
            child: Lottie.asset('assets/lottie/info.json'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            getTranslated(context, 'exit_text'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
          ),
        ),
        // Opacity(
        //   opacity: 0.4,
        //   child: Text(
        //     "©2001 - 2020. Barcha huquqlar himoyalangan.",
        //     textAlign: TextAlign.center,
        //     style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400),
        //   ),
        // ),
        SizedBox(height: 30.0),
      ],
    );
  }
}

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:flutter/material.dart';
import 'package:charity_app/utils/device_size_config.dart';

class EmptyData extends StatelessWidget {
  final String text;
  final Widget image;

  EmptyData({this.text, this.image});

  @override
  Widget build(BuildContext context) {
    String _message =
        text != null ? text : getTranslated(context, 'data_not_found');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (image != null) image,
        SizedBox(
          height: SizeConfig.calculateBlockVertical(18),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _message,
            textAlign: TextAlign.center,
            // textScaleFactor: SizeConfig.textScaleFactor(),

            style: TextStyle(
              fontSize: SizeConfig.calculateTextSize(15),
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}

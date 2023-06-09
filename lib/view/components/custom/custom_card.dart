import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/material.dart';

class CustomCardContainer extends StatefulWidget {
  final String title;
  final String description;
  final GestureTapCallback onTap;

  const CustomCardContainer(
      {Key key, this.title, this.description, this.onTap});

  @override
  _CustomCardContainer createState() => _CustomCardContainer();
}

class _CustomCardContainer extends State<CustomCardContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppThemeStyle.appBarStyle16,
                      textAlign: TextAlign.start,
                      // textScaleFactor: SizeConfig.textScaleFactor(),
                    ),
                    SizedBox(height: SizeConfig.calculateBlockVertical(10)),
                    Text(
                      widget.description,
                      // textScaleFactor: SizeConfig.textScaleFactor(),
                      style: AppThemeStyle.titleStyle,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

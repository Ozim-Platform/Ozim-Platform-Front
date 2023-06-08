import 'package:flutter/material.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadioWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final double width;
  final double height;
  final String title;
  final TextStyle titleStyle;
  final bool titleInStart;

  CustomRadioWidget(
      {this.value,
      this.groupValue,
      this.onChanged,
      this.width = 32,
      this.height = 32,
      this.title,
      this.titleStyle,
      this.titleInStart = false});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: title,
      checked: value == groupValue,
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          onChanged(this.value);
        },
        child: Row(
          children: [
            if (title != null && titleInStart) titleWidget(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: this.height,
                width: this.width,
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Container(
                    height: this.height - 8,
                    width: this.width - 8,
                    decoration: ShapeDecoration(
                      shape: CircleBorder(),
                      color: value == groupValue
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
              ),
            ),
            if (title != null && !titleInStart) titleWidget()
          ],
        ),
      ),
    );
  }

  Widget titleWidget() => Expanded(
        child: Text(
          title,
          // textScaleFactor: SizeConfig.textScaleFactor(),
          style: titleStyle ??
              TextStyle(
                // fontFamily: 'Arial',
                fontSize: 14.sp,
                color: const Color(0xFF758084),
              ),
        ),
      );
}

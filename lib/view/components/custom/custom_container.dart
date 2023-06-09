import 'package:charity_app/view/theme/app_color.dart';
import 'package:flutter/material.dart';

class  CustomContainer extends StatelessWidget{
  final Widget child;

  const CustomContainer({Key key,this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primary,
      ),
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: BoxDecoration(
          color: Color.fromRGBO(244, 244, 244, 1.0),
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(40),
            topRight: const Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: child,
        ),
      ),
    );
  }
}
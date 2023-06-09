import 'package:charity_app/utils/device_size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BtnUIIcon extends StatefulWidget {
  const BtnUIIcon({
    this.fieldKey,
    this.color,
    this.textColor,
    this.text,
    this.onTap,
    this.height = 60,
    this.isLoading = false,
    this.icon,
    this.child,
  });

  final Key fieldKey;
  final String text;
  final Color color;
  final Color textColor;
  final double height;
  final child;
  final SvgPicture icon;
  final bool isLoading;
  final GestureTapCallback onTap;

  @override
  _BtnUIIconState createState() => _BtnUIIconState();
}

class _BtnUIIconState extends State<BtnUIIcon>
    with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      onTapCancel: _tapCancel,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          height: widget.height,
          constraints: BoxConstraints(maxWidth: 450),
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.color,
              width: 0.75,
            ),
            color: widget.color,
            borderRadius: BorderRadius.circular(27.0),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: widget.isLoading == false
                      ? Text(
                          widget.text,
                          // textScaleFactor: SizeConfig.textScaleFactor(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 16.sp,
                            // fontFamily: 'Arial',
                          ),
                        )
                      : CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.textColor,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                    ),
                    child: widget.icon,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _tapCancel() {
    _controller.reverse();
  }
}

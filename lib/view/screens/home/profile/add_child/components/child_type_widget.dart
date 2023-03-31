import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChildTypeWidget extends StatefulWidget {
  final String type;
  final Function onSelected;
  final ValueNotifier<bool> isActiveNotifier;
  final isGirl;
  ChildTypeWidget(
      {Key key,
      this.type,
      @required this.isActiveNotifier,
      @required this.onSelected,
      this.isGirl})
      : super(key: key);

  @override
  State<ChildTypeWidget> createState() => _ChildTypeWidgetState();
}

class _ChildTypeWidgetState extends State<ChildTypeWidget> {
  Color color;

  SvgPicture icon;

  @override
  void initState() {
    switch (widget.type) {
      case 'boy':
        color = const Color(0XFF6CBBD9);
        icon = SvgPicture.asset(
          'assets/svg/icons/add_boy.svg',
          height: 27.39,
        );
        break;
      case 'girl':
        color = const Color(0XFFF08390);
        icon = SvgPicture.asset(
          'assets/svg/icons/add_girl.svg',
          height: 27.39,
        );
        break;
    }
    // Add a listener to the isActiveNotifier
    widget.isActiveNotifier.addListener(_onActiveNotifierChanged);

    super.initState();
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    widget.isActiveNotifier.removeListener(_onActiveNotifierChanged);
    super.dispose();
  }

  void _onActiveNotifierChanged() {
    // Call setState to update the color when the value of isActiveNotifier changes
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        enableFeedback: false,
        onTap: () => widget.onSelected(),
        child: Container(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          margin: EdgeInsets.only(bottom: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
            color: (widget.isActiveNotifier.value == widget.isGirl)
                ? color
                : Color(0XFFADB1B3),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: icon,
              ),
              Text(
                widget.type,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

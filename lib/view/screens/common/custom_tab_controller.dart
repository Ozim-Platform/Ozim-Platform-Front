import 'package:charity_app/view/widgets/custom/custom_appbar.dart';
import 'package:flutter/material.dart';

class CustomTabController extends StatelessWidget {
  final List list;
  final bool needBackArrow;
  final String title;
  final model;
  final Function buildMethod;
  final TabController controller;

  const CustomTabController({
    @required this.list,
    this.needBackArrow = true,
    @required this.title,
    @required this.model,
    @required this.buildMethod,
    this.controller,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: list.length,
      child: Scaffold(
        appBar: customAppbar(
          context: context,
          category: list,
          existArrow: needBackArrow,
          appBarTitle: '',
          appBarIncome: title,
          controller: controller,
        ),
        body: TabBarView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: List<Widget>.generate(list.length, (int index) {
            return buildMethod(context, model, list[index].sysName, list);
          }),
        ),
      ),
    );
  }
}

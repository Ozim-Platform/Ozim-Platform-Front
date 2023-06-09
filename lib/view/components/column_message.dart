import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:charity_app/view/widgets/avatar_iamge.dart';
import 'package:flutter/material.dart';

class ColumnMessage extends StatefulWidget {
  const ColumnMessage(
      {this.fieldKey,
      this.imageUrl,
      this.title,
      this.description,
      this.time,
      this.badge,
      this.isVisible,
      this.onTap});

  final Key fieldKey;
  final String imageUrl;
  final String title;
  final String description;
  final String time;
  final String badge;
  final bool isVisible;
  final GestureTapCallback onTap;

  @override
  _ColumnMessage createState() => _ColumnMessage();
}

class _ColumnMessage extends State<ColumnMessage> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 6),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AvatarImage(
                    imageUrl:
                        'https://news.berkeley.edu/wp-content/uploads/2020/03/Maryam-Karimi-01-750.jpg',
                    size: 60.0),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Бибигуль Ахметова",
                        textAlign: TextAlign.start,
                        style: AppThemeStyle.subtitleList2,
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Детский церебральный паралич Каждый год от хронического вирусного гепатита В, по оценкам ВОЗ, умирает почти 900 000 ",
                        textAlign: TextAlign.start,
                        style: AppThemeStyle.titleFormStyle,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 10),
                Visibility(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(254, 205, 131, 1),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(20)),
                    ),
                    
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("22",
                      
                          // textScaleFactor: SizeConfig.textScaleFactor(),
                          style: AppThemeStyle.buttonWhite14),
                    ),
                  ),
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  visible: widget.isVisible,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70),
              child: Divider(thickness: 1, color: Colors.black26),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                "13.04.2021",
                                          // textScaleFactor: SizeConfig.textScaleFactor(),

                style: AppThemeStyle.titleListGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

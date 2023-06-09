import 'dart:developer';

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/persistance/hive_boxes.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/components/custom/custom_badge.dart';
import 'package:charity_app/view/screens/other/notification/notification_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationButton extends StatefulWidget {
  final bool removePaddings;
  final double size;
  final Widget icon;
  final bool isBottomBar;
  const NotificationButton(
      {Key key,
      this.removePaddings = false,
      this.size = 24.0,
      this.icon,
      this.isBottomBar})
      : super(key: key);

  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _user;

  Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream;

  bool _hasError = true;

  int count = 0;

  final n = Notif(Hive.box<int>(HiveBoxes.countBox));

  @override
  initState() {
    _user = _auth.currentUser;
    _usersStream = FirebaseFirestore.instance
        .collection('chat')
        .doc(_user?.email)
        .snapshots();
    n.box.listenable().addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  resetBox() async {
    print('reset');
    n.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: getTranslated(context, "notifications"),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          resetBox();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NotificationScreen(),
            ),
          );
        },
        child: IgnorePointer(
          child: SizedBox(
            width: 37,
            height: 27,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  width: 0,
                  height: 0,
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasError) {
                        return SizedBox();
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox();
                      }

                      if (snapshot.data.data() == null) return SizedBox();

                      List data = snapshot.data.data()['rooms'];

                      if (data.length == 0) return SizedBox();

                      int _count = 0;
                      data.forEach((element) {
                        if (element['unread'] != null) {
                          _count += toInt(element['unread']);
                        }
                      });

                      /**Установка количества сообщений*/
                      count = _count;
                      _hasError = false;

                      return SizedBox();
                    },
                  ),
                ),
                SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: widget.icon,
                ),
                if (count > 0 && !_hasError)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: ValueListenableBuilder(
                        valueListenable: n.box.listenable(),
                        builder: (context, Box<int> box, _) {
                          log("n.box.listenable");
                          return BadgeMessagesNotice(
                            box.get(0),
                            shape: BadgeMessagesNotice.ellipsis,
                            isBottomBar: widget.isBottomBar,
                          );
                        }),
                  ),
                // Positioned(
                //   top: 0,
                //   right: 0,
                //   child: ValueListenableBuilder(
                //     valueListenable: n.box.listenable(),
                //     builder: (context, Box<int> box, _) {
                //       return BadgeMessagesNotice(
                //         box.get(0),
                //         shape: BadgeMessagesNotice.ellipsis,
                //         isBottomBar: widget.isBottomBar,
                //       );
                //     },
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

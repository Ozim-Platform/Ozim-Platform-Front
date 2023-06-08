import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HiveBoxes {
  static final String countBox = 'notification_count_box';
}

class Notif {
  static final int _id = 0;
  final Box<int> box;
  Notif(this.box) {
    if (!box.containsKey(_id)) box.put(_id, 0);
  }

  Future<void> clear() async => await box.put(_id, 0);

  Future<void> increment() async {
    await box.put(_id, box.get(_id) + 1);
  }
}

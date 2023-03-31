import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

enum ReadedNotification { Comments, Forum }

class ReadedNotifications {
  static const String _comments = 'comments';
  static const String _forum = 'forum';

  Future<Box> _openBox() => Hive.openBox('readed_notifications');

  Future<void> putReaded({@required ReadedNotification type, int id}) async {
    Box box = await _openBox();
    List<int> readed = (await getReaded(type: type)) ?? [];
    readed.add(id);
    return box.put(_readedNotificationToString(type), readed);
  }

  Future<List<int>> getReaded({@required ReadedNotification type}) async {
    try {
      Box box = await _openBox();
      List<int> result = box.get(_readedNotificationToString(type));
      return result;
    } catch (e) {
      return null;
    }
  }

  String _readedNotificationToString(ReadedNotification v) {
    switch (v) {
      case ReadedNotification.Comments:
        return _comments;
      case ReadedNotification.Forum:
        return _forum;
    }
    return null;
  }
}

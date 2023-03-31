
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Constants {
  static const String MAIN_HTTP = "https://ozimplatform.kz/";
  static const Color mainTextColor = Color(0xff758084);
  static const Color ligtherMainTextColor = Color(0xffACB1B4);
  static FirebaseFirestore db = null;
  static List listnablemodels = [];
}

final navigationChat = GlobalKey<NavigatorState>();

final RegExp emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/data.dart';

class Faq extends CommonModel {
  @override
  Faq.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    page = json['page'];
    pages = json['pages'];
  }
}

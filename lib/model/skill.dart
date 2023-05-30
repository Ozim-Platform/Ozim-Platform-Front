import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/data.dart';

class Skill extends CommonModel {
  @override
  Skill.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        v['type'] = 'skill';
        data.add(new Data.fromJson(v));
      });
    }

    page = json['page'];
    pages = json['pages'];
  }
}

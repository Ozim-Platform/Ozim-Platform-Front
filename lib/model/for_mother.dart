import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/data.dart';

class For_Parent extends CommonModel {
  @override
  For_Parent.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        v['type'] = 'for_parent';
        data.add(new Data.fromJson(v));
      });
    }
    page = json['page'];
    pages = json['pages'];
  }
}

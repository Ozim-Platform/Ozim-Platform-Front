import 'dart:developer';

import 'package:charity_app/model/data.dart';
import 'package:charity_app/utils/utils.dart';

class CommonModel {
  List<Data> data;
  int page;
  int pages;

  CommonModel({this.data, this.page, this.pages});

  CommonModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach(
        (v) {
          data.add(
            new Data.fromJson(
              v,
            ),
          );
        },
      );
    }
    page = toInt(json['page']);
    pages = toInt(json['pages']);

    log("page: $page");
    log("pages: $pages");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['pages'] = this.pages;
    return data;
  }

  @override
  String toString() {
    return 'CommonModel{data: $data}';
  }
}

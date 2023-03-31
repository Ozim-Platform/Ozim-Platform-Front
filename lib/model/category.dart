import 'package:charity_app/model/type.dart';
import 'package:charity_app/model/user/user.dart';

class Category {
  String name;
  String sysName;
  Language language;
  Type type;

  Category({this.name, this.sysName, this.language, this.type});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sysName = json['sys_name'];
    language = json['language'] != null
        ? new Language.fromJson(json['language'])
        : null;
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['sys_name'] = this.sysName;
    if (this.language != null) {
      data['language'] = this.language.toJson();
    }
    if (this.type != null) {
      data['type'] = this.type.toJson();
    }
    return data;
  }
}

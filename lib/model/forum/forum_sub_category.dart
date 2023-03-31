import 'package:charity_app/model/forum/forum_category.dart';

import 'forum_detail.dart';

class ForumSubCategory {
  String name;
  String sysName;
  Language language;
  ForumCategory category;
  int id;
  int record_count;
  int last_comment;

  ForumSubCategory({
    this.name,
    this.sysName,
    this.language,
    this.category,
    this.id,
    this.record_count,
    this.last_comment,
  });

  ForumSubCategory.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    sysName = json['sys_name'];
    language = json['language'] != null
        ? new Language.fromJson(json['language'])
        : null;
    category = json['category'] != null
        ? new ForumCategory.fromJson(json['category'])
        : null;
    id = json['id'];
    record_count = json['record_count'] != null ? json['record_count'] : 0;
    last_comment = json['last_comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['sys_name'] = this.sysName;
    if (this.language != null) {
      data['language'] = this.language.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['id'] = this.id;
    data['record_count'] = this.record_count;
    data['last_comment'] = this.last_comment;
    return data;
  }
}

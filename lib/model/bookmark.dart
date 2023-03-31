class BookMark {
  List<BookmarkData> data;

  BookMark({this.data});

  BookMark.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BookmarkData>[];
      json['data'].forEach((v) {
        data.add(new BookmarkData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BookmarkData {
  int id;
  String name;
  String sysName;
  String createdAt;

  BookmarkData({this.id, this.name, this.sysName, this.createdAt});

  BookmarkData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sysName = json['sys_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['sys_name'] = this.sysName;
    data['created_at'] = this.createdAt;
    return data;
  }
}

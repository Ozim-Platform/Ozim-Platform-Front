class Links {
  List<LinksData> data;
  int page;
  int pages;

  Links({this.data, this.page, this.pages});

  Links.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LinksData>[];
      json['data'].forEach((v) {
        data.add(new LinksData.fromJson(v));
      });
    }
    page = json['page'];
    pages = json['pages'];
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
}

class LinksData {
  String link;
  String name;
  String description;
  String category;

  LinksData({this.link, this.description, this.category});

  LinksData.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['link'] = this.link;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category'] = this.category;
    return data;
  }
}

class Type {
  String type;
  String name;

  Type({this.type, this.name});

  Type.fromJson(Map<String, dynamic> json) {
    type = json['sys_name'] != null? json['sys_name'] : 'none';
    name = json['name'] != null? json['name'] : 'Без категории';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['sys_name'] = this.type;
    return data;
  }
}
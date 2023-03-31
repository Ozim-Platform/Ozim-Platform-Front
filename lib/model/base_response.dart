class BaseResponses {
  String success;
  String error;
  Map<String, dynamic> data;
  int id;

  BaseResponses({this.success, this.error, this.data, this.id});

  BaseResponses.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    data = json['data'] != null ? json['data'] : json['comment'];
    if (json['id'] != null && json['id'] is int) {
      id = json['id'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    data['data'] = this.data;
    if (id != null) {
      data['data'] = this.id;
    }
    return data;
  }
}

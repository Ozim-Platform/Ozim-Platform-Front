class Authorization {
  String success;
  String error;
  String auth_token;

  Authorization({this.success, this.auth_token});

  Authorization.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    auth_token = json['auth_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['error'] = this.error;
    data['auth_token'] = this.auth_token;
    return data;
  }
}

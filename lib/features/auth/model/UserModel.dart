class Usermodel {
  int? id_user;
  String? username;
  String? email;
  String? password;
  String? token;

  Usermodel({
    this.id_user,
    this.username,
    this.email,
    this.password,
    this.token,
  });
  Usermodel.fromJson(Map<String, dynamic> json) {
    id_user = json['id_user'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    token = json['token'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id_user'] = id_user;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['token'] = token;
    return data;
  }
}

class UserProfile {
  Data data;
  String token;

  UserProfile({this.data, this.token});

  UserProfile.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Data {
  String username;
  String email;
  String firstName;
  String lastName;
  String tel;
  String profileImg;
  String role;
  String createdAt;
  String updatedAt;

  Data(
      {this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.tel,
      this.profileImg,
      this.role,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    tel = json['tel'];
    profileImg = json['profile_img'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['tel'] = this.tel;
    data['profile_img'] = this.profileImg;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
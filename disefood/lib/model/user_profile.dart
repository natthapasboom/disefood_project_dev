class UserProfile {
  Data data;
  String accessToken;
  String tokenType;
  String expiresAt;

  UserProfile({this.data, this.accessToken, this.tokenType, this.expiresAt});

  UserProfile.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresAt = json['expires_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_at'] = this.expiresAt;
    return data;
  }
}

class Data {
  int id;
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
      {this.id,
      this.username,
      this.email,
      this.firstName,
      this.lastName,
      this.tel,
      this.profileImg,
      this.role,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
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
    data['id'] = this.id;
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

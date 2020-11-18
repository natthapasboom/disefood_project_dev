class FacebookUser {
  Data data;
  bool missingProfile;
  String accessToken;
  String tokenType;
  String expiresAt;

  FacebookUser(
      {this.data,
      this.missingProfile,
      this.accessToken,
      this.tokenType,
      this.expiresAt});

  FacebookUser.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    missingProfile = json['missing_profile'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresAt = json['expires_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['missing_profile'] = this.missingProfile;
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_at'] = this.expiresAt;
    return data;
  }
}

class Data {
  String username;
  String email;
  String profileImg;
  String updatedAt;
  String createdAt;
  int id;

  Data(
      {this.username,
      this.email,
      this.profileImg,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    profileImg = json['profile_img'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['profile_img'] = this.profileImg;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

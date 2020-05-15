class UserProfile {
  int userId;
  String firstName;
  String lastName;
  String tel;
  String profileImg;
  int isSeller;
  String createdAt;
  String updatedAt;

  UserProfile(
      {this.userId,
      this.firstName,
      this.lastName,
      this.tel,
      this.profileImg,
      this.isSeller,
      this.createdAt,
      this.updatedAt});

  UserProfile.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    tel = json['tel'];
    profileImg = json['profile_img'];
    isSeller = json['is_seller'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['tel'] = this.tel;
    data['profile_img'] = this.profileImg;
    data['is_seller'] = this.isSeller;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
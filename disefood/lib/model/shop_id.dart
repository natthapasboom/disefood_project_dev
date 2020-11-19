class ShopById {
  Data data;
  int status;

  ShopById({this.data, this.status});

  ShopById.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int id;
  int userId;
  int shopSlot;
  String name;
  String coverImg;
  int approved;
  String deletedAt;
  String createdAt;
  String updatedAt;
  List<AccountNumbers> accountNumbers;

  Data(
      {this.id,
      this.userId,
      this.shopSlot,
      this.name,
      this.coverImg,
      this.approved,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.accountNumbers});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    shopSlot = json['shop_slot'];
    name = json['name'];
    coverImg = json['cover_img'];
    approved = json['approved'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['account_numbers'] != null) {
      accountNumbers = new List<AccountNumbers>();
      json['account_numbers'].forEach((v) {
        accountNumbers.add(new AccountNumbers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['shop_slot'] = this.shopSlot;
    data['name'] = this.name;
    data['cover_img'] = this.coverImg;
    data['approved'] = this.approved;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.accountNumbers != null) {
      data['account_numbers'] =
          this.accountNumbers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AccountNumbers {
  int id;
  String number;
  String channel;
  int shopId;
  String createdAt;
  String updatedAt;

  AccountNumbers(
      {this.id,
      this.number,
      this.channel,
      this.shopId,
      this.createdAt,
      this.updatedAt});

  AccountNumbers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    channel = json['channel'];
    shopId = json['shop_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['channel'] = this.channel;
    data['shop_id'] = this.shopId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

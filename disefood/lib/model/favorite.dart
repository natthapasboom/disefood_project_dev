class Favorite {
  List<Data> data;

  Favorite({this.data});

  Favorite.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  int userId;
  int shopId;
  String createdAt;
  String updatedAt;
  Shop shop;

  Data(
      {this.id,
      this.userId,
      this.shopId,
      this.createdAt,
      this.updatedAt,
      this.shop});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    shopId = json['shop_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['shop_id'] = this.shopId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    return data;
  }
}

class Shop {
  int id;
  int shopSlot;
  String name;

  Shop({this.id, this.shopSlot, this.name});

  Shop.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopSlot = json['shop_slot'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_slot'] = this.shopSlot;
    data['name'] = this.name;
    return data;
  }
}

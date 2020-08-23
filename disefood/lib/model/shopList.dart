class ShopList {
  List<Data> data;

  ShopList({this.data});

  ShopList.fromJson(Map<String, dynamic> json) {
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
  int shopSlot;
  String name;
  String coverImg;
  int approved;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
      this.userId,
      this.shopSlot,
      this.name,
      this.coverImg,
      this.approved,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    shopSlot = json['shop_slot'];
    name = json['name'];
    coverImg = json['cover_img'];
    approved = json['approved'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['shop_slot'] = this.shopSlot;
    data['name'] = this.name;
    data['cover_img'] = this.coverImg;
    data['approved'] = this.approved;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
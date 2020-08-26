class FoodByShopId {
  Data data;

  FoodByShopId({this.data});

  FoodByShopId.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
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
  List<Foods> foods;

  Data(
      {this.id,
      this.userId,
      this.shopSlot,
      this.name,
      this.coverImg,
      this.approved,
      this.createdAt,
      this.updatedAt,
      this.foods});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    shopSlot = json['shop_slot'];
    name = json['name'];
    coverImg = json['cover_img'];
    approved = json['approved'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['foods'] != null) {
      foods = new List<Foods>();
      json['foods'].forEach((v) {
        foods.add(new Foods.fromJson(v));
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.foods != null) {
      data['foods'] = this.foods.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Foods {
  int id;
  int shopId;
  String name;
  int price;
  int status;
  String coverImg;
  String createdAt;
  String updatedAt;

  Foods(
      {this.id,
      this.shopId,
      this.name,
      this.price,
      this.status,
      this.coverImg,
      this.createdAt,
      this.updatedAt});

  Foods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
    coverImg = json['cover_img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_id'] = this.shopId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    data['cover_img'] = this.coverImg;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

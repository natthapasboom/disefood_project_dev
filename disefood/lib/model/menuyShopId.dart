class MenuByShopId {
  List<Data> data;
  int status;

  MenuByShopId({this.data, this.status});

  MenuByShopId.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int id;
  int shopId;
  String name;
  int price;
  int status;
  String coverImg;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
      this.shopId,
      this.name,
      this.price,
      this.status,
      this.coverImg,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
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
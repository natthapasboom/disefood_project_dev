class TopSeller {
  List<Data> data;
  int totalQuantityShop;
  int totalAmountShop;

  TopSeller({this.data, this.totalQuantityShop, this.totalAmountShop});

  TopSeller.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    totalQuantityShop = json['totalQuantityShop'];
    totalAmountShop = json['totalAmountShop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['totalQuantityShop'] = this.totalQuantityShop;
    data['totalAmountShop'] = this.totalAmountShop;
    return data;
  }
}

class Data {
  int id;
  int shopId;
  String name;
  int price;
  int status;
  String cover_img;
  String createdAt;
  String updatedAt;
  int totalQuantity;
  int totalAmount;

  Data(
      {this.id,
      this.shopId,
      this.name,
      this.price,
      this.status,
      this.cover_img,
      this.createdAt,
      this.updatedAt,
      this.totalQuantity,
      this.totalAmount});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shop_id'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
    cover_img = json['cover_img'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalQuantity = json['totalQuantity'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_id'] = this.shopId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    data['cover_img'] = this.cover_img;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['totalQuantity'] = this.totalQuantity;
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}

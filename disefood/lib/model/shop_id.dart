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
  String documentImg;
  int approved;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
      this.userId,
      this.shopSlot,
      this.name,
      this.coverImg,
      this.documentImg,
      this.approved,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    shopSlot = json['shop_slot'];
    name = json['name'];
    coverImg = json['cover_img'];
    documentImg = json['document_img'];
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
    data['document_img'] = this.documentImg;
    data['approved'] = this.approved;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

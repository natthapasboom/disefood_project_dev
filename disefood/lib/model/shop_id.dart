class ShopById {
  int shopId;
  int userId;
  int shopSlot;
  String name;
  String coverImage;
  String createdAt;
  String updatedAt;

  ShopById(
      {this.shopId,
      this.userId,
      this.shopSlot,
      this.name,
      this.coverImage,
      this.createdAt,
      this.updatedAt});

  ShopById.fromJson(Map<String, dynamic> json) {
    shopId = json['shop_id'];
    userId = json['user_id'];
    shopSlot = json['shop_slot'];
    name = json['name'];
    coverImage = json['cover_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_id'] = this.shopId;
    data['user_id'] = this.userId;
    data['shop_slot'] = this.shopSlot;
    data['name'] = this.name;
    data['cover_image'] = this.coverImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
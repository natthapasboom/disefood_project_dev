class FoodsList {
  int foodId;
  int shopId;
  String name;
  int price;
  int status;
  String coverImage;
  String createdAt;
  String updatedAt;

  FoodsList(
      {this.foodId,
      this.shopId,
      this.name,
      this.price,
      this.status,
      this.coverImage,
      this.createdAt,
      this.updatedAt});

  FoodsList.fromJson(Map<String, dynamic> json) {
    foodId = json['food_id'];
    shopId = json['shop_id'];
    name = json['name'];
    price = json['price'];
    status = json['status'];
    coverImage = json['cover_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_id'] = this.foodId;
    data['shop_id'] = this.shopId;
    data['name'] = this.name;
    data['price'] = this.price;
    data['status'] = this.status;
    data['cover_image'] = this.coverImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
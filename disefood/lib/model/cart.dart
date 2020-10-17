class CartModel {
  int id;
  String shopId;
  int foodId;
  String foodName;
  int foodQuantity;
  String foodDescription;

  CartModel(
      {this.id,
      this.shopId,
      this.foodId,
      this.foodName,
      this.foodQuantity,
      this.foodDescription});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shopId'];
    foodId = json['foodId'];
    foodName = json['foodName'];
    foodQuantity = json['foodQuantity'];
    foodDescription = json['foodDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shopId'] = this.shopId;
    data['foodId'] = this.foodId;
    data['foodName'] = this.foodName;
    data['foodQuantity'] = this.foodQuantity;
    data['foodDescription'] = this.foodDescription;
    return data;
  }
}

class CartModel {
  int id;
  String shopId;
  int foodId;
  String foodName;
  int foodQuantity;
  String foodDescription;
  int foodPrice;
  int foodSumPrice;

  CartModel({
    this.id,
    this.shopId,
    this.foodId,
    this.foodName,
    this.foodQuantity,
    this.foodDescription,
    this.foodPrice,
    this.foodSumPrice,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shopId'];
    foodId = json['foodId'];
    foodName = json['foodName'];
    foodQuantity = json['foodQuantity'];
    foodDescription = json['foodDescription'];
    foodPrice = json['foodPrice'];
    foodSumPrice = json['foodSumPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shopId'] = this.shopId;
    data['foodId'] = this.foodId;
    data['foodName'] = this.foodName;
    data['foodQuantity'] = this.foodQuantity;
    data['foodDescription'] = this.foodDescription;
    data['foodPrice'] = this.foodPrice;
    data['foodSumPrice'] = this.foodSumPrice;
    return data;
  }
}

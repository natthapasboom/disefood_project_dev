import 'package:flutter/cupertino.dart';

class CartModel {
  int id;
  String shopId;
  String shopName;
  int foodId;
  String foodName;
  int foodQuantity;
  String foodDescription;
  int foodPrice;
  int foodSumPrice;
  String foodImg;

  CartModel({
    this.id,
    this.shopId,
    this.shopName,
    this.foodId,
    this.foodName,
    this.foodQuantity,
    this.foodDescription,
    this.foodPrice,
    this.foodSumPrice,
    this.foodImg,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopId = json['shopId'];
    shopName = json['shopName'];
    foodId = json['foodId'];
    foodName = json['foodName'];
    foodQuantity = json['foodQuantity'];
    foodDescription = json['foodDescription'];
    foodPrice = json['foodPrice'];
    foodSumPrice = json['foodSumPrice'];
    foodImg = json['foodImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shopId'] = this.shopId;
    data['shopName'] = this.shopName;
    data['foodId'] = this.foodId;
    data['foodName'] = this.foodName;
    data['foodQuantity'] = this.foodQuantity;
    data['foodDescription'] = this.foodDescription;
    data['foodPrice'] = this.foodPrice;
    data['foodSumPrice'] = this.foodSumPrice;
    data['foodImg'] = this.foodImg;
    return data;
  }
}

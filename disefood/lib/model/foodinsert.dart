import 'package:flutter/cupertino.dart';



class FoodsInsert {
  
  int foodId;
  int shopId;
  String name;
  int price;
  int status;
  String coverImage;
  

    FoodsInsert({
      @required this.foodId,
      @required this.shopId,
      @required this.name,
      @required this.price,
      @required this.status,
      @required this.coverImage,



       


    });

        factory FoodsInsert.fromJson(Map<String, dynamic> json){
           return FoodsInsert(
              foodId: json['foodId'],
              shopId: json['shopId'],
              name: json['name'],
              price: json['price'],
              status: json['status'],
              coverImage: json['coverImage'],
           );
        }
   



     Map<String, dynamic> toJson(){
       return{
         "foodId" : foodId,
         "shopId": shopId,
        "name" : name,
        "price" : price,
        "status" : status,
        "coverImage" : coverImage,
       };
     }
}


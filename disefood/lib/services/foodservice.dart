import 'package:disefood/model/api_response.dart';
import 'package:disefood/model/foodinsert.dart';
import 'package:disefood/model/foods_list.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:async';




  
  



  Future<List<FoodsList>> getFoodsData(http.Client client) async {
  const foodAPI = 'http://10.0.2.2:8000/api/foods/';
  final response = await client.get(foodAPI);
  return compute(parseFoods, response.body);
   
}

List<FoodsList> parseFoods(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<FoodsList>((json) => FoodsList.fromJson(json)).toList();
}


Future<APIResponse<bool>> createFood(FoodsInsert item ) async{
   const foodAPI = 'http://10.0.2.2:8000/api/foods/';
    return http.post(foodAPI,body: json.encode(item.toJson())).then((data){
          if(data.statusCode == 201){
            return APIResponse<bool>(data: true);
          }
          return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
     .catchError((_)=> APIResponse<bool>(error: true,errorMessage: 'An error occured'));
}


Future<FoodsInsert> createFood1(String url,{Map body}) async {
   
    return http.post(url, body: body).then((http.Response response){
        final int statusCode = response.statusCode;
        if(statusCode < 200 || statusCode > 400 || json == null){
          throw new Exception('Error while fetching data');
        }
        return FoodsInsert.fromJson(json.decode(response.body));
    });
}

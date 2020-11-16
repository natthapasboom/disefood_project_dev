// import 'package:disefood/model/shops_list.dart';
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;

// Future<List<Shops>> fetchShops(http.Client client, int shopId) async {
//   if (shopId == 0) {
//     final response = await client.get('http://10.0.2.2:8080/api/shops/');
//     return compute(parseShops, response.body);
//   } else {
//     final response =
//         await client.get('http://10.0.2.2:8080/api/shops/+$shopId');
//     return compute(parseShops, response.body);
//   }
// }

// List<Shops> parseShops(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

//   return parsed.map<Shops>((json) => Shops.fromJson(json)).toList();
// }

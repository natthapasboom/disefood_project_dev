import 'dart:convert';
import 'package:disefood/model/foods_list.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<List<Foods>> fetchFoodsMenuPage(http.Client client,int shopId) async {
  final response = await client.get('http://10.0.2.2:8000/api/shop/foods/'+'${shopId}');

  return compute(parseFoods, response.body);
}

List<Foods> parseFoods(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Foods>((json) => Foods.fromJson(json)).toList();
}

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:disefood/model/shopList.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

import 'package:logger/logger.dart';

class ApiProvider {
  ApiProvider();
  Logger logger = Logger();
  String url = 'http://10.0.2.2:8080';

  Future<http.Response> doLogin(String username, String password) async {
    String _url = 'http://10.0.2.2:8080/api/auth/login';

    var body = {"username": username, "password": password};
    http.Response response = await http.post(_url, body: body);
    return response;
  }


  Future<http.Response> approveShopById(int shopId, String approved, String _method) async {
    String _url = 'http://10.0.2.2:8080/api/admin/approved/$shopId'; 
    var body = {"approved": approved, "_method": _method};
    http.Response response = await http.post(_url, body: body);
    return response;

  }


  Future<http.Response> getUserById(int userId) async {
    String _url = 'http://10.0.2.2:8080/api/user/$userId';
    http.Response response = await http.get(_url);
    return response;
  }


  Future<String> getShops() async {
    String _url = 'http://10.0.2.2:8080/api/shop';
    final response = await http.get(_url);
      var body = response.body; 
      var arr = json.decode(body)['data'];
      logger.d(arr);
     return "successful";
  }


  


  Future<List<ShopList>> getShopList(http.Client client) async {
    String _url = 'http://10.0.2.2:8080/api/shop';
    final response = await client.get(_url);
    print(response.statusCode);
    logger.d(response.body); 
    return compute(parseShop, response.body);
  }

  List<ShopList> parseShop(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ShopList>((parsed) => ShopList.fromJson(parsed)).toList();
  }

  Future<http.Response> doRegister(
      String username,
      String password,
      String firstname,
      String lastname,
      String phone,
      File image,
      bool status) async {
    String _url = 'http://127.0.0.1:8080/api/user';
    var fileContent = image.readAsBytesSync();
    var fileContentBase64 = base64.encode(fileContent);
    var body = {
      "username": username,
      "password": password,
      "first_name": firstname,
      "last_name": lastname,
      "tel": phone,
      "image_cover": fileContentBase64,
      "isSeller": status,
    };
    print(body);
    return await http.post(
      _url,
      body: body,
    );
  }
}

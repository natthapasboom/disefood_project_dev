import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:disefood/model/shopList.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class ApiProvider {
  ApiProvider();
  Logger logger = Logger();
  String url = 'http://10.0.2.2:8080';

  Future<http.Response> doLogin(String username, String password) async {
    String _url = 'http://54.151.194.224:8000/api/auth/login';
    // String _url = 'http://10.0.2.2:8080/api/auth/login';

    var body = {"username": username, "password": password};
    http.Response response = await http.post(_url, body: body);
    return response;
  }

  Future<String> addFood(String name, int price, bool status, File image,
      String token, int shopId) async {
    int statusFood;
    String fileImage = image.path.split('/').last;
    Logger logger = Logger();
    logger.d('shop_id : $shopId');
    logger.d(status);
    if (status == true) {
      statusFood = 1;
    } else {
      statusFood = 0;
    }
    logger.d(statusFood);
    // logger.d('token : $token');
    String url = 'http://54.151.194.224:8000/api/shop/menu/$shopId';
    FormData formData = FormData.fromMap({
      'name': name,
      'price': price,
      'status': status,
      'cover_img':
          await MultipartFile.fromFile(image.path, filename: fileImage),
    });

    logger.d(formData.fields);
    var response = await Dio().post(
      url,
      data: formData,
      options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
          followRedirects: false,
          validateStatus: (status) {
            return status < 500;
          }),
    );
    logger.d('status code : ${response.statusCode}');
    if (response.statusCode == 200) {
      logger.d("succes");
    }
  }

  Future<String> createShop(String name, int shopSlot, File coverImg,
      File documentImg, String token) async {
    try {
      String _url = 'http://54.151.194.224:8000/api/shop/owner';
      Dio().options.headers['Authorization'] = 'Bearer $token';

      String shopImage = coverImg.path.split('/').last;
      String docImage = documentImg.path.split('/').last;

      FormData formData = FormData.fromMap({
        "name": name,
        "shop_slot": shopSlot,
        "cover_img":
            await MultipartFile.fromFile(coverImg.path, filename: shopImage),
        "document_img":
            await MultipartFile.fromFile(documentImg.path, filename: docImage),
      });
      logger.d('FormData : ${formData.fields}');
      var response = await Dio().post(
        _url,
        data: formData,
        options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );

      logger.d("Status: ${response.statusCode}");
      logger.d("Data: ${response.data}");

      if (response.statusCode == 200) {
        return "success";
      } else {}
    } catch (err) {
      print('ERROR  $err');
    }
  }

  Future<String> register(
      String username,
      String email,
      String password,
      String firstName,
      String lastName,
      String tel,
      File image,
      String role) async {
    try {
      String url = 'http://54.151.194.224:8000/api/auth/register';
      String fileName = image.path.split('/').last;
      print('after try ==> ');
      FormData formData = FormData.fromMap({
        "username": username,
        "email": email,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "tel": tel,
        "profile_img":
            await MultipartFile.fromFile(image.path, filename: fileName),
        "role": role,
      });
      print(formData.fields);
      // print(formData.files);
      print('data : $formData');
      var response = await Dio().post(
        url,
        data: formData,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );

      print('res : $response');
      print('res : ${response.data}');
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('response : ${response.data}');
        print('Success');
        // Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
      } else {
        print('error code');
      }
      print('res : $response');
    } catch (e) {}
  }

  Future<http.Response> approveShopById(
      String token, int shopId, String approved, String _method) async {
    String _url = 'http://54.151.194.224:8000/api/admin/approved/$shopId';
    var body = {"approved": approved, "_method": _method};
    http.Response response = await http.post(_url,
        headers: {'Authorization': 'Bearer $token'}, body: body);
    return response;
  }

  Future<http.Response> getHistoryById(String token) async {
    String _url = 'http://54.151.194.224:8000/api/order/me';
    // String _url = 'http://10.0.2.2:8080/api/order/me';
    http.Response response =
        await http.get(_url, headers: {'Authorization': 'Bearer $token'});
    return response;
  }

  Future<http.Response> rejectShopByID(int id, String token) async {
    String _url = 'http://54.151.194.224:8000/api/admin/rejected/$id';
    http.Response response =
        await http.delete(_url, headers: {'Authorization': 'Bearer $token'});
    return response;
  }

  Future<http.Response> deleteMenuById(int id, String token) async {
    String _url = 'http://54.151.194.224:8000/api/shop/menu/remove/$id';
    http.Response response =
        await http.delete(_url, headers: {'Authorization': 'Bearer $token'});
    return response;
  }

  Future<http.Response> getUserById(int userId) async {
    String _url = 'http://54.151.194.224:8000/api/user/$userId';
    http.Response response = await http.get(_url);
    return response;
  }

  Future<http.Response> getFoodByShopId(int shopId) async {
    String _url = 'http://54.151.194.224:8000/api/shop/menu/$shopId';
    http.Response response = await http.get(_url);
    return response;
  }

  Future<http.Response> getShopId(String token) async {
    String _url = 'http://54.151.194.224:8000/api/shop/owner';
    http.Response response =
        await http.get(_url, headers: {'Authorization': 'Bearer $token'});
    return response;
  }

  Future<String> getShops() async {
    String _url = 'http://54.151.194.224:8000/api/shop';
    final response = await http.get(_url);
    var body = response.body;
    var arr = json.decode(body)['data'];
    logger.d(arr);
    return "successful";
  }

  Future<List<ShopList>> getShopList(http.Client client) async {
    String _url = 'http://54.151.194.224:8000/api/shop';
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

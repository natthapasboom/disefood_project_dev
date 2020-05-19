import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:disefood/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';

class ApiProvider {
  ApiProvider();

  String url = 'http://127.0.0.1:8080';

  Future<http.Response> doLogin(String username, String password) async {
    String _url = '$url/api/login';
    var body = {"username": username, "password": password};
    return await http.post(_url, body: body);
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

  Future<http.Response> doRegister1(
    String username,
    String password,
    String firstname,
    String lastname,
    String phone,
    File image,
    bool status,
  ) async {
    String _url = 'http://10.0.2.2:8080/api/user/';

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

  // Future<User> dioRegister({

  //   @required  String username,
  //   @required  String password,
  //   @required  String firstname,
  //   @required  String lastname,
  //    @required String phone,
  //    @required String image,
  //   @required  bool status}) async {
    
  //   try {
  //     var body = FormData.fromMap({
  //       "username": username,
  //       "password": password,
  //       "first_name": firstname,
  //       "last_name": lastname,
  //       "tel": phone,
  //       "image_cover": await MultipartFile.fromFile(image) ,
  //       "isSeller": status,
  //     });
  //       String url = 'http://10.0.2.2:8000/api/user';
  //       final result = await Dio().post(url,
  //       data: body,
  //       );

  //       return User.fromJson(result.data);
  //   } catch (e) {
  //     print('error :  $e');
  //     throw e;
  //   }

  // }

  // Future<http.Response> register(
  //   String username,
  //   String password,
  //   String firstname,
  //   String lastname,
  //   String phone,
  //   File image,
  // ) async {
  //      var fileContent = image.readAsBytesSync();
  //      var fileContentBase64 = base64.encode(fileContent);
  //   var response = await http.post('http://10.0.2.2:8000/api/user', body: {
      
  //     "username": username,
  //     "password": password,
  //     "first_name": firstname,
  //     "last_name": lastname,
  //     "tel": phone,
  //     "image_cover": fileContentBase64,
  //   },
   
  //   );
  //       Map<String, dynamic> data = jsonDecode(response.body);
        
  // }
}

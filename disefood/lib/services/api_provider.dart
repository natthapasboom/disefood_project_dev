import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';


class ApiProvider {
  ApiProvider();

  String url = 'http://10.0.2.2:8080';

  Future<http.Response> doLogin(String username, String password) async {
    String _url = 'http://10.0.2.2:8080/api/login';
    
    var body = {"username": username, "password": password};
    http.Response response = await http.post(_url,  body: body);
    return response;
    
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

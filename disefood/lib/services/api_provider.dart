import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';


class ApiProvider{
  ApiProvider();

  String url = 'http://127.0.0.1:8000';

  Future<http.Response> doLogin(String username,String password) async{
        String _url = '$url/api/login';
        var body = {
          "username" : username,
          "password" : password
        };
          return http.post(_url,body: body);

  }

  Future<http.Response> doRegister(String username,String password,String firstname,String lastname,String phone,File image,) async{
        String _url =  '$url/api/user';
        var fileContent = image.readAsBytesSync();
        var fileContentBase64 = base64.encode(fileContent); 
        var body = {
          "username" : username,
          "password" : password,
          "firstname" : firstname,
          "lastname" : lastname,
          "phone" : phone,
          "image" : fileContentBase64,
          // "status" : status,
        };
          print(body);
          return await http.post(_url,body: body);

  }
  

}
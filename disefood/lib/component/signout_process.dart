import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:disefood/screen/login_customer_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Null> signOutProcess(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  try {
    String url = 'http://54.151.194.224:8000/api/auth/logout';

    String token = preferences.getString('token');
    print(token);
    var response = await Dio().get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
        followRedirects: false,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );

    Logger logger = Logger();
    logger.d(response.statusCode);
    logger.d(response.data);
    if (response.statusCode == 200) {
      // exit(0);
      preferences.clear();
      MaterialPageRoute route =
          MaterialPageRoute(builder: (context) => LoginPage());
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    }
  } catch (e) {
    Logger logger = Logger();
    logger.e(e);
  }
}

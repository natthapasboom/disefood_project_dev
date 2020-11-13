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
import 'package:shared_preferences/shared_preferences.dart';

Future<Null> signOutProcess(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  double star1 = preferences.getDouble('star1');
  double star2 = preferences.getDouble('star2');
  double star3 = preferences.getDouble('star3');
  double star4 = preferences.getDouble('star4');
  double star5 = preferences.getDouble('star5');

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

      await preferences.remove('star1');
      await preferences.remove('star2');
      await preferences.remove('star3');
      await preferences.remove('star4');
      await preferences.remove('star5');
      await preferences.remove('token');
      await preferences.clear();
      preferences.commit();
      logger.d(
          'star : $star1, $star2, $star3, $star4, $star5, $preferences, $token');
      MaterialPageRoute route =
          MaterialPageRoute(builder: (context) => LoginPage());
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    }
  } catch (e) {
    Logger logger = Logger();
    logger.e(e);
  }
}



import 'dart:io';


import 'package:disefood/screen/login_customer_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Null> signOutProcess(BuildContext context) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    // exit(0);
    MaterialPageRoute route = MaterialPageRoute(builder: (context)=> LoginPage());
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }
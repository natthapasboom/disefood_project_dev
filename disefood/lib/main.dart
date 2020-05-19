import 'dart:ui';

import 'package:disefood/component/login.dart';
import 'package:disefood/component/organize_seller_bottombar.dart';
import 'package:disefood/screen/login_customer_page.dart';
import 'package:disefood/screen/menu_page.dart';
import 'package:disefood/screen/order_items.dart';
import 'package:disefood/screen/order_promptpay_page.dart';
import 'package:disefood/screen/view_order_page.dart';
import 'package:disefood/screen_seller/home_seller.dart';
import 'package:disefood/screen_seller/organize_seller_page.dart';
import 'package:disefood/screen_seller/widget/organize_seller.dart';
import 'package:flutter/material.dart';
import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/screen_seller/addmenu.dart';
import 'component/register.dart';
import 'screen/menu_order_detail_amount.dart';
import 'screen_seller/home_seller.dart';
import 'package:disefood/screen_seller/create_shop.dart';

//#Clt+Alt+L จัดระเบียบ
void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.orange,
      appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white),),
      
    ),
    home: Home(),
    initialRoute: '/',
    routes: {
      "/home_seller": (_) => HomeSeller(),
      '/home_customer' : (_) => Home(),
      '/Login' : (_) => LoginPage(),
    },
    
  ));
}

// void main() {
//   runApp(new MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(
//       primaryColor: Colors.orange,
//       appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
//     ),
//     home: new Home(),
//     initialRoute: '/',
//   ));
// }

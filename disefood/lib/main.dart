


import 'package:disefood/component/order_seller_bottombar.dart';
import 'package:disefood/component/organize_seller_bottombar.dart';
import 'package:disefood/screen/login_customer_page.dart';
import 'package:disefood/screen/menu_page.dart';
import 'package:disefood/screen/order_items.dart';
import 'package:disefood/screen/order_promptpay_page.dart';
import 'package:disefood/screen/view_order_page.dart';
import 'package:disefood/screen_seller/home_seller.dart';
import 'package:disefood/screen_seller/home_seller_tab.dart';
import 'package:disefood/screen_seller/order_seller_page.dart';
import 'package:disefood/screen_seller/orderdetail.dart';
import 'package:disefood/screen_seller/organize_seller_page.dart';

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
      fontFamily: 'Aleo',
      primaryColor: Colors.amber[800],
      appBarTheme: AppBarTheme(
        color: Colors.amber[800],
        iconTheme: IconThemeData(color: Colors.white),
      ),
    ),
    home: Homepage(),
    initialRoute: '/',
    routes: {
      Regis.routeName: (_) => Regis(),
      CreateShop.routeName: (_) => CreateShop(),
      AddMenu.route: (_) => AddMenu(),
      Homepage.routeName: (_) => Homepage(),
      "/home_seller": (_) => HomeSeller(),
      '/home_customer': (_) => Home(),
      '/organize_seller': (_) => OrganizeSellerPage(),
      '/Login': (_) => LoginPage(),
      '/order_seller': (_) => OrderSellerPage(),
      // '/order_detail_seller': (_) => OrderDetailSeller(),
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



import 'package:disefood/screen/order_promptpay_page.dart';
import 'package:disefood/screen_seller/home_seller.dart';
import 'package:flutter/material.dart';
import 'package:disefood/screen/home_customer.dart';


//#Clt+Alt+L จัดระเบียบ
void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.orange,
      appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
    ),
    home: new PromptpayPage(),
    initialRoute: '/',

  ));

}


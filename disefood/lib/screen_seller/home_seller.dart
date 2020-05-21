import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/screen_seller/create_shop.dart';
import 'package:disefood/screen_seller/edit_shop.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:disefood/component/feedback_seller_bottombar.dart';
import 'package:disefood/component/organize_seller_bottombar.dart';
import 'package:disefood/component/signout_process.dart';
import 'package:disefood/component/summary_seller_bottombar.dart';
import 'package:disefood/model/shop_id.dart';
import 'package:disefood/model/user_profile.dart';
import 'package:disefood/screen/login_customer_page.dart';
import 'package:disefood/screen_seller/order_seller_page.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:disefood/component/sidemenu_seller.dart';
import 'package:disefood/component/order_seller_bottombar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'organize_seller_page.dart';

class HomeSeller extends StatefulWidget {
  // final UserProfile userData;
  // HomeSeller({Key key, @required this.userData}):super(key:key);
  static const routeName = '/home_seller';

  @override
  _HomeSellerState createState() => _HomeSellerState();
}

class _HomeSellerState extends State<HomeSeller> {
  String shopImg;
  String nameUser;
  String lastNameUser;
  int userId;
  String profileImg;
  int shopId;
  String _shopName;
  int _shopId;
  String _shopImg;
  bool _isLoading = false;
  int _shopSlot;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      findUser();
      fetchShopFromStorage();
    });
  }

  Future<Null> findUser() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preference.getString('first_name');
      userId = preference.getInt('user_id');
      lastNameUser = preference.getString('last_name');
      profileImg = preference.getString('profile_img');
    });
  }

  Future<Null> fetchShopFromStorage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    final shopName = _prefs.getString('shop_name');
    final shopId = _prefs.getInt('shop_id');
    final shopImg = _prefs.getString('cover_img');
    final shopSlot = _prefs.getInt('shop_slot');
    setState(() {
      _shopName = shopName;
      _shopId = shopId;
      _shopImg = shopImg;
      _isLoading = false;
      _shopSlot = shopSlot;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('User Id = $userId');
    print('first name = $nameUser');
    print('lastname = $lastNameUser');
    print('shopname = $_shopName');
    print('Shop Id $_shopId');
    return new Scaffold(
      body: _shopId != null
          ? 
          ListView(
              children: <Widget>[
                headerImage(),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Text(
                              "$_shopSlot",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24.0),
                            ),
                          ),
                          title: Text(
                            '$_shopName',
                            style: TextStyle(
                                fontSize: 24.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("ประเภทของร้านอาหาร"),
                              Container(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 15.0,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5.0),
                                      child: Text("4.2"),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 13.0,
                  color: Colors.black12,
                ),
                Container(
                  // child: _shopId == null
                  //     ? Center(
                  //         child: IconButton(
                  //           icon: Icon(
                  //             Icons.add_circle,
                  //             color: Colors.amber[900],
                  //           ),
                  //           onPressed: () {},
                  //         ),
                  //       )
                      child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: 20, right: 30, top: 75),
                              child: IconButton(
                                icon: Icon(
                                  Icons.store,
                                  color: Colors.amber[800],
                                  size: 64,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditShop()));
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Center(
                                child: Text(
                                  'แก้ไขร้านอาหาร',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ],
            )
          : Center(
              child: Column(
                children: <Widget>[
                  // headerImage(),
                  Container(
                    margin: EdgeInsets.only(top: 250),
                    child: IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.amber[900],
                        size: 36,
                      ),
                      onPressed: () {
                        
                        Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CreateShop()));
                      },
                    ),
                  ),
                  Center(
                    child: Text(
                      'เพิ่มร้านค้า',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  

  Widget headerImage() =>
      // _shopImg != null ?
      // Image.network(
      //   'https://disefood.s3-ap-southeast-1.amazonaws.com/'+'$_shopImg',
      //   height: 160.0,
      //   width: 430.0,
      //   fit: BoxFit.cover,
      // ):
      // ,
      Container(

        child: _shopImg == null ?
          Container(
          
          width: 430.0,
          height: 160.0,
          color: Colors.white60,
          child: Center(
            child: Icon(Icons.photo,size: 36,color: Colors.amber[900],),
          ),
          )
        :CachedNetworkImage(
          imageUrl:
              'https://disefood.s3-ap-southeast-1.amazonaws.com/$_shopImg',
          width: 430.0,
          height: 160.0,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error)),
      );
     
}

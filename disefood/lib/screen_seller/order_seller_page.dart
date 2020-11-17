import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/orderList.dart';
import 'package:disefood/model/orderbyshopid.dart';
import 'package:disefood/screen_seller/orderdetail.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OrderSellerPage extends StatefulWidget {
  static final route = "/order_seller";
  //  final UserProfile userData;
  // OrderSellerPage({Key key,@required this.userData}) : super(key : key);
  @override
  _OrderSellerPageState createState() => _OrderSellerPageState();
}

class _OrderSellerPageState extends State<OrderSellerPage> {
  bool isLoading = true;
  Logger logger = Logger();
  int userId;
  String name;
  var orderList;
  Future<SellerOrderData> _orderList;

  @override
  void initState() {
    _orderList = getOrderByShopId();
    Future.microtask(() async {
      fetchNameFromStorage();
    });
    super.initState();
  }

  Future fetchNameFromStorage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    setState(() {
      name = _prefs.getString('first_name');
      userId = _prefs.getInt('user_id');
    });
  }

  Future<SellerOrderData> getOrderByShopId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int shopId = _prefs.getInt("shop_id");
    String token = _prefs.getString("token");
    String _url = 'http://54.151.194.224:8000/api/order/shop/$shopId';
    final response = await http.get(
      _url,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        var jsonString = response.body;
        Map jsonMap = json.decode(jsonString);
        orderList = SellerOrderData.fromJson(jsonMap);
      });
    } else {
      print(response.statusCode);
    }
    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    // print('$_userId $_name');

    return Scaffold(
        body: ListView(
      children: [
        Container(
          child: FutureBuilder<SellerOrderData>(
            future: _orderList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.data.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data.data[index];
                    return Container(
                      child: Text("${data.user.firstName}"),
                    );
                  },
                );
              } else {
                return Container(
                  margin: EdgeInsets.only(top: 250),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        )
      ],
    ));
  }
}

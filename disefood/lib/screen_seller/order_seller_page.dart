import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
  List orderSeller = [];

  String _name;
  int _userId;
  Logger logger = Logger();
  int userId;
  String timePickup;
  int totalPrice;
  String allFoodName = "";
  List orderDetail = [];
  String userFName;
  String userLName;
  String userTel;
  int tempColor = 0;
  String tempStatus = "";

  @override
  void initState() {
    Future.microtask(() async {
      fetchNameFromStorage();
      getOrderByShopId();
    });
    super.initState();
  }

  Future fetchNameFromStorage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final name = _prefs.getString('first_name');
    final userId = _prefs.getInt('user_id');
    setState(() {
      _name = name;
      _userId = userId;
    });
  }

  Future getOrderByShopId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int shopId = _prefs.getInt("shop_id");
    String token = _prefs.getString("token");
    String _url = 'http://10.0.2.2:8080/api/order/shop/$shopId';
    final response = await http.get(
      _url,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    var body = response.body;
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        orderSeller = jsonDecode(body)['data'];
        logger.d(orderSeller);
      });
    } else {
      setState(() {
        orderSeller = null;
      });
    }
    // logger.d(body);
  }

  colorCheck(item) {
    if (item["status"] == "not confirmed") {
      tempColor = 0;
      tempStatus = "ยังไม่ยืนยัน";
    } else if (item["status"] == "in process") {
      tempColor = 1;
      tempStatus = "กำลังทำ";
    } else if (item["status"] == "success") {
      tempColor = 2;
      tempStatus = "เสร็จสิ้น";
    }
  }

  Color getColor() {
    if (tempColor == 0) {
      return Colors.redAccent;
    } else if (tempColor == 1) {
      return Colors.yellow[600];
    } else if (tempColor == 2) {
      return Colors.lightGreen;
    } else {
      return Colors.redAccent;
    }
  }

  // dispose() {
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    // print('$_userId $_name');

    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : new ListView.builder(
              itemCount: orderSeller != null ? orderSeller.length : 0,
              itemBuilder: (BuildContext context, int index) {
                var item = orderSeller[index];
                colorCheck(item);
                logger.d(tempColor);
                // Todo: Improve coding next time, Boom.
                var i;
                if (allFoodName == "") {
                  for (i = 0; i < item["order_details"].length; i++) {
                    allFoodName +=
                        item["order_details"][i]["food"]["name"] + " ";
                  }
                }
                return orderSeller.length == 0 || orderSeller.length == null
                    ? Center(
                        child: Text(
                          "ยังไม่มีออเดอร์ในขณะนี้",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontSize: 20),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.all(20),
                        child: InkWell(
                          child: Card(
                            elevation: 8,
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          "https://disefood.s3-ap-southeast-1.amazonaws.com/${item['cover_img']}",
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 380,
                                      placeholder: (context, url) => Center(
                                          child: Container(
                                              margin: EdgeInsets.only(
                                                  top: 50, bottom: 0),
                                              child: CircularProgressIndicator(
                                                backgroundColor:
                                                    Colors.amber[900],
                                              ))),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: 100,
                                        width: 380,
                                        // color: const Color(0xff7FC9C5),
                                        color: getColor(),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.fastfood,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                              Transform.translate(
                                                offset: Offset(0, 0),
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 5),
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 4, 5, 5),
                                                  decoration: BoxDecoration(
                                                      // color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Text(
                                                    "$tempStatus",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Transform.translate(
                                        offset: Offset(10, 10),
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 4, 5, 5),
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            "คิวที่ ${index + 1}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 15, top: 5),
                                  child: Text(
                                    "รายละเอียด",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15, top: 5),
                                  child: Text(
                                    '${allFoodName}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        "ราคา  ",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Container(
                                        child: Text(
                                          "${item["total_price"]} บาท",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        "เวลาที่จะมารับ  ",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          "${item["time_pickup"]}",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      ButtonBar(
                                        children: <Widget>[
                                          RaisedButton(
                                            onPressed: () {
                                              userId = item["user_id"];
                                              timePickup = item["time_pickup"];
                                              totalPrice = item["total_price"];
                                              orderDetail =
                                                  item["order_details"];
                                              userFName =
                                                  item["user"]["first_name"];
                                              userLName =
                                                  item["user"]["last_name"];
                                              userTel = item["user"]["tel"];
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderDetailSeller(
                                                    userId: userId,
                                                    timePickup: timePickup,
                                                    totalPrice: totalPrice,
                                                    orderDetail: orderDetail,
                                                    userFName: userFName,
                                                    userLName: userLName,
                                                    userTel: userTel,
                                                  ),
                                                ),
                                              );
                                            },
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            color: Colors.white,
                                            child: Text(
                                              "แก้ไข",
                                              style: TextStyle(
                                                  color: Colors.orangeAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          RaisedButton(
                                            onPressed: () {
                                              logger.d(orderSeller);
                                            },
                                            padding: EdgeInsets.only(
                                                left: 20, right: 20),
                                            color: Colors.orange,
                                            child: Text(
                                              "ยอมรับ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
              },
            ),
    );
  }
}

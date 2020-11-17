import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/orderList.dart';
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
  List<OrderList> list = List();
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

  Future<List<OrderList>> getOrderByShopId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int shopId = _prefs.getInt("shop_id");
    String token = _prefs.getString("token");
    String _url = 'http://54.151.194.224:8000/api/order/shop/$shopId';
    final response = await http.get(
      _url,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    logger.d('${response.statusCode}');
    print('${response.statusCode}');
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new OrderList.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
      var body = json.decode(response.body);
      var orderDetail = json.decode(response.body)['order_details'];
      print('order_detail : $orderDetail');
      for (Map<String, dynamic> m in body['order_details']) {
        var order = list.add(OrderList.fromJson(m));
      }
    } else if (response.statusCode != 200) {
      var body = json.decode(response.body);
      List data = body['data'];
      return data.map((m) => OrderList.fromJson(m)).toList();
    }
    // logger.d(body);
  }

  String _foodName(dynamic item) {
    return item['order_details']['food']['name'];
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

  Text checkStatus(var item) {
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

  Color getColor(var status) {
    if (status == 'not confirmed') {
      return Colors.redAccent;
    } else if (status == 'in process') {
      return Colors.yellow[600];
    } else if (status == 'success') {
      return Colors.lightGreen;
    } else {
      return Colors.redAccent;
    }
  }

  ListView _order(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Container(
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
                              "https://disefood.s3-ap-southeast-1.amazonaws.com/${data['cover_img']}",
                          fit: BoxFit.cover,
                          height: 100,
                          width: 380,
                          placeholder: (context, url) => Center(
                              child: Container(
                                  margin: EdgeInsets.only(top: 50, bottom: 0),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 5.0,
                                    valueColor: AlwaysStoppedAnimation(
                                        const Color(0xffF6A911)),
                                  ))),
                          errorWidget: (context, url, error) => Container(
                            height: 100,
                            width: 380,
                            // color: const Color(0xff7FC9C5),
                            color: getColor(data[index]),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.fastfood,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  Transform.translate(
                                    offset: Offset(0, 0),
                                    child: Container(
                                      margin: EdgeInsets.only(top: 5),
                                      padding: EdgeInsets.fromLTRB(5, 4, 5, 5),
                                      decoration: BoxDecoration(
                                          // color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        data['status'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
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
                              padding: EdgeInsets.fromLTRB(5, 4, 5, 5),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(5),
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
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, top: 5),
                      child: Text(
                        '${data['order_details']['food']['name']}',
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
                              "${data["total_price"]} บาท",
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
                              "${data["time_pickup"]}",
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
                                  userId = data["user_id"];
                                  timePickup = data["time_pickup"];
                                  totalPrice = data["total_price"];
                                  orderDetail = data["order_details"];
                                  userFName = data["user"]["first_name"];
                                  userLName = data["user"]["last_name"];
                                  userTel = data["user"]["tel"];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderDetailSeller(
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
                                padding: EdgeInsets.only(left: 20, right: 20),
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
                                padding: EdgeInsets.only(left: 20, right: 20),
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
        });
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('$_userId $_name');

    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 5.0,
                valueColor: AlwaysStoppedAnimation(const Color(0xffF6A911)),
              ),
            )
          : orderSeller.length != 0
              ? new ListView.builder(
                  itemCount: orderSeller != null ? orderSeller.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    var item = orderSeller[index];
                    print('${orderSeller.length}');
                    colorCheck(item);
                    logger.d(tempColor);
                    // Todo: Improve coding next time, Boom.
                    var i;
                    if (allFoodName == "") {
                      for (i = 0; i < orderSeller.length; i++) {
                        allFoodName +=
                            item["order_details"][i]["food"]["name"] + " ";
                        // allFoodName +=
                        //     item["order_details"][i];
                        print(
                            'order_details: ${item["order_details"][i]["food"]} ');
                      }
                    }
                    return Container(
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
                                              strokeWidth: 5.0,
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      const Color(0xffF6A911)),
                                            ))),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: 100,
                                      width: 380,
                                      // color: const Color(0xff7FC9C5),
                                      color: getColor(item['status']),
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
                                                margin: EdgeInsets.only(top: 5),
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 4, 5, 5),
                                                decoration: BoxDecoration(
                                                    // color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Text(
                                                  item['status'],
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
                                            orderDetail = item["order_details"];
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
                )
              : Center(
                  child: Text(
                    "ยังไม่มีออเดอร์ในขณะนี้",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                        fontSize: 20),
                  ),
                ),
    );
  }
}

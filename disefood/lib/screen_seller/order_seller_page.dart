import 'dart:convert' show jsonDecode;
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:disefood/model/orderbyshopid.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'orderdetail.dart';

class OrderSellerPage extends StatefulWidget {
  static final route = "/order_seller";
  const OrderSellerPage({
    Key key,
  }) : super(key: key);
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
  List<DateTime> timePickup = [];
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isOrderEmpty = true;
  List<int> qty;

  Color color;

  @override
  void initState() {
    assignValue();

    Future.microtask(() async {
      fetchNameFromStorage();
    });
    super.initState();
    refreshList();
  }

  void convertStrToDateTime(datetime, index) {
    timePickup.add(DateTime.parse(datetime));
  }

  Future fetchNameFromStorage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    setState(() {
      name = _prefs.getString('first_name');
      userId = _prefs.getInt('user_id');
    });
  }

  getStatusText(String status) {
    String result;

    if (status == "in process") {
      color = Color(0xffF9DE1B);
      result = "กำลังดำเนินการ";
    } else if (status == "not confirmed") {
      result = "ยังไม่ยืนยัน";
      color = Colors.red;
    } else {
      result = "เสร็จสิ้น";
      color = Colors.green;
    }
    return result;
  }
  // qty = List<int>(snapshot.data.data.length);

  void addQty(index) {
    qty[index]++;

    setState(() {});
  }

  void resetQty(index) {
    qty[index] = 0;
    setState(() {});
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
        var jsonString = response.body;
        Map jsonMap = jsonDecode(jsonString);
        assignQtyValue(jsonMap);

        orderList = SellerOrderData.fromJson(jsonMap);
      });
    } else {
      print(response.statusCode);
    }
    return orderList;
  }

  void assignValue() {
    _orderList = getOrderByShopId();
  }

  void assignQtyValue(Map jsonMap) {
    qty = List<int>(jsonMap["data"].length);
  }

  Future<Null> updateOrder(int orderId, String timepickup) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String url = 'http://54.151.194.224:8000/api/order/shop/$orderId';
    String token = preferences.getString('token');
    DateTime datetimepickup = DateTime.parse(timepickup);
    String status = "success";
    String _method = "PUT";
    FormData formData = FormData.fromMap({
      "status": status,
      "time_pickup": datetimepickup,
      "_method": _method,
    });
    var response = await Dio().post(
      url,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
        followRedirects: false,
        validateStatus: (status) {
          if (status == 200) {
            assignValue();
            showToast("อัพเดทออร์เดอร์เรียบร้อยแล้ว");
          } else {
            showToast("มีข้อผิดพลาดเกิดขึ้น โปรดลองใหม่ภายหลัง Status : " +
                "$status");
          }
          return status < 500;
        },
      ),
    );
    print(response.statusCode);
  }

  void showToast(String msg) {
    Toast.show(msg, context,
        textColor: Colors.white, duration: Toast.LENGTH_LONG);
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _orderList = getOrderByShopId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Colors.orange,
        onRefresh: refreshList,
        key: refreshKey,
        child: ListView(
          children: [
            Container(
              child: FutureBuilder<SellerOrderData>(
                future: _orderList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data.data.length == 0
                        ? Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 230),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.not_interested,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "ยังไม่มีออเดอร์ในขณะนี้",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.data.length,
                            itemBuilder: (context, index) {
                              var data = snapshot.data.data[index];
                              convertStrToDateTime(data.timePickup, index);
                              int minuteCheck = timePickup[index].minute;
                              String timeMinute;
                              if (minuteCheck == 0) {
                                timeMinute = "${timePickup[index].minute}0";
                              } else if (minuteCheck < 10) {
                                timeMinute = "0${timePickup[index].minute}";
                              } else {
                                timeMinute = "${timePickup[index].minute}";
                              }
                              return Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: 20,
                                        left: 20,
                                        top: 10,
                                        bottom: 5),
                                    height: 210,
                                    child: Card(
                                      elevation: 5,
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    "https://disefood.s3-ap-southeast-1.amazonaws.com/" +
                                                        '${data.orderDetails[0].food.coverImg}',
                                                width: 380,
                                                height: 90,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 5.0,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            const Color(
                                                                0xffF6A911)),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  height: 90,
                                                  color:
                                                      const Color(0xff7FC9C5),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.fastfood,
                                                      size: 50,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            5, 4, 5, 5),
                                                    margin: EdgeInsets.only(
                                                        left: 10, top: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black45,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Text(
                                                      "คิวที่ ${index + 1}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      "${getStatusText(data.status)}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            5, 4, 5, 5),
                                                    margin: EdgeInsets.only(
                                                        right: 10, top: 10),
                                                    decoration: BoxDecoration(
                                                      color: color,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 16),
                                            width: double.maxFinite,
                                            child: Text(
                                              "รายการอาหาร",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 18),
                                            child: Column(
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 3),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 135,
                                                        child: Text(
                                                          "${data.orderDetails[0].food.name}",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.orange,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            data.totalQuantity -
                                                                    1 !=
                                                                0,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          decoration:
                                                              new BoxDecoration(
                                                            color:
                                                                Colors.orange,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          constraints:
                                                              BoxConstraints(
                                                            minWidth: 16,
                                                            minHeight: 16,
                                                          ),
                                                          child: Text(
                                                            '+ ${data.totalQuantity - 1}  ',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: double.maxFinite,
                                                  child: Row(
                                                    children: [
                                                      Text("ราคารวม : ",
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 4),
                                                        child: Text(
                                                          "${data.totalPrice}",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.green,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      Text(
                                                        " บาท",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.green,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: double.maxFinite,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        "เวลาที่จะมารับ : ${timePickup[index].hour}.$timeMinute น. ",
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      Visibility(
                                                        visible:
                                                            qty[index] != null,
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(2),
                                                          decoration:
                                                              new BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                          constraints:
                                                              BoxConstraints(
                                                            minWidth: 16,
                                                            minHeight: 16,
                                                          ),
                                                          child: Text(
                                                            '+ ${qty[index]}  ',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(263, 165),
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(bottom: 20),
                                      width: 115,
                                      child: FlatButton(
                                        onPressed: () {
                                          List<OrderDetails> orderDetail =
                                              data.orderDetails;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetailSeller(
                                                timePickup: timePickup[index],
                                                totalPrice: data.totalPrice,
                                                coverImage: data.orderDetails[0]
                                                    .food.coverImg,
                                                orderDetail: orderDetail,
                                                userFName: data.user.firstName,
                                                userLName: data.user.lastName,
                                                userTel: data.user.tel,
                                                slipImg:
                                                    data.payment.paymentImg,
                                                orderId: data.id,
                                                addQty: addQty,
                                                resetQty: resetQty,
                                                index: index,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "รายละเอียด",
                                          style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: Offset(260, 130),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 120,
                                      child: FlatButton(
                                        onPressed: () {
                                          updateOrder(data.id, data.timePickup)
                                              .then((value) {
                                            setState(() {});
                                          });
                                        },
                                        color: Colors.orange,
                                        child: Text(
                                          "เสร็จสิ้น",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(top: 250),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                          valueColor:
                              AlwaysStoppedAnimation(const Color(0xffF6A911)),
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

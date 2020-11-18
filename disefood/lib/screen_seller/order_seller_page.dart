import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/orderbyshopid.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'orderdetail.dart';

class OrderSellerPage extends StatefulWidget {
  static final route = "/order_seller";
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
  @override
  void initState() {
    _orderList = getOrderByShopId();
    Future.microtask(() async {
      fetchNameFromStorage();
    });
    super.initState();
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
                      convertStrToDateTime(data.timePickup, index);
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                right: 20, left: 20, top: 10, bottom: 5),
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
                                        placeholder: (context, url) => Center(
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 50, bottom: 35),
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 5.0,
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          const Color(
                                                              0xffF6A911)),
                                                ))),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          height: 90,
                                          color: const Color(0xff7FC9C5),
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
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 4, 5, 5),
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.black45,
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
                                          Container(
                                            padding:
                                                EdgeInsets.fromLTRB(5, 4, 5, 5),
                                            margin: EdgeInsets.only(
                                                right: 10, top: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              "${data.status}",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
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
                                          margin: EdgeInsets.only(top: 3),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 135,
                                                child: Text(
                                                  "${data.orderDetails[0].food.name}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Visibility(
                                                visible:
                                                    data.totalQuantity - 1 != 0,
                                                child: Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: new BoxDecoration(
                                                    color: Colors.orange,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  constraints: BoxConstraints(
                                                    minWidth: 16,
                                                    minHeight: 16,
                                                  ),
                                                  child: Text(
                                                    ' + ${data.totalQuantity - 1}  ',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    textAlign: TextAlign.center,
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
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              Container(
                                                margin: EdgeInsets.only(top: 4),
                                                child: Text(
                                                  "${data.totalPrice}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              Text(
                                                " บาท",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Stack(
                                          children: [
                                            Container(
                                              width: double.maxFinite,
                                              child: Text(
                                                "เวลาที่จะมารับ : ${timePickup[index].hour}.${timePickup[index].minute} น.",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        )
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
                                      builder: (context) => OrderDetailSeller(
                                        timePickup: timePickup[index],
                                        totalPrice: data.totalPrice,
                                        coverImage:
                                            data.orderDetails[0].food.coverImg,
                                        orderDetail: orderDetail,
                                        userFName: data.user.firstName,
                                        userLName: data.user.lastName,
                                        userTel: data.user.tel,
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
                                    decoration: TextDecoration.underline,
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
                                onPressed: () {},
                                color: Colors.orange,
                                child: Text(
                                  "รับออเดอร์",
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
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

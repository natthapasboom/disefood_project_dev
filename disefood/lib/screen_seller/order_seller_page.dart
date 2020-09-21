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
  List<Card> carditem = new List<Card>();
  Logger logger = Logger();
  List orderDetail = [];
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
    logger.d(body);
    setState(() {
      // var orderDetail = json.decode(body)['data']['order_detail'];
      // logger.d(orderDetail);

      isLoading = false;
      orderSeller = jsonDecode(body);
    });
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('$_userId $_name');
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : new ListView.builder(
              itemCount: orderSeller != null ? orderSeller.length : 0,
              itemBuilder: (BuildContext context, int index) {
                var item = orderSeller[index];

                return Container(
                  margin: EdgeInsets.all(20),
                  height: 300,
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
                                height: 120,
                                width: 380,
                                placeholder: (context, url) => Center(
                                    child: Container(
                                        margin:
                                            EdgeInsets.only(top: 50, bottom: 0),
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.amber[900],
                                        ))),
                                errorWidget: (context, url, error) => Container(
                                  height: 120,
                                  width: 380,
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
                              Transform.translate(
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
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 5),
                            child: Text(
                              "รายละเอียด",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 15, top: 5),
                            child: Text(
                              '',
                              //ตรงนี้ๆฟกหสาหฟสกสหฟากสหฟาสกฟหาสวกวฟหกาวสฟหกวสหฟวสกาฟหวสกวหฟก
                              // "${orderSeller[]}",
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

                          Row(
                            children: <Widget>[
                              ButtonBar(
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: () {},
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    color: Colors.orange,
                                    child: Text(
                                      "เสร็จสิ้น",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetailSeller(),
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    color: Colors.white,
                                    child: Text(
                                      "แก้ไข",
                                      style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                          // Transform.translate(
                          //   offset: Offset(10, -20),
                          //   child: Row(
                          //     children: <Widget>[
                          //       Text(
                          //         "รายการอาหาร",
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 18),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // Transform.translate(
                          //   offset: Offset(10, -20),
                          //   child: Container(
                          //     child: Row(
                          //       children: <Widget>[
                          //         Container(
                          //           padding: EdgeInsets.only(right: 5),
                          //           child: Text("ก๋วยเตี๋ยวต้มยำพิเศษ"),
                          //         ),
                          //         Container(
                          //           padding: EdgeInsets.only(right: 5, top: 2),
                          //           child: Text("2"),
                          //         ),
                          //         Container(
                          //           height: 15,
                          //           padding: EdgeInsets.only(right: 5, top: 2),
                          //           child: VerticalDivider(
                          //             color: Colors.black54,
                          //             thickness: 2,
                          //           ),
                          //         ),
                          //         Container(
                          //           padding: EdgeInsets.only(right: 5),
                          //           child: Text("ก๋วยเตี๋ยวเย็นตาโฟ"),
                          //         ),
                          //         Container(
                          //           padding: EdgeInsets.only(right: 5, top: 2),
                          //           child: Text("1"),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // Transform.translate(
                          //   offset: Offset(10, -20),
                          //   child: Container(
                          //     child: Row(
                          //       children: <Widget>[
                          //         Container(
                          //           padding: EdgeInsets.only(right: 5),
                          //           child: Text("ราคา"),
                          //         ),
                          //         Container(
                          //           padding: EdgeInsets.only(right: 0, top: 3),
                          //           child: Text(
                          //             "135",
                          //             style: TextStyle(
                          //               color: Colors.green,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //         ),
                          //         Container(
                          //           padding: EdgeInsets.only(right: 5, top: 2),
                          //           child: Icon(
                          //             Icons.attach_money,
                          //             color: Colors.green,
                          //             size: 20,
                          //           ),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // Transform.translate(
                          //   offset: Offset(10, -20),
                          //   child: Container(
                          //     child: Row(
                          //       children: <Widget>[
                          //         Container(
                          //           padding: EdgeInsets.only(right: 5),
                          //           child: Text("เวลาที่จะมารับ"),
                          //         ),
                          //         Container(
                          //           padding: EdgeInsets.only(right: 5),
                          //           child: Text("11.30 AM"),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // Transform.translate(
                          //   offset: Offset(2, -20),
                          //   child: Container(
                          //     child: Row(
                          //       children: <Widget>[
                          //         ButtonBar(
                          //           children: <Widget>[
                          //             RaisedButton(
                          //               onPressed: () {},
                          //               padding: EdgeInsets.only(
                          //                   left: 20, right: 20),
                          //               color: Colors.orange,
                          //               child: Text(
                          //                 "เสร็จสิ้น",
                          //                 style: TextStyle(
                          //                     color: Colors.white,
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //             ),
                          //             RaisedButton(
                          //               onPressed: () => Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       OrderDetailSeller(),
                          //                 ),
                          //               ),
                          //               padding: EdgeInsets.only(
                          //                   left: 20, right: 20),
                          //               color: Colors.white,
                          //               child: Text(
                          //                 "แก้ไข",
                          //                 style: TextStyle(
                          //                     color: Colors.orangeAccent,
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
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

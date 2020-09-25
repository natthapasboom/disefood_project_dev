import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailSeller extends StatefulWidget {
  static final route = "/order_detail_seller";
  final int userId;
  final String timePickup;
  final int totalPrice;
  final List orderDetail;
  final String userFName;
  final String userLName;
  final String userTel;
  const OrderDetailSeller({
    Key key,
    @required this.userId,
    @required this.timePickup,
    @required this.totalPrice,
    @required this.orderDetail,
    @required this.userFName,
    @required this.userLName,
    @required this.userTel,
  }) : super(key: key);
  @override
  _OrderDetailSellerState createState() => _OrderDetailSellerState();
}

class _OrderDetailSellerState extends State<OrderDetailSeller> {
  bool isLoading = true;
  bool isthisbuttonselected = true;
  String nameUser;
  String lastNameUser;
  String profileImg;
  Logger logger = Logger();
  int userId;
  String timePickup;
  int totalPrice;
  List orderDetail;
  String userFName;
  String userLName;
  String userTel;
  @override
  void initState() {
    // Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    // Future.microtask(() {});
    super.initState();
    setState(() {
      userId = widget.userId;
      timePickup = widget.timePickup;
      totalPrice = widget.totalPrice;
      orderDetail = widget.orderDetail;
      userFName = widget.userFName;
      userLName = widget.userLName;
      userTel = widget.userTel;
    });
  }

  // void _getCurrentTime() {}

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'เพิ่มเวลา',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 50, top: 5),
                          child: SizedBox(
                            width: 30.0,
                            height: 30.0,
                            child: const Card(
                              child: Center(),
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 35, top: 5),
                          child: SizedBox(
                            width: 30.0,
                            height: 30.0,
                            child: const Card(
                              child: Center(),
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 40, top: 10),
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: const Card(
                              child: Center(
                                child: Text(
                                  '03',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5, top: 10),
                          child: Text(
                            ":",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5, top: 10),
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: const Card(
                              child: Center(
                                child: Text(
                                  '03',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              color: Colors.black26,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5, top: 10),
                          child: Text(
                            "นาที",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 50, top: 5),
                          child: SizedBox(
                            width: 30.0,
                            height: 30.0,
                            child: const Card(
                              child: Center(),
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 35, top: 5),
                          child: SizedBox(
                            width: 30.0,
                            height: 30.0,
                            child: const Card(
                              child: Center(),
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ButtonBar(
              children: <Widget>[
                RaisedButton(
                  hoverColor: Colors.orange,
                  elevation: 5,
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  color: Colors.white,
                  child: Text(
                    'ย้อนกลับ',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                RaisedButton(
                  elevation: 5,
                  onPressed: () => {},
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  color: Colors.orange,
                  child: Text(
                    'เสร็จสิ้น',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        bottomNavigationBar: Container(
          decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 12.0,
                spreadRadius: 5.0,
                offset: Offset(
                  10.0,
                  10.0,
                ),
              )
            ],
          ),
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                Container(
                  width: 350,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ราคารวม",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          "$totalPrice บาท",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.only(left: 0, top: 0, right: 170),
              child: Center(
                  child: Text(
                "Order Detail",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )),
            ),
          ],
        ),
        // drawer: _sideMenuSeller(params.userData),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://sifu.unileversolutions.com/image/th-TH/recipe-topvisual/2/1260-709/%E0%B8%81%E0%B9%8B%E0%B8%A7%E0%B8%A2%E0%B9%80%E0%B8%95%E0%B8%B5%E0%B9%8B%E0%B8%A2%E0%B8%A7%E0%B8%95%E0%B9%89%E0%B8%A1%E0%B8%A2%E0%B8%B3%E0%B8%AA%E0%B8%B8%E0%B9%82%E0%B8%82%E0%B8%97%E0%B8%B1%E0%B8%A2-50357483.jpg',
                  height: 140,
                  width: 430.0,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: EdgeInsets.only(left: 40),
                  width: double.maxFinite,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "เวลาทำอาหาร",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 40,
                      ),
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: const Card(
                          child: Center(
                            child: Text(
                              '03',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                      ),
                      child: Text(
                        ":",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                      ),
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: const Card(
                          child: Center(
                            child: Text(
                              '03',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          color: Colors.black26,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                      ),
                      child: Text(
                        "นาที",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: 100,
                      ),
                      child: ButtonBar(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              _neverSatisfied();
                            },
                            padding: EdgeInsets.all(10),
                            color: Colors.orange,
                            child: Text(
                              'เพิ่มเวลา',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 7),
                        child: Text(
                          "เวลาที่จะมารับ : ",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Text(
                        '$timePickup',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 40, right: 45),
                  alignment: Alignment.centerLeft,
                  width: double.maxFinite,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "รายการอาหาร",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        "จำนวน",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orderDetail != null ? orderDetail.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(left: 40, right: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${orderDetail[index]["food"]["name"]}",
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                "${orderDetail[index]["quantity"]}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey[200],
                          thickness: 2,
                          height: 0,
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.only(left: 40),
                  alignment: Alignment.centerLeft,
                  width: double.maxFinite,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: Text(
                    "รายละเอียดผู้สั่ง",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 40, right: 40),
                        height: 40,
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ชื่อ  ",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              "$userFName $userLName",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey[200],
                        thickness: 2,
                        height: 0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 40, right: 40),
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "เบอร์ติดต่อ",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              "$userTel",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )

        //     Row(
        //       children: <Widget>[
        //         Container(
        //           padding: EdgeInsets.only(left: 40, top: 10),
        //           child: SizedBox(
        //             width: 50.0,
        //             height: 50.0,
        //             child: const Card(
        //               child: Center(
        //                 child: Text(
        //                   '03',
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                       fontWeight: FontWeight.bold, color: Colors.white),
        //                 ),
        //               ),
        //               color: Colors.black26,
        //             ),
        //           ),
        //         ),
        //         Container(
        //           padding: EdgeInsets.only(left: 5, top: 10),
        //           child: Text(
        //             ":",
        //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        //           ),
        //         ),
        //         Container(
        //           padding: EdgeInsets.only(left: 5, top: 10),
        //           child: SizedBox(
        //             width: 50.0,
        //             height: 50.0,
        //             child: const Card(
        //               child: Center(
        //                 child: Text(
        //                   '03',
        //                   textAlign: TextAlign.center,
        //                   style: TextStyle(
        //                       fontWeight: FontWeight.bold, color: Colors.white),
        //                 ),
        //               ),
        //               color: Colors.black26,
        //             ),
        //           ),
        //         ),
        //         Container(
        //           padding: EdgeInsets.only(left: 5, top: 10),
        //           child: Text(
        //             "นาที",
        //             style: TextStyle(fontSize: 14),
        //           ),
        //         ),
        //         Container(
        //           padding: EdgeInsets.only(left: 100, top: 10),
        //           child: ButtonBar(
        //             children: <Widget>[
        //               RaisedButton(
        //                 onPressed: () {
        //                   _neverSatisfied();
        //                 },
        //                 padding: EdgeInsets.all(10),
        //                 color: Colors.orange,
        //                 child: Text(
        //                   'เพิ่มเวลา',
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     fontSize: 18,
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ],
        //     ),

        //     textdetailCustomer,
        //     Container(
        //       child: Divider(
        //         indent: 40,
        //         color: Colors.black,
        //         endIndent: 40,
        //       ),
        //     ),
        //     //หมวดข้อมูลผู้สั่ง Order
        //     Container(
        //       child: Row(
        //         children: <Widget>[
        //           Container(
        //             padding: EdgeInsets.only(left: 40, top: 5, bottom: 10),
        //             child: Column(
        //               children: <Widget>[
        //                 Text(
        //                   "ชื่อ",
        //                   style: TextStyle(fontSize: 14, color: Colors.black),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     Container(
        //       child: Row(
        //         children: <Widget>[
        //           Container(
        //             padding: EdgeInsets.only(
        //               left: 40,
        //               top: 10,
        //             ),
        //             child: Column(
        //               children: <Widget>[
        //                 Text(
        //                   "0863882908",
        //                   style: TextStyle(fontSize: 14, color: Colors.black),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),

        //     Row(
        //       children: <Widget>[
        //         Container(
        //           padding: EdgeInsets.only(left: 40, top: 10),
        //           child: Text(
        //             "เวลาที่จะมารับ",
        //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        //           ),
        //         ),
        //         Container(
        //           //หมวดเวลา
        //           padding: EdgeInsets.only(left: 130, top: 10),
        //           child: Text(
        //             '${timePickup}',
        //             style: TextStyle(fontSize: 14, color: Colors.black),
        //           ),
        //         ),
        //       ],
        //     ),
        //     Container(
        //       child: Divider(
        //         indent: 40,
        //         color: Colors.black,
        //         endIndent: 40,
        //       ),
        //     ),
        //     textOrder,
        //     Container(
        //       child: Divider(
        //         indent: 40,
        //         color: Colors.black,
        //         endIndent: 40,
        //       ),
        //     ),
        //     Row(
        //       children: <Widget>[
        //         Container(
        //           padding: EdgeInsets.only(left: 40, top: 10),
        //           child: Text(
        //             "รายการอาหาร",
        //             style: TextStyle(fontSize: 14),
        //           ),
        //         ),
        //         Container(
        //           padding: EdgeInsets.only(left: 0, top: 10),
        //           child: Text(
        //             ' / รายละเอียด',
        //             style: TextStyle(fontSize: 14, color: Colors.black),
        //           ),
        //         ),
        //         Container(
        //           padding: EdgeInsets.only(left: 120, top: 10),
        //           child: Text(
        //             'จำนวน',
        //             style: TextStyle(fontSize: 14),
        //           ),
        //         ),
        //       ],
        //     ),
        //     Container(
        //       padding: EdgeInsets.only(top: 10),
        //       child: Divider(
        //         indent: 40,
        //         color: Colors.black,
        //         endIndent: 40,
        //       ),
        //     ),
        //     Row(
        //       children: <Widget>[
        //         Container(
        //           padding: EdgeInsets.only(left: 40, top: 10),
        //           child: Text(
        //             "ราคารวม",
        //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //           ),
        //         ),
        //         Container(
        //           padding: EdgeInsets.only(left: 120, top: 10),
        //           child: Text(
        //             '${totalPrice}',
        //             style: TextStyle(fontSize: 14),
        //           ),
        //         ),
        //         Container(
        //             padding: EdgeInsets.only(left: 120, top: 10),
        //             child: Icon(
        //               Icons.attach_money,
        //               color: Colors.green,
        //               size: 30,
        //             )),
        //       ],
        //     ),
        //     Container(
        //       padding: EdgeInsets.only(top: 10),
        //       child: Divider(
        //         indent: 40,
        //         color: Colors.black,
        //         endIndent: 40,
        //       ),
        //     ),
        //   ],
        // ),
        );
  }

  Widget textdetailCustomer = new Row(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(left: 40, top: 10),
        child: Text(
          "รายละเอียดผู้สั่ง",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    ],
  );

  Widget textOrder = new Row(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(left: 40, top: 10),
        child: Text(
          "รายการอาหาร",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    ],
  );

  Widget texTimeProcess = new Row(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(left: 40, top: 20),
        child: Text(
          "เวลาทำอาหาร",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    ],
  );
  Widget headerImage = new Image.network(
    'https://sifu.unileversolutions.com/image/th-TH/recipe-topvisual/2/1260-709/%E0%B8%81%E0%B9%8B%E0%B8%A7%E0%B8%A2%E0%B9%80%E0%B8%95%E0%B8%B5%E0%B9%8B%E0%B8%A2%E0%B8%A7%E0%B8%95%E0%B9%89%E0%B8%A1%E0%B8%A2%E0%B8%B3%E0%B8%AA%E0%B8%B8%E0%B9%82%E0%B8%82%E0%B8%97%E0%B8%B1%E0%B8%A2-50357483.jpg',
    height: 160.0,
    width: 430.0,
    fit: BoxFit.cover,
  );
}

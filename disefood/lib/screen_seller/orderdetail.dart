import 'dart:async';

import 'package:disefood/component/sidemenu_seller.dart';

import 'package:flutter/material.dart';

class orderDetailSeller extends StatefulWidget {
  @override
  _orderDetailSellerState createState() => _orderDetailSellerState();
}

class _orderDetailSellerState extends State<orderDetailSeller> {
  var totalminute;
  var totalhour;
  var currenthours;
  var currentmin;
  int addTimeAmount = 5;
  Timer timer;
  bool isthisbuttonselected = true;
  @override
  void initState() {
    currenthours = DateTime.now().hour;
    // currenthours = 22;
    currentmin = DateTime.now().minute;
    // currentmin = 56;
    totalhour = currenthours;

    if (currentmin < 54) {
      totalminute = currentmin + 5;
    } else {
      totalhour = currenthours + 1;
      totalminute = (currentmin + 5) - 60;
    }
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

  void _getCurrentTime() {
    currenthours = DateTime.now().hour;
    currentmin = DateTime.now().minute;
  }

  void updateAddTimeStatus() {
    setState(
      () {
        if (totalminute >= 59) {
          totalminute = 0;
          if (totalhour >= 23) {
            totalhour = 0;
          } else {
            totalhour++;
          }
        } else {
          totalminute++;
        }
      },
    );
  }

  void updateMinusTimeStatus() {
    setState(
      () {
        if (addTimeAmount >= 5) {
          if (totalminute <= 0) {
            totalminute = 59;
            if (totalhour <= 0) {
              totalhour = 23;
            } else {
              totalhour--;
            }
          } else {
            totalminute--;
          }
        }
      },
    );
  }

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
                              child: Center(
                               
                              ),
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
                              child: Center(
                                
                              ),
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
                              child: Center(
                                
                              ),
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
                              child: Center(
                                
                              ),
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
      drawer: SideMenuSeller(),
      body: ListView(
        children: <Widget>[
          headerImage,
          textdetailCustomer,
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              indent: 40,
              color: Colors.black,
              endIndent: 40,
            ),
          ),
          //หมวดข้อมูลผู้สั่ง Order
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 40, top: 5, bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Nawapan Deeprasertkul",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: 40,
                    top: 10,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "0863882908",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Divider(
              indent: 40,
              color: Colors.black,
              endIndent: 40,
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 40, top: 10),
                child: Text(
                  "เวลาที่จะมารับ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Container(
                //หมวดเวลา
                padding: EdgeInsets.only(left: 130, top: 10),
                child: Text(
                  '$totalhour.$totalminute  นาฬิกา',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              indent: 40,
              color: Colors.black,
              endIndent: 40,
            ),
          ),
          textOrder,
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              indent: 40,
              color: Colors.black,
              endIndent: 40,
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 40, top: 10),
                child: Text(
                  "รายการอาหาร",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 0, top: 10),
                child: Text(
                  ' / ลายละเอียด',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 120, top: 10),
                child: Text(
                  'จำนวน',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              indent: 40,
              color: Colors.black,
              endIndent: 40,
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 40, top: 10),
                child: Text(
                  "ราคารวม",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 120, top: 10),
                child: Text(
                  '',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 120, top: 10),
                  child: Icon(
                    Icons.attach_money,
                    color: Colors.green,
                    size: 30,
                  )),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              indent: 40,
              color: Colors.black,
              endIndent: 40,
            ),
          ),
          texTimeProcess,
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              indent: 40,
              color: Colors.black,
              endIndent: 40,
            ),
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
                            fontWeight: FontWeight.bold, color: Colors.white),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                            fontWeight: FontWeight.bold, color: Colors.white),
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
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 100, top: 10),
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
        ],
      ),
    );
  }

  Widget textdetailCustomer = new Row(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(left: 40, top: 10),
        child: Text(
          "ลายละเอียดผู้สั่ง",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    ],
  );

  Widget textOrder = new Row(
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(left: 40, top: 30),
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
        padding: EdgeInsets.only(left: 40, top: 30),
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

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:disefood/model/orderList.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int userId;
  Logger logger = Logger();
  bool isLoading = false;
  String token = '';
  var mapData;
  List list = List();
  ApiProvider apiProvider = ApiProvider();
  Future<OrderList> _orderLists;
  @override
  void initState() {
    isLoading = false;
    _orderLists = orderByUserId();

    super.initState();
    Future.microtask(() {});
  }

  Future<OrderList> orderByUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getInt('user_id');
    token = sharedPreferences.getString('token');
    var orderLists = null;
    print('user_id: $userId');
    try {
      if (userId != null) {
        var response = await apiProvider.getHistoryById(token);
        print('status code: ${response.statusCode}');
        if (response.statusCode == 200) {
          var jsonString = response.body;
          var jsonMap = json.decode(jsonString);
          orderLists = OrderList.fromJson(jsonMap);
          // print('order list: ${orderLists.toString()}');
          // setState(() {
          //   isLoading = true;
          //   var list = json.decode(response.body)['data'];
          //   print('list order: $list \n');
          //   print('${list[0]['order_details']} \n');
          // });

        }
      }
    } catch (e) {
      return orderLists;
    }

    return orderLists;
  }

  Widget checkStatus(String status) {
    if (status == "success") {
      return Container(
        margin: EdgeInsets.only(top: 0.0),
        child: Text(
          'เสร็จสิ้น',
          style: TextStyle(
              color: const Color(0xff11AB17), fontSize: 18, fontFamily: 'Aleo'),
        ),
      );
    } else if (status == "not confirm") {
      return Container(
        margin: EdgeInsets.only(top: 0.0),
        child: Text(
          'ยังไม่ได้รับออเดอร์',
          style: TextStyle(
              color: const Color(0xffAB0B1F), fontSize: 18, fontFamily: 'Aleo'),
        ),
      );
    } else if (status == "in process") {
      return Container(
        margin: EdgeInsets.only(top: 00.0),
        child: Text(
          'กำลังทำ',
          style: TextStyle(
              color: const Color(0xffFF7C2C), fontSize: 18, fontFamily: 'Aleo'),
        ),
      );
    }
  }

  Widget getDate(String timePickup) {
    DateTime convertDate = DateTime.parse(timePickup);
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    String formattedDate = formatter.format(convertDate);
    print(formattedDate);
    return Text('$formattedDate',
        style: TextStyle(
          fontFamily: 'Aleo',
        ));
  }

  Widget getTime(String timePickup) {
    DateTime convertDate = DateTime.parse(timePickup);
    String formattedTime = DateFormat.Hm().format(convertDate);
    print(formattedTime);
    return Text('$formattedTime',
        style: TextStyle(
          fontFamily: 'Aleo',
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 40, top: 30),
                child: Text(
                  "ประวัติการสั่งอาหาร",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      fontFamily: 'Aleo'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Divider(
                  thickness: 1,
                  indent: 40,
                  color: Colors.black,
                  endIndent: 40,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: FutureBuilder<OrderList>(
                future: _orderLists,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.data.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data.data[index];
                          // var detail =
                          //     snapshot.data.data[index].orderDetails.length;
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10.0,
                                        bottom: 15.0),
                                    // height: 100,
                                    // width: 350,
                                    child: InkWell(
                                      onTap: () async {
                                        alertDialog(context, data.status);
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        margin: EdgeInsets.all(12),
                                        elevation: 10,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Text("ชื่อร้านอาหาร",
                                                        style: TextStyle(
                                                            fontFamily: 'Aleo',
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    SizedBox(height: 4),
                                                    getDate(data.timePickup),
                                                    getTime(data.timePickup),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                  padding: EdgeInsets.all(10),
                                                  child:
                                                      checkStatus(data.status)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }

  alertDialog(BuildContext context, String status) {
    print('alert');
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            contentPadding: EdgeInsets.only(top: 0.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    decoration: BoxDecoration(
                      color: Color(0xffFF7C2C),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0)),
                    ),
                    child: Text(
                      "Wait Order",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Aleo',
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Add Review",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        color: Color(0xffFF7C2C),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0)),
                      ),
                      child: status == "success"
                          ? FlatButton(
                              onPressed: () {},
                              child: Center(
                                child: Text('Review'),
                              ))
                          : Text(
                              "",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

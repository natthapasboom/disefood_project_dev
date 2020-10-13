import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:disefood/model/orderList.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

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
  var orderLists;
  ApiProvider apiProvider = ApiProvider();
  Future<OrderList> _orderLists;
  @override
  void initState() {
    isLoading = false;
    _orderLists = orderByUserId();
    logger.d(_orderLists);

    super.initState();
    Future.microtask(() {});
  }

  Future<OrderList> orderByUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getInt('user_id');
    token = sharedPreferences.getString('token');

    print('user_id: $userId');
    try {
      if (userId != null) {
        var response = await apiProvider.getHistoryById(token);
        print('response : ${response.body}');
        print('status code: ${response.statusCode}');
        if (response.statusCode == 200) {
          setState(() {
            var jsonString = response.body;
            var jsonMap = json.decode(jsonString);
            orderLists = OrderList.fromJson(jsonMap);
          });
        } else {
          print('${response.request}');
        }
      }
    } catch (e) {
      print('error : $e');
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
    } else if (status == "not confirmed") {
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

  Widget checkTextStatus(String status) {
    if (status == "success") {
      return Text(
        'เสร็จสิ้น',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Aleo', fontSize: 24, fontWeight: FontWeight.bold),
      );
    } else if (status == "not confirmed") {
      return Text(
        'ยังไม่ได้รับออเดอร์',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Aleo', fontSize: 24, fontWeight: FontWeight.bold),
      );
    } else if (status == "in process") {
      return Text(
        'กำลังทำ',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Aleo', fontSize: 24, fontWeight: FontWeight.bold),
      );
    }
  }

  Widget checkImageStatus(String status) {
    if (status == "not confirmed") {
      return Center(
        child: Image.asset('assets/images/baking.png'),
      );
    } else if (status == "in process") {
      return Center(
        child: Image.asset('assets/images/flambe.png'),
      );
    } else if (status == "success") {
      return Center(
        child: Image.asset('assets/images/bakery.png'),
      );
    }
  }

  Widget indicatorCheck(String status) {
    if (status == "not confirmed") {
      return Center(
          child: StepsIndicator(
        selectedStep: 0,
        nbSteps: 3,
        selectedStepColorOut: const Color(0xff11AB17),
        selectedStepColorIn: const Color(0xff11AB17),
        doneStepColor: const Color(0xff11AB17),
        doneLineColor: const Color(0xff11AB17),
        undoneLineColor: const Color(0xffAB0B1F),
        unselectedStepColorIn: const Color(0xffAB0B1F),
        unselectedStepColorOut: const Color(0xffAB0B1F),
        unselectedStepSize: 20,
        selectedStepSize: 20,
        doneStepSize: 20,
      ));
    } else if (status == "in process") {
      return Center(
          child: StepsIndicator(
        selectedStep: 1,
        nbSteps: 3,
        selectedStepColorOut: const Color(0xff11AB17),
        selectedStepColorIn: const Color(0xff11AB17),
        doneStepColor: const Color(0xff11AB17),
        doneLineColor: const Color(0xff11AB17),
        undoneLineColor: const Color(0xffAB0B1F),
        unselectedStepColorIn: const Color(0xffAB0B1F),
        unselectedStepColorOut: const Color(0xffAB0B1F),
        unselectedStepSize: 20,
        selectedStepSize: 20,
        doneStepSize: 20,
      ));
    } else if (status == "success") {
      return Center(
          child: StepsIndicator(
        selectedStep: 2,
        nbSteps: 3,
        selectedStepColorOut: const Color(0xff11AB17),
        selectedStepColorIn: const Color(0xff11AB17),
        doneStepColor: const Color(0xff11AB17),
        doneLineColor: const Color(0xff11AB17),
        undoneLineColor: const Color(0xffAB0B1F),
        unselectedStepColorIn: const Color(0xffAB0B1F),
        unselectedStepColorOut: const Color(0xffAB0B1F),
        unselectedStepSize: 20,
        selectedStepSize: 20,
        doneStepSize: 20,
      ));
    }
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
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.data.length,
                        itemBuilder: (context, index) {
                          var data = snapshot.data.data[index];
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
                                        bottom: 0.0),
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
                    return Container(
                      margin: EdgeInsets.only(top: 150),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                          valueColor:
                              AlwaysStoppedAnimation(const Color(0xffF6A911)),
                        ),
                      ),
                    );
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
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    child: checkTextStatus(status),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 20),
                    child: indicatorCheck(status),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: checkImageStatus(status),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 20),
                    child: Center(
                      child: Text(
                        'รายการอาหาร',
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  //   child: TextField(
                  //     decoration: InputDecoration(
                  //       hintText: "Add Review",
                  //       border: InputBorder.none,
                  //     ),
                  //     maxLines: 8,
                  //   ),
                  // ),
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
                                child: Text(
                                  'Review',
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
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

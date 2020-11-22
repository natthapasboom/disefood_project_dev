import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:disefood/model/topseller.dart';
import 'package:disefood/screen/home_customer.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopSellerPage extends StatefulWidget {
  @override
  _TopSellerPageState createState() => _TopSellerPageState();
}

class _TopSellerPageState extends State<TopSellerPage> {
  var topSellerList;
  Map jsonTopMap;
  Future<TopSeller> topSellerData;
  int totalPriceSummary = 0;
  @override
  void initState() {
    topSellerData = getTopSellerData();
    setState(() {});
    super.initState();
    Future.microtask(() {});
  }

  getColorTab(int index) {
    Color colorList;
    if (index == 0) {
      colorList = Color(0xffB80900);
    } else if (index == 1) {
      colorList = Color(0xffE01E00);
    } else if (index == 2) {
      colorList = Color(0xffF54100);
    } else {
      colorList = Color(0xffFF801F);
    }
    return colorList;
  }

  Future<TopSeller> getTopSellerData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int shopId = _prefs.getInt("shop_id");
    String token = _prefs.getString("token");
    String _url = 'http://54.151.194.224:8000/api/shop/owner/$shopId/dataSum';
    final response = await http.get(
      _url,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    if (response.statusCode == 200) {
      setState(() {
        var jsonString = response.body;
        jsonTopMap = json.decode(jsonString);
        totalPriceSummary = jsonTopMap["totalAmountShop"];
        topSellerList = TopSeller.fromJson(jsonTopMap);
      });
    } else {
      print('${response.statusCode}');
    }
    print(response.statusCode);
    return topSellerList;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Home();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(animation),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 400),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ListView(
          children: [
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.fromLTRB(30, 10, 20, 0),
              child: Text(
                "อันดับอาหารขายดี",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffB80900)),
              ),
            ),
            Divider(
              thickness: 6,
              endIndent: 20,
              color: Color(0xffB80900),
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: FutureBuilder(
                future: topSellerData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data.data.length == 0
                        ? Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 230),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.warning_rounded,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "ยังไม่มีรายการอาหารในขณะนี้",
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
                              return Container(
                                margin: EdgeInsets.only(right: 20, bottom: 10),
                                decoration: BoxDecoration(
                                  //สีแถบ
                                  color: getColorTab(index),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                width: double.maxFinite,
                                height: 60,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        "${index + 1}  ",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://disefood.s3-ap-southeast-1.amazonaws.com/" +
                                                '${data.cover_img}',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 5.0,
                                            valueColor: AlwaysStoppedAnimation(
                                                const Color(0xffF6A911)),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          height: 50,
                                          child: Center(
                                            child: Icon(
                                              Icons.fastfood,
                                              size: 25,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200,
                                      margin:
                                          EdgeInsets.only(right: 0, left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Text(
                                              "${data.name}",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Text(
                                                  "จำนวน ",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 3),
                                                  child: Text(
                                                    "${data.totalQuantity}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                Text(
                                                  " จาน",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 80,
                                      padding: EdgeInsets.only(right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${data.totalAmount}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            " บาท",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
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
                  width: 380,
                  height: 50,
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
                    child: totalPriceSummary != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ยอดขายรวมทั้งหมด :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                "$totalPriceSummary " + "บาท",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ยอดขายรวมทั้งหมด :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(
                                "0 " + "บาท",
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
      ),
    );
  }
}

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/foodByShopId.dart';
import 'package:disefood/model/foods_list.dart';
import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopSellerPage extends StatefulWidget {
  @override
  _TopSellerPageState createState() => _TopSellerPageState();
}

class _TopSellerPageState extends State<TopSellerPage> {
  int userId;
  ApiProvider apiProvider = ApiProvider();
  String email;
  bool isLoading = true;
  // @override
  // void initState() {
  //   super.initState();
  //   setState(() {
  //     shopName = widget.shopName;
  //     shopCoverImg = widget.shopCoverImg;
  //     shopSlot = widget.shopSlot;
  //     shopId = widget.shopId;
  //   });
  //   Future.microtask(() {
  //     findMenu();
  //   });
  // }

  // Future<Foods> findMenu() async {
  //   SharedPreferences preference = await SharedPreferences.getInstance();
  //   var response = await apiProvider.getFoodByShopId(shopId);
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     Map map = json.decode(response.body);
  //     FoodByShopId msg = FoodByShopId.fromJson(map);
  //     var data = msg.data.toJson();
  //     setState(() {
  //       isLoading = false;
  //       foods = msg.data.foods;
  //     });
  //   } else {
  //     logger.e("statuscode != 200");
  //   }
  // }

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
                  height: 100,
                ),
                Container(
                  width: 350,
                  height: 70,
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
                          "ยอดขายรวม",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          "9000 บาท",
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
        // drawer: SideMenuCustomer(
        //   firstName: nameUser,
        //   userId: userId,
        //   lastName: lastNameUser,
        //   coverImg: profileImg),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 20, 20),
                alignment: Alignment.centerRight,
                child: Container(
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text(
                      "Mock filter",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              //Listview Replacement //0xffE8CE00
              Container(
                margin: EdgeInsets.only(right: 20, bottom: 10),
                decoration: BoxDecoration(
                  //สีแถบ
                  color: const Color(0xffE8CE00),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                width: double.maxFinite,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "1",
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
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "https://i.pinimg.com/originals/98/fe/e9/98fee9bccce67719f9f356f73124ba75.png"),
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "Menu Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            child: Text("Qty",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      child: Text(
                        "900 บาท",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 20, bottom: 10),
                decoration: BoxDecoration(
                  //สีแถบ
                  color: const Color(0xff7C7C7C),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                width: double.maxFinite,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "2",
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
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "https://i.pinimg.com/originals/98/fe/e9/98fee9bccce67719f9f356f73124ba75.png"),
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text(
                              "Menu Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            child: Text("Qty",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      child: Text(
                        "900 บาท",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/foodByShopId.dart';
import 'package:disefood/model/foods_list.dart';
import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/screen/menu_order_detail_amount.dart';
import 'package:disefood/screen/order_items.dart';
import 'package:disefood/screen/view_order_page.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:disefood/services/getfoodmenupageservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedBackPage extends StatefulWidget {
  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
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
        appBar: AppBar(
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 265),
              child: new IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  return
                      // Navigator.pop(context);
                      Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
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
                  );
                },
              ),
            ),
            new IconButton(
              icon: new Icon(Icons.favorite),
              onPressed: () => debugPrint('asd'),
            ),
            new IconButton(
              icon: Icon(Icons.archive),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewOrder(),
                ),
              ),
            ),
          ],
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
                  color: Colors.grey,
                  child: Text(
                    "Mock filter",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              //Listview Replacement
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
                              "https://lh3.googleusercontent.com/proxy/z2o6VanYu7nMKGiiGtt0H8GcSqihPizOh-CFRP__LhBdB851xUPCbrJ5N0d-FbhDMd-XJxduC5igJ3xLV53JzjKfJdRfktcXY--IpzH4TQ-yU8y8GxON-eKstXxEf2drGbLM-rumH4dj"),
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
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
                      margin: EdgeInsets.only(right: 20),
                      child: Text(
                        "1000 บาท",
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
                              "https://lh3.googleusercontent.com/proxy/z2o6VanYu7nMKGiiGtt0H8GcSqihPizOh-CFRP__LhBdB851xUPCbrJ5N0d-FbhDMd-XJxduC5igJ3xLV53JzjKfJdRfktcXY--IpzH4TQ-yU8y8GxON-eKstXxEf2drGbLM-rumH4dj"),
                        ),
                      ),
                    ),
                    Container(
                      width: 180,
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

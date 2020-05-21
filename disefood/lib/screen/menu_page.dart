import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/foods_list.dart';
import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/screen/menu_order_detail_amount.dart';
import 'package:disefood/screen/order_items.dart';
import 'package:disefood/screen/view_order_page.dart';
import 'package:disefood/services/getfoodmenupageservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatefulWidget {
  MenuPage({
    Key key,
  }) : super(key: key);
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String shopName, shopImg, foodName, foodImg;
  int shopId, foodPrice, foodId;
  bool isAmountHasValue = false;
  String nameUser;
  String lastNameUser;
  String profileImg;
  int userId;
  var foodList;
  @override
  void initState() {
    Future.microtask(() {
      findUser();
      fetchShop();
      fetchFood();
    });
    super.initState();
  }

  Future<Null> fetchShop() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      shopName = preferences.getString('shop_name');
      shopId = preferences.getInt('shop_id');
      shopImg = preferences.getString('shop_img');
    });
  }

  Future<Null> fetchFood() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      foodId = preferences.getInt('food_id');
      foodName = preferences.getString('food_name');
      foodPrice = preferences.getInt('food_price');
      foodImg = preferences.getString('food_img');
    });
  }

  Future<Null> findUser() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preference.getString('first_name');
      userId = preference.getInt('user_id');
      lastNameUser = preference.getString('last_name');
      profileImg = preference.getString('profile_img');
    });
  }

  final logger = Logger();
  @override
  Widget build(BuildContext context) {
    print('shopId : $shopId');
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
                  height: 70,
                ),
                Container(
                  width: 320,
                  height: 40,
                  child: FloatingActionButton.extended(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.orange,
                    elevation: 4.0,
                    label: const Text(
                      'ยืนยันรายการอาหาร',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderItemPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
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
          child: FutureBuilder<List<FoodsList>>(
            future: fetchFoodsMenuPage(http.Client(), shopId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 300, bottom: 10),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.orange,
                  ),
                );
              } else {
                return Container(
                  child: Column(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl:
                            'https://disefood.s3-ap-southeast-1.amazonaws.com/$shopImg',
                        height: 200,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: -1,
                              blurRadius: 10,
                              offset:
                                  Offset(0, -8), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              padding: EdgeInsets.only(left: 45),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "0" + "$shopId",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    height: 65,
                                    child: VerticalDivider(
                                      color: Colors.orange,
                                      thickness: 3,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "$shopName",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("ShopTypeValue"),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                            size: 20,
                                          ),
                                          Text("RateStarsValue"),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 15,
                              color: Colors.grey[300],
                            ),

                            //
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(45, 20, 45, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "รายการอาหาร",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 45),
                                Text(
                                  "ราคา",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 20),
                              width: double.maxFinite,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Visibility(
                                            visible: false,
                                            child: SizedBox(
                                              width: 25,
                                              child: Text(
                                                "${snapshot.data[index].quantity}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.orange),
                                              ),
                                            ),
                                            replacement: SizedBox(
                                              width: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 140,
                                            child: Text(
                                                '${snapshot.data[index].name}'),
                                          ),
                                          SizedBox(
                                            width: 30,
                                            child: Text(
                                              '${snapshot.data[index].price}',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          IconButton(
                                            icon: new Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.orange,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderAmount(
                                                          foodList:
                                                              snapshot.data,
                                                          index: index),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: new Icon(
                                              Icons.favorite_border,
                                              color: Colors.orange,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Colors.black,
                                        height: 0,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

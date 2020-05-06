import 'dart:convert';

import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/screen/menu_order_detail_amount.dart';
import 'package:disefood/screen/order_items.dart';
import 'package:disefood/screen/view_order_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Foods>> fetchFoods(http.Client client) async {
  final response = await client.get('http://10.0.2.2:8000/api/foods/');

  return compute(parseFoods, response.body);
}

List<Foods> parseFoods(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Foods>((json) => Foods.fromJson(json)).toList();
}

class Foods {
  final int food_id;
  final int shop_id;
  final String name;
  final int price;
  final int status;

  Foods({this.food_id, this.shop_id, this.name, this.price, this.status});

  factory Foods.fromJson(Map<String, dynamic> json) {
    return Foods(
      food_id: json['food_id'] as int,
      shop_id: json['shop_id'] as int,
      name: json['name'] as String,
      price: json['price'] as int,
      status: json['status'] as int,
    );
  }
}

class FoodsList extends StatefulWidget {
  FoodsList({Key key, this.foods}) : super(key: key);
  final List<Foods> foods;
  @override
  _FoodsListState createState() => _FoodsListState(foods);
}

class _FoodsListState extends State<FoodsList> {
  List<Foods> foods;

  _FoodsListState(this.foods) {
    foods = this.foods;
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
      child: new Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.network(
                  "https://momofuku-assets.s3.amazonaws.com/uploads/sites/27/2018/08/2-2-1440x590.jpg",
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  padding: EdgeInsets.only(left: 45),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "00",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 65,
                        child: VerticalDivider(
                          color: Colors.orange,
                          thickness: 3,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "ร้านก๋วยเตี๋ยว",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text("อาหารเส้น"),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.star,
                                color: Colors.orangeAccent,
                                size: 20,
                              ),
                              Text("4.9"),
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
                Container(
                  padding: EdgeInsets.fromLTRB(45, 20, 45, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "รายการอาหาร",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                          itemCount: foods.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 175,
                                      child: Text('${foods[index].name}'),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: Text('${foods[index].price}'),
                                    ),
                                    SizedBox(
                                      width: 10,
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
                                                OrderAmount(),
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
          ),
        ),
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  
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
                return Navigator.push(
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
            onPressed: () => debugPrint('Favorite'),
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
      body: FutureBuilder<List<Foods>>(
        future: fetchFoods(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : FoodsList(foods: snapshot.data);
        },
      ),
    );
  }
}

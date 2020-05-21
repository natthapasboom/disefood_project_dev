
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:disefood/model/foods_list.dart';
import 'package:disefood/model/shops_list.dart';
import 'package:disefood/services/shopservice.dart';
import 'package:disefood/screen/login_customer_page.dart';
import 'package:disefood/screen/menu_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:disefood/component/sidemenu_customer.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  //  final UserProfile userData;
  //  Home({Key key, @required this.userData}):super(key:key);
  static const routeName = '/home_customer';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final logger = Logger();
  String shopImg;
  String nameUser;
  String lastNameUser;
  String profileImg;
  int userId;
  Future<Null> _routeMenuById(
      Widget mywidget, Shops shops, FoodsList foods) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('shop_id', shops.shopId);
    await preferences.setString('shop_name', shops.name);
    await preferences.setString('shop_img', shops.coverImage);
    await preferences.setInt('food_id', foods.foodId);
    await preferences.setString('food_name', foods.name);
    await preferences.setInt('food_price', foods.price);
    await preferences.setString('food_img', foods.coverImage);

    MaterialPageRoute route = MaterialPageRoute(builder: (context) => mywidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
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

  Future<List<Shops>> fetchShopAndFood(int shopId) async {
    String shopUrl = "http://10.0.2.2:8080/api/shops/+$shopId";

    try {
      Dio dio = Dio();
      Response response = await dio.get(shopUrl);
      print(response.statusCode);
      if (response.statusCode == 200) {
        String foodUrl = "http://10.0.2.2:8080/api/shop/foods/+$shopId";
        var result = Shops.fromJson(response.data);
        try {
          Dio dio = Dio();
          Response response = await dio.get(foodUrl);
          if (response.statusCode == 200) {
            var foodresultlogger = FoodsList.fromJson(response.data[0]);
            // var foodresult = FoodsList.fromJson(response.data[0]);
            // logger.d('${foodresult}');

            // var jsonFood = foodresult.toJson();
            _routeMenuById(MenuPage(), result, foodresultlogger);
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    findUser();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('shopId : $userId');
    return WillPopScope(
      onWillPop: () async => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return LoginPage();
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
        appBar: AppBar(
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.favorite),
              onPressed: () => debugPrint('favorites'),
            ),
            new IconButton(
              icon: Icon(Icons.archive),
              onPressed: () => debugPrint("archive"),
            ),
          ],
        ),
        drawer: SideMenuCustomer(
            firstName: nameUser,
            userId: userId,
            lastName: lastNameUser,
            coverImg: profileImg), //EndAppbar
        body: FutureBuilder<List<Shops>>(
            future: fetchShops(http.Client(), 0),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.orange,
                  )),
                );
              } else {
                return Column(
                  children: <Widget>[
                    headerSection,
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              fetchShopAndFood(snapshot.data[index].shopId);
                            },
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 5,
                              color: Colors.white70,
                              margin: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 40, right: 40),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CachedNetworkImage(
                                    imageUrl:
                                        'https://disefood.s3-ap-southeast-1.amazonaws.com/${snapshot.data[index].coverImage}',
                                    width: 380,
                                    height: 210,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  ListTile(
                                    title: Text(
                                      "${snapshot.data[index].name}",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                        ),
                                        Text("  4.2 Review(20 Review)")
                                      ],
                                    ),
                                  ),
                                ],
//          crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}

Widget headerSection = new Material(
  child: Container(
    padding: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 6.0,
        ),
      ],
    ),
    child: Column(
      children: <Widget>[
        new Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: new Column(
            children: [
              TextFormField(
                decoration: new InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  labelText: "โปรดใส่ชื่อร้านอาหารที่ต้องการค้นหา",
                  filled: true,
                  fillColor: Colors.white10,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  //fillColor: Colors.green
                ),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                "รายการร้านอาหาร",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);

import 'package:dio/dio.dart';
import 'package:disefood/model/shops_list.dart';
import 'package:disefood/model/user_profile.dart';
import 'package:disefood/services/shopservice.dart';
import 'package:disefood/screen/login_customer_page.dart';
import 'package:disefood/screen/menu_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:disefood/component/sidemenu_customer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  //  final UserProfile userData;
  //  Home({Key key, @required this.userData}):super(key:key);
  static const routeName = '/home_customer';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Null> _routeMenuById(Widget mywidget, Shops shops) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('shop_id', shops.shopId);
    await sharedPreferences.setString('shop_name', shops.name);
    await sharedPreferences.setString('shop_img', shops.coverImage);
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => mywidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Future<List<Shops>> fetchShop(int shopId) async {
    String url = "http://10.0.2.2:8080/api/shops/+$shopId";
    try {
      Dio dio = Dio();
      Response response = await dio.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("Complete");
        var result = Shops.fromJson(response.data);
        _routeMenuById(MenuPage(), result);
      }
    } catch (e) {
      print("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Home params = ModalRoute.of(context).settings.arguments;
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
        // drawer: _sideMenuCustomer(params.userData), //EndAppbar
        body: FutureBuilder<List<Shops>>(
            future: fetchShops(http.Client(), 0),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(child: CircularProgressIndicator()),
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
                              fetchShop(snapshot.data[index].shopId);
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
                                  Image.network(
                                      'https://disefood.s3-ap-southeast-1.amazonaws.com/${snapshot.data[index].coverImage}',
                                      width: 380,
                                      height: 210,
                                      fit: BoxFit.cover),
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

_sideMenuCustomer(UserProfile userData) {
  return SideMenuCustomer(
    userData: userData,
  );
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

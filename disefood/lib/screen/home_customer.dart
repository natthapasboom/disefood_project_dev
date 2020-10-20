import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/userById.dart';
import 'package:disefood/screen/history.dart';
import 'package:disefood/services/api_provider.dart';
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
  //sidebar att.
  String shopImg;
  String nameUser;
  String lastNameUser;
  String profileImg;
  //fetch ข้อมูล
  int userId;
  ApiProvider apiProvider = ApiProvider();
  String email;
  bool isLoading = true;
  List shops = [];
  //ตัวแปรส่งไปหน้าต่อไป
  int shopId;
  String shopName;
  int shopSlot;
  String shopCoverImg;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      findUser();
      getShops();
    });
  }

  Future<UserById> findUser() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    userId = preference.getInt('user_id');
    var response = await apiProvider.getUserById(userId);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map map = json.decode(response.body);
      UserById msg = UserById.fromJson(map);
      // var data = msg.data.toJson();
      userId = preference.getInt('user_id');
      setState(() {
        nameUser = msg.data.firstName;
        lastNameUser = msg.data.lastName;
        profileImg = msg.data.profileImg;
        email = msg.data.email;
      });
    } else {
      logger.e("statuscode != 200");
    }
  }

  Future getShops() async {
    String _url = 'http://54.151.194.224:8000/api/shop';
    final response = await http.get(_url);
    var body = response.body;

    setState(() {
      isLoading = false;
      shops = json.decode(body)['data'];

      // for(var item in shops){
      //   for (int i = 0; i < item.length; i++) {
      //     setState(() {
      //     var approved = item[i]['approved'];
      //     logger.d(approved);
      //   });
      //   }

      // }
      print(shops);
    });
  }

  // Future<List<Shops>> fetchShopAndFood(int shopId) async {
  //   String shopUrl = "http://10.0.2.2:8080/api/shops/+$shopId";

  //   try {
  //     Dio dio = Dio();
  //     Response response = await dio.get(shopUrl);
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       String foodUrl = "http://10.0.2.2:8080/api/shop/foods/+$shopId";
  //       var result = Shops.fromJson(response.data);
  //       try {
  //         Dio dio = Dio();
  //         Response response = await dio.get(foodUrl);
  //         if (response.statusCode == 200) {
  //           var foodresultlogger = FoodsList.fromJson(response.data[0]);
  //           // var foodresult = FoodsList.fromJson(response.data[0]);
  //           // logger.d('${foodresult}');

  //           // var jsonFood = foodresult.toJson();
  //           _routeMenuById(MenuPage(), result, foodresultlogger);
  //         }
  //       } catch (e) {
  //         print(e);
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
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
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.account_circle,
                  size: 30,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.favorite,
                size: 30,
              ),
              onPressed: () => debugPrint('favorites'),
            ),
            new IconButton(
              icon: Icon(
                Icons.history,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => History()));
              },
            ),
          ],
        ),
        drawer: SideMenuCustomer(
          firstName: nameUser,
          userId: userId,
          lastName: lastNameUser,
          coverImg: profileImg,
          email: email,
        ), //EndAppbar
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  valueColor: AlwaysStoppedAnimation(const Color(0xffF6A911)),
                ),
              )
            : Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: <Widget>[
                    headerSection,
                    Expanded(
                      child: ListView.builder(
                        itemCount: shops != null ? shops.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          var item = shops[index];
                          return item['approved'] == 1
                              ? InkWell(
                                  onTap: () {
                                    //card
                                    shopId = item['id'];
                                    shopName = item['name'];
                                    shopSlot = item['shop_slot'];
                                    shopCoverImg = item['cover_img'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MenuPage(
                                          shopId: shopId,
                                          shopName: shopName,
                                          shopSlot: shopSlot,
                                          shopCoverImg: shopCoverImg,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: 0,
                                        top: 20,
                                        left: 20,
                                        right: 20),
                                    child: Card(
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 5,
                                      color: Colors.white70,
                                      // margin: EdgeInsets.only(
                                      //     top: 8, bottom: 8, left: 40, right: 40),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          CachedNetworkImage(
                                            imageUrl:
                                                "https://disefood.s3-ap-southeast-1.amazonaws.com/" +
                                                    '${item['cover_img']}',
                                            width: 380,
                                            height: 140,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Center(
                                                    child: Container(
                                                        margin: EdgeInsets.only(
                                                            top: 50,
                                                            bottom: 35),
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 5.0,
                                                          valueColor:
                                                              AlwaysStoppedAnimation(
                                                                  const Color(
                                                                      0xffF6A911)),
                                                        ))),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              height: 140,
                                              width: 380,
                                              color: const Color(0xff7FC9C5),
                                              child: Center(
                                                child: Icon(
                                                  Icons.store,
                                                  size: 50,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            color: Colors.grey[50],
                                            child: ListTile(
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "0.${item['id']}",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Container(
                                                        height: 20,
                                                        child: VerticalDivider(
                                                          color: Colors.black38,
                                                          thickness: 3,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${item['name']}",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.star,
                                                        color: Colors.orange,
                                                      ),
                                                      Text("  4.2 Reviews"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              // subtitle: Row(
                                              //   children: <Widget>[
                                              //     Icon(
                                              //       Icons.star,
                                              //       color: Colors.orange,
                                              //     ),
                                              //     Text("  4.2 Review(20 Review)")
                                              //   ],
                                              // ),
                                            ),
                                          ),
                                        ],
//          crossAxisAlignment: CrossAxisAlignment.start,
                                      ),
                                    ),
                                  ),
                                )
                              : null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

Widget headerSection = new Material(
  child: Container(
    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 8.0,
        ),
      ],
    ),
    child: Column(
      children: <Widget>[
        Container(
          height: 40,
          margin: EdgeInsets.only(left: 2, right: 2),
          child: TextFormField(
            style: TextStyle(
                // backgroundColor: const Color(0xffC4C4C4)
                ),
            decoration: new InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              labelText: "โปรดใส่ชื่อร้านอาหารที่ต้องการค้นหา",
              filled: true,
              fillColor: Colors.white10,
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(8.0),
              ),
              //fillColor: Colors.green
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(8, 10, 0, 10),
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

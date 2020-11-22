import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/userById.dart';
import 'package:disefood/screen/favorite.dart';
import 'package:disefood/screen/history.dart';
import 'package:disefood/services/api_provider.dart';
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
  TextEditingController _textController = new TextEditingController();
  final logger = Logger();
  //sidebar att.
  double shopRating;
  String shopImg;
  String nameUser;
  String lastNameUser;
  String profileImg;
  bool _isFacebookAccount = false;
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
  bool isSearchActive = false;
  String facebookImg;
  bool checkMissingProfile;
  @override
  void initState() {
    // readSQLite();
    super.initState();
    Future.microtask(() {
      findUser();
      getShops();
    });
  }

  Future<Null> findUser() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    userId = preference.getInt('user_id');
    var response = await apiProvider.getUserById(userId);
    print("Connection Status Code: " + "${response.statusCode}");
    if (response.statusCode == 200) {
      Map map = json.decode(response.body);
      UserById msg = UserById.fromJson(map);
      // var data = msg.data.toJson();
      userId = preference.getInt('user_id');
      setState(() {
        checkMissingProfile = preference.getBool('missing_profile');
        logger.e('missing profile: $checkMissingProfile');
        facebookImg = preference.getString('facebook_img');
        // logger.e('facebook : $facebookImg ');
        nameUser = msg.data.firstName;
        lastNameUser = msg.data.lastName;
        profileImg = facebookImg == null ? msg.data.profileImg : facebookImg;
        // logger.e('image: $profileImg ');
        email = msg.data.email;
        if (checkMissingProfile == null) {
          setState(() {
            _isFacebookAccount = false;

            // logger.e('is face account : $_isFacebookAccount');
          });
        } else {
          _isFacebookAccount = true;
          // logger.e('is face account : $_isFacebookAccount');
        }
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
    });
  }

  Future onSearchBoxUsed(String text) async {
    String _url =
        'http://54.151.194.224:8000/api/shop/search?name=$text&approved=true';
    final response = await http.get(_url);
    var body = response.body;
    setState(() {
      shops = json.decode(body)['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onPressed: () {
                debugPrint('favorites');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavoritePage()));
              }),
          new IconButton(
            icon: Icon(
              Icons.history,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => History()));
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
        isFacebook: _isFacebookAccount,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 5.0,
                valueColor: AlwaysStoppedAnimation(const Color(0xffF6A911)),
              ),
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                setState(() {
                  isSearchActive = false;
                });
              },
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(0)),
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
                            child: TextField(
                              onTap: () {
                                setState(() {
                                  isSearchActive = true;
                                });
                              },
                              controller: _textController,
                              onChanged: (text) {
                                onSearchBoxUsed(text);
                              },
                              style: TextStyle(
                                  // backgroundColor: const Color(0xffC4C4C4)
                                  ),
                              decoration: new InputDecoration(
                                suffixIcon: Visibility(
                                  visible: isSearchActive,
                                  child: IconButton(
                                    onPressed: () {
                                      _textController.clear();
                                      getShops();
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                labelText: "ค้นหาร้านค้า",
                                filled: true,
                                fillColor: Colors.white10,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(8.0),
                                ),
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: shops != null ? shops.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          var item = shops[index];
                          return item['approved'] == 1
                              ? Container(
                                  margin: EdgeInsets.only(
                                      bottom: 10, top: 10, left: 30, right: 30),
                                  child: InkWell(
                                    onTap: () {
                                      //card
                                      shopId = item['id'];
                                      shopName = item['name'];
                                      shopSlot = item['shop_slot'];
                                      shopCoverImg = item['cover_img'];
                                      shopRating = item['averageRating'];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MenuPage(
                                            shopId: shopId,
                                            shopName: shopName,
                                            shopSlot: shopSlot,
                                            shopCoverImg: shopCoverImg,
                                            rating: shopRating,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      elevation: 5,
                                      color: Colors.white70,
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
                                                        "${item['id']}",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        child: VerticalDivider(
                                                          color: Colors.orange,
                                                          thickness: 3,
                                                        ),
                                                      ),
                                                      Text(
                                                        " ${item['name']}",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "รายการอาหาร",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.orange,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.orange,
                                                  ),
                                                  Text(
                                                      "  ${item['averageRating']} Review")
                                                ],
                                              ),
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

// Widget headerSection = new Material(
//   child: Container(
//     padding: EdgeInsets.only(left: 20, right: 20, top: 20),
//     height: 120,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
//       color: Colors.white,
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey,
//           offset: Offset(0.0, 1.0), //(x,y)
//           blurRadius: 8.0,
//         ),
//       ],
//     ),
//     child: Column(
//       children: <Widget>[
//         Container(
//           height: 40,
//           margin: EdgeInsets.only(left: 2, right: 2),
//           child: TextField(
//             style: TextStyle(
//                 // backgroundColor: const Color(0xffC4C4C4)
//                 ),
//             decoration: new InputDecoration(
//               prefixIcon: Icon(
//                 Icons.search,
//                 color: Colors.black,
//               ),
//               labelText: "ค้นหาร้านค้า",
//               filled: true,
//               fillColor: Colors.white10,
//               border: new OutlineInputBorder(
//                 borderRadius: new BorderRadius.circular(8.0),
//               ),
//             ),
//           ),
//         ),
//         Row(
//           children: <Widget>[
//             Container(
//               margin: EdgeInsets.fromLTRB(8, 10, 0, 10),
//               alignment: Alignment.topLeft,
//               child: Text(
//                 "รายการร้านอาหาร",
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   ),
// );

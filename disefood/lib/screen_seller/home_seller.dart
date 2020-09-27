import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/userById.dart';
import 'package:disefood/screen_seller/create_shop.dart';
import 'package:disefood/screen_seller/edit_shop.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:disefood/model/shop_id.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeSeller extends StatefulWidget {
  // final UserProfile userData;
  // HomeSeller({Key key, @required this.userData}):super(key:key);
  static const routeName = '/home_seller';

  @override
  _HomeSellerState createState() => _HomeSellerState();
}

class _HomeSellerState extends State<HomeSeller> {
  String shopImg;
  String nameUser;
  String lastNameUser;
  int userId;
  String profileImg;
  int shopId;
  String _shopName;
  int _shopId;
  String _shopImg;
  bool _isLoading = false;
  int _shopSlot;
  String email;
  int approve;
  String token;
  final logger = Logger();
  ApiProvider apiProvider = ApiProvider();
  @override
  void initState() {
    _isLoading = false;
    super.initState();
    Future.microtask(() {
      findUser();
      fetchShopFromStorage();
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
      var data = msg.data.toJson();
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

  Future<Null> fetchShopFromStorage() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    userId = preference.getInt('user_id');
    token = preference.getString('token');

    var response = await apiProvider.getShopId(token);
    logger.d(token);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map map = json.decode(response.body);
      ShopById msg = ShopById.fromJson(map);
      logger.d(msg.data);
      setState(() {
        _isLoading = true;
        _shopName = msg.data.name;
        _shopImg = msg.data.coverImg;
        _shopSlot = msg.data.shopSlot;
        _shopId = msg.data.id;
        approve = msg.data.approved;
        logger.d(msg.data.approved);
        preference.setInt('shop_id', msg.data.id);
        preference.setInt('approved', approve);
      });
    } else {
      setState(() {
        _isLoading = true;
        logger.d('shop not found');
        logger.d(_shopId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.d(_shopId);
    return new Scaffold(
      body: _isLoading == false
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 5.0,
                valueColor: AlwaysStoppedAnimation(const Color(0xffF6A911)),
              ),
            )
          : _shopId != null
              ? approve == 0
                  ? Center(
                      child: Text('รอแอดมินอนุมัติร้านค้า'
                      ,
                       style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20),),
                      
                    )
                  : ListView(
                      children: <Widget>[
                        headerImage(),
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                      padding:
                                          EdgeInsets.only(left: 25, right: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            "0" + "$_shopId",
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
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
                                              Container(
                                                padding: EdgeInsets.only(
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  "$_shopName",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                    bottom: 5,
                                                  ),
                                                  child: Text(
                                                    "ShopTypeValue",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[500]),
                                                  )),
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      right: 5,
                                                    ),
                                                    child: Icon(
                                                      Icons.star,
                                                      color:
                                                          Colors.orangeAccent,
                                                      size: 20,
                                                    ),
                                                  ),
                                                  Text("RateStarsValue"),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    //
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 13.0,
                          color: const Color(0xffC4C4C4),
                        ),
                        Container(
                          // child: _shopId == null
                          //     ? Center(
                          //         child: IconButton(
                          //           icon: Icon(
                          //             Icons.add_circle,
                          //             color: Colors.amber[900],
                          //           ),
                          //           onPressed: () {},
                          //         ),
                          //       )
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: 20, right: 30, top: 75),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.store,
                                    color: Colors.amber[800],
                                    size: 64,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditShop(
                                                  shopId: _shopId,
                                                  shopImg: _shopImg,
                                                  shopName: _shopName,
                                                  shopSlot: _shopSlot,
                                                ))).then((value) {
                                      setState(() {
                                        fetchShopFromStorage();

                                        print('Set state work');
                                      });
                                    });
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Center(
                                  child: Text(
                                    'แก้ไขร้านอาหาร',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
              : Center(
                  child: Column(
                    children: <Widget>[
                      // headerImage(),
                      Container(
                        margin: EdgeInsets.only(top: 250),
                        child: IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.amber[900],
                            size: 36,
                          ),
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateShop()))
                                .then((value) {
                              setState(() {
                                initState();
                              });
                            });
                          },
                        ),
                      ),
                      Center(
                        child: Text(
                          'เพิ่มร้านค้า',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }

  Widget headerImage() =>
      // _shopImg != null ?
      // Image.network(
      //   'https://disefood.s3-ap-southeast-1.amazonaws.com/'+'$_shopImg',
      //   height: 160.0,
      //   width: 430.0,
      //   fit: BoxFit.cover,
      // ):
      // ,
      Container(
        child: _shopImg == null
            ? Container(
                width: 430.0,
                height: 160.0,
                color: Colors.white60,
                child: Center(
                  child: Icon(
                    Icons.photo,
                    size: 36,
                    color: Colors.amber[900],
                  ),
                ),
              )
            : CachedNetworkImage(
                imageUrl:
                    'https://disefood.s3-ap-southeast-1.amazonaws.com/$_shopImg',
                width: 430.0,
                height: 160.0,
                fit: BoxFit.fill,
                placeholder: (context, url) => Center(
                    child: Container(
                        margin: EdgeInsets.only(top: 50, bottom: 35),
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                          valueColor:
                              AlwaysStoppedAnimation(const Color(0xffF6A911)),
                        ))),
                errorWidget: (context, url, error) => Container(
                  height: 121,
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
      );
}

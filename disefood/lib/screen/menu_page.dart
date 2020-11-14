import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/config/app_config.dart';
import 'package:disefood/model/foodByShopId.dart';
import 'package:disefood/model/foods_list.dart';
import 'package:disefood/model/userById.dart';
import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/screen/menu_amount_select.dart';
import 'package:disefood/screen/order_cart.dart';
import 'package:disefood/screen/view_order_page.dart';
import 'package:disefood/screen_seller/editmenu.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:disefood/services/getfoodmenupageservice.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customer_dialog/order_amount_dialog.dart';

class MenuPage extends StatefulWidget {
  final int shopId;
  final String shopName;
  final int shopSlot;
  final String shopCoverImg;
  const MenuPage(
      {Key key,
      @required this.shopId,
      @required this.shopName,
      @required this.shopSlot,
      @required this.shopCoverImg})
      : super(key: key);
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  Logger logger = Logger();
  int shopId;
  String shopName;
  int shopSlot;
  String shopCoverImg;
  TextEditingController reviewController = TextEditingController();
  ApiProvider apiProvider = ApiProvider();
  bool isTrue;
  bool isFalse;
  bool isLoading = true;
  List foods = [];
  List fav = [];
  double rating;
  int userId;
  bool isFav = false;
  @override
  void initState() {
    super.initState();

    setState(() {
      rating = 0;
      shopName = widget.shopName;
      shopCoverImg = widget.shopCoverImg;
      shopSlot = widget.shopSlot;
      shopId = widget.shopId;
    });
    Future.microtask(() async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      isTrue = sharedPreferences.getBool('isTrue');
      isFalse = sharedPreferences.getBool('isFalse');
      logger.d('isTrue or False : $isTrue , $isFalse');
      getFavoriteByMe();
      findMenu();
      // findUser();
    });
  }

  _ackAlert(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'มีบางอย่างผิดพลาด',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('โปรดกรอกรีวิว'),
          actions: [
            FlatButton(
              textColor: const Color(0xffFF7C2C),
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Future<UserById> findUser() async {
  //   SharedPreferences preference = await SharedPreferences.getInstance();
  //   userId = preference.getInt('user_id');
  // }

  Future findMenu() async {
    // SharedPreferences preference = await SharedPreferences.getInstance();
    var response = await apiProvider.getFoodByShopId(shopId);
    print(response.statusCode);
    var body = response.body;
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
        foods = json.decode(body)['data'];
        // logger.d(foods);
      });
    } else {
      logger.e("statuscode != 200");
    }
  }

  Future getFavoriteByMe() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    var response = await apiProvider.getFavoriteByMe(token);
    if (response.statusCode == 200) {
      setState(() {
        fav = json.decode(response.body)['data'];
        logger.d('fav response : ${fav.toList()}');
      });
    } else {
      logger.e('status : ${response.statusCode}');
    }
  }

  Future postFavorite() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    var response = await apiProvider.postFavorite(shopId, token);
    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                    height: 250.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            // Container(height: 150.0),
                            // Container(
                            //   height: 100.0,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.only(
                            //         topLeft: Radius.circular(10.0),
                            //         topRight: Radius.circular(10.0),
                            //       ),
                            //       color: Colors.red),
                            // ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 40),
                                height: 90.0,
                                width: 90.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/success.png'),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                top: 20, left: 10, right: 10, bottom: 0),
                            child: Center(
                              child: Text(
                                'เพิ่มรายการโปรดสำเร็จ',
                                style: TextStyle(
                                  fontFamily: 'Aleo-Bold',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ],
                    )));
          }).then((value) => Navigator.pop(context));
    }
  }

  Future deleteFavorite() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    var response = await apiProvider.deleteFavorite(shopId, token);
    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                    height: 250.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            // Container(height: 150.0),
                            // Container(
                            //   height: 100.0,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.only(
                            //         topLeft: Radius.circular(10.0),
                            //         topRight: Radius.circular(10.0),
                            //       ),
                            //       color: Colors.red),
                            // ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 40),
                                height: 90.0,
                                width: 90.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/red-cross.png'),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                top: 20, left: 10, right: 10, bottom: 0),
                            child: Center(
                              child: Text(
                                'ลบรายการโปรดสำเร็จ',
                                style: TextStyle(
                                  fontFamily: 'Aleo-Bold',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ],
                    )));
          }).then((value) => Navigator.pop(context));
    }
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
        resizeToAvoidBottomInset: true,
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
                  width: 370,
                  height: 40,
                  child: FloatingActionButton.extended(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.orange,
                    elevation: 4.0,
                    label: Row(
                      children: [
                        Icon(Icons.shopping_basket),
                        Text(
                          'ไปยังตะกร้า',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderItemPage(
                            shopId: shopId,
                            shopName: shopName,
                            shopSlot: shopSlot,
                            shopCoverImg: shopCoverImg,
                          ),
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
            // Container(
            //   margin: EdgeInsets.only(right: 265),
            //   child: new IconButton(
            //     icon: Icon(Icons.arrow_back),
            //     onPressed: () {
            //       return
            //           // Navigator.pop(context);
            //           Navigator.push(
            //         context,
            //         PageRouteBuilder(
            //           pageBuilder: (BuildContext context,
            //               Animation<double> animation,
            //               Animation<double> secondaryAnimation) {
            //             return Home();
            //           },
            //           transitionsBuilder: (BuildContext context,
            //               Animation<double> animation,
            //               Animation<double> secondaryAnimation,
            //               Widget child) {
            //             return FadeTransition(
            //               opacity: Tween<double>(
            //                 begin: 0,
            //                 end: 1,
            //               ).animate(animation),
            //               child: child,
            //             );
            //           },
            //           transitionDuration: Duration(milliseconds: 400),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // new IconButton(
            //   icon: new Icon(Icons.favorite),
            //   onPressed: () => debugPrint('asd'),
            // ),
            // new IconButton(
            //   icon: Icon(Icons.archive),
            //   onPressed: () => Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => ViewOrder(),
            //     ),
            //   ),
            // ),
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  valueColor: AlwaysStoppedAnimation(const Color(0xffF6A911)),
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl:
                            'https://disefood.s3-ap-southeast-1.amazonaws.com/$shopCoverImg',
                        height: 140,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                            child: Container(
                                margin: EdgeInsets.only(top: 50, bottom: 35),
                                child: CircularProgressIndicator(
                                  strokeWidth: 5.0,
                                  valueColor: AlwaysStoppedAnimation(
                                      const Color(0xffF6A911)),
                                ))),
                        errorWidget: (context, url, error) => Container(
                          height: 140,
                          width: double.maxFinite,
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
                                    height: 40,
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
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                            size: 20,
                                          ),
                                          Text("4.2 Reviews"),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 70),
                                    child: RaisedButton(
                                        child: Center(
                                          child: Text(
                                            'review',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Aleo',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                        ),
                                        color: const Color(0xffF6A911),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color:
                                                    const Color(0xffF6A911))),
                                        onPressed: () {
                                          ListView(
                                            reverse: true,
                                            children: [
                                              alertDialog(context, shopName,
                                                  shopCoverImg, shopId),
                                            ],
                                          );
                                        }),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 0),
                                    child: IconButton(
                                      icon: !isFav && isTrue == null
                                          ? Icon(
                                              Icons.favorite_border,
                                              color: Color(0xffFF7C2C),
                                              size: 24,
                                            )
                                          : Icon(
                                              Icons.favorite,
                                              color: Color(0xffFF7C2C),
                                              size: 24,
                                            ),
                                      onPressed: () async {
                                        SharedPreferences sharedPreferences =
                                            await SharedPreferences
                                                .getInstance();
                                        setState(() {
                                          isFav = !isFav;
                                          if (!isFav) {
                                            deleteFavorite();
                                            logger.d(isFav);
                                            sharedPreferences.setBool(
                                                'isFalse', isFav);
                                            sharedPreferences.remove('isTrue');
                                          } else if (isFav) {
                                            postFavorite();
                                            logger.d(isFav);

                                            sharedPreferences.setBool(
                                                'isTrue', isFav);
                                            sharedPreferences.remove('isFalse');
                                          }
                                          // if (isFav) {
                                          //   sharedPreferences.setBool(
                                          //       'isFalse', isFav);
                                          //   sharedPreferences.remove('isTrue');
                                          //   isFav = sharedPreferences
                                          //       .getBool('isFalse');
                                          // } else if (!isFav) {
                                          //   sharedPreferences.setBool(
                                          //       'isTrue', isFav);
                                          //   sharedPreferences.remove('isFalse');
                                          //   isFav = sharedPreferences
                                          //       .getBool('isTrue');
                                          // }
                                        });
                                      },
                                    ),
                                  ),
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
                        padding: EdgeInsets.fromLTRB(45, 10, 45, 0),
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
                                SizedBox(width: 65),
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
                                itemCount: foods != null ? foods.length : 0,
                                itemBuilder: (BuildContext context, int index) {
                                  var item = foods[index];
                                  // logger.d(foods);
                                  return Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          // Visibility(
                                          //   visible: false,
                                          //   child: SizedBox(
                                          //     width: 25,
                                          //     child: Text(
                                          //       "0",
                                          //       style: TextStyle(
                                          //           fontWeight: FontWeight.bold,
                                          //           color: Colors.orange),
                                          //     ),
                                          //   ),
                                          //   replacement: SizedBox(
                                          //     width: 20,
                                          //   ),
                                          // ),
                                          SizedBox(
                                            width: 190,
                                            child: Text('${item['name']}'),
                                          ),
                                          SizedBox(
                                            width: 30,
                                            child: Text(
                                              '${item['price']}',
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
                                              int foodId = item['id'];
                                              String foodname = item['name'];
                                              String foodImg =
                                                  item['cover_img'];
                                              int foodPrice = item["price"];
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    OrderAmountDialog(
                                                  shopId: shopId,
                                                  foodId: foodId,
                                                  foodName: foodname,
                                                  foodImg: foodImg,
                                                  foodPrice: foodPrice,
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

  alertDialog(
    BuildContext context,
    String name,
    String shopImg,
    int shopId,
  ) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    String token = preference.getString('token');
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    print('alert');
    showDialog(
        context: context,
        builder: (context) {
          return ListView(
            reverse: true,
            children: [
              SingleChildScrollView(
                // child: Padding(
                // padding: EdgeInsets.only(
                //     bottom: MediaQuery.of(context).viewInsets.bottom),
                child: StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    contentPadding: EdgeInsets.only(top: 0.0),
                    content: Container(
                      width: 342.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                            decoration: BoxDecoration(
                              color: Color(0xffFF7C2C),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 120),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Review",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Aleo',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                    // textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(left: 60),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 36,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 20,
                            ),
                            child: Center(
                              child: Text(
                                name,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15, bottom: 20),
                            child: shopImg == null
                                ? CircleAvatar(
                                    backgroundColor: Colors.orangeAccent,
                                    radius: 75,
                                    child: Icon(
                                      Icons.image,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                  )
                                : Center(
                                    child: CircleAvatar(
                                      backgroundColor: const Color(0xffF6A911),
                                      radius: 60,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                            imageUrl:
                                                '${AppConfig.image}$shopImg',
                                            height: 300,
                                            width: 500,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Center(
                                                    child: Center(
                                                  child: Container(
                                                      child:
                                                          CircularProgressIndicator(
                                                    strokeWidth: 5.0,
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Colors.white),
                                                  )),
                                                )),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                                      Icons.error,
                                                      color: Colors.white,
                                                      size: 48,
                                                    )),
                                      ),
                                    ),
                                  ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            child: Center(
                              child: RatingBar(
                                initialRating: rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  this.rating = rating;

                                  print(rating);
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                bottom: 30, left: 30, right: 30),
                            child: Center(
                              child: Material(
                                elevation: 5.0,
                                child: Container(
                                  padding: EdgeInsets.only(
                                    top: 20,
                                    left: 20,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return _ackAlert(context);
                                        }
                                      },
                                      autofocus: false,
                                      controller: reviewController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        hintText: "Add Review",
                                        border: InputBorder.none,
                                      ),
                                      maxLines: 4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                                padding:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                decoration: BoxDecoration(
                                  color: Color(0xffFF7C2C),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(25.0),
                                      bottomRight: Radius.circular(25.0)),
                                ),
                                child: FlatButton(
                                    onPressed: () async {
                                      String review =
                                          reviewController.text.trim();
                                      int rating1 = this.rating.toInt();
                                      logger.d('body : $review  $rating1 ');
                                      if (_formKey.currentState.validate()) {
                                        String url =
                                            'http://54.151.194.224:8000/api/feedback/me/shop/$shopId';
                                        var formData = FormData.fromMap({
                                          'comment': review,
                                          'rating': rating1,
                                        });
                                        // logger.d(formData.fields);
                                        var response = await Dio().post(url,
                                            data: formData,
                                            options: Options(
                                                headers: {
                                                  'Authorization':
                                                      'Bearer $token',
                                                },
                                                followRedirects: false,
                                                validateStatus: (status) {
                                                  return status < 500;
                                                }));
                                        logger.d(
                                            'review status: ${response.statusCode}');
                                        if (response.statusCode == 200) {
                                          showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    Future.delayed(
                                                        Duration(seconds: 3),
                                                        () {
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    });
                                                    return Dialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        child: Container(
                                                            height: 250.0,
                                                            width: 300.0,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0)),
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Stack(
                                                                  children: <
                                                                      Widget>[
                                                                    // Container(height: 150.0),
                                                                    // Container(
                                                                    //   height: 100.0,
                                                                    //   decoration: BoxDecoration(
                                                                    //       borderRadius: BorderRadius.only(
                                                                    //         topLeft: Radius.circular(10.0),
                                                                    //         topRight: Radius.circular(10.0),
                                                                    //       ),
                                                                    //       color: Colors.red),
                                                                    // ),
                                                                    Center(
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            top:
                                                                                40),
                                                                        height:
                                                                            90.0,
                                                                        width:
                                                                            90.0,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(50.0),
                                                                            image: DecorationImage(
                                                                              image: AssetImage('assets/images/success.png'),
                                                                              fit: BoxFit.cover,
                                                                            )),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Container(
                                                                    margin: EdgeInsets.only(
                                                                        top: 20,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            0),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'รีวิวสำเร็จ',
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Aleo-Bold',
                                                                          fontSize:
                                                                              24.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    )),
                                                              ],
                                                            )));
                                                  })
                                              .then((value) =>
                                                  Navigator.pop(context));
                                        }
                                      } else {}
                                    },
                                    child: Center(
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ))),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        });
  }
}

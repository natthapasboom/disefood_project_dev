import 'dart:async';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:dio/dio.dart';
import 'package:disefood/model/cart.dart';
import 'package:disefood/screen/customer_dialog/edit_order_amount_dialog.dart';
import 'package:disefood/screen/customer_utilities/sqlite_helper.dart';
import 'package:disefood/screen/menu_page.dart';
import 'package:disefood/screen/view_order_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class OrderItemPage extends StatefulWidget {
  final int shopId;
  final String shopName;
  final int shopSlot;
  final String shopCoverImg;
  final VoidCallback findMenu;
  const OrderItemPage(
      {Key key,
      @required this.shopId,
      @required this.shopName,
      @required this.shopSlot,
      @required this.findMenu,
      @required this.shopCoverImg})
      : super(key: key);
  @override
  _OrderItemPageState createState() => _OrderItemPageState();
}

class _OrderItemPageState extends State<OrderItemPage> {
  VoidCallback findMenu;
  int shopId;
  String shopName;
  int shopSlot;
  String shopCoverImg;
  List<CartModel> cartModels = List();
  int totalPrice;
  bool isCartNotEmpty = false;
  TimeOfDay _time =
      TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 5)));
  String timeShow = "ยังไม่ได้เลือกเวลา";
  DateTime timeValue;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

  @override
  void initState() {
    super.initState();
    readSQLite();
    setState(() {
      findMenu = widget.findMenu;
      shopId = widget.shopId;
      shopName = widget.shopName;
      shopSlot = widget.shopSlot;
      shopCoverImg = widget.shopCoverImg;
    });
  }

  void checkEmptyCart() {
    if (cartModels.length == 0) {
      setState(() {
        isCartNotEmpty = false;
      });
    } else {
      setState(() {
        isCartNotEmpty = true;
      });
    }
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFromSQLite();
    totalPrice = 0;
    for (var model in object) {
      setState(() {
        cartModels = object;
        totalPrice = totalPrice + model.foodSumPrice;
      });
    }
    checkEmptyCart();
  }

  dynamic myTimeEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  Future<Null> sendOrderAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("All Items in Cart : " + "${cartModels.length}");
    String url = 'http://54.151.194.224:8000/api/order/shop/$shopId';
    String token = preferences.getString('token');

    List<Map<String, dynamic>> formOrder = List<Map<String, dynamic>>();

    for (var i = 0; i < cartModels.length; i++) {
      Map<String, dynamic> newOrder = {
        "foodId": cartModels[i].foodId,
        "quantity": cartModels[i].foodQuantity,
        "description": cartModels[i].foodDescription,
      };
      formOrder.add(newOrder);
    }

    FormData formData = FormData.fromMap({
      "newOrder": formOrder,
      "time_pickup": timeValue,
    });

    var response = await Dio().post(
      url,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
        followRedirects: false,
        validateStatus: (status) {
          return status < 500;
        },
      ),
    );
    if (response.statusCode == 200) {
      print("Data : " + "${formData.fields}");
      print(
          "=====Send API Completed Status : " + "${response.statusCode}=====");
      deleteAllFoodInCart();
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
    } else {
      showToast("มีข้อผิดพลาดเกิดขึ้น โปรดลองใหม่ภายหลัง Status : " +
          "${response.statusCode}");
    }
  }

  Future<Null> deleteAllFoodInCart() async {
    await SQLiteHelper().deleteAllData();
  }

  void showToast(String msg) {
    Toast.show(
      msg,
      context,
      textColor: Colors.white,
    );
  }

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
        child: Visibility(
          visible: isCartNotEmpty,
          child: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Container(
              padding: EdgeInsets.only(top: 10),
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "ราคารวม",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text("$totalPrice บาท",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 5,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
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
                          Text(
                            'ยืนยัน',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        if (timeValue != null) {
                          print(
                              "Order Data is Complete => Sending Order API...");
                          sendOrderAPI();
                        } else {
                          showToast("โปรดเลือกเวลารับอาหาร");
                          print(
                              "Order Data is not Complete => Time is not Selected.");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
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
                if (shopId != int.parse(cartModels[0].shopId)) {
                  findMenu();
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return MenuPage(
                          shopId: shopId,
                          shopName: shopName,
                          shopSlot: shopSlot,
                          shopCoverImg: shopCoverImg,
                        );
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
                } else {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
                        return MenuPage(
                          shopId: shopId,
                          shopName: shopName,
                          shopSlot: shopSlot,
                          shopCoverImg: shopCoverImg,
                        );
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
                }
              },
            ),
          ),
          new IconButton(
            icon: new Icon(Icons.favorite),
            onPressed: () {},
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
      body: cartModels.length == 0
          ? Container(
              margin: EdgeInsets.only(top: 200),
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 70,
                    color: Colors.grey[700],
                  ),
                  Text(
                    "ไม่มีรายการในตะกร้าสินค้า",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700]),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 16, 5, 16),
                          child: Text(
                            "ตะกร้าของคุณ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Icon(Icons.shopping_basket),
                      ],
                    ),
                    Container(
                      height: 45,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 20),
                            width: double.maxFinite,
                            color: Colors.grey[400],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "สรุปรายการอาหาร",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Container(
                                  height: 45,
                                  padding: EdgeInsets.only(right: 15, left: 15),
                                  decoration: new BoxDecoration(
                                    color: Colors.orange,
                                    // shape: BoxShape.rectangle,
                                    // borderRadius: BorderRadius.all(
                                    //   Radius.circular(4.0),
                                    // ),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "ร้าน : ${cartModels[0].shopName}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                        // decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      margin: EdgeInsets.only(left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 190,
                            child: Text(
                              "ชื่ออาหาร",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: 50,
                            child: Text(
                              "จำนวน",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 0),
                            width: 45,
                            child: Text(
                              "ราคา",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            width: 45,
                            child: Text(
                              "แก้ไข",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 0,
                      // indent: 30,
                      // endIndent: 30,
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: cartModels.length,
                        itemBuilder: (BuildContext context, int index) {
                          var items = cartModels[index];
                          return Container(
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 25),
                                  height: 40,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: 220,
                                        child: Text(
                                          "${items.foodName}",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 25,
                                        child: Text(
                                          "${items.foodQuantity}",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 35,
                                        child: Text(
                                          "${items.foodSumPrice}",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                EditOrderAmountDialog(
                                              shopId: int.parse(items.shopId),
                                              foodId: items.foodId,
                                              foodName: items.foodName,
                                              foodDescription:
                                                  items.foodDescription,
                                              foodImg: items.foodImg,
                                              foodPrice: items.foodPrice,
                                              shopName: shopName,
                                              shopSlot: shopSlot,
                                              shopCoverImg: shopCoverImg,
                                              readSQLite: readSQLite,
                                              foodQuantity: items.foodQuantity,
                                            ),
                                          ).then((value) {
                                            setState(() {});
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 50,
                                          child: Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 0,
                                  // indent: 30,
                                  // endIndent: 30,
                                  thickness: 1,
                                  color: Colors.grey[300],
                                ),
                              ],
                            ),
                          );
                        }),
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                          width: double.maxFinite,
                          color: Colors.grey[400],
                          child: Text(
                            "เลือกเวลารับอาหาร",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Container(
                                width: 90,
                                child: Text(
                                  "คำแนะนำ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                ": โปรดระบุเวลาอย่างน้อย 5 นาที เพื่อให้แม่ค้า",
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 97,
                              ),
                              Container(
                                child: Text(
                                    "สามารถจัดเตรียมอาหารได้ทันตามกำหนดเวลา"),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 90,
                                child: Text(
                                  "เวลา เปิด-ปิด",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                ": 9:00 น. - 15.59 น.",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          Navigator.of(context).push(
                            showPicker(
                              is24HrFormat: true,
                              context: context, okText: "ตกลง",
                              cancelText: "ยกเลิก",
                              accentColor: Colors.orange,
                              value: _time,
                              onChange: onTimeChanged,
                              // Optional onChange to receive value as DateTime
                              onChangeDateTime: (DateTime timeSelected) {
                                //เวลาเปิดปิด
                                if (timeSelected.hour > 8 &&
                                    timeSelected.hour < 16) {
                                  if (timeSelected.minute == 0) {
                                    timeShow = timeSelected.hour.toString() +
                                        ":" +
                                        timeSelected.minute.toString() +
                                        "0 น.";
                                    timeValue = timeSelected;
                                    print("Time Selected :" + "$timeSelected");
                                  } else if (timeSelected.minute > 0 &&
                                      timeSelected.minute < 10) {
                                    timeShow = timeSelected.hour.toString() +
                                        ":0" +
                                        timeSelected.minute.toString() +
                                        " น.";
                                    timeValue = timeSelected;
                                    print("Time Selected :" + "$timeSelected");
                                  } else {
                                    timeShow = timeSelected.hour.toString() +
                                        ":" +
                                        timeSelected.minute.toString() +
                                        " น.";
                                    timeValue = timeSelected;
                                    print("Time Selected :" + "$timeSelected");
                                  }
                                } else {
                                  timeShow = "เวลาไม่ถูกต้อง";
                                }
                              },
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Icon(
                                      Icons.access_time,
                                      size: 22.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "$timeShow",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "เปลี่ยนเวลา",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

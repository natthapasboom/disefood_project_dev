import 'dart:async';
import 'package:provider/provider.dart';
import 'package:disefood/model/cart.dart';
import 'package:disefood/screen/customer_dialog/edit_order_amount_dialog.dart';
import 'package:disefood/screen/customer_utilities/sqlite_helper.dart';
import 'package:disefood/screen/menu_page.dart';
import 'package:disefood/screen/view_order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class OrderItemPage extends StatefulWidget {
  final int shopId;
  final String shopName;
  final int shopSlot;
  final String shopCoverImg;
  const OrderItemPage(
      {Key key,
      @required this.shopId,
      @required this.shopName,
      @required this.shopSlot,
      @required this.shopCoverImg})
      : super(key: key);
  @override
  _OrderItemPageState createState() => _OrderItemPageState();
}

class _OrderItemPageState extends State<OrderItemPage> {
  int shopId;
  String shopName;
  int shopSlot;
  String shopCoverImg;
  String _time = "  ยังไม่ได้เลือกเวลา";
  List<CartModel> cartModels = List();
  int totalPrice;
  bool isCartNotEmpty = false;

  @override
  void initState() {
    super.initState();
    readSQLite();
    setState(() {
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
                      onPressed: () {},
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
              },
            ),
          ),
          new IconButton(
            icon: new Icon(Icons.favorite),
            onPressed: () {
              readSQLite();
            },
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
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          width: double.maxFinite,
                          color: Colors.grey[400],
                          child: Text(
                            "สรุปรายการอาหาร",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      margin: EdgeInsets.only(left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 200,
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
                            margin: EdgeInsets.only(right: 5),
                            width: 40,
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
                            width: 50,
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
                                        width: 30,
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
                                        width: 30,
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
                                              foodImg: items.foodImg,
                                              foodPrice: items.foodPrice,
                                              shopName: shopName,
                                              shopSlot: shopSlot,
                                              shopCoverImg: shopCoverImg,
                                              readSQLite: readSQLite,
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
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                          Text(
                              "คำแนะนำ : โปรดระบุเวลาอย่างน้อย 5 นาที เพื่อให้แม่ค้าสามารถ"),
                          Text(
                              "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\tจัดเตรียมอาหารได้ทันตามกำหนดเวลา"),
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
                          DatePicker.showTimePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true, onConfirm: (time) {
                            if (time.hour >= 8 && time.hour <= 24) {
                              if (time.hour > DateTime.now().hour) {
                                if (time.hour != 24) {
                                  _time =
                                      '  ${time.hour} : ${time.minute} : ${time.second}';
                                  setState(() {});
                                } else {
                                  if (time.minute > 30) {
                                    _time =
                                        "  เวลาที่ระบุไม่ถูกต้อง"; //เกิน 15.30 min
                                    setState(() {});
                                  } else if (time.minute == 30) {
                                    if (time.second > 0) {
                                      _time =
                                          "  เวลาที่ระบุไม่ถูกต้อง"; //เกิน 15.30 sec
                                      setState(() {});
                                    } else {
                                      _time =
                                          '  ${time.hour} : ${time.minute} : ${time.second}';
                                      setState(() {});
                                    }
                                  } else {
                                    _time =
                                        '  ${time.hour} : ${time.minute} : ${time.second}';
                                    setState(() {});
                                  }
                                }
                              } else if (time.hour == DateTime.now().hour) {
                                if (time.minute >= DateTime.now().minute + 5) {
                                  if (time.hour != 15) {
                                    _time =
                                        '  ${time.hour} : ${time.minute} : ${time.second}';
                                    setState(() {});
                                  } else {
                                    if (time.minute > 30) {
                                      _time =
                                          "  เวลาที่ระบุไม่ถูกต้อง"; // เกิน 15.30 min
                                      setState(() {});
                                    } else if (time.minute == 30) {
                                      if (time.second > 0) {
                                        _time =
                                            "  เวลาที่ระบุไม่ถูกต้อง"; //เกิน 15.30 sec
                                        setState(() {});
                                      } else {
                                        _time =
                                            '  ${time.hour} : ${time.minute} : ${time.second}';
                                        setState(() {});
                                      }
                                    } else {
                                      _time =
                                          '  ${time.hour} : ${time.minute} : ${time.second}';
                                      setState(() {});
                                    }
                                  }
                                } else {
                                  _time =
                                      "  เวลาที่ระบุไม่ถูกต้อง"; //เวลานาทีน้อยกว่าปัจจุบัน 5 min
                                  setState(() {});
                                }
                              } else {
                                _time =
                                    "  เวลาที่ระบุไม่ถูกต้อง"; //น้อยกว่า now
                                setState(() {});
                              }
                            } else {
                              _time =
                                  "  เวลาที่ระบุไม่ถูกต้อง"; //เกินเวลาเปิดปิด1
                              setState(() {});
                            }
                          },
                              currentTime:
                                  DateTime.now().add(Duration(minutes: 5)),
                              locale: LocaleType.en);
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
                                  Text(
                                    " $_time",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ],
                              ),
                              Text(
                                "  เปลี่ยนเวลา",
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
                    // Column(
                    //   children: <Widget>[
                    //     Container(
                    //       padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //       width: double.maxFinite,
                    //       color: Colors.grey[400],
                    //       child: Text(
                    //         "โปรดเลือกวิธีการชำระเงิน",
                    //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    //       ),
                    //     ),
                    //     Row(
                    //       children: <Widget>[
                    //         Container(
                    //           height: 50,
                    //           width: 205,
                    //           child: RaisedButton(
                    //             elevation: 5,
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(0),
                    //               side: BorderSide(
                    //                 color: ispromptpaybuttonselected
                    //                     ? Colors.orange
                    //                     : Colors.grey,
                    //                 width: ispromptpaybuttonselected ? 3 : 1,
                    //               ),
                    //             ),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: <Widget>[
                    //                 Container(
                    //                   margin: EdgeInsets.fromLTRB(5, 0, 0, 2),
                    //                   child: Row(
                    //                     children: <Widget>[
                    //                       Text(
                    //                         "พร้อมเพย์  ",
                    //                         style: TextStyle(
                    //                           fontSize: 16,
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   child: Image.network(
                    //                       "https://toppng.com/uploads/thumbnail//promptpay-logo-11551057371ufyvbrttny.png"),
                    //                 ),
                    //               ],
                    //             ),
                    //             onPressed: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => PromptpayPage(),
                    //                 ),
                    //               );
                    //             },
                    //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //           ),
                    //         ),
                    //         Container(
                    //           height: 50,
                    //           width: 206,
                    //           child: RaisedButton(
                    //             elevation: 5,
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(0),
                    //               side: BorderSide(
                    //                 color: istruewalletbuttonselected
                    //                     ? Colors.orange
                    //                     : Colors.grey,
                    //                 width: istruewalletbuttonselected ? 3 : 1,
                    //               ),
                    //             ),
                    //             child: Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: <Widget>[
                    //                 Container(
                    //                   margin: EdgeInsets.fromLTRB(5, 0, 0, 2),
                    //                   child: Row(
                    //                     children: <Widget>[
                    //                       Text(
                    //                         "ทรูวอลเล็ท  ",
                    //                         style: TextStyle(
                    //                           fontSize: 16,
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //                 Container(
                    //                   height: 30,
                    //                   child: Image.network(
                    //                       "https://seeklogo.com/images/T/truemoney-wallet-logo-9CCDDD6CB0-seeklogo.com.png"),
                    //                 ),
                    //               ],
                    //             ),
                    //             onPressed: () {
                    //               Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                   builder: (context) => TruewalletPage(),
                    //                 ),
                    //               );
                    //             },
                    //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}

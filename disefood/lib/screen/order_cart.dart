import 'package:disefood/model/cart.dart';
import 'package:disefood/screen/customer_utilities/sqlite_helper.dart';
import 'package:disefood/screen/view_order_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class OrderItemPage extends StatefulWidget {
  @override
  _OrderItemPageState createState() => _OrderItemPageState();
}

class _OrderItemPageState extends State<OrderItemPage> {
  String _time = "  ยังไม่ได้เลือกเวลา";
  List<CartModel> cartModels = List();

  @override
  void initState() {
    super.initState();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFromSQLite();
    setState(() {
      cartModels = object;
    });
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
                      Text("00 บาท",
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
                          'ยืนยันการสั่งซื้อ',
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
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 265),
            child: new IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
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
      body: cartModels.length == 0
          ? Center(
              child: Text("ยังไม่มีอาหารในตะกร้าสินค้า"),
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
                      margin: EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 230,
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
                          return Container(
                            child: Column(
                              children: [
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.fromLTRB(30, 0, 40, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: 220,
                                        child: Text(
                                          "${cartModels[index].foodName}",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 30,
                                        child: Text(
                                          "${cartModels[index].foodQuantity}",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 30,
                                        child: Text(
                                          "${cartModels[index].foodSumPrice}",
                                          style: TextStyle(
                                            fontSize: 14,
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

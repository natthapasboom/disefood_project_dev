import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:disefood/model/accountdata.dart';
import 'package:disefood/model/getPayment.dart';
import 'package:disefood/model/payment_less_or_more.dart';
import 'package:disefood/screen/customer_dialog/less_confirm_dialog.dart';
import 'package:disefood/screen/history.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class PaymentPage extends StatefulWidget {
  final int shopId;
  final int totalPrice;
  final int orderId;

  const PaymentPage({
    Key key,
    @required this.shopId,
    @required this.totalPrice,
    @required this.orderId,
  }) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int shopId;
  int totalPrice;
  int orderId;
  Map jsonAccMap;
  Map jsonPaymentMap;
  Map jsonLessOrMoreMap;
  var accList;
  var lessOrMoreList;
  Future<PaymentLessOrMore> lessOrMoreData;
  Future<AccountData> dataList;
  bool isUploaded = false;
  bool isSlipVerified = false;
  bool showBottomNavigate = false;
  bool isHasSlip = false;
  var paymentList;
  Future<GetPayment> paymentData;
  File _image;
  @override
  void initState() {
    setState(() {
      totalPrice = widget.totalPrice;
      shopId = widget.shopId;
      orderId = widget.orderId;
    });

    dataList = getAccountNumber();
    paymentData = getSlipImg();

    super.initState();
  }

  Future<GetPayment> getSlipImg() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String _url = 'http://54.151.194.224:8000/api/order/me/$orderId/payment';
    String token = preferences.getString('token');
    final response = await http.get(
      _url,
      headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
    );
    if (response.statusCode == 200) {
      setState(() {
        var jsonString = response.body;
        jsonPaymentMap = json.decode(jsonString);
        if (jsonPaymentMap["data"]["payment_img"] != null) {
          setState(() {
            isHasSlip = true;
            isSlipVerified = true;
          });
        } else {
          setState(() {
            isHasSlip = false;
          });
        }
      });
    } else {
      print('${response.statusCode} <---- 500 ถูกแล้ว');
    }
    return paymentList;
  }

  Future<AccountData> getAccountNumber() async {
    String _url = 'http://54.151.194.224:8000/api/shop/$shopId/account-number';
    final response = await http.get(
      _url,
    );
    if (response.statusCode == 200) {
      setState(() {
        var jsonString = response.body;
        jsonAccMap = json.decode(jsonString);
        accList = AccountData.fromJson(jsonAccMap);
      });
    } else {
      print('${response.statusCode}');
    }
    return accList;
  }

  Future<PaymentLessOrMore> getMsgLessOrMore() async {
    String _url = 'http://54.151.194.224:8000/api/payment/check/order/$orderId';
    final response = await http.get(
      _url,
    );
    if (response.statusCode == 200) {
      setState(() {
        var jsonString = response.body;
        jsonLessOrMoreMap = json.decode(jsonString);
        lessOrMoreList = PaymentLessOrMore.fromJson(jsonLessOrMoreMap);
        print(jsonLessOrMoreMap["data"]["msg"]);
      });
    } else {
      print('${response.statusCode}');
    }
    return lessOrMoreList;
  }

  void showToast(String msg) {
    Toast.show(msg, context,
        textColor: Colors.white, duration: Toast.LENGTH_LONG);
  }

  Future<void> getImage(ImageSource imageSource) async {
    try {
      var image = await ImagePicker.pickImage(
        source: imageSource,
      );
      setState(() {
        _image = image;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Null> sendPayment(File _image) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String url = 'http://54.151.194.224:8000/api/order/me/$orderId/payment';
    String token = preferences.getString('token');

    String fileName = _image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "payment_img":
          await MultipartFile.fromFile(_image.path, filename: fileName),
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
          if (status == 200) {
            showToast("อัพโหลดสลิปเรียบร้อย");
            showBottomNavigate = true;
          } else if (status == 500) {
            showToast("ไม่สามารถยืนยันสลิปได้ : มีการใช้สลิปนี้ไปแล้ว");
            showBottomNavigate = false;
          } else {
            showToast("มีข้อผิดพลาดเกิดขึ้น โปรดลองใหม่ภายหลัง Status : " +
                "$status");
            showBottomNavigate = false;
          }
          return status < 500;
        },
      ),
    );
    print(response.statusCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 360),
            child: new IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => History(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: isSlipVerified,
        child: Container(
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
              height: 65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                            'กลับไปยังประวัติสั่งอาหาร',
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
                            builder: (context) => History(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Text(
                "การชำระเงิน",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              thickness: 2,
              indent: 30,
              endIndent: 30,
            ),
            Container(
              child: FutureBuilder<AccountData>(
                future: dataList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data.data[index];
                        return Container(
                          margin: EdgeInsets.only(
                            right: 40,
                            left: 40,
                            top: 0,
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(
                                        "${data.channel} :",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(new ClipboardData(
                                            text: "${data.number}"));
                                        showToast(
                                            "คัดลอกข้อความไปยังคลิปบอร์ดแล้ว");
                                      },
                                      child: Container(
                                        child: Text(
                                          "${data.number}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(
                                        "ราคา :",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "$totalPrice บาท",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                replacement: Container(
                                  margin: EdgeInsets.only(top: 130),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 70,
                                      ),
                                      Text(
                                        "คุณได้ทำการยืนยันสลิปแล้ว",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "โปรดกดยืนยันการชำระเงินเพื่อส่งออเดอร์ให้แม่ค้า",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                visible: !isHasSlip,
                                child: Container(
                                  child: Column(
                                    children: [
                                      Visibility(
                                        visible: isUploaded,
                                        replacement: InkWell(
                                          onTap: () {
                                            getImage(ImageSource.gallery);
                                            setState(() {
                                              isUploaded = true;
                                            });
                                          },
                                          child: Container(
                                            width: 120,
                                            height: 130,
                                            child: Container(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 100,
                                                    color: Colors.grey[400],
                                                  ),
                                                  Text(
                                                    "เลือกรูปภาพ",
                                                    style: TextStyle(
                                                        color: Colors.grey[400],
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            if (isSlipVerified == true) {
                                            } else {
                                              getImage(ImageSource.gallery);
                                              setState(() {
                                                isUploaded = true;
                                              });
                                            }
                                          },
                                          child: Container(
                                            child: Container(
                                              child: _image == null
                                                  ? Container(
                                                      width: 120,
                                                      height: 130,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5),
                                                        child: Column(
                                                          children: [
                                                            Icon(
                                                              Icons.image,
                                                              size: 100,
                                                              color: Colors
                                                                  .grey[400],
                                                            ),
                                                            Text(
                                                              "เลือกรูปภาพ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      color: Colors.grey[400],
                                                      margin: EdgeInsets.only(
                                                          bottom: 5),
                                                      child: Image.file(
                                                        _image,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !isSlipVerified,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              right: 80, left: 80, bottom: 20),
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            elevation: 8,
                                            onPressed: () {
                                              if (_image == null) {
                                                setState(() {
                                                  isSlipVerified = false;
                                                });
                                                showToast(
                                                    "ไม่พบรูปภาพที่อัพโหลด");
                                              } else {
                                                sendPayment(
                                                  _image,
                                                ).then(
                                                  (value) {
                                                    lessOrMoreData =
                                                        getMsgLessOrMore().then(
                                                      (value) {
                                                        if (jsonLessOrMoreMap[
                                                                    "data"]
                                                                ["msg"] ==
                                                            "Payment's amount is less than Order's price") {
                                                          print(
                                                              "Slip invalid value : less than case");

                                                          String msg = "less";
                                                          showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) =>
                                                                LessOrMoreDialog(
                                                              msg: msg,
                                                              orderId: orderId,
                                                            ),
                                                          ).then(
                                                            (value) {
                                                              setState(
                                                                () {
                                                                  if (showBottomNavigate) {
                                                                    isSlipVerified =
                                                                        true;
                                                                  } else {
                                                                    isSlipVerified =
                                                                        false;
                                                                  }
                                                                },
                                                              );
                                                            },
                                                          );
                                                        } else if (jsonLessOrMoreMap[
                                                                    "data"]
                                                                ["msg"] ==
                                                            "Payment's amount is more than Order's price") {
                                                          print(
                                                              "Slip invalid value : more than case");
                                                          String msg = "more";
                                                          showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder: (context) =>
                                                                LessOrMoreDialog(
                                                              msg: msg,
                                                              orderId: orderId,
                                                            ),
                                                          ).then(
                                                            (value) {
                                                              setState(
                                                                () {
                                                                  if (showBottomNavigate) {
                                                                    isSlipVerified =
                                                                        true;
                                                                  } else {
                                                                    isSlipVerified =
                                                                        false;
                                                                  }
                                                                },
                                                              );
                                                            },
                                                          );
                                                        } else {
                                                          print("Correct Case");
                                                          setState(
                                                            () {
                                                              if (showBottomNavigate) {
                                                                isSlipVerified =
                                                                    true;
                                                              } else {
                                                                isSlipVerified =
                                                                    false;
                                                              }
                                                            },
                                                          );
                                                        }
                                                      },
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                            color: Colors.white,
                                            child: Text(
                                              ' ยืนยันสลิป',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(top: 150),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                          valueColor:
                              AlwaysStoppedAnimation(const Color(0xffF6A911)),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

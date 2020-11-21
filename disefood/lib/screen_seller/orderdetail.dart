import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:disefood/model/orderbyshopid.dart';
import 'package:disefood/screen_seller/seller_dialog/addtime_orderpage_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class OrderDetailSeller extends StatefulWidget {
  static final route = "/order_detail_seller";
  final DateTime timePickup;
  final int totalPrice;
  final String coverImage;
  final List<OrderDetails> orderDetail;
  final String userFName;
  final String userLName;
  final String userTel;
  final String slipImg;
  final int orderId;
  final Function(int) addQty;
  final Function(int) resetQty;
  final int index;

  const OrderDetailSeller({
    Key key,
    @required this.timePickup,
    @required this.totalPrice,
    @required this.coverImage,
    @required this.orderDetail,
    @required this.userFName,
    @required this.userLName,
    @required this.userTel,
    @required this.slipImg,
    @required this.orderId,
    @required this.addQty,
    @required this.resetQty,
    @required this.index,
  }) : super(key: key);
  @override
  _OrderDetailSellerState createState() => _OrderDetailSellerState();
}

class _OrderDetailSellerState extends State<OrderDetailSeller> {
  Function(int) addQty;
  Function(int) resetQty;
  int index;
  bool isLoading = true;
  bool isthisbuttonselected = true;
  String nameUser;
  String lastNameUser;
  String profileImg;
  Logger logger = Logger();
  DateTime timePickup;
  int totalPrice;
  String coverImage;
  String userFName;
  String userLName;
  String userTel;
  String slipImg;
  int orderId;
  bool isAddTime = false;
  List<OrderDetails> orderDetail;
  String timeMinute;

  TextEditingController addTimeController = TextEditingController();

  int qty = 0;

  @override
  void initState() {
    // Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    // Future.microtask(() {});
    super.initState();
    setState(() {
      timePickup = widget.timePickup;
      totalPrice = widget.totalPrice;
      coverImage = widget.coverImage;
      orderDetail = widget.orderDetail;
      userFName = widget.userFName;
      userLName = widget.userLName;
      userTel = widget.userTel;
      slipImg = widget.slipImg;
      orderId = widget.orderId;
      addQty = widget.addQty;
      resetQty = widget.resetQty;
      index = widget.index;
    });
    timeTextCheck();
  }

  Future<Null> updateOrder(int qty) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String url = 'http://54.151.194.224:8000/api/order/shop/$orderId';
    String token = preferences.getString('token');
    DateTime newTime = timePickup.add(Duration(minutes: qty));
    String status = "in process";
    String _method = "PUT";
    FormData formData = FormData.fromMap({
      "status": status,
      "time_pickup": newTime,
      "_method": _method,
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
            showToast("เพิ่มเวลาเรียบร้อยแล้ว");
          } else {
            showToast("มีข้อผิดพลาดเกิดขึ้น โปรดลองใหม่ภายหลัง Status : " +
                "$status");
          }
          return status < 500;
        },
      ),
    );
    print(response.statusCode);
  }

  void showToast(String msg) {
    Toast.show(msg, context,
        textColor: Colors.white, duration: Toast.LENGTH_LONG);
  }

  void add() {
    qty++;
    if (qty > 0) {
      isAddTime = true;
    }
    setState(() {});
  }

  void remove() {
    if (qty > 0) {
      qty--;
      setState(() {});
    }
    if (qty == 0) {
      isAddTime = false;
    }
  }

  void timeTextCheck() {
    int minuteCheck = timePickup.minute;
    if (minuteCheck == 0) {
      timeMinute = "${timePickup.minute}0";
    } else if (minuteCheck < 10) {
      timeMinute = "0${timePickup.minute}";
    } else {
      timeMinute = "${timePickup.minute}";
    }
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
                            'ยืนยันการเพิ่มเวลา',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        if (qty == 0) {
                          resetQty(index);
                          showToast(
                              "ท่านยังไม่ได้ระบุจำนวนเวลาที่ต้องการเพิ่ม");
                        } else {
                          resetQty(index);
                          for (var i = 0; i < qty; i++) {
                            addQty(index);
                          }
                          updateOrder(qty).then((value) {
                            Navigator.of(context).pop();
                          });
                        }
                      },
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
                margin: EdgeInsets.only(right: 120, top: 15),
                child: Text(
                  "รายละเอียดคำสั่งซื้อ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )),
          ],
        ),
        // drawer: _sideMenuSeller(params.userData),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          "https://disefood.s3-ap-southeast-1.amazonaws.com/" +
                              '$coverImage',
                      width: double.maxFinite,
                      height: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 50, bottom: 35),
                          child: CircularProgressIndicator(
                            strokeWidth: 5.0,
                            valueColor:
                                AlwaysStoppedAnimation(const Color(0xffF6A911)),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 100,
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
                      padding: EdgeInsets.only(left: 40),
                      width: double.maxFinite,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            "เวลาทำอาหาร",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: double.maxFinite,
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "เวลาที่จะมารับ : ",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 2),
                            child: Text(
                              '${timePickup.hour}.$timeMinute น.',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[200],
                      thickness: 2,
                      height: 0,
                    ),
                    Visibility(
                      visible: isAddTime,
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            width: double.maxFinite,
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Text(
                                    "เวลาที่เพิ่ม : ",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 7),
                                  child: Text(
                                    '+ $qty นาที',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 40, right: 45),
                      alignment: Alignment.centerLeft,
                      width: double.maxFinite,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "รายการอาหาร",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            "จำนวน",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: orderDetail != null ? orderDetail.length : 0,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Container(
                              height: 40,
                              margin: EdgeInsets.only(left: 40, right: 60),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${orderDetail[index].food.name}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "${orderDetail[index].quantity}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey[200],
                              thickness: 2,
                              height: 0,
                            ),
                          ],
                        );
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 40),
                      alignment: Alignment.centerLeft,
                      width: double.maxFinite,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: Text(
                        "ข้อมูลผู้สั่ง",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 40, right: 40),
                            height: 40,
                            width: double.maxFinite,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "ชื่อ  ",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                Text(
                                  "$userFName $userLName",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey[200],
                            thickness: 2,
                            height: 0,
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 40, right: 40),
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "เบอร์ติดต่อ",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                Text(
                                  "$userTel",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey[200],
                            thickness: 2,
                            height: 0,
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        width: 340,
                        height: 410,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 10,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 10, left: 20),
                                width: double.maxFinite,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text("สลิปการโอนเงิน",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              CachedNetworkImage(
                                imageUrl:
                                    "https://disefood.s3-ap-southeast-1.amazonaws.com/" +
                                        '$slipImg',
                                width: 250,
                                height: 347,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 5.0,
                                    valueColor: AlwaysStoppedAnimation(
                                        const Color(0xffF6A911)),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  padding: EdgeInsets.only(top: 70),
                                  width: 250,
                                  height: 250,
                                  color: Colors.white,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Icon(
                                          Icons.error,
                                          size: 50,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          "เกิดปัญหาในการโหลดรูปภาพ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.red),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(265, 80),
                child: Container(
                  width: 125,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    elevation: 8,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddTimeOrderPage(
                          qty: qty,
                          add: add,
                          remove: remove,
                        ),
                      );
                    },
                    color: Colors.orange,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'เพิ่มเวลา',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.timer,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

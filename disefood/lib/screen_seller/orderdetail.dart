import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/model/orderbyshopid.dart';
import 'package:disefood/screen_seller/seller_dialog/addtime_orderpage_dialog.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class OrderDetailSeller extends StatefulWidget {
  static final route = "/order_detail_seller";
  final DateTime timePickup;
  final int totalPrice;
  final String coverImage;
  final List<OrderDetails> orderDetail;
  final String userFName;
  final String userLName;
  final String userTel;
  const OrderDetailSeller({
    Key key,
    @required this.timePickup,
    @required this.totalPrice,
    @required this.coverImage,
    @required this.orderDetail,
    @required this.userFName,
    @required this.userLName,
    @required this.userTel,
  }) : super(key: key);
  @override
  _OrderDetailSellerState createState() => _OrderDetailSellerState();
}

class _OrderDetailSellerState extends State<OrderDetailSeller> {
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
  bool isAddTime = false;
  List<OrderDetails> orderDetail;
  TextEditingController addTimeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    });
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
                            'รับออร์เดอร์',
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
                                valueColor: AlwaysStoppedAnimation(
                                    const Color(0xffF6A911)),
                              ))),
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
                              '${timePickup.hour}.${timePickup.minute} น.',
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
                        "รายละเอียดผู้สั่ง",
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
                          Icons.more_time,
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

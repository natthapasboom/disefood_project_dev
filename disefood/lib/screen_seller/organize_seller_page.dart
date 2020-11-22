import 'dart:convert';

import 'package:disefood/model/feedback.dart';
import 'package:disefood/model/foods_list.dart';
import 'package:disefood/screen_seller/addmenu.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:disefood/services/foodservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'editmenu.dart';

class OrganizeSellerPage extends StatefulWidget {
  static final route = "/organize_seller";
  @override
  _OrganizeSellerPageState createState() => _OrganizeSellerPageState();
}

class _OrganizeSellerPageState extends State<OrganizeSellerPage> {
  FoodsList foodslist = FoodsList();
  List foodList = [];
  bool _isLoading = false;
  int _shopId;
  String foodName;
  String token;
  int approve;
  ApiProvider apiProvider = ApiProvider();
  List<Feedbacks> _feedbackLists = new List<Feedbacks>();
  @override
  void initState() {
    Future.microtask(() async {
      // fetchNameFromStorage();
      getFoodByShopId();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      token = preferences.getString('token');
      approve = preferences.getInt('approved');
    });
    super.initState();
  }

  Future getFoodByShopId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _shopId = preferences.getInt('shop_id');
    String _url = 'http://54.151.194.224:8000/api/shop/menu/$_shopId';
    final response = await http.get(_url);
    var body = response.body;
    setState(() {
      _isLoading = true;
      foodList = json.decode(body)['data'];
      print('approve: $approve');
    });
  }

  @override
  Widget build(BuildContext context) {
    // final OrganizeSellerPage params = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 40, top: 30),
                child: Text(
                  "รายการอาหาร",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 15, left: 40),
                child: Text(
                  'ชื่อ',
                  style: TextStyle(
                      fontFamily: 'Aleo',
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15, left: 195),
                child: Text(
                  'ราคา',
                  style: TextStyle(
                      fontFamily: 'Aleo',
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Divider(
              indent: 40,
              color: Colors.black,
              endIndent: 40,
            ),
          ),
          Container(
            child: !_isLoading
                ? Container(
                    margin: EdgeInsets.only(top: 150),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 5.0,
                        valueColor:
                            AlwaysStoppedAnimation(const Color(0xffF6A911)),
                      ),
                    ),
                  )
                : Container(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: foodList != null ? foodList.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          var foods = foodList[index];
                          return Container(
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Container(
                                      width: 180,
                                      margin: EdgeInsets.only(
                                        left: 30,
                                        top: 5,
                                      ),
                                      child: Text(
                                        '${foods['name']}'.toUpperCase(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      )),
                                  trailing: Wrap(
                                    spacing: 1.0,
                                    // space between two icons
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 13, right: 5, left: 50),
                                        child: Text(
                                          '${foods['price']} ฿',
                                          style: TextStyle(
                                            color: const Color(0xff11AB17),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),

                                      IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.amber[800],
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditMenuPage(
                                                          image: foods[
                                                              'cover_img'],
                                                          name: foods['name'],
                                                          price: foods['price'],
                                                          status:
                                                              foods['status'],
                                                          id: foods['id'],
                                                        ))).then((value) {
                                              setState(() {
                                                initState();
                                                print('Set state work');
                                              });
                                            });
                                          }),

                                      IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.amber[800],
                                          ),
                                          onPressed: () {
                                            alertDialog(context,
                                                'ลบรายการอาหาร?', foods['id']);
                                          }),
                                      // icon-1
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 0),
                                  child: Divider(
                                    indent: 40,
                                    color: Colors.black,
                                    endIndent: 40,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
          ),
          Container(
              child: _isLoading
                  ? approve == 1
                      ? Column(
                          children: <Widget>[
                            ListTile(
                              leading: Container(
                                margin: EdgeInsets.only(
                                  left: 30,
                                ),
                                child: Text(
                                  'เพิ่มรายการอาหาร',
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Colors.amber[800],
                                ),
                                onPressed: () {
                                  MaterialPageRoute materialPageRoute =
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return AddMenu();
                                  });

                                  Navigator.of(context)
                                      .push(materialPageRoute)
                                      .then((value) {
                                    setState(() {
                                      initState();
                                      print('Set state work');
                                    });
                                  });
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Divider(
                                indent: 40,
                                color: Colors.black,
                                endIndent: 40,
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Container(
                              margin: EdgeInsets.only(top: 150),
                              child: Text('รอแอดมินอณุมัติร้านค้า')),
                        )
                  : Container()),
        ],
      ),
    );
  }

  Future<void> alertDialog(
    BuildContext context,
    String message,
    int foodId,
  ) async {
    showDialog(
        context: context,
        builder: (context) => Container(
              child: SimpleDialog(
                title: Container(
                    child: Text(
                  message,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: 30, top: 10, bottom: 30, right: 100),
                    child: Text(
                      'ท่านต้องการลบรายการอาหารใช่หรือไม่',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xff838181)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: FlatButton(
                            onPressed: () async {
                              var response = await apiProvider.deleteMenuById(
                                  foodId, token);
                              if (response.statusCode == 200) {
                                Navigator.of(context).pop(true);
                                initState();
                              } else {
                                print('status code = ${response.statusCode}');
                              }
                            },
                            child: Text(
                              'ยืนยัน',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xffFF7C2C)),
                            )),
                      ),
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            'ยกเลิก',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xffFF7C2C)),
                          )),
                    ],
                  )
                ],
              ),
            ));
  }
}

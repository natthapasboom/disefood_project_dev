import 'package:disefood/component/feedback_seller_bottombar.dart';
import 'package:disefood/component/order_seller_bottombar.dart';
import 'package:disefood/component/sidemenu_seller.dart';
import 'package:disefood/component/summary_seller_bottombar.dart';
import 'package:disefood/model/user_profile.dart';
import 'package:disefood/screen_seller/organize_seller_page.dart';
import 'package:flutter/material.dart';
import 'package:disefood/screen_seller/orderdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderSellerPage extends StatefulWidget {
  static final route = "/order_seller";
  //  final UserProfile userData;
  // OrderSellerPage({Key key,@required this.userData}) : super(key : key);
  @override
  _OrderSellerPageState createState() => _OrderSellerPageState();
}

class _OrderSellerPageState extends State<OrderSellerPage> {
  List<String> items = List<String>.generate(7 + 1, (index) {
    return "Item + $index";
  });

  List<Card> carditem = new List<Card>();

  @override
  void initState() {
    Future.microtask(() async {
      fetchNameFromStorage();
    });
    super.initState();
  }

  String _name;
  int _userId;
  Future fetchNameFromStorage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final name = _prefs.getString('first_name');
    final userId = _prefs.getInt('user_id');
    setState(() {
      _name = name;
      _userId = userId;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('$_userId $_name');
    return Scaffold(
      body: new ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, int i) {
          return new Dismissible(
            key: new Key(items[i]),
            child: Container(
              margin: EdgeInsets.all(20),
              height: 338,
              child: InkWell(
                child: Card(
                  elevation: 8,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                        "https://sifu.unileversolutions.com/image/th-TH/recipe-topvisual/2/1260-709/%E0%B8%81%E0%B9%8B%E0%B8%A7%E0%B8%A2%E0%B9%80%E0%B8%95%E0%B8%B5%E0%B9%8B%E0%B8%A2%E0%B8%A7%E0%B8%95%E0%B9%89%E0%B8%A1%E0%B8%A2%E0%B8%B3%E0%B8%AA%E0%B8%B8%E0%B9%82%E0%B8%82%E0%B8%97%E0%B8%B1%E0%B8%A2-50357483.jpg",
                        fit: BoxFit.cover,
                        height: 150,
                        width: 380,
                      ),
                      Transform.translate(
                        offset: Offset(10.0, -140.0),
                        child: Container(
                          margin: EdgeInsets.only(left: 0),
                          padding: EdgeInsets.fromLTRB(5, 4, 5, 5),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "คิวที่ ${i + 1}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(10, -20),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "รายการอาหาร",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(10, -20),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Text("ก๋วยเตี๋ยวต้มยำพิเศษ"),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5, top: 2),
                                child: Text("2"),
                              ),
                              Container(
                                height: 15,
                                padding: EdgeInsets.only(right: 5, top: 2),
                                child: VerticalDivider(
                                  color: Colors.black54,
                                  thickness: 2,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Text("ก๋วยเตี๋ยวเย็นตาโฟ"),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5, top: 2),
                                child: Text("1"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(10, -20),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Text("ราคา"),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 0, top: 3),
                                child: Text(
                                  "135",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5, top: 2),
                                child: Icon(
                                  Icons.attach_money,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(10, -20),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Text("เวลาที่จะมารับ"),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Text("11.30 AM"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(2, -15),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              ButtonBar(
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        items.removeAt(i);
                                      });
                                    },
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    color: Colors.orange,
                                    child: Text(
                                      "เสร็จสิ้น",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetailSeller(),
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    color: Colors.white,
                                    child: Text(
                                      "แก้ไข",
                                      style: TextStyle(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

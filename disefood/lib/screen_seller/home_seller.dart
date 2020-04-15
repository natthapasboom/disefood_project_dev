import 'package:disefood/component/feedback_seller_bottombar.dart';
import 'package:disefood/component/organize_seller_bottombar.dart';
import 'package:disefood/component/summary_seller_bottombar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:disefood/component/sidemenu_seller.dart';
import 'package:disefood/component/order_seller_bottombar.dart';

class HomeSeller extends StatefulWidget {
  static const routeName = '/screen/home_seller';

  @override
  _HomeSellerState createState() => _HomeSellerState();
}

class _HomeSellerState extends State<HomeSeller> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
      ),
      drawer: SideMenuSeller(),
      body: ListView(
        children: <Widget>[
          headerImage,
          titleSection,
          Container(
            height: 13.0,
            color: Colors.black12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //menu order
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderSeller()),
                        );
                      },
                      child: Icon(
                        Icons.fastfood,
                        size: 70,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      "ออเดอร์",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              //menu manage resteraunt
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrganizeSeller()),
                        );
                      },
                      child: Icon(
                        Icons.settings,
                        color: Colors.orange,
                        size: 70,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      "จัดการร้านค้า",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //feedback
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedbackSeller()),
                        );
                      },
                      child: Icon(
                        Icons.rate_review,
                        color: Colors.orange,
                        size: 70,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      "คำแนะนำ",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              //summary
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SummarySeller()),
                        );
                      },
                      child: Icon(
                        Icons.equalizer,
                        color: Colors.orange,
                        size: 70,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Text(
                      "ดูยอดขาย",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

//          buttonSection1,
//          buttonSection2,
        ],
      ),
    );
  }
}

Widget headerImage = new Image.network(
  'https://www.prachachat.net/wp-content/uploads/2018/05/3-1024x704-728x501.jpg',
  height: 160.0,
  width: 430.0,
  fit: BoxFit.cover,
);

Widget titleSection = Container(
  padding: EdgeInsets.all(10.0),
  child: Row(
    children: <Widget>[
      Expanded(
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "01",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0),
            ),
          ),
          title: Text(
            "Restaurant 1",
            style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("อาหารเส้น"),
              Container(
                padding: EdgeInsets.only(top: 5.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 15.0,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5.0),
                      child: Text("4.2"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ],
  ),
);

//Widget buttonSection1 = Row(
//  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//  children: <Widget>[
//    _buildButtonColumn1(icon: Icons.fastfood, label: "ออเดอร์"),
//    _buildButtonColumn2(icon: Icons.settings, label: "จัดการร้านค้า"),
//  ],
//);

//Widget buttonSection2 = Row(
//  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//  children: <Widget>[
//    _buildButtonColumn3(icon: Icons.feedback, label: "คำแนะนำ"),
//    _buildButtonColumn4(icon: Icons.equalizer, label: "ยอดขาย"),
//  ],
//);
//
//Column _buildButtonColumn1({IconData icon, String label}) {
//  var iconColor = Colors.orange;
//  return Column(
//    children: <Widget>[
//      Container(
//        margin: EdgeInsets.only(top: 40),
//        child: Icon(
//          icon,
//          color: iconColor,
//          size: 70,
//        ),
//      ),
//      Container(
//        margin: EdgeInsets.only(top: 8),
//        child: Text(
//          label,
//          style: TextStyle(
//            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500,
//          ),
//        ),
//      )
//    ],
//  );
//}
//
//Column _buildButtonColumn2({IconData icon, String label}) {
//  var iconColor = Colors.orange;
//  return Column(
//    children: <Widget>[
//      Container(
//        margin: EdgeInsets.only(top: 40),
//        child: Icon(
//          icon,
//          color: iconColor,
//          size: 70,
//        ),
//      ),
//      Container(
//        margin: EdgeInsets.only(top: 8),
//        child: Text(
//          label,
//          style: TextStyle(
//            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500,
//          ),
//        ),
//      )
//    ],
//  );
//}
//
//Column _buildButtonColumn3({IconData icon, String label}) {
//  var iconColor = Colors.orange;
//  return Column(
//    children: <Widget>[
//      Container(
//        margin: EdgeInsets.only(top: 40),
//        child: Icon(
//          icon,
//          color: iconColor,
//          size: 70,
//        ),
//      ),
//      Container(
//        margin: EdgeInsets.only(top: 8),
//        child: Text(
//          label,
//          style: TextStyle(
//            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500,
//          ),
//        ),
//      )
//    ],
//  );
//}
//
//Column _buildButtonColumn4({IconData icon, String label}) {
//  var iconColor = Colors.orange;
//  return Column(
//    children: <Widget>[
//      Container(
//        margin: EdgeInsets.only(top: 40),
//        child: Icon(
//          icon,
//          color: iconColor,
//          size: 70,
//        ),
//      ),
//      Container(
//        margin: EdgeInsets.only(top: 8),
//        child: Text(
//          label,
//          style: TextStyle(
//            fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500,
//          ),
//        ),
//      )
//    ],
//  );
//}

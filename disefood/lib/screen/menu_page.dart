import 'package:disefood/component/sidemenu_customer.dart';
import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/screen/menu_order_detail_amount.dart';
import 'package:disefood/screen/order_items.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  final String stramount;
  final bool checkinvis;

  MenuPage({Key key, this.stramount, this.checkinvis}) : super(key: key);
  @override
  _MenuPageState createState() => _MenuPageState(stramount, checkinvis);
}

class _MenuPageState extends State<MenuPage> {
  bool isfavorite = false;
  String stramount;
  bool checkinvis;
  int amounttempvalue;
  bool isinvis = false;

  _MenuPageState(this.stramount, this.checkinvis) {
    if (checkinvis != null) {
      isinvis = checkinvis;
    }
  }

  setAmountToTemp() {
    amounttempvalue = int.parse(stramount);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.favorite),
              onPressed: () => debugPrint('Favorite')),
          new IconButton(
              icon: Icon(Icons.archive),
              onPressed: () => debugPrint("archieve")),
        ],
      ),
      drawer: SideMenuCustomer(),
      body: Container(
        child: Column(
          children: <Widget>[
            Image.network(
              "https://momofuku-assets.s3.amazonaws.com/uploads/sites/27/2018/08/2-2-1440x590.jpg",
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
              padding: EdgeInsets.only(left: 45),
              child: Row(
                children: <Widget>[
                  Text(
                    "01",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 65,
                    child: VerticalDivider(
                      color: Colors.orange,
                      thickness: 3,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "ร้านก๋วยเตี๋ยว",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text("อาหารเส้น"),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.orangeAccent,
                            size: 20,
                          ),
                          Text("4.9"),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(
              thickness: 15,
              color: Colors.grey[300],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(45, 20, 45, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        "รายการอาหาร",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 55),
                      Text(
                        "ราคา",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("Noodle 1"),
                      SizedBox(width: 55),
                      Visibility(
                        visible: isinvis,
                        replacement: SizedBox(
                          width: 25,
                        ),
                        child: Container(
                          child: Text(
                            'x' + '$stramount',
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                          width: 25,
                        ),
                      ),
                      SizedBox(width: 50),
                      Text("45"),
                      SizedBox(width: 15),
                      IconButton(
                        icon: new Icon(
                          Icons.add_circle,
                          color: Colors.orange,
                        ),
                        onPressed: () {
                          if (this.stramount == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return OrderAmount();
                                },
                              ),
                            );
                          } else {
                            setAmountToTemp();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return OrderAmount(
                                      amounttempvalue: amounttempvalue);
                                },
                              ),
                            );
                          }
                        },
                      ),
                      Visibility(
                        visible: isfavorite,
                        replacement: IconButton(
                          icon: new Icon(Icons.favorite_border),
                          color: Colors.orange,
                          onPressed: () => setState(
                            () => isfavorite = true,
                          ),
                        ),
                        child: IconButton(
                          icon: new Icon(
                            Icons.favorite,
                            color: Colors.orange,
                          ),
                          onPressed: () => setState(
                            () => isfavorite = false,
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    endIndent: 15,
                    height: 0,
                    color: Colors.grey,
                    thickness: 1.5,
                  ),
                  Row(
                    children: <Widget>[
                      Text("Noodle 1"),
                      SizedBox(width: 130),
                      Text("45"),
                      SizedBox(width: 15),
                      IconButton(
                          icon: new Icon(
                            Icons.add_circle,
                            color: Colors.orange,
                          ),
                          onPressed: () => debugPrint('Add')),
                      IconButton(
                          icon: new Icon(
                            Icons.favorite_border,
                            color: Colors.orange,
                          ),
                          onPressed: () => debugPrint('Mark as Favorite')),
                    ],
                  ),
                  Divider(
                    endIndent: 15,
                    height: 0,
                    color: Colors.grey,
                    thickness: 1.5,
                  ),
                  Row(
                    children: <Widget>[
                      Text("Noodle 1"),
                      SizedBox(width: 130),
                      Text("45"),
                      SizedBox(width: 15),
                      IconButton(
                          icon: new Icon(
                            Icons.add_circle,
                            color: Colors.orange,
                          ),
                          onPressed: () => debugPrint('Add')),
                      IconButton(
                          icon: new Icon(
                            Icons.favorite_border,
                            color: Colors.orange,
                          ),
                          onPressed: () => debugPrint('Mark as Favorite')),
                    ],
                  ),
                  Divider(
                    endIndent: 15,
                    height: 0,
                    color: Colors.grey,
                    thickness: 1.5,
                  ),
                  Container(
                    margin: EdgeInsets.all(30),
                    child: IntrinsicWidth(
                      //ทำให้ปุ่มกว้างเท่ากันไม่ได้
                      child: Row(
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              return Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (BuildContext context,
                                          Animation<double> animation,
                                          Animation<double>
                                              secondaryAnimation) {
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
                                      transitionDuration:
                                          Duration(milliseconds: 400)));
                            },
                            child: Text(
                              "Back",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderItemPage(),
                                ),
                              );
                            },
                            child: Text(
                              "View Order",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

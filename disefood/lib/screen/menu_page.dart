import 'package:disefood/component/sidemenu_customer.dart';
import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/screen/menu_order_detail_amount.dart';
import 'package:disefood/screen/order_items.dart';
import 'package:disefood/screen/view_order_page.dart';
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
    return WillPopScope(
      onWillPop: () async => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
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
          transitionDuration: Duration(milliseconds: 400),
        ),
      ),
      child: new Scaffold(
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
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Container(
                  width: 320,
                  height: 40,
                  child: FloatingActionButton.extended(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.orange,
                    elevation: 4.0,
                    label: const Text(
                      'ยืนยันรายการอาหาร',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderItemPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
                  return Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation) {
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
                      transitionDuration: Duration(milliseconds: 400),
                    ),
                  );
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
        body: SingleChildScrollView(
          child: Container(
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
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
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
                        height: 0,
                        color: Colors.grey,
                        thickness: 1.5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

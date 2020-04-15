import 'dart:async';
import 'package:disefood/component/sidemenu_customer.dart';
import 'package:disefood/screen/order_promptpay_page.dart';
import 'package:flutter/material.dart';

class OrderItemPage extends StatefulWidget {
  @override
  _OrderItemPageState createState() => _OrderItemPageState();
}

class _OrderItemPageState extends State<OrderItemPage> {
  var currenthours;
  var currentmin;
  var totalminute;
  var totalhour;
  int addTimeAmount = 5;
  Timer timer;
  bool isthisbuttonselected = true;
  @override
  void initState() {
    currenthours = DateTime.now().hour;
    // currenthours = 22;
    currentmin = DateTime.now().minute;
    // currentmin = 56;
    totalhour = currenthours;

    if (currentmin < 54) {
      totalminute = currentmin + 5;
    } else {
      totalhour = currenthours + 1;
      totalminute = (currentmin + 5) - 60;
    }
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

  void _getCurrentTime() {
    currenthours = DateTime.now().hour;
    currentmin = DateTime.now().minute;
  }

  void updateAddTimeStatus() {
    setState(
      () {
        if (totalminute >= 59) {
          totalminute = 0;
          if (totalhour >= 23) {
            totalhour = 0;
          } else {
            totalhour++;
          }
        } else {
          totalminute++;
        }
      },
    );
  }

  void updateMinusTimeStatus() {
    setState(
      () {
        if (addTimeAmount >= 5) {
          if (totalminute <= 0) {
            totalminute = 59;
            if (totalhour <= 0) {
              totalhour = 23;
            } else {
              totalhour--;
            }
          } else {
            totalminute--;
          }
        }
      },
    );
  }

  void addTime() {
    setState(() {
      addTimeAmount++;
    });
  }

  void setStateAddTime() {
    setState(() {});
  }

  void minusTime() {
    setState(() {
      if (addTimeAmount != 0) addTimeAmount--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 16, 5, 16),
                child: Text(
                  "View Order",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Icon(Icons.fastfood),
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                width: double.maxFinite,
                color: Colors.grey[400],
                child: Text(
                  "Order Summary",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(50, 20, 50, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "x2",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Noodle 1",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "45",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            indent: 40,
            endIndent: 40,
            thickness: 1.5,
            color: Colors.grey,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(50, 20, 50, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "x2",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Noodle 1",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "45",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
            indent: 40,
            endIndent: 40,
            thickness: 1.5,
            color: Colors.grey,
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                width: double.maxFinite,
                color: Colors.grey[400],
                child: Text(
                  "Recieve Time",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: IconButton(
                        icon: new Icon(
                          Icons.indeterminate_check_box,
                          color: Colors.orange,
                          size: 30,
                        ),
                        onPressed: () {
                          if (addTimeAmount > 5) {
                            minusTime();
                            updateMinusTimeStatus();
                          }
                        },
                      ),
                      onTapDown: (TapDownDetails details) {
                        timer = Timer.periodic(
                          Duration(milliseconds: 150),
                          (t) {
                            setState(
                              () {
                                if (addTimeAmount > 5) {
                                  minusTime();
                                  updateMinusTimeStatus();
                                }
                              },
                            );
                          },
                        );
                      },
                      onTapUp: (TapUpDetails details) {
                        timer.cancel();
                      },
                      onTapCancel: () {
                        timer.cancel();
                      },
                    ),
                    Text(
                      '$addTimeAmount นาที',
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      child: IconButton(
                        icon: new Icon(
                          Icons.add_box,
                          color: Colors.orange,
                          size: 30,
                        ),
                        onPressed: () {
                          addTime();
                          updateAddTimeStatus();
                        },
                      ),
                      onTapDown: (TapDownDetails details) {
                        timer = Timer.periodic(
                          Duration(milliseconds: 150),
                          (t) {
                            setState(
                              () {
                                addTime();
                                updateAddTimeStatus();
                              },
                            );
                          },
                        );
                      },
                      onTapUp: (TapUpDetails details) {
                        timer.cancel();
                      },
                      onTapCancel: () {
                        timer.cancel();
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      size: 25,
                    ),
                    Text(
                      "  เวลาที่จะไปรับอาหาร  :  ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '$totalhour.$totalminute  นาฬิกา',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
                width: double.maxFinite,
                color: Colors.grey[400],
                child: Text(
                  "Payment Method",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 205,
                    child: RaisedButton(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: BorderSide(
                          color: isthisbuttonselected
                              ? Colors.grey
                              : Colors.orange,
                          width: isthisbuttonselected ? 1 : 3,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 0, 2),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "พร้อมเพย์  ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Image.network(
                                "https://toppng.com/uploads/thumbnail//promptpay-logo-11551057371ufyvbrttny.png"),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PromptpayPage(),
                          ),
                        );
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 206,
                    child: RaisedButton(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                        side: BorderSide(
                          color: isthisbuttonselected
                              ? Colors.grey
                              : Colors.orange,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 0, 2),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "ทรูวอลเล็ท  ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 30,
                            child: Image.network(
                                "https://seeklogo.com/images/T/truemoney-wallet-logo-9CCDDD6CB0-seeklogo.com.png"),
                          ),
                        ],
                      ),
                      onPressed: () {},
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

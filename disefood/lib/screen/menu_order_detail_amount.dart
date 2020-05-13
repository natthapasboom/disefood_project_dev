import 'package:disefood/screen/menu_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderAmount extends StatefulWidget {
  final String foodName;
  final int foodPrice;
  final String foodImage;
  final int foodAmount;
  OrderAmount(
      {Key key, this.foodName, this.foodPrice, this.foodImage, this.foodAmount})
      : super(key: key);
  @override
  _OrderAmountState createState() =>
      _OrderAmountState(foodName, foodPrice, foodImage, foodAmount);
}

class _OrderAmountState extends State<OrderAmount> {
  String foodNameRecieve;
  int foodPriceRecieve;
  String foodImageRecieve;
  int foodAmount = 1;
  bool isFoodRemove = false;
  int totalPrice;
  _OrderAmountState(foodName, foodPrice, foodImage, foodAmount) {
    this.foodNameRecieve = foodName;
    this.foodPriceRecieve = foodPrice;
    this.foodImageRecieve = foodImage;
    this.totalPrice = foodPrice;
    if (foodAmount == null) {
      foodAmount = 1;
    } else {
      this.foodAmount = foodAmount;
    }
  }

  void add() {
    foodAmount++;
    checkButtonRemove();
    totalPrice = totalPrice + foodPriceRecieve;
    setState(() {});
  }

  void remove() {
    if (foodAmount > 0) {
      foodAmount--;
      checkButtonRemove();
      totalPrice = totalPrice - foodPriceRecieve;
      setState(() {});
    }
  }

  void checkButtonRemove() {
    if (foodAmount <= 0) {
      isFoodRemove = true;
      setState(() {});
    } else {
      isFoodRemove = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Center(
          child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: 23),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(),
                                  IconButton(
                                    icon: new Icon(
                                      Icons.close,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                "https://disefood.s3-ap-southeast-1.amazonaws.com/${foodImageRecieve}",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    child: Text(
                      "${foodNameRecieve}",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 10,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    child: Text(
                      "คำแนะนำพิเศษ",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextField(
                      style: new TextStyle(
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              'ใส่ข้อมูลระบุสำหรับอาหาร เช่น หวานน้อย เป็นต้น'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 70),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: new OutlineButton(
                            padding: EdgeInsets.only(right: 1),
                            child: new Icon(
                              Icons.remove,
                              size: 30,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              remove();
                            },
                            borderSide: BorderSide(
                                color: Colors.grey[350],
                                style: BorderStyle.solid,
                                width: 3),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          child: new Text(
                            '${foodAmount}',
                            style: new TextStyle(fontSize: 20.0),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: new OutlineButton(
                            padding: EdgeInsets.only(right: 1),
                            child: new Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              add();
                            },
                            borderSide: BorderSide(
                                color: Colors.grey[350],
                                style: BorderStyle.solid,
                                width: 3),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 50,
                    margin: EdgeInsets.only(top: 70),
                    child: Visibility(
                      visible: isFoodRemove,
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return MenuPage();
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
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8),
                        ),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                'นำออกจากตะกร้า',
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      replacement: RaisedButton(
                        color: Colors.orange,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return MenuPage();
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
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8),
                        ),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                'เพิ่มลงตะกร้า - ${totalPrice}',
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:disefood/screen/menu_page.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class OrderAmount extends StatefulWidget {
//   final int amounttempvalue;
//   OrderAmount({Key key, this.amounttempvalue}) : super(key: key);
//   @override
//   _OrderAmountState createState() => _OrderAmountState(amounttempvalue);
// }

// class _OrderAmountState extends State<OrderAmount> {
//   int amounttempvalue;
//   bool isbuttonpriceinvis = true;
//   bool isinvis;
//   int totalPrice = 45;
//   int amount;
//   String stramount = " ";
//   int price = 45;
//   String textbutton = "เพิ่มลงตะกร้า";
//   _OrderAmountState(this.amounttempvalue) {
//     if (amounttempvalue == null) {
//       amount = 1;
//     } else {
//       amount = this.amounttempvalue;
//       totalPrice = price * amount;
//     }
//   }

//   checkInvis() {
//     if (amount == 0) {
//       isinvis = false;
//     } else {
//       isinvis = true;
//     }
//   }

//   convertAmountIntToString() {
//     setState(() {
//       stramount = amount.toString();
//     });
//   }

//   changeText(int opt) {
//     setState(() {
//       if (opt == 1) {
//         textbutton = 'ลบรายการอาหาร';
//       } else {
//         textbutton = 'เพิ่มลงตะกร้า';
//       }
//     });
//   }

//   void add() {
//     setState(() {
//       amount++;
//     });
//   }

//   void minus() {
//     setState(() {
//       if (amount != 0) amount--;
//     });
//   }

//   void updateAddPrice() {
//     setState(() {
//       totalPrice = price * amount;
//     });
//   }

//   void updateRemovePrice() {
//     setState(() {
//       if (amount != 0) {
//         totalPrice -= price;
//       } else if (amount == 0) {
//         totalPrice = 0;
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       resizeToAvoidBottomPadding: false,
//       resizeToAvoidBottomInset: false,
//       body: SingleChildScrollView(
//         child: Center(
//           child: GestureDetector(
//             onTap: () {
//               FocusScopeNode currentFocus = FocusScope.of(context);
//               if (!currentFocus.hasPrimaryFocus) {
//                 currentFocus.unfocus();
//               }
//             },
//             child: Container(
//               margin: EdgeInsets.only(top: 23),
//               color: Colors.white,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Stack(
//                     children: <Widget>[
//                       Card(
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: 200,
//                           child: Column(
//                             children: <Widget>[
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Container(),
//                                   IconButton(
//                                     icon: new Icon(
//                                       Icons.close,
//                                       size: 30,
//                                     ),
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                               fit: BoxFit.fill,
//                               image: NetworkImage(
//                                 "https://www.seriouseats.com/2020/01/20200122-kal-guksu-anchovy-noodle-soup-vicky-wasik-5-1500x1125.jpg",
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Container(
//                     alignment: Alignment.centerLeft,
//                     padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
//                     child: Text(
//                       "Noodle",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                   ),
//                   Divider(
//                     color: Colors.grey[300],
//                     thickness: 10,
//                   ),
//                   Container(
//                     alignment: Alignment.centerLeft,
//                     padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
//                     child: Text(
//                       "คำแนะนำพิเศษ",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                   Container(
//                     padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                     child: TextField(
//                       style: new TextStyle(
//                         fontSize: 15,
//                       ),
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText:
//                               'ใส่ข้อมูลระบุสำหรับอาหาร เช่น หวานน้อย เป็นต้น'),
//                     ),
//                   ),
//                   Container(
//                     margin: EdgeInsets.only(top: 70),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         SizedBox(
//                           width: 40,
//                           height: 40,
//                           child: new OutlineButton(
//                             padding: EdgeInsets.only(right: 1),
//                             child: new Icon(
//                               Icons.remove,
//                               size: 30,
//                               color: Colors.orange,
//                             ),
//                             onPressed: () {
//                               minus();
//                               updateRemovePrice();
//                               if (amount == 0) {
//                                 changeText(1);
//                                 isbuttonpriceinvis = false;
//                               }
//                             },
//                             borderSide: BorderSide(
//                                 color: Colors.grey[350],
//                                 style: BorderStyle.solid,
//                                 width: 3),
//                             shape: new RoundedRectangleBorder(
//                               borderRadius: new BorderRadius.circular(8.0),
//                             ),
//                           ),
//                         ),
//                         Container(
//                           margin: EdgeInsets.all(20),
//                           child: new Text(
//                             '$amount',
//                             style: new TextStyle(fontSize: 20.0),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 40,
//                           height: 40,
//                           child: new OutlineButton(
//                             padding: EdgeInsets.only(right: 1),
//                             child: new Icon(
//                               Icons.add,
//                               size: 30,
//                               color: Colors.orange,
//                             ),
//                             onPressed: () {
//                               add();
//                               updateAddPrice();
//                               if (amount > 0) {
//                                 changeText(2);
//                                 isbuttonpriceinvis = true;
//                               }
//                             },
//                             borderSide: BorderSide(
//                                 color: Colors.grey[350],
//                                 style: BorderStyle.solid,
//                                 width: 3),
//                             shape: new RoundedRectangleBorder(
//                               borderRadius: new BorderRadius.circular(8.0),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     width: 300,
//                     height: 50,
//                     margin: EdgeInsets.only(top: 70),
//                     child: RaisedButton(
//                       onPressed: () {
//                         checkInvis();
//                         convertAmountIntToString();
//                         Navigator.push(
//                           context,
//                           PageRouteBuilder(
//                             pageBuilder: (BuildContext context,
//                                 Animation<double> animation,
//                                 Animation<double> secondaryAnimation) {
//                               FoodsList();
//                               return MenuPage();
//                             },
//                             transitionsBuilder: (BuildContext context,
//                                 Animation<double> animation,
//                                 Animation<double> secondaryAnimation,
//                                 Widget child) {
//                               return FadeTransition(
//                                 opacity: Tween<double>(
//                                   begin: 0,
//                                   end: 1,
//                                 ).animate(animation),
//                                 child: child,
//                               );
//                             },
//                             transitionDuration: Duration(milliseconds: 400),
//                           ),
//                         );
//                       },
//                       shape: new RoundedRectangleBorder(
//                         borderRadius: new BorderRadius.circular(8),
//                       ),
//                       color: isbuttonpriceinvis ? Colors.orange : Colors.red,
//                       child: Container(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             new Text(
//                               '$textbutton',
//                               style: new TextStyle(
//                                   color: Colors.white, fontSize: 18),
//                             ),
//                             Visibility(
//                               visible: isbuttonpriceinvis,
//                               child: new Text(
//                                 ' - $totalPrice บาท',
//                                 style: new TextStyle(
//                                     color: Colors.white, fontSize: 18),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

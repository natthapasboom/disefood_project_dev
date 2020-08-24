import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/screen/order_items.dart';
import 'package:disefood/screen/view_order_page.dart';
import 'package:flutter/material.dart';
import 'home_customer.dart';
import 'menu_order_detail_amount.dart';

class keepdataPage extends StatefulWidget {
  @override
  _keepdataPageState createState() => _keepdataPageState();
}

class _keepdataPageState extends State<keepdataPage> {
  int listsize = 10;
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
      child: Scaffold(
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
                    return
                        // Navigator.pop(context);
                        Navigator.push(
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
                onPressed: () => debugPrint('asd'),
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
                  CachedNetworkImage(
                    imageUrl:
                        // 'https://disefood.s3-ap-southeast-1.amazonaws.com/$shopImg',
                        'https://www.matichon.co.th/wp-content/uploads/2019/03/Pic-Little-Wild_190308_0022.jpg',
                    height: 200,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: -1,
                          blurRadius: 10,
                          offset: Offset(0, -8), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          padding: EdgeInsets.only(left: 45),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "0" + "shopId",
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
                                    " shopName",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text("ShopTypeValue"),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        color: Colors.orangeAccent,
                                        size: 20,
                                      ),
                                      Text("RateStarsValue"),
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

                        //
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.white,
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
                            SizedBox(width: 45),
                            Text(
                              "ราคา",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          width: double.maxFinite,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: listsize,
                            itemBuilder: (context, index) {
                              return Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Visibility(
                                        visible: false,
                                        child: SizedBox(
                                          width: 25,
                                          child: Text(
                                            "testinvis",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.orange),
                                          ),
                                        ),
                                        replacement: SizedBox(
                                          width: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 140,
                                        child: Text('foodName'),
                                      ),
                                      SizedBox(
                                        width: 30,
                                        child: Text(
                                          '10',
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      IconButton(
                                        icon: new Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderAmount(),
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: new Icon(
                                          Icons.favorite_border,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black,
                                    height: 0,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

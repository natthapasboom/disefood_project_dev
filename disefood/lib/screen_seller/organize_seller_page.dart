import 'dart:convert';
import 'package:disefood/component/sidemenu_seller.dart';
import 'package:disefood/model/foods_list.dart';
import 'package:disefood/screen_seller/home_seller.dart';
import 'package:disefood/screen_seller/widget/organize_seller.dart';
import 'package:disefood/services/foodservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:disefood/services/foodservice.dart';
import 'editmenu.dart';

class OrganizeSellerPage extends StatefulWidget {
  static final route = "/organize_seller";
  @override
  _OrganizeSellerPageState createState() => _OrganizeSellerPageState();
}

class _OrganizeSellerPageState extends State<OrganizeSellerPage> {
  FoodsList foodslist = FoodsList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.only(left: 0, top: 0, right: 170),
            child: Center(
              child: Text(
                "Organize",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      drawer: SideMenuSeller(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 40, top: 30),
            child: Text(
              "รายการอาหาร",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
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
            child: FutureBuilder(
                future: getFoodsData(http.Client()),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.data);
                  if (snapshot.data == null) {
                    return Container(
                      margin: EdgeInsets.only(top: 200),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                leading:  Container(
                                    margin: EdgeInsets.only(
                                      left: 30,
                                    ),
                                    child: Text(
                                      '${snapshot.data[index].name}',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                
                                trailing: Wrap(
                                  spacing: 12, // space between two icons
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 13),
                                      child: Text(
                                        '${snapshot.data[index].price}',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: snapshot.hasData
                                          ? IconButton(
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
                                                              foodslist:
                                                                  snapshot.data[
                                                                      index],
                                                            )));
                                              })
                                          : IconButton(
                                              icon: Icon(
                                                Icons.add_circle,
                                                color: Colors.amber[800],
                                              ),
                                              onPressed: () {},
                                            ),
                                    ),
                                    // icon-1
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

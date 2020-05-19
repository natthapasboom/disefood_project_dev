import 'package:disefood/model/foods_list.dart';
import 'package:disefood/services/foodservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'editmenu.dart';

class OrganizeSellerPage extends StatefulWidget {
  static final route = "/organize_seller";
  @override
  _OrganizeSellerPageState createState() => _OrganizeSellerPageState();
}

class _OrganizeSellerPageState extends State<OrganizeSellerPage> {
  FoodsList foodslist = FoodsList();

  @override
  void initState() {
    Future.microtask(() async {
      fetchNameFromStorage();
    });
    super.initState();
  }

  int _shopId;
  String _name;

  Future fetchNameFromStorage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final name = _prefs.getString('first_name');
    final shopId = _prefs.getInt('shop_id');
    setState(() {
      _name = name;
      _shopId = shopId;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Name = $_name");
    print('$_shopId');

    // final OrganizeSellerPage params = ModalRoute.of(context).settings.arguments;
    return Scaffold(
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
                future: getFoodsDataByID(http.Client(), _shopId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.data);
                  if (snapshot.data == null) {
                    return Container(
                      margin: EdgeInsets.only(top: 200),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.amber[900],
                        ),
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
                                leading: Container(
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
          Container(
            child: ListTile(
              leading: Container(
                margin: EdgeInsets.only(
                  left: 30,
                ),
                child: Text(
                  'เพิ่มรายการอาหาร',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.amber[800],
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

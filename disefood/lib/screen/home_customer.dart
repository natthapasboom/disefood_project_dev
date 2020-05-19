import 'package:disefood/model/shops_list.dart';
import 'package:disefood/services/shopservice.dart';
import 'package:disefood/screen/login_customer_page.dart';
import 'package:disefood/screen/menu_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:disefood/component/sidemenu_customer.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
   
  static const routeName = '/home_customer';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String nameUser;
  String lastNameUser;
  int userId;
  String coverImg;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      findUser();
    });
  }
    Future<Null> findUser() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preference.getString('first_name');
      userId = preference.getInt('user_id');
      lastNameUser = preference.getString('last_name');
      coverImg = preference.getString('profile_img');
    });
  }

  @override
  Widget build(BuildContext context) {
     
    return WillPopScope(
      onWillPop: () async => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return LoginPage();
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
        appBar: AppBar(
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.favorite),
              onPressed: () => debugPrint('favorites'),
            ),
            new IconButton(
              icon: Icon(Icons.archive),
              onPressed: () => debugPrint("archive"),
            ),
          ],
        ),
        drawer: SideMenuCustomer(
          firstName: nameUser,
          userId: userId,
          lastName: lastNameUser,
          coverImg: coverImg,
        ), //EndAppbar
        body: FutureBuilder<List<Shops>>(
            future: fetchShops(http.Client()),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return Column(
                  children: <Widget>[
                    headerSection,
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MenuPage(
                                      shopId: snapshot.data[index].shopId,
                                      shopName: snapshot.data[index].name,
                                      shopImage:
                                          'https://disefood.s3-ap-southeast-1.amazonaws.com/${snapshot.data[index].coverImage}'),
                                ),
                              );
                            },
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 5,
                              color: Colors.white70,
                              margin: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 40, right: 40),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Image.network(
                                      'https://disefood.s3-ap-southeast-1.amazonaws.com/${snapshot.data[index].coverImage}',
                                      width: 380,
                                      height: 210,
                                      fit: BoxFit.cover),
                                  ListTile(
                                    title: Text(
                                      "${snapshot.data[index].name}",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.star,
                                          color: Colors.orange,
                                        ),
                                        Text("  4.2 Review(20 Review)")
                                      ],
                                    ),
                                  ),
                                ],
//          crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}


Widget headerSection = new Material(
  child: Container(
    padding: EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0), bottomRight: Radius.circular(0)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 6.0,
        ),
      ],
    ),
    child: Column(
      children: <Widget>[
        new Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: new Column(
            children: [
              TextFormField(
                decoration: new InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  labelText: "โปรดใส่ชื่อร้านอาหารที่ต้องการค้นหา",
                  filled: true,
                  fillColor: Colors.white10,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  //fillColor: Colors.green
                ),
              ),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
              alignment: Alignment.topLeft,
              child: Text(
                "รายการร้านอาหาร",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);

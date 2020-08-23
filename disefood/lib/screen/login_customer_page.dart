import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:disefood/component/dialogcomponents/alert_dialog.dart';
import 'package:disefood/component/register.dart';
import 'package:disefood/model/shop_id.dart';
import 'package:disefood/model/user_profile.dart';
import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/screen_admin/home.dart';
import 'package:disefood/screen_seller/addmenu.dart';
import 'package:disefood/screen_seller/home_seller.dart';
import 'package:disefood/screen_seller/home_seller_tab.dart';
import 'package:disefood/screen_seller/order_seller_page.dart';
import 'package:disefood/screen_seller/organize_seller_page.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/src/response.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/Login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _obscureText = true;

  final logger = Logger();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  ApiProvider apiProvider = ApiProvider();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<UserProfile> list = List();

  Future<UserProfile> _login() async {
    print('before validate ==> ');

    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      print('after validate ==> ');
      String url = "http://10.0.2.2:8080/api/login";
      try {
        print('after try ==> ');
        var username = _usernameController.text.trim();
        var password = _passwordController.text.trim();
        var response = await apiProvider.doLogin(username, password);
      

        print(response.statusCode);
        if (response.statusCode == 200) {
          Map map = json.decode(response.body);
          UserProfile msg = UserProfile.fromJson(map);
          var data = msg.data.toJson();
          String role = msg.data.role;
          // logger.d(data);
          if (role == "admin") {
              routeToService(HomeAdmin(),msg);
          } else if (role == "customer") {
              routeToService(Home(),msg);
          } else if (role == "seller") {
              routeToService(Homepage(),msg);
          }

        
        } else {
          print('error code');
          setState(() {
            _isLoading = false;
          });
        }
      } catch (error) {
        print('error: $error');
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      alertDialog(context, "กรุณากรอกใหม่");
    }
  }

  Future<Null> routeToService(Widget myWidget,UserProfile userprofile) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.setInt('user_id', userprofile.data.id);
    await preference.setString('token',  userprofile.token);
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.amber[900],
              ),
            )
          : Stack(
              children: <Widget>[
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Cafeteria',
                              style: TextStyle(
                                  fontSize: 36,
                                  color: Colors.amber[900],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Management System',
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.amber[700],
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 40.0,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'โปรดกรอกไอดี';
                                }
                              },
                              controller: _usernameController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.account_circle),
                                contentPadding: const EdgeInsets.only(left: 20),
                                hintText: 'ไอดี',
                                hintStyle: TextStyle(
                                    color: Colors.black38, fontSize: 18),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.black38)),
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide:
                                      new BorderSide(color: Colors.black38),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: TextFormField(
                              obscureText: _obscureText,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'โปรดกรอกรหัสผ่าน';
                                }
                              },
                              cursorColor: Colors.white,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                contentPadding: const EdgeInsets.only(left: 20),
                                hintText: 'รหัสผ่าน',
                                hintStyle: TextStyle(
                                    color: Colors.black38, fontSize: 18),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        BorderSide(color: Colors.black38)),
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide:
                                      new BorderSide(color: Colors.black38),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: RaisedButton(
                              onPressed: () {
                                _login();
                              },
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  'ลงชื่อเข้าใช้',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              color: Colors.amber[600],
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 5),
                                  child: RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Regis()),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'สมัครสมาชิก',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    color: Colors.amber[900],
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.amber[900],
                                          width: 1,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 10),
                                  child: RaisedButton(
                                    onPressed: () {},
                                    child: Padding(
                                      padding: EdgeInsets.all(17.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'FACEBOOK',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.blue,
                                          width: 1,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

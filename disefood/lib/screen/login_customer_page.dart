import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:disefood/component/dialogcomponents/alert_dialog.dart';
import 'package:disefood/component/register.dart';
import 'package:disefood/model/message.dart';
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
        var message = response.isRedirect.toString();
        print(response.statusCode);
        if (response.statusCode == 200) {
          Map map = json.decode(response.body);
          UserProfile msg = UserProfile.fromJson(map);

          var data = msg.data.toJson();
          String role = msg.data.role;
          // logger.d(data);
          if (role == "admin") {
            routeToService(HomeAdmin(), msg);
          } else if (role == "customer") {
            routeToService(Home(), msg);
          } else if (role == "seller") {
            routeToService(Homepage(), msg);
          }
        } else if (response.statusCode == 401) {
          print('error code');
          Map map = json.decode(response.body);
          Message msg = Message.fromJson(map);
          print('message: ${msg.msg}');
          setState(() {
            dialogError(context, msg.msg);
            _isLoading = false;
          });
        }
      } catch (error) {
        print('error: $error');
        setState(() {
          _isLoading = false;
          // dialogError(
          //   context,
          // );
        });
      }
    } else {
      alertDialog(context, "กรุณากรอกใหม่");
    }
  }

  Future<Null> routeToService(Widget myWidget, UserProfile userprofile) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    await preference.setInt('user_id', userprofile.data.id);
    await preference.setString('token', userprofile.accessToken);
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 5.0,
                valueColor: AlwaysStoppedAnimation(const Color(0xffF6A911)),
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

  Future<void> dialogError(BuildContext context, String msg) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  height: 300.0,
                  width: 300.0,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          // Container(height: 150.0),
                          // Container(
                          //   height: 100.0,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.only(
                          //         topLeft: Radius.circular(10.0),
                          //         topRight: Radius.circular(10.0),
                          //       ),
                          //       color: Colors.red),
                          // ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 40),
                              height: 90.0,
                              width: 90.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Cross_red_circle.svg/1024px-Cross_red_circle.svg.png'),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              top: 5, left: 10, right: 10, bottom: 0),
                          child: Center(
                            child: Text(
                              'ไอดี หรือ รหัสผ่านผิด',
                              style: TextStyle(
                                fontFamily: 'Aleo-Bold',
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              top: 5, left: 10, right: 10, bottom: 5),
                          child: Center(
                            child: Text(
                              'กรุณากรอกฟอร์มใหม่',
                              style: TextStyle(
                                fontFamily: 'Aleo-Bold',
                                fontSize: 18.0,
                                color: Colors.black38,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                      SizedBox(height: 10.0),
                      Container(
                        margin:
                            EdgeInsets.only(top: 5, left: 90.0, right: 90.0),
                        child: RaisedButton(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side:
                                    BorderSide(color: const Color(0xffF6A911))),
                            child: Center(
                              child: Text(
                                'ตกลง',
                                style: TextStyle(
                                    fontFamily: 'Aleo-Bold',
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: const Color(0xffF6A911)),
                      )
                    ],
                  )));
        });
  }
}

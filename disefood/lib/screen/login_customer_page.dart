import 'dart:convert';

import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  ApiProvider apiProvider = ApiProvider();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Future _login() async {
    if (_formKey.currentState.validate()) {
      try {
        var response = await apiProvider.doLogin(
            _usernameController.text, _passwordController.text);
        if (response.statusCode == 200) {
          print(response.body);
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['ok']) {
            String token = jsonResponse['token'];
            print(token);
            SharedPreferences prefs =
                await SharedPreferences.getInstance(); // ใช้เก็บ token
            await prefs.setString('token', token);
             Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
            // redirect

            print(jsonResponse['error']);
          }
        } else {
          print('Connection error');
        }
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                fit: BoxFit.cover,
                image: new NetworkImage(
                    'https://wallpaperaccess.com/full/718077.jpg'),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Image.network(
                        "https://seeklogo.com/images/B/business-people-circle-logo-83C8022853-seeklogo.com.png",
                        width: 100,
                      ),
                    ),
                    SizedBox(
                      height: 70.0,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return 'โปรดกรอกไอดี';
                          }
                        },
                        controller: _usernameController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20),
                          hintText: 'ไอดี',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return 'โปรดกรอกรหัสผ่าน';
                          }
                        },
                        cursorColor: Colors.white,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 20),
                          hintText: 'รหัสผ่าน',
                          hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(color: Colors.white),
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
                    RaisedButton(
                      onPressed: () {
                        _login();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'ลงชื่อเข้าใช้',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      color: Colors.orange[800],
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),

                    SizedBox(
                      height: 12.0,
                    ),
                    // Row(
                    //   children: <Widget>[
                    //     Expanded(
                    //       child: Divider(
                    //         color: Colors.white,
                    //         height: 8.0,
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: 8.0,
                    //     ),
                    //     Text(
                    //       'OR',
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //     SizedBox(
                    //       width: 8.0,
                    //     ),
                    //     Expanded(
                    //       child: Divider(
                    //         color: Colors.white,
                    //         height: 8.0,
                    //       ),
                    //     )
                    //   ],
                    // ),
                    FlatButton(
                      onPressed: () {},
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.network(
                              "https://i.ya-webdesign.com/images/white-png-image-4.png",
                              width: 25,
                            ),
                            Text(
                              '   ลงชื่อเข้าใช้ด้วยเฟซบุ้ค',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      color: Colors.transparent,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.white,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    // Center(
                    //   child: Container(
                    //     width: 75,
                    //     child: FlatButton(
                    //       onPressed: () {},
                    //       child: Image.network(
                    //         "https://cdn4.iconfinder.com/data/icons/social-messaging-ui-color-shapes-2-free/128/social-facebook-circle-512.png",
                    //       ),
                    //     ),
                    //   ),
                    // ),
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

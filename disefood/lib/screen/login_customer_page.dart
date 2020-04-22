import 'package:disefood/screen/home_customer.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: 'ชื่อผู้ใช้'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        hintText: 'รหัสผ่าน'),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  RaisedButton(
                    onPressed: () {
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
        ],
      ),
    );
  }
}

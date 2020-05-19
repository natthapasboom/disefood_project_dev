import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:disefood/model/user_profile.dart';
import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/screen_seller/home_seller.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/Login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  ApiProvider apiProvider = ApiProvider();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<UserProfile> list = List();

  Future<List<UserProfile>> _login() async {
    print('before validate ==> ');
    if (_formKey.currentState.validate()) {
      print('after validate ==> ');
      String url = "http://10.0.2.2:8080/api/login";
      try {
        print('after try ==> ');
        Dio dio = Dio();
          dio.options.headers['content-Type']='application/json';
       
        Response response = await dio.post(
          url,
          data: {
          "username": _usernameController.text.trim(),
          "password": _passwordController.text.trim(),
        
          },
          );
         
        print(response.statusCode);
        if (response.statusCode == 200) {
          print('response : ${response.data}');
          print('Success');
           
           var result = UserProfile.fromJson(response.data[0]);
            print('result : ${result.isSeller}');
            print('id : ${result.userId}');
            
               if(result.isSeller == 1){
                      Navigator.of(context).pushReplacementNamed(HomeSeller.routeName,arguments: HomeSeller(userData: result,));
               }else if (result.isSeller == 0){
                      Navigator.of(context).pushReplacementNamed(Home.routeName,arguments: Home());
                      // userData: result,
                  // Navigator.of(context).pushReplacementNamed(Home.routeName,arguments: );
               }
          
            // 
          // for(var map in result){
          //   UserProfile userProfile = UserProfile.fromJson(map);
          //   print(userProfile);
          //   // if(userProfile.isSeller == 1){
          //   //   Navigator.of(context).pushReplacementNamed(HomeSeller.routeName);
          //   // }
          // }
          // var jsonData = UserProfile.fromJson(response.data);
          // print('json data : $jsonData');
            // if(jsonData.isSeller == 1){
            //     Navigator.of(context).pushReplacementNamed(HomeSeller.routeName);
            // }


         
        } else {
          print('error code');
         
        }
       
      } catch (error) {
        print('error: $error');
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
                      child: Text('Login',style: TextStyle(fontSize: 48,color: Colors.white,fontWeight: FontWeight.bold),),
                      // child: Image.network(
                      //   "https://seeklogo.com/images/B/business-people-circle-logo-83C8022853-seeklogo.com.png",
                      //   width: 100,
                      // ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                    RaisedButton(
                      
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
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.blue,
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

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:disefood/screen/login_customer_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

class Regis extends StatefulWidget {
  static const routeName = '/Regis';
  @override
  _RegisState createState() => _RegisState();
}

class _RegisState extends State<Regis> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  final logger = Logger();
  File _image;
  ApiProvider apiProvider = ApiProvider();
  String status;
  var uuid = Uuid();

  Future<void> getImage(ImageSource imageSource) async {
    try {
      var image = await ImagePicker.pickImage(
          source: imageSource, maxWidth: 400.0, maxHeight: 400.0);

      setState(() {
        _image = image;
      });
    } catch (e) {}
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "โปรดกรอกอีเมลล์";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'กรุณากรอกอีเมลล์ใหม่';
  }

  bool isValidEmail(value) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }

  Future<String> _register() async {
    print('before validate ==> ');
    if (_formKey.currentState.validate()) {
      print('after validate ==> ');
      String username = _usernameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();
      String tel = _phoneController.text.trim();

      String url = 'http://54.151.194.224:8000/api/auth/register';
      String fileName = _image.path.split('/').last;
      print('after try ==> ');
      FormData formData = FormData.fromMap({
        "username": username,
        "email": email,
        "password": password,
        "first_name": firstName,
        "last_name": lastName,
        "tel": tel,
        "profile_img":
            await MultipartFile.fromFile(_image.path, filename: fileName),
        "role": status,
      });
      print(formData.fields);
      // print(formData.files);
      print('data : $formData');
      var response = await Dio().post(
        url,
        data: formData,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );

      print('res : $response');
      print('res : ${response.data}');
      print(response.statusCode);
      if (response.statusCode == 200) {
        dialogSucces(context);
      } else {
        dialogError(context);
        print('error code');
      }

      print('res : $response');
    }
      dialogError(context);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.yellow[900],
                Colors.orange[300],
                Colors.orange[200]
              ]),
        ),
        child: ListView(
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: Text(
                    'สมัครสมาชิก',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    _image == null
                        ? CircleAvatar(
                            backgroundColor: Colors.amber[500],
                            radius: 60,
                            child: Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.white,
                            ),
                          )
                        : CircleAvatar(
                            radius: 60,
                            child: ClipOval(
                              child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                                height: 150,
                                width: 300,
                              ),
                            ),
                          ),
                    Positioned(
                      right: 130,
                      bottom: 0,
                      width: 45,
                      child: FloatingActionButton(
                          backgroundColor: Colors.amber[900],
                          onPressed: () {
                            getImage(ImageSource.gallery);
                            setState(() {
                              Image.file(_image);
                            });
                          },
                          child: Icon(Icons.add_a_photo)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 20,
                ),
                child: _buildfrom(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildfrom() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'โปรดกรอกไอดี';
                }
              },
              maxLength: 50,
              controller: _usernameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'กรอกไอดี',
                hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Colors.white),
                ),
                errorBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'โปรดกรอกรหัสผ่าน';
                }
              },
              // onChanged: (value) =>
              //   _passwordController.text = value.trim()
              // ,
              cursorColor: Colors.white,
              maxLength: 50,

              controller: _passwordController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'กรอกรหัสผ่าน',
                hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Colors.white),
                ),
                errorBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'โปรดกรอกชื่อ';
                }
              },
              // onChanged: (value) =>
              //   _firstNameController.text = value.trim()
              // ,
              maxLength: 50,
              controller: _firstNameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'กรอกชื่อ',
                hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Colors.white),
                ),
                errorBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'โปรดกรอกนามสกุล';
                }
              },
              // onChanged: (value) =>
              //   _lastNameController.text = value.trim()
              // ,
              maxLength: 50,
              controller: _lastNameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'กรอกนามสกุล',
                hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Colors.white),
                ),
                errorBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.length != 10) {
                  return 'โปรดกรอกให้ครบ10หลัก';
                }
                if (value.isEmpty) {
                  return 'โปรดกรอกเบอร์โทร';
                }
                // if(value != 9){
                //   return 'โปรดกรอกให้ครบ10หลัก';
                // }
              },
              //
              maxLength: 10,
              controller: _phoneController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'กรอกเบอร์โทร',
                hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Colors.white),
                ),
                errorBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: TextFormField(
              validator: _validateEmail,
              // onFieldSubmitted: (value) {
              //   if (isValidEmail(value)) {
              //     logger.d(value);
              //   } else {
              //     logger.e('โปรดกรอกอีเมลล์ให้ถูกต้อง');
              //   }
              // },
              // validator: (value) {
              //   if (isValidEmail(value)) {
              //     logger.d(value);
              //   } else {
              //     return 'โปรดกรอกอีเมลล์ให้ถูกต้อง';
              //   }
              // },
              //
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              maxLength: 50,
              controller: _emailController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'กรอกอีเมลล์',
                hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Colors.white),
                ),
                errorBorder: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                  borderSide: new BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
          Container(
            child: Container(
              margin: EdgeInsets.only(left: 50, top: 20),
              child: Text(
                'เลือกสถานะ',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          _radiocheck(),
          _buttonRegister(),
          _buttonCancel(),
        ],
      ),
    );
  }

  Widget _buttonRegister() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Center(
        child: RaisedButton(
          color: Colors.green,
          onPressed: () {
            _register();
          },
          child: Container(
            padding:
                EdgeInsets.only(left: 120, right: 120, top: 10, bottom: 10),
            child: Text(
              'สมัคร',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonCancel() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: Center(
        child: RaisedButton(
          color: Colors.red,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Container(
            padding:
                EdgeInsets.only(left: 120, right: 120, top: 10, bottom: 10),
            child: Text(
              'ยกเลิก',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> dialogError(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  height: 300.0,
                  width: 200.0,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(height: 150.0),
                          // Container(
                          //   height: 100.0,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.only(
                          //         topLeft: Radius.circular(10.0),
                          //         topRight: Radius.circular(10.0),
                          //       ),
                          //       color: Colors.red),
                          // ),
                          Positioned(
                              top: 30.0,
                              left: 94.0,
                              child: Container(
                                height: 90.0,
                                width: 90.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/red-cross.png'),
                                      fit: BoxFit.cover,
                                    )),
                              ))
                        ],
                      ),
                      SizedBox(height: 0.0),
                      Container(
                          margin: EdgeInsets.only(
                              top: 0, left: 10, right: 10, bottom: 0),
                          child: Center(
                            child: Text(
                              'มีอะไรผิดพลาด',
                              style: TextStyle(
                                fontFamily: 'Aleo-Bold',
                                fontSize: 18.0,
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                      SizedBox(height: 10.0),
                      Container(
                        margin:
                            EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                        child: RaisedButton(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
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

  Future<void> dialogSucces(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  height: 300.0,
                  width: 200.0,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(height: 150.0),
                          // Container(
                          //   height: 100.0,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.only(
                          //         topLeft: Radius.circular(10.0),
                          //         topRight: Radius.circular(10.0),
                          //       ),
                          //       color: Colors.red),
                          // ),
                          Positioned(
                              top: 30.0,
                              left: 94.0,
                              child: Container(
                                height: 90.0,
                                width: 90.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/success.png'),
                                      fit: BoxFit.cover,
                                    )),
                              ))
                        ],
                      ),
                      SizedBox(height: 0.0),
                      Container(
                          margin: EdgeInsets.only(
                              top: 0, left: 10, right: 10, bottom: 0),
                          child: Center(
                            child: Text(
                              'สมัครสมาชิก',
                              style: TextStyle(
                                fontFamily: 'Aleo-Bold',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              top: 5, left: 10, right: 10, bottom: 5),
                          child: Center(
                            child: Text(
                              'สำเร็จ',
                              style: TextStyle(
                                fontFamily: 'Aleo-Bold',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                      SizedBox(height: 10.0),
                      Container(
                        margin:
                            EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                        child: RaisedButton(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.green)),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            color: Colors.green),
                      )
                    ],
                  )));
        }).then((value) {});
  }

  Widget _radiocheck() {
    return Container(
      margin: EdgeInsets.only(left: 40),
      child: Column(
        children: <Widget>[
          RadioListTile(
            title: Text(
              "พ่อค้า / แม่ค้า",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            value: "seller",
            groupValue: selectedRadio,
            onChanged: (newValue) {
              print(' value : $newValue');
              // print("Radio $val");
              setState(() {
                setSelectedRadio(newValue);
                status = "seller";
                print(' Status :  $status');
              });
            },
            activeColor: Colors.amber[900],
          ),
          RadioListTile(
            title: Text(
              "ผู้ใช้งาน",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            value: "customer",
            groupValue: selectedRadio,
            onChanged: (newValue) {
              setState(() {
                status = "customer";
                setSelectedRadio(newValue);
                print(' Status :  $status');
              });
            },
            activeColor: Colors.amber[900],
          ),
        ],
      ),
    );
  }

  String selectedRadio = '';
  void initState() {
    selectedRadio = '';
    // selectedRadio = false;
    super.initState();
  }

  setSelectedRadio(String val) {
    setState(() {
      selectedRadio = val;
    });
  }
}

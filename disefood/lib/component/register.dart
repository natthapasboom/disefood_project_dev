import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:disefood/screen/login_customer_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http_parser/http_parser.dart';
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
  File _image;
  ApiProvider apiProvider = ApiProvider();
  bool status;
  var uuid = Uuid();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future<Null> _register() async {
    print('before validate ==> ');
    if (_formKey.currentState.validate()) {
      print('after validate ==> ');
      // String url = "http://321514e0.ngrok.io/api/user";
      String url = 'http://10.0.2.2:8080/api/user';

      try {
        print('after try ==> ');
        Dio dio = Dio();
        // dio.options.headers['Content-Type'] = 'multipart/form-data';
        var formData = FormData.fromMap({
          "username": _usernameController.text.trim(),
          "password": _passwordController.text.trim(),
          "first_name": _firstNameController.text.trim(),
          "last_name": _lastNameController.text.trim(),
          "tel": _phoneController.text.trim(),
          "profile_img": await MultipartFile.fromFile(
            '${_image.path}',
            filename: '${uuid.v4()}.jpeg',
             
          ),
          "is_seller": status,
        });
        print(formData.fields);
        print(formData.files.toString());
        // print(formData.files);
        print('data : $formData');
        Response response = await dio.post(
          url,
          data: formData,
          options: Options(
            headers: {
              'Headers' : 'multipart/form-data',
              'Accept' : '*/*',
            }
          )
          // data: formData,
          // data: formData,
          // options:  Options(
          //  followRedirects: false,
          //  validateStatus: (status) { return status < 500; }
          //   ),
          // data: formData,
          // data:{
          // "username": _usernameController.text.trim(),
          // "password": _passwordController.text.trim(),
          // "first_name": _firstNameController.text.trim(),
          // "last_name": _lastNameController.text.trim(),
          // "tel": _phoneController.text.trim(),

          // // "profile_img": await MultipartFile.fromFile(
          // //     _image.path,
          // //      filename: '${uuid.v4()}.png',
          // // ) ,
          // "is_seller": status,
          // },
        );

        print('res : $response');
        print('res : ${response.data}');
        print(response.statusCode);
        if (response.statusCode == 200) {
          print('response : ${response.data}');
          print('Success');
          Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
         
        } else {
          print('error code');
         
        }
        print('res : $response');
      } catch (error) {
        print('error: $error');
      }
    }
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
                            getImage();
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
                hintText: 'ไอดี',
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
                hintText: 'รหัสผ่าน',
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
                hintText: 'ชื่อ',
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
                hintText: 'นามสกุล',
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
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                
                if(value.length != 10){
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
                hintText: 'เบอร์โทร',
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
            padding: EdgeInsets.only(left: 120, right: 120, top: 10, bottom: 10),
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
            padding: EdgeInsets.only(left: 120, right: 120, top: 10, bottom: 10),
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
            value: true,
            groupValue: selectedRadio,
            onChanged: (bool newValue) {
              print(' value : $newValue');
              // print("Radio $val");
              setState(() {
                setSelectedRadio(newValue);
                status = newValue;
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
            value: false,
            groupValue: selectedRadio,
            onChanged: (bool newValue) {
              setState(() {
                status = newValue;
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

  bool selectedRadio = false;
  void initState() {
    selectedRadio = null;
    // selectedRadio = false;
    super.initState();
  }

  setSelectedRadio(bool val) {
    setState(() {
      selectedRadio = val;
    });
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Regis extends StatefulWidget {
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
  

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image =  image;
    });
  }

  Future<void> _register() async {
    print('before validate ==> ');
    if (_formKey.currentState.validate()) {
      print('after validate ==> ');
      String url = "http://10.0.2.2:8080/api/user";
      try {
        print('after try ==> ');
        Dio dio = Dio();
        var formData = FormData.fromMap({
          "username": _usernameController.text.trim(),
          "password": _passwordController.text.trim(),
          "first_name": _firstNameController.text.trim(),
          "last_name": _lastNameController.text.trim(),
          "tel": _phoneController.text.trim(),
          "profile_img":_image,
          "is_seller": status,
        });
        print(formData.fields);
        print('data : $formData');
        Response response = await dio.post(url,data: formData);
        print('res : $response');
        print(response.statusCode);
        if (response.statusCode == 200) {
          print('response : ${response.data}');
          print('Success');
          // Scaffold.of(context).showSnackBar(new SnackBar(
          //   content: new Text("User Info Updated"),
          // ));
        } else {
          print('error code');
          // Map<String, dynamic> _responseMap = json.decode(response.data);
          // Scaffold.of(context).showSnackBar(new SnackBar(
          //   content: new Text(_responseMap['message']),
          // ));
        }
        print('res : $response');
      } catch (error) {
        print('error: $error');
      }
    }
  }

  // Future<http.Response> _register() async {

  //   if (_formKey.currentState.validate()) {

  //     try {
  //        var response = await apiProvider.doRegister1(

  //           _usernameController.text,
  //           _passwordController.text,
  //           _firstNameController.text,
  //           _lastNameController.text,
  //           _phoneController.text,
  //           _image,

  //           status,
  //           );

  //       print(response.statusCode);
  //       print('status:   $response');
  //       if (response.statusCode == 200 )  {
  //         print('body = ${response.body}');
  //         var jsonResponse = json.decode(response.body);
  //         if (jsonResponse['ok']) {
  //           String token = jsonResponse['token'];

  //           print(token);
  //           SharedPreferences prefs =
  //               await SharedPreferences.getInstance(); // ใช้เก็บ token
  //           await prefs.setString('token', token);

  //           // redirect

  //           print(jsonResponse['error']);
  //         }
  //       } else {
  //         print('Connection error');
  //       }
  //     } catch (error) {
  //       print('Error : $error');

  //     }

  //   }

  // }

  // Future<void> _register() async{
  //   try{
  //       print('before register =>');

  //       final user = await apiProvider.dioRegister(
  //       username : _usernameController.text,
  //       password : _passwordController.text,
  //       firstname :_firstNameController.text ,
  //       lastname : _lastNameController.text,
  //       phone : _phoneController.text,
  //       image : _image,
  //       status:  status,
  //       );

  //         print('User is : $user');
  //         if(user != null){
  //           print('Regis : $user');

  //         }

  //   }catch(e){

  //   }
  // }

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
                    'Sign in',
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
                  return '*';
                }
              },
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
                  return '*';
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
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return '*';
                }
              },
              controller: _firstNameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'ชื่อ',
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
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return '*';
                }
              },
              controller: _lastNameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'นามสกุล',
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
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return '*';
                }
              },
              controller: _phoneController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'เบอร์โทร',
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
        ],
      ),
    );
  }

  Widget _buttonRegister() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Center(
        child: RaisedButton(
          color: Colors.amber[900],
          onPressed: () {
            _register();
          },
          child: Container(
            padding: EdgeInsets.only(left: 80, right: 80, top: 10, bottom: 10),
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
    // selectedRadio = false;
    super.initState();
  }

  setSelectedRadio(bool val) {
    setState(() {
      selectedRadio = val;
    });
  }
}

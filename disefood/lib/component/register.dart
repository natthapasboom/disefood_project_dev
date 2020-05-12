import 'dart:convert';
import 'dart:io';

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
  String image;
   

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future _register() async {
    print(_usernameController.text);
    print(_image);
    print('Status:');
    print(status);
    if (_formKey.currentState.validate()) {
      try {
        var response = await apiProvider.doRegister(
            _usernameController.text,
            _passwordController.text,
            _firstNameController.text,
            _lastNameController.text,
            _phoneController.text,
            _image,
           
            );
        if (response.statusCode == 200) {
          print(response.body);
          var jsonResponse = json.decode(response.body);
          if (jsonResponse['ok']) {
            String token = jsonResponse['token'];
            print(token);
            SharedPreferences prefs =
                await SharedPreferences.getInstance(); // ใช้เก็บ token
            await prefs.setString('token', token);
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
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
            Expanded(
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
                            setState(() {
                             _image;
                            });
                          },
                          child: Icon(Icons.add_a_photo)),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
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
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: TextFormField(
              
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

  Widget _buttonRegister(){
    return Container(
      margin: EdgeInsets.only(top:20,bottom: 20),
        child: Center(
          child: RaisedButton(
            color: Colors.amber[900],
            onPressed: (){
            _register();
          },
          child: Container(
            padding: EdgeInsets.only(left:80,right: 80,top: 10,bottom: 10),
              child: Text('สมัคร',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 18),
              ),
              
          ),
          ),
        ),
        
    );
  }


  Widget _radiocheck() {
    return Container(
      margin: EdgeInsets.only(left:40),
      child: Column(
        children: <Widget>[
          RadioListTile(

           
            title: Text("พ่อค้า / แม่ค้า",style: TextStyle(
                    fontSize: 18,
                    
                    color: Colors.white),),
            value: true,
            groupValue: selectedRadio,
            onChanged: (bool newValue) {
              print(' value : $newValue');
              // print("Radio $val");
              setState(() {
                
                status = newValue;
                print(' Status :  $status');
              });
              
            },
            
            activeColor: Colors.amber[900],
          ),
          RadioListTile(
            title: Text("ผู้ใช้งาน",style: TextStyle(
                    fontSize: 18,
                    
                    color: Colors.white),),
            value: false,
            groupValue: selectedRadio,

            onChanged: (value) {
             setState(() {
                status = value;
                print(' Status :  $status');
             });
             
              // print('after on change');
              // print(status);
            },
            
            activeColor: Colors.amber[900],
          ),
        ],
      ),
    );
  }

  bool selectedRadio = false;
  void initState() {
    
    super.initState();
  }

  // setSelectedRadio(bool val) {
  //   setState(() {
  //     selectedRadio = val;
  //   });
  // }
}

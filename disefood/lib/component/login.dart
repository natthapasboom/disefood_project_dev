import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  File _image;
  ApiProvider apiProvider = ApiProvider();



  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future _register() async{
    if(_formKey.currentState.validate()){
          try{
              var response = await apiProvider.doRegister(_usernameController.text, _passwordController.text, _firstNameController.text, _lastNameController.text, _phoneController.text, _image);
              if(response.statusCode == 200){
                print(response.body);
                var jsonResponse = json.decode(response.body);
                  if(jsonResponse['ok']){
                    String token = jsonResponse['token'];
                    print(token);
                    SharedPreferences prefs = await SharedPreferences.getInstance(); // ใช้เก็บ token
                    await prefs.setString('token', token);      
                    // redirect
                              
                    print(jsonResponse['error']);
                  }
              }else{
                print('Connection error');
              }
          }catch(error){
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
              colors: [Colors.yellow[900], Colors.orange[300],Colors.orange[200]]),
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
                    child: _buildfrom()))
          ],
        ),
      ),
    );
  }

  Widget _buildfrom() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: 'ไอดี',
                hintStyle: TextStyle(color: Colors.white,fontSize: 18),
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
                hintStyle: TextStyle(color: Colors.white,fontSize: 18),
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
            
          )
        ],
      ),
    );
  }
}

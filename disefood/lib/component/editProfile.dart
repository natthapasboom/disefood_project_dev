import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name;
  String _shopImg;
  bool _isEdit = false;
  File _image;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _telController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 411,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.orange[700],
                        Colors.orange[600],
                        Colors.orange[400],
                        Colors.orange[200]
                      ]),
                ),
              ),
              Transform.translate(
                offset: Offset(20.0, -80.0),
                child: Stack(
                  children: <Widget>[
                    _image == null
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 70,
                            child: Icon(
                              Icons.photo,
                              size: 50,
                              color: Colors.orange,
                            ),
                          )
                        : CircleAvatar(
                            radius: 70,
                            child: ClipOval(
                              child: Image.file(
                                _image,
                                width: 150,
                                fit: BoxFit.cover,
                                height: 150,
                              ),
                            ),
                          ),
                    Positioned(
                      right: 0,
                      left: 100,
                      bottom: 0,
                      child: FloatingActionButton(
                          backgroundColor: const Color(000000).withOpacity(0.6),
                          onPressed: () {
                            getImage();
                            setState(() {
                              _isEdit = true;
                              Image.file(_image);
                            });
                          },
                          child: Icon(
                            Icons.add_a_photo,
                            size: 20,
                          )),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Transform.translate(
                          offset: Offset(0.0, -30.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Text(
                                  'Name',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Roboto'),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[350],
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                  ),
                                  margin: EdgeInsets.fromLTRB(60, 0, 30, 0),
                                  child: new TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(30, 0, 0, 0),
                                      hintStyle: TextStyle(fontSize: 14),
                                      fillColor: Colors.grey,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey[350])),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey[350])),
                                      enabledBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(15.0),
                                        borderSide: new BorderSide(
                                            color: Colors.grey[350]),
                                      ),
                                      errorBorder: new OutlineInputBorder(
                                        borderRadius:
                                            new BorderRadius.circular(15.0),
                                        borderSide:
                                            new BorderSide(color: Colors.red),
                                      ),
                                      hintText: 'กรอกชื่อ-นามสกุล',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, -10),
                          child: Container(
                            padding: EdgeInsets.only(bottom: 0),
                            child: Divider(
                              indent: 30,
                              color: Colors.black,
                              endIndent: 30,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(30, 30, 0, 30),
                              child: Text(
                                'Password',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: new TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    hintStyle: TextStyle(fontSize: 14),
                                    fillColor: Colors.grey,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[350])),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey[350])),
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide: new BorderSide(
                                          color: Colors.grey[350]),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          new BorderSide(color: Colors.red),
                                    ),
                                    hintText: 'กรอกรหัสผ่าน'
                                    ,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Divider(
                            indent: 30,
                            color: Colors.black,
                            endIndent: 30,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(30, 30, 0, 30),
                              child: Text(
                                'Tel.',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Roboto'),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                margin: EdgeInsets.fromLTRB(80, 0, 30, 0),
                                child: new TextFormField(
                                  controller: _telController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(30, 0, 0, 0),
                                    hintStyle: TextStyle(fontSize: 14),
                                    fillColor: Colors.grey,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[350])),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey[350])),
                                    enabledBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide: new BorderSide(
                                          color: Colors.grey[350]),
                                    ),
                                    errorBorder: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                      borderSide:
                                          new BorderSide(color: Colors.red),
                                    ),
                                    hintText: 'กรอกเบอร์โทร',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10, bottom: 30),
                          child: Divider(
                            indent: 30,
                            color: Colors.black,
                            endIndent: 30,
                          ),
                        ),
                        Container(
                        margin: EdgeInsets.only(bottom:30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(),
                                width: 132,
                                height: 40,
                                    child:  RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      onPressed: (){

                                      },
                                      color: Colors.white,
                                      elevation: 5,
                                       child: Container(
                                    child: Text(
                                      "ย้อนกลับ",
                                      style: TextStyle(color: const Color(0xffF6A911),fontFamily: 'Roboto',fontSize: 16,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                      ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left:30),
                                  width: 132,
                                  height: 40,
                                  
                                child:  RaisedButton(
                                  onPressed: (){

                                  },
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                  color: const Color(0xffF6A911),
                                  elevation: 5,
                                  child: Container(
                                    child: Text(
                                      "ยืนยัน",
                                      style: TextStyle(color: Colors.white,fontFamily: 'Roboto',fontSize: 16,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

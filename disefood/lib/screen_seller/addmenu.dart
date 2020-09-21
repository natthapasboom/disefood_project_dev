import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:disefood/component/sidemenu_seller.dart';
import 'package:disefood/model/foodinsert.dart';
import 'package:disefood/model/shop_id.dart';
import 'package:disefood/services/api_provider.dart';

import 'package:disefood/services/foodservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'organize_seller_page.dart';

class AddMenu extends StatefulWidget {
  static final route = "/addMenu_seller";

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  bool status;
  var selectOnStock;
  var selectOutOfStock;
  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  int groupValue;
  File _image;
  int statusFood;
  Future<void> getImage(ImageSource imageSource) async {
    try {
      var image = await ImagePicker.pickImage(
          source: imageSource, maxWidth: 400.0, maxHeight: 400.0);

      setState(() {
        _image = image;
      });
    } catch (e) {}
  }

  Future<String> addFood() async {
    SharedPreferences preference = await SharedPreferences.getInstance();

    String token = preference.getString('token');
    int shopId = preference.getInt('shop_id');
    int statusFood;
    String fileImage = _image.path.split('/').last;
    Logger logger = Logger();
    int price = int.parse(priceController.text.trim());
    String name = nameController.text.trim();
    logger.d('data: $name, $price, ${status.toString()} ${_image.path}');
    logger.d('shop_id : $shopId');
    logger.d(status);
    logger.d(token);
    if (status == true) {
      statusFood = 1;
    } else {
      statusFood = 0;
    }
    logger.d(statusFood);
    // logger.d('token : $token');
    String url = 'http://10.0.2.2:8080/api/shop/menu/$shopId';
    FormData formData = FormData.fromMap({
      'name': name,
      'price': priceController.text.trim(),
      'status': statusFood.toString(),
      'cover_img':
          await MultipartFile.fromFile(_image.path, filename: fileImage),
    });
    try {
      var response = await Dio().post(
        url,
        data: formData,
        options: Options(
            headers: {
              "ContentType":
                  ContentType.parse("application/x-www-form-urlencoded"),
              "Authorization": "Bearer $token",
            },
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      logger.d('response data : ${response.data}');
      logger.d('response header : ${response.headers}');
      logger.d('status code : ${response.statusCode}');
      if (response.statusCode == 200) {
        Navigator.of(context).pop(true);
        logger.d("succes");
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 302) {
        logger.e(e);
      }
    }

    return '';
  }

  final _formKey = GlobalKey<FormState>();
  bool newValue = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.only(left: 0, top: 0, right: 151),
            child: Center(
              child: Text(
                "เพื่มรายการอาหาร",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 60, bottom: 0),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  _image == null
                      ? CircleAvatar(
                          backgroundColor: Colors.orangeAccent,
                          radius: 75,
                          child: Icon(
                            Icons.image,
                            size: 80,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          radius: 75,
                          child: ClipOval(
                            child: Image.file(
                              _image,
                              fit: BoxFit.cover,
                              height: 150,
                            ),
                          ),
                        ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: FloatingActionButton(
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
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 40),
              child: Card(
                elevation: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: Builder(
                    builder: (context) => Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Text("ชื่อ"),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                                // labelText: 'ชื่ออาหาร',
                                ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'โปรดใส่ชื่ออาหาร';
                              }
                            },
                            controller: nameController,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text("ราคา"),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                // labelText: 'ราคา'
                                ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'โปรดใส่ราคา';
                              }
                            },
                            controller: priceController,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 10.0, left: 25, bottom: 10),
                            child: Text(
                              "Choose Status",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              RadioListTile(
                                title: Text("พร้อมขาย"),
                                value: true,
                                groupValue: selectedRadio,
                                onChanged: (newValue) {
                                  print("สถานะ = $newValue");

                                  setState(() {
                                    setSelectedRadio(newValue);
                                    status = newValue;
                                  });
                                },
                                activeColor: Colors.green,
                              ),
                              RadioListTile(
                                title: Text("ของหมด"),
                                value: false,
                                groupValue: selectedRadio,
                                onChanged: (newValue) {
                                  print("สถานะ = $newValue");
                                  setSelectedRadio(newValue);
                                  status = newValue;
                                },
                                activeColor: Colors.red,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 20.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                    color: Colors.red,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 30),
                                ),
                                Expanded(
                                  child: Container(
                                    child: RaisedButton(
                                      color: Colors.green,
                                      onPressed: () async {
                                        final form = _formKey.currentState;
                                        if (form.validate()) {
                                          form.save();
                                          addFood();
                                        }
                                      },
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool selectedRadio = false;
  void initState() {
    selectedRadio = null;
    super.initState();
  }

  setSelectedRadio(bool val) {
    setState(() {
      selectedRadio = val;
    });
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Add menu finish')));
  }
}

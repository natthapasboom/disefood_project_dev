import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:disefood/component/sidemenu_seller.dart';
import 'package:disefood/model/foodinsert.dart';

import 'package:disefood/services/foodservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'organize_seller_page.dart';

class AddMenu extends StatefulWidget {
  static final route = "/addMenu_seller";

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  int _shopId;

  bool status;
  var selectOnStock;
  var selectOutOfStock;
  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  int groupValue;
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Future fetchNameFromStorage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    final shopId = _prefs.getInt('shop_id');
    setState(() {
      _shopId = shopId;
    });
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
          Container(
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
                            labelText: 'ชื่ออาหาร',
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
                          decoration: InputDecoration(labelText: 'ราคา'),
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
                          padding:
                              EdgeInsets.only(top: 10.0, left: 25, bottom: 10),
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
                                // child: Container(
                                //   child: RaisedButton(
                                //     color: Colors.green,
                                //     onPressed: () async {
                                //       final form = _formKey.currentState;
                                //       if (form.validate()) {

                                //         form.save();
                                //         int _price =
                                //             int.parse(priceController.text);

                                //           String _url =
                                //               'http://10.0.2.2:8080/api/shop/$_shopId';
                                //           try {
                                //             var formData = FormData.fromMap({
                                //               "name": nameController,
                                //               "price": _price,
                                //               "status": status,
                                //             });
                                //             print(formData.fields);
                                //             Response response =
                                //                 await Dio().post(
                                //               _url,
                                //               data: {
                                //                 'name': nameController.text,
                                //                 'price': _price,
                                //                 'status': status,
                                //               },
                                //             );
                                //             print('res : ${response.data}');
                                //             print(response.statusCode);
                                //             if (response.statusCode == 201) {
                                //               print(
                                //                   'response : ${response.data}');
                                //               print('Success');
                                //              Navigator.pop(context);
                                //               // Navigator.pop(context);
                                //             } else {
                                //               print('error code');
                                //             }
                                //           } catch (error) {
                                //             print('error: $error');
                                //           }
                                //         }
                                //     },
                                //     child: Text(
                                //       'Save',
                                //       style: TextStyle(
                                //           fontSize: 18, color: Colors.white),
                                //     ),
                                //   ),
                                // ),
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
                                        int _price =
                                            int.parse(priceController.text);

                                        String _url =
                                            'http://10.0.2.2:8080/api/shop/$_shopId';
                                        try {
                                          var formData = FormData.fromMap({
                                            "name": nameController,
                                            "price": _price,
                                            "status": status,
                                          });
                                          print(formData.fields);
                                          Response response = await Dio().post(
                                            _url,
                                            data: {
                                              'name': nameController.text,
                                              'price': _price,
                                              'status': status,
                                            },
                                          );
                                          print('res : ${response.data}');
                                          print(response.statusCode);
                                          if (response.statusCode == 201) {
                                            print(
                                                'response : ${response.data}');
                                            print('Success');
                                            Navigator.pop(context);
                                            // Navigator.pop(context);
                                          } else {
                                            print('error code');
                                          }
                                        } catch (error) {
                                          print('error: $error');
                                        }
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
        ],
      ),
    );
  }

  bool selectedRadio = false;
  void initState() {
    Future.microtask(() async {
      fetchNameFromStorage();
    });
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

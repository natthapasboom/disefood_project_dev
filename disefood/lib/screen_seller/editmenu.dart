import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:disefood/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditMenuPage extends StatefulWidget {
  final String image;
  final String name;
  final int price;
  final int status;
  final int id;
  EditMenuPage({
    Key key,
    @required this.image,
    @required this.name,
    @required this.price,
    @required this.status,
    @required this.id,
  }) : super(key: key);
  @override
  _EditMenuPageState createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {
  String nameUser;
  String lastNameUser;
  int userId;
  String menuImage;
  String coverImg;
  int shopId;
  String _shopName;
  int _shopId;
  String _shopImg;
  bool _isEdit = false;
  bool status;
  var image;
  var selectOnStock;
  var selectOutOfStock;
  int statusFood;
  var imageUrl;
  String contents;
  TextEditingController _nameController = TextEditingController();

  TextEditingController _priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Widget _checkImage() {
    if (_isEdit) {
      if (_image != null) {
        return Image.file(
          _image,
          fit: BoxFit.cover,
          height: 300,
        );
      } else {
        return CircleAvatar(
          backgroundColor: Colors.orangeAccent,
          radius: 75,
          child: Icon(
            Icons.image,
            size: 80,
            color: Colors.white,
          ),
        );
      }
    } else {
      setState(() {
        imageUrl = '${AppConfig.image}${widget.image}';
      });

      return CachedNetworkImage(
          imageUrl: '${AppConfig.image}${widget.image}',
          height: 300,
          width: 500,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
                  child: Center(
                child: Container(
                    child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                )),
              )),
          errorWidget: (context, url, error) => Icon(
                Icons.error,
                color: Colors.white,
                size: 48,
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.only(
                left: 0,
                top: 0,
                right: 130,
              ),
              child: Center(
                child: Text(
                  "แก้ไขรายการอาหาร",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
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
                  widget.image == null
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
                          backgroundColor: const Color(0xffF6A911),
                          radius: 70,
                          child: ClipOval(
                            child: _checkImage(),
                          ),
                        ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: FloatingActionButton(
                        backgroundColor: Colors.amber[900],
                        onPressed: () {
                          getImage();
                          setState(() {
                            _isEdit = true;
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
                          decoration: InputDecoration(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'โปรดใส่ชื่ออาหาร';
                            }
                          },
                          controller: _nameController,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text("ราคา"),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'โปรดใส่ราคา';
                            }
                          },
                          controller: _priceController,
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
                                setSelectedRadio(newValue);
                                status = newValue;
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
                                    'ยกเลิก',
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
                                        if (_image == null) {
                                          setState(() {
                                            Image.file(File(widget.image));
                                          });
                                        } else {
                                          setState(() {
                                            image =
                                                Image.file(File(widget.image));
                                          });
                                        }

                                        if (selectedRadio == true) {
                                          statusFood = 1;
                                        } else {
                                          statusFood = 0;
                                        }

                                        Logger logger = Logger();

                                        SharedPreferences preferences =
                                            await SharedPreferences
                                                .getInstance();
                                        _shopId = preferences.getInt('shop_id');

                                        String token =
                                            preferences.getString('token');
                                        int menuId = widget.id;

                                        logger.d(
                                            'data: $menuId ${_nameController.text}, ${_priceController.text}, $selectedRadio, ${widget.image} // $imageUrl  ');
                                        String _url =
                                            'http://54.151.194.224:8000/api/shop/menu/edit/$menuId';
                                        String name =
                                            _nameController.text.trim();
                                        String fileImage = _isEdit
                                            ? _image.path.split('/').last
                                            : null;
                                        FormData formData = FormData.fromMap({
                                          '_method': 'PUT',
                                          'name': name,
                                          'price': _priceController.text.trim(),
                                          'status': statusFood.toString(),
                                          'cover_img': _isEdit
                                              ? await MultipartFile.fromFile(
                                                  _image.path,
                                                  filename: fileImage)
                                              : null,
                                        });

                                        var response = await Dio().post(
                                          _url,
                                          data: formData,
                                          options: Options(
                                              headers: {
                                                "ContentType": ContentType.parse(
                                                    "application/x-www-form-urlencoded"),
                                                "Authorization":
                                                    "Bearer $token",
                                              },
                                              followRedirects: false,
                                              validateStatus: (status) {
                                                return status < 500;
                                              }),
                                        );

                                        logger.d(response.statusCode);
                                        if (response.statusCode == 200) {
                                          logger.d('success');
                                          Navigator.of(context).pop(true);
                                        } else {
                                          logger.d(response.statusMessage);
                                        }
                                      }
                                    },
                                    child: Text(
                                      'บันทึก',
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

  bool selectedRadio;
  void initState() {
    if (widget.status == 1) {
      selectedRadio = true;
    } else {
      selectedRadio = false;
    }

    _nameController.text = '${widget.name}';
    _priceController.text = '${widget.price}';
    Future.microtask(() {
      menuImage = widget.image;
      print(menuImage);
    });
    // contents = new File(widget.image).readAsStringSync();

    super.initState();
  }

  setSelectedRadio(bool val) {
    setState(() {
      selectedRadio = val;
    });
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:disefood/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class EditShop extends StatefulWidget {
  static const routeName = '/create_seller';
  @override
  _EditShopState createState() => _EditShopState();
}

class _EditShopState extends State<EditShop> {
  bool _isEdit = false;

  String _shopName;
  int _shopId;
  String _shopImg;
  int _shopSlot;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      fetchShopFromStorage();
    });
  }

  Future<Null> fetchShopFromStorage() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    final shopName = _prefs.getString('shop_name');
    final shopId = _prefs.getInt('shop_id');
    final shopImg = _prefs.getString('cover_img');
    final shopSlot = _prefs.getInt('shop_slot');
    setState(() {
      _shopName = shopName;
      _shopId = shopId;
      _shopImg = shopImg;
      _shopSlot = shopSlot;
    });
  }

  Widget _checkImage() {
    if (_isEdit) {
      if (_image != null) {
        return Image.file(
          _image,
          fit: BoxFit.cover,
          height: 150,
          width: 500,
        );
      } else {
        return Center(
          child: IconButton(
            onPressed: () {
              getImage();
              setState(() {
                _isEdit = true;
                Image.file(_image);
              });
            },
            iconSize: 36,
            color: Colors.white,
            icon: Icon(Icons.add_a_photo),
          ),
        );
      }
    } else {
      return CachedNetworkImage(
        imageUrl: '${AppConfig.image}$_shopImg',
        height: 150,
        width: 500,
        fit: BoxFit.cover,
      );
    }
  }

  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  TextEditingController _shopNameController = TextEditingController();
  TextEditingController _shopSlotController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 0, top: 0, right: 140),
            child: Center(
              child: Text(
                "แก้ไขร้านค้า",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildPhoto(),
                _buildform(),
                _button(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoto() {
    return Container(
      height: 150,
      color: _shopImg == null ? Colors.amber[500] : Colors.white,
      child: _shopImg == null
          ? Center(
              child: IconButton(
                onPressed: () {
                  getImage();
                  setState(() {
                    _isEdit = true;
                    Image.file(_image);
                  });
                },
                iconSize: 36,
                color: Colors.white,
                icon: Icon(Icons.add_a_photo),
              ),
            )
          : Container(
              child: CachedNetworkImage(
                imageUrl:
                    'https://disefood.s3-ap-southeast-1.amazonaws.com/$_shopImg',
                height: 150,
                width: 500,
                fit: BoxFit.cover,
              ),
            ),
    );
  }

  Widget _buildform() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 30, left: 40, right: 40, bottom: 10),
          child: Text('ชื่อร้านค้า :'),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
          child: TextFormField(
            controller: _shopNameController,
            decoration: InputDecoration(
              labelText: '$_shopName',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
          child: Text('สล็อตของร้าน :'),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 10),
          child: TextFormField(
            controller: _shopSlotController,
            decoration: InputDecoration(
              labelText: '$_shopSlot',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _button() {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 20),
      child: RaisedButton(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding:
                EdgeInsets.only(top: 12, bottom: 12, left: 120, right: 120),
            child: Text(
              'ยืนยัน',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          color: Colors.orange,
          onPressed: () {
            _createShop();
          }),
    );
  }

  Future<void> _createShop() async {
    Dio dio = Dio();
    var uuid = Uuid();
    String url = 'http://10.0.2.2:8080/api/shop/';

    try {
      var formData = FormData.fromMap({
        "name": _shopNameController.text.trim(),
        "shopslot": _shopSlotController.text.trim(),
        "cover_img": await MultipartFile.fromFile(
          _image.path,
          filename: '${uuid.v4()}.png',
        ),
      });

      print(formData.fields);
      Response response = await dio.put(
        url,
        data: formData,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      response.headers.set('content-type', 'application/json');

      print('status : ${response.statusCode}');
      if (response.statusCode == 200) {
        print('response : ${response.data}');
        print('Success');
      } else {
        print('error code');
      }
    } catch (error) {
      print('error: $error');
    }
  }
}

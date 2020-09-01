import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:disefood/config/app_config.dart';
import 'package:disefood/model/shop_id.dart';
import 'package:disefood/screen_seller/home_seller_tab.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CreateShop extends StatefulWidget {
  static const routeName = '/create_seller';
  @override
  _CreateShopState createState() => _CreateShopState();
}

class _CreateShopState extends State<CreateShop> {
  final logger = Logger();
  bool _isEdit = false;
  String nameUser;
  String lastNameUser;
  int userId;
  String coverImg;
  String _shopName;
  int _shopId;
  String _shopImg;
  int _shopSlot;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      findUser();
      fetchShopFromStorage();
    });
  }

  Future<Null> findUser() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preference.getString('first_name');
      userId = preference.getInt('user_id');
      lastNameUser = preference.getString('last_name');
      coverImg = preference.getString('profile_img');
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
    logger.d(userId);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 0, top: 0, right: 140),
            child: Center(
              child: Text(
                "เพิ่มร้านค้า",
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
                // _buttonCancel(),
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
      color: Colors.amber,
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
              // child: Image.file(
              //   _shopImg,
              //   height: 150,
              //   width: 500,
              //   fit: BoxFit.cover,
              // ),
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
              labelText: 'กรอกชื่อร้านค้า',
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
              labelText: 'กรอกสล็อตของร้านค้า',
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
          color: Colors.green,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              logger.d(userId);
              _createShop();
            }
          }),
    );
  }

  // Widget _buttonCancel() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 10, bottom: 20),
  //     child: RaisedButton(
  //         elevation: 8,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         child: Container(
  //           padding:
  //               EdgeInsets.only(top: 12, bottom: 12, left: 120, right: 120),
  //           child: Text(
  //             'ยกเลิก',
  //             style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white),
  //           ),
  //         ),
  //         color: Colors.red,
  //         onPressed: ()
  //         {
  //           logger.d(userId);
  //           Navigator.pop(context);
  //         }),
  //   );
  // }

  Future<void> _createShop() async {
    Dio dio = Dio();
    var uuid = Uuid();
    String url = 'http://10.0.2.2:8080/api/shop';
    int _price = int.parse(_shopSlotController.text.trim());
    try {
      var formData = FormData.fromMap({
        "name": _shopNameController.text.trim(),
        "shop_slot": _price,
        "user_id": userId,
        // "cover_img": await MultipartFile.fromFile(
        //   _image.path,
        //   filename: '${uuid.v4()}.png',
        // ),
      });

      print(formData.fields);
      Response response = await dio.post(
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
        String _url = 'http://10.0.2.2:8080/api/shop/user/$userId';
        logger.d(_url);
        try {
          Response shopResponse = await Dio().get(_url);
          print(shopResponse);
          if (shopResponse.statusCode == 200) {
            print('Success Shop!');
            var resultShop = ShopById.fromJson(shopResponse.data);
            logger.d(resultShop);
            SharedPreferences preference =
                await SharedPreferences.getInstance();
            // await preference.setInt('shop_id', resultShop.shopId);
            // await preference.setString('shop_name', resultShop.name);
            // await preference.setInt('shop_user_id', resultShop.userId);
            // await preference.setInt('shop_slot', resultShop.shopSlot);
            // await preference.setString('cover_img', resultShop.coverImage);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Homepage()));
          }
        } catch (error) {
          logger.e(error);
        }
        print('response : ${response.data}');
        print('Success');
        logger.d(response.data);
      } else {
        print('error code');
      }
    } catch (error) {
      print('error: $error');
    }
  }
}

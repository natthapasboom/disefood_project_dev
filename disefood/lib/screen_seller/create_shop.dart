import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:disefood/config/app_config.dart';
import 'package:disefood/model/shop_id.dart';
import 'package:disefood/screen_seller/home_seller_tab.dart';
import 'package:disefood/services/api_provider.dart';
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
              getImage(ImageSource.gallery);
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

  File documentImg;
  File _image;
  Future<void> getImage(ImageSource imageSource) async {
    try {
      var image = await ImagePicker.pickImage(
          source: imageSource, maxWidth: 400.0, maxHeight: 400.0);

      setState(() {
        _image = image;
      });
    } catch (e) {}
  }

  Future<void> getDocImg(ImageSource imageSource) async {
    try {
      var image = await ImagePicker.pickImage(
          source: imageSource, maxWidth: 400.0, maxHeight: 400.0);
      setState(() {
        documentImg = image;
      });
    } catch (e) {}
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
    return Column(
      children: <Widget>[
        Container(
          height: 150,
          color: const Color(0xff7FC9C5),
          child: _image == null
              ? Center(
                  child: IconButton(
                    onPressed: () {
                      getImage(ImageSource.gallery);
                      setState(() {
                        _isEdit = true;
                        Image.file(_image);
                      });
                    },
                    iconSize: 36,
                    color: Colors.white,
                    icon: Icon(Icons.store),
                  ),
                )
              : Container(
                  child: Image.file(
                    _image,
                    height: 150,
                    width: 500,
                    fit: BoxFit.cover,
                  ),
                ),
          // child: Image.file(
          //   _shopImg,
          //   height: 150,
          //   width: 500,
          //   fit: BoxFit.cover,
          // ),
        ),
        Transform.translate(
          offset: Offset(0, -30.0),
          child: Container(
            margin: EdgeInsets.only(left: 290),
            child: FloatingActionButton(
              child: Icon(
                Icons.add_a_photo,
                size: 20,
              ),
              backgroundColor: const Color(000000).withOpacity(0.6),
              onPressed: () {
                getImage(ImageSource.gallery);
                setState(() {
                  _isEdit = true;
                  Image.file(_image);
                });
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildform() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 0, left: 40, right: 40, bottom: 10),
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
          margin: EdgeInsets.only(top: 10, left: 40, right: 40, bottom: 20),
          child: TextFormField(
            keyboardType: TextInputType.number,
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
        Center(
          child: documentImg == null
              ? Container(
                  margin: const EdgeInsets.all(30.0),
                  padding: const EdgeInsets.all(140.0),
                  decoration:
                      myBoxDecoration(), //       <--- BoxDecoration here
                  child: IconButton(
                      onPressed: () {
                        getDocImg(ImageSource.gallery);
                        setState(() {
                          Image.file(documentImg);
                        });
                      },
                      icon: Icon(Icons.add_a_photo)))
              : Container(
                  margin: const EdgeInsets.all(10.0),
                  child: InkWell(
                    onTap: () {
                      getDocImg(ImageSource.gallery);
                      setState(() {
                        Image.file(documentImg);
                      });
                    },
                    child: Image.file(
                      documentImg,
                      height: 300,
                      width: 300,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: RaisedButton(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding:
                      EdgeInsets.only(top: 12, bottom: 12, left: 95, right: 95),
                  child: Text(
                    'เลือกรูปภาพ',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                color: const Color(0xffF6A911),
                onPressed: () {
                  getDocImg(ImageSource.gallery);
                  setState(() {
                    Image.file(documentImg);
                  });
                }),
          ),
        ),
      ],
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 1, style: BorderStyle.solid),
    );
  }

  Widget _button() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
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

  Future<String> _createShop() async {
    int _slot = int.parse(_shopSlotController.text);
    String name = _shopNameController.text.trim();
    ApiProvider apiProvider = ApiProvider();
    SharedPreferences preference = await SharedPreferences.getInstance();
    String token = preference.getString('token');

    var body = {
      "slot": _slot,
      "name": name,
      "cover_img": _image,
      "document_img": documentImg,
      "token": token
    };
    logger.d("body $body");

    var response =
        await apiProvider.createShop(name, _slot, _image, documentImg, token);

    return response;
  }
}

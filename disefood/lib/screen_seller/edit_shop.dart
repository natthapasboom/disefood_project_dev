import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:disefood/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class EditShop extends StatefulWidget {
  final String shopName;
  final int shopSlot;
  final String shopImg;
  final int shopId;
  static const routeName = '/create_seller';

  const EditShop(
      {Key key,
      @required this.shopName,
      @required this.shopSlot,
      @required this.shopImg,
      @required this.shopId})
      : super(key: key);
  @override
  _EditShopState createState() => _EditShopState();
}

class _EditShopState extends State<EditShop> {
  bool _isEdit = false;

  String _shopName;
  int _shopId;
  String _shopImg;
  int _shopSlot;
  Logger logger = Logger();
  @override
  void initState() {
    _shopName = widget.shopName;
    _shopNameController.text = '${widget.shopName}';
    _shopSlotController.text = '${widget.shopSlot}';
    _shopId = widget.shopId;

    super.initState();
    Future.microtask(() {});
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
          imageUrl: '${AppConfig.image}${widget.shopImg}',
          height: 150,
          width: 500,
          fit: BoxFit.fitWidth,
          placeholder: (context, url) => Container(
                height: 150,
                width: 500,
                color: const Color(0xff7FC9C5),
                child: Center(
                    child: Center(
                  child: Container(
                      child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  )),
                )),
              ),
          errorWidget: (context, url, error) => Icon(
                Icons.store,
                color: Colors.white,
                size: 48,
              ));
    }
  }

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
    return Column(
      children: <Widget>[
        Container(
          height: 150,
          color: Colors.white,
          child: widget.shopImg == null
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
                  child: _checkImage(),
                ),
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
    // return Container(
    //   height: 150,
    //   color: _shopImg == null ? Colors.amber[500] : Colors.white,
    //   child: widget.shopImg == null
    //       ? Center(
    //           child: IconButton(
    //             onPressed: () {
    //               getImage();
    //               setState(() {
    //                 _isEdit = true;
    //                 Image.file(_image);
    //               });
    //             },
    //             iconSize: 36,
    //             color: Colors.white,
    //             icon: Icon(Icons.add_a_photo),
    //           ),
    //         )
    //       : Container(
    //           child: _checkImage(),
    //         ),
    //          Transform.translate(
    //       offset: Offset(0, -30.0),
    //       child: Container(
    //         margin: EdgeInsets.only(left: 290),
    //         child: FloatingActionButton(
    //           child: Icon(
    //             Icons.add_a_photo,
    //             size: 20,
    //           ),
    //           backgroundColor: const Color(000000).withOpacity(0.6),
    //           onPressed: () {
    //             getImage(ImageSource.gallery);
    //             setState(() {
    //               _isEdit = true;
    //               Image.file(_image);
    //             });
    //           },
    //         ),
    //       ),
    //     )
    // );
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
          onPressed: () async {
            logger.d(_shopId);
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            String token = sharedPreferences.getString('token');
            String _url = 'http://10.0.2.2:8080/api/shop/owner/$_shopId';
            String name = _shopNameController.text.trim();
            String fileImage = _isEdit ? _image.path.split('/').last : null;
            FormData formData = FormData.fromMap({
              '_method': 'PUT',
              'name': name,
              'shop_slot': _shopSlot,
              'cover_img': _isEdit
                  ? await MultipartFile.fromFile(_image.path,
                      filename: fileImage)
                  : null,
            });
            logger.d('FormData : ${formData.fields}');
            var response = await Dio().post(
              _url,
              data: formData,
              options: Options(
                  headers: {
                    'Authorization': 'Bearer $token',
                  },
                  followRedirects: false,
                  validateStatus: (status) {
                    return status < 500;
                  }),
            );

            logger.d("Status: ${response.statusCode}");
            logger.d("Data: ${response.data}");

            if (response.statusCode == 200) {
              logger.d('success');
              Navigator.of(context).pop(true);
            } else {
              logger.e(response.statusMessage);
            }
          }),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreateShop extends StatefulWidget {
  @override
  _CreateShopState createState() => _CreateShopState();
}

class _CreateShopState extends State<CreateShop> {
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
                "สร้างร้านค้า",
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
      color: Colors.amber,
      child: _image == null
          ? Center(
              child: IconButton(
                onPressed: () {
                  getImage();
                },
                iconSize: 36,
                color: Colors.white,
                icon: Icon(Icons.add_a_photo),
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
    );
  }

  Widget _buildform() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 80, left: 40, right: 40, bottom: 10),
          child: TextFormField(
            controller: _shopNameController,
            decoration: InputDecoration(
              labelText: 'กรอกชื่อร้าน',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.orange),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 10),
          child: TextFormField(
            controller: _shopSlotController,
            decoration: InputDecoration(
              labelText: 'กรอกล็อตของร้าน',
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
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 120, right: 120),
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
    String url = 'http://10.0.2.2:8080/api/shop';
    
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
        
          print('response : ${response.data}');
          print('Success');
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text("Shop Create"),
          ));
        } else {
          print('error code');
          Map<String, dynamic> _responseMap = json.decode(response.data);
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text(_responseMap['message']),
          ));
        }

    } catch (error) {
      print('error: $error');
    }
  }
}

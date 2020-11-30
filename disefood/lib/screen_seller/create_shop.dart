import 'dart:io';
// import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:disefood/config/app_config.dart';
import 'package:disefood/screen_seller/home_seller_tab.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool checkDocImg = false;
  @override
  void initState() {
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
                    checkDocImg = true;
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
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              //   String _url = 'http://54.151.194.224:8000/api/shop/owner';
              //   SharedPreferences preference =
              //       await SharedPreferences.getInstance();
              //   String token = preference.getString('token');
              //   int _slot = int.parse(_shopSlotController.text.trim());
              //   Map<String, String> headers = {
              //     "Accept": "application/json",
              //     "Authorization": "Bearer $token"
              //   };
              //   logger.d(userId);
              //   var request = http.MultipartRequest("POST", Uri.parse(_url));

              //   var stream = http.ByteStream(DelegatingStream(_image.openRead()));
              //   var length = await _image.length();
              //   var multipartFileSign = new http.MultipartFile(
              //       'profile_img', stream, length,
              //       filename: basename(_image.path));
              //   request.files.add(multipartFileSign);
              //   request.fields['name'] = _shopNameController.text.trim();
              //   request.fields['shop_slot'] = _slot.toString();
              //   request.headers.addAll(headers);
              //   if (checkDocImg == true) {
              //     var stream =
              //         http.ByteStream(DelegatingStream(documentImg.openRead()));
              //     var length = await documentImg.length();
              //     var multipartFileSign = new http.MultipartFile(
              //         'document_img', stream, length,
              //         filename: basename(documentImg.path));
              //     request.files.add(multipartFileSign);
              //   } else {}
              //   var response = await request.send();
              //   logger.d(response.statusCode);
              //   if (response.statusCode == 200) {
              //     // var context1;
              //     showDialog(
              //       barrierDismissible: false,
              //       context: context,
              //       builder: (context) {
              //         Future.delayed(Duration(seconds: 3), () {
              //           Navigator.of(context).pop(true);
              //         });
              //         return Dialog(
              //             shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(10.0)),
              //             child: Container(
              //                 height: 250.0,
              //                 width: 300.0,
              //                 decoration: BoxDecoration(
              //                     borderRadius: BorderRadius.circular(20.0)),
              //                 child: Column(
              //                   children: <Widget>[
              //                     Stack(
              //                       children: <Widget>[
              //                         Center(
              //                           child: Container(
              //                             margin: EdgeInsets.only(top: 40),
              //                             height: 90.0,
              //                             width: 90.0,
              //                             decoration: BoxDecoration(
              //                                 borderRadius:
              //                                     BorderRadius.circular(50.0),
              //                                 image: DecorationImage(
              //                                   image: AssetImage(
              //                                       'assets/images/success.png'),
              //                                   fit: BoxFit.cover,
              //                                 )),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     Container(
              //                         margin: EdgeInsets.only(
              //                             top: 30,
              //                             left: 10,
              //                             right: 10,
              //                             bottom: 0),
              //                         child: Center(
              //                           child: Text(
              //                             'สร้างร้านค้าสำเร็จ',
              //                             style: TextStyle(
              //                               fontFamily: 'Aleo-Bold',
              //                               fontSize: 24.0,
              //                               fontWeight: FontWeight.bold,
              //                             ),
              //                           ),
              //                         )),
              //                   ],
              //                 )));
              //       },
              //     ).then((value) => Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => Homepage())));

              //     return "success";
              //   } else {

              //     dialogError(context);
              //   }
              // }
              _createShop();
            }
          }),
    );
  }

  Future<void> dialogError(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                  height: 300.0,
                  width: 200.0,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(height: 150.0),
                          // Container(
                          //   height: 100.0,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.only(
                          //         topLeft: Radius.circular(10.0),
                          //         topRight: Radius.circular(10.0),
                          //       ),
                          //       color: Colors.red),
                          // ),
                          Positioned(
                              top: 30.0,
                              left: 94.0,
                              child: Container(
                                height: 90.0,
                                width: 90.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/red-cross.png'),
                                      fit: BoxFit.cover,
                                    )),
                              ))
                        ],
                      ),
                      SizedBox(height: 0.0),
                      Container(
                          margin: EdgeInsets.only(
                              top: 0, left: 10, right: 10, bottom: 0),
                          child: Center(
                            child: Text(
                              'มีอะไรผิดพลาด',
                              style: TextStyle(
                                fontFamily: 'Aleo-Bold',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(
                              top: 5, left: 10, right: 10, bottom: 5),
                          child: Center(
                            child: Text(
                              'กรุณากรอกฟอร์มใหม่',
                              style: TextStyle(
                                fontFamily: 'Aleo-Bold',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                      SizedBox(height: 10.0),
                      Container(
                        margin:
                            EdgeInsets.only(top: 10, left: 40.0, right: 40.0),
                        child: RaisedButton(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side:
                                    BorderSide(color: const Color(0xffF6A911))),
                            child: Center(
                              child: Text(
                                'ตกลง',
                                style: TextStyle(
                                    fontFamily: 'Aleo-Bold',
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: const Color(0xffF6A911)),
                      )
                    ],
                  )));
        });
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
      // "document_img": documentImg,
      "token": token
    };
    logger.d("body $body");

    try {
      String _url = 'http://54.151.194.224:8000/api/shop/owner';
      Dio().options.headers['Authorization'] = 'Bearer $token';

      String shopImage = _image.path.split('/').last;
      String docImage = documentImg.path.split('/').last;

      FormData formData = FormData.fromMap({
        "name": name,
        "shop_slot": _slot,
        "cover_img":
            await MultipartFile.fromFile(_image.path, filename: shopImage),
        "document_img":
            await MultipartFile.fromFile(documentImg.path, filename: docImage),
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
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                    height: 250.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 40),
                                height: 90.0,
                                width: 90.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/success.png'),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                top: 30, left: 10, right: 10, bottom: 0),
                            child: Center(
                              child: Text(
                                'สร้างร้านค้าสำเร็จ',
                                style: TextStyle(
                                  fontFamily: 'Aleo-Bold',
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                      ],
                    )));
          },
        ).then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homepage())));

        return "success";
      } else {
        dialogError(context);
      }
    } catch (err) {
      print('ERROR  $err');
    }
  }
}

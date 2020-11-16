import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:disefood/config/app_config.dart';
import 'package:disefood/model/userById.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  static const routeName = '/edit_profile';
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String name;
  String _shopImg;
  bool _isEdit = false;
  bool _isFirstNameEdit = false;
  bool _isLastNameEdit = false;
  bool _isEmailEdit = false;
  bool _isTelEdit = false;
  File _image;
  String coverImg;
  String firstName;
  String lastName;
  String lastNameUser;
  String profileImg;
  int userId;
  int _userId;
  String userName;
  String password;
  String tel;
  String email;
  var imageUrl;
  bool _isLoading = false;
  final logger = Logger();
  bool isLoading = true;
  List shops = [];
  ApiProvider apiProvider = ApiProvider();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _telController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> getImage(ImageSource imageSource) async {
    try {
      var image = await ImagePicker.pickImage(
          source: imageSource, maxWidth: 400.0, maxHeight: 400.0);

      setState(() {
        _image = image;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    _isLoading = false;
    super.initState();
    Future.microtask(() {
      findUser();
    });
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Enter email address";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'กรุณากรอกอีเมลล์ใหม่';
  }

  Future<UserById> findUser() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    userId = preference.getInt('user_id');
    password = preference.getString('password');
    var response = await apiProvider.getUserById(userId);
    // print(response.statusCode);
    if (response.statusCode == 200) {
      Map map = json.decode(response.body);
      UserById msg = UserById.fromJson(map);
      var data = msg.data.toJson();

      setState(() {
        _isLoading = true;
        userId = preference.getInt('user_id');
        userName = msg.data.username;
        firstName = msg.data.firstName;
        lastName = msg.data.lastName;
        lastNameUser = msg.data.lastName;
        profileImg = msg.data.profileImg;
        email = msg.data.email;
        tel = msg.data.tel;
        logger.d(profileImg);
        // _passwordController.text = '$password';
        _firstNameController.text = '${msg.data.firstName}';
        _lastNameController.text = '${msg.data.lastName}';
        _emailController.text = '${msg.data.email}';
        _telController.text = '${msg.data.tel}';
      });
    } else {
      logger.e("statuscode != 200");
    }
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
          imageUrl: '${AppConfig.image}$profileImg',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading == false
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 5.0,
                valueColor: AlwaysStoppedAnimation(const Color(0xffF6A911)),
              ),
            )
          : userId != null
              ? ListView(
                  padding: EdgeInsets.all(0),
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 411,
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xffFF7C2C),
                                const Color(0xffFF7C2C),
                                const Color(0xffF6A341),
                                const Color(0xffFFC888),
                              ],
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(20.0, -80.0),
                          child: Stack(
                            children: <Widget>[
                              profileImg == null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 70,
                                      child: _image == null
                                          ? Icon(
                                              Icons.photo,
                                              size: 50,
                                              color: Colors.orange,
                                            )
                                          : CircleAvatar(
                                              radius: 70,
                                              child: ClipOval(
                                                child: Image.file(
                                                  _image,
                                                  fit: BoxFit.cover,
                                                  height: 150,
                                                  width: 500,
                                                ),
                                              ),
                                            ),
                                    )
                                  : CircleAvatar(
                                      radius: 70,
                                      child: ClipOval(
                                        child: _checkImage(),
                                      ),
                                    ),
                              Positioned(
                                right: 0,
                                left: 100,
                                bottom: 0,
                                child: FloatingActionButton(
                                    backgroundColor:
                                        const Color(000000).withOpacity(0.6),
                                    onPressed: () {
                                      getImage(ImageSource.gallery);
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
                                          margin:
                                              EdgeInsets.fromLTRB(30, 0, 0, 0),
                                          child: Text(
                                            'ชื่อ',
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
                                                  new BorderRadius.circular(
                                                      15.0),
                                            ),
                                            margin: EdgeInsets.fromLTRB(
                                                95, 0, 30, 0),
                                            child: new TextFormField(
                                              onChanged: (val) {
                                                _isFirstNameEdit = true;
                                              },
                                              controller: _firstNameController,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        30, 0, 0, 0),
                                                hintStyle:
                                                    TextStyle(fontSize: 14),
                                                fillColor: Colors.grey,
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[350])),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey[350])),
                                                enabledBorder:
                                                    new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          15.0),
                                                  borderSide: new BorderSide(
                                                      color: Colors.grey[350]),
                                                ),
                                                errorBorder:
                                                    new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          15.0),
                                                  borderSide: new BorderSide(
                                                      color: Colors.red),
                                                ),
                                                hintText:
                                                    _firstNameController != null
                                                        ? '$firstName'
                                                        : 'กรอกชื่อ',
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
                                        margin:
                                            EdgeInsets.fromLTRB(30, 30, 0, 30),
                                        child: Text(
                                          'นามสกุล',
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
                                          margin:
                                              EdgeInsets.fromLTRB(55, 0, 30, 0),
                                          child: new TextFormField(
                                            onChanged: (val) {
                                              _isLastNameEdit = true;
                                            },
                                            controller: _lastNameController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      30, 0, 0, 0),
                                              hintStyle:
                                                  TextStyle(fontSize: 14),
                                              fillColor: Colors.grey,
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[350])),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[350])),
                                              enabledBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.grey[350]),
                                              ),
                                              errorBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.red),
                                              ),
                                              hintText: 'กรอกนามสกุล',
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
                                        margin:
                                            EdgeInsets.fromLTRB(30, 30, 0, 30),
                                        child: Text(
                                          'อีเมลล์',
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
                                          margin:
                                              EdgeInsets.fromLTRB(75, 0, 30, 0),
                                          child: new TextFormField(
                                            onChanged: (val) {
                                              _isEmailEdit = true;
                                            },
                                            validator: _validateEmail,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            controller: _emailController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      30, 0, 0, 0),
                                              hintStyle:
                                                  TextStyle(fontSize: 14),
                                              fillColor: Colors.grey,
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[350])),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[350])),
                                              enabledBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.grey[350]),
                                              ),
                                              errorBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.red),
                                              ),
                                              hintText: 'กรอกอีเมลล์',
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
                                        margin:
                                            EdgeInsets.fromLTRB(30, 30, 0, 30),
                                        child: Text(
                                          'เบอร์โทรศัพท์',
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
                                          margin:
                                              EdgeInsets.fromLTRB(20, 0, 30, 0),
                                          child: new TextFormField(
                                            maxLength: 10,
                                            onChanged: (val) {
                                              _isTelEdit = true;
                                            },
                                            keyboardType: TextInputType.number,
                                            controller: _telController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      30, 0, 0, 0),
                                              hintStyle:
                                                  TextStyle(fontSize: 14),
                                              fillColor: Colors.grey,
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[350])),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[350])),
                                              enabledBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.grey[350]),
                                              ),
                                              errorBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.red),
                                              ),
                                              hintText: 'กรอกเบอร์โทร',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 20),
                                    child: Divider(
                                      indent: 30,
                                      color: Colors.black,
                                      endIndent: 30,
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 20, 0, 30),
                                        child: Text(
                                          'ยืนยันรหัสผ่าน',
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
                                          margin:
                                              EdgeInsets.fromLTRB(20, 0, 30, 0),
                                          child: new TextFormField(
                                            onChanged: (val) {
                                              _isEdit = true;
                                            },
                                            keyboardType: TextInputType.text,
                                            controller: _passwordController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      30, 0, 0, 0),
                                              hintStyle:
                                                  TextStyle(fontSize: 14),
                                              fillColor: Colors.grey,
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[350])),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[350])),
                                              enabledBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.grey[350]),
                                              ),
                                              errorBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.red),
                                              ),
                                              hintText: 'กรอกรหัสผ่าน',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 30),
                                    child: Divider(
                                      indent: 30,
                                      color: Colors.black,
                                      endIndent: 30,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(),
                                          width: 132,
                                          height: 40,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            color: Colors.white,
                                            elevation: 5,
                                            child: Container(
                                              child: Text(
                                                "ย้อนกลับ",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xffF6A911),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 30),
                                          width: 132,
                                          height: 40,
                                          child: RaisedButton(
                                            onPressed: () async {
                                              Dio().options.contentType = Headers
                                                  .formUrlEncodedContentType;
                                              if (_formKey.currentState
                                                  .validate()) {
                                                try {
                                                  String url =
                                                      'http://54.151.194.224:8000/api/auth/profile';
                                                  String fileImage = _isEdit
                                                      ? _image.path
                                                          .split('/')
                                                          .last
                                                      : null;
                                                  SharedPreferences
                                                      sharedPreferences =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  String token =
                                                      sharedPreferences
                                                          .getString('token');
                                                  String email =
                                                      _emailController.text
                                                          .trim();
                                                  String firstName =
                                                      _firstNameController.text
                                                          .trim();
                                                  String lastName =
                                                      _lastNameController.text
                                                          .trim();

                                                  String tel = _telController
                                                      .text
                                                      .trim();
                                                  String password =
                                                      _passwordController.text
                                                          .trim();
                                                  // var profileImg =
                                                  //     await MultipartFile
                                                  //         .fromFile(_image.path,
                                                  //             filename:
                                                  //                 fileImage);
                                                  logger.d(
                                                      'data : $password  $userName  $token');
                                                  // String body =
                                                  //     '{"username": "$userName", "email": "$email", "first_name": "$firstName", "last_name": "$lastName", "tel": "$tel", "profile_img": "$profileImg", "confirm_password": "$password", "_method": "_PUT"}';
                                                  // var formData = {
                                                  //   'email': email,
                                                  //   'first_name': firstName,
                                                  //   'last_name': lastName,
                                                  //   'tel': tel,
                                                  //   //     _isEdit ? 'profile_img': _isEdit
                                                  //   // //     ? await MultipartFile
                                                  //   // //         .fromFile(
                                                  //   // //             _image.path,
                                                  //   // //             filename:
                                                  //   // //                 fileImage)
                                                  //   // //     : null,
                                                  //   // // 'profile_img': _isEdit
                                                  //   // //     ? await MultipartFile
                                                  //   // //         .fromFile(
                                                  //   // //             _image.path,
                                                  //   // //             filename:
                                                  //   // //                 fileImage)
                                                  //   // //     : null,
                                                  //   'confirm_password':
                                                  //       password.toString(),
                                                  //   '_method': 'PUT',
                                                  // };

                                                  // FormData formData =
                                                  //     FormData.fromMap({
                                                  //   'image_profile':
                                                  //       await MultipartFile
                                                  //           .fromFile(
                                                  //               _image.path,
                                                  //               filename:
                                                  //                   fileImage)
                                                  // });
                                                  var imageProfile =
                                                      await MultipartFile
                                                          .fromFile(_image.path,
                                                              filename:
                                                                  fileImage);

                                                  var response =
                                                      await http.post(
                                                    url,
                                                    body: {
                                                      _isEmailEdit == true
                                                          ? 'email'
                                                          : email: email,
                                                      _isFirstNameEdit == true
                                                              ? 'first_name'
                                                              : firstName:
                                                          firstName,
                                                      _isLastNameEdit == true
                                                          ? 'last_name'
                                                          : lastName: lastName,
                                                      _isTelEdit == true
                                                          ? 'tel'
                                                          : tel: tel,
                                                      // _isEdit == true
                                                      //     ? 'image_profile'
                                                      //     : imageProfile: null,
                                                      '_method': 'PUT',
                                                      'confirm_password':
                                                          password,
                                                    },
                                                    headers: {
                                                      'Authorization':
                                                          'Bearer $token',
                                                    },
                                                  );

                                                  logger.d(response.statusCode);
                                                  if (response.statusCode ==
                                                      200) {
                                                    logger.d('success');
                                                    showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              Future.delayed(
                                                                  Duration(
                                                                      seconds:
                                                                          3),
                                                                  () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(true);
                                                              });
                                                              return Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0)),
                                                                  child: Container(
                                                                      height: 250.0,
                                                                      width: 300.0,
                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                                                                      child: Column(
                                                                        children: <
                                                                            Widget>[
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
                                                                                        image: AssetImage('assets/images/success.png'),
                                                                                        fit: BoxFit.cover,
                                                                                      )),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                              margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  'แก้ไขโปรไฟล์สำเร็จ',
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Aleo-Bold',
                                                                                    fontSize: 24.0,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                        ],
                                                                      )));
                                                            })
                                                        .then((value) =>
                                                            Navigator.pop(
                                                                context));
                                                  }
                                                } catch (error) {
                                                  if (error.response
                                                          .statusCode ==
                                                      302) {
                                                    // do your stuff here
                                                    logger.e('error: $error');
                                                  }
                                                }
                                              }
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            color: const Color(0xffF6A911),
                                            elevation: 5,
                                            child: Container(
                                              child: Text(
                                                "ยืนยัน",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                )
              :
              //if user not null
              ListView(
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
                                const Color(0xffFF7C2C),
                                const Color(0xffF6A341),
                                const Color(0xffF6A341),
                                const Color(0xffFFC888),
                              ],
                            ),
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
                                    backgroundColor:
                                        const Color(000000).withOpacity(0.6),
                                    onPressed: () {
                                      getImage(ImageSource.gallery);
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
                                          margin:
                                              EdgeInsets.fromLTRB(30, 0, 0, 0),
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
                                                  new BorderRadius.circular(
                                                      15.0),
                                            ),
                                            margin: EdgeInsets.fromLTRB(
                                                60, 0, 30, 0),
                                            child: new TextFormField(
                                              controller: _firstNameController,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        30, 0, 0, 0),
                                                hintStyle:
                                                    TextStyle(fontSize: 14),
                                                fillColor: Colors.grey,
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Colors.grey[350])),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        borderSide: BorderSide(
                                                            color: Colors
                                                                .grey[350])),
                                                enabledBorder:
                                                    new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          15.0),
                                                  borderSide: new BorderSide(
                                                      color: Colors.grey[350]),
                                                ),
                                                errorBorder:
                                                    new OutlineInputBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          15.0),
                                                  borderSide: new BorderSide(
                                                      color: Colors.red),
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
                                        margin:
                                            EdgeInsets.fromLTRB(30, 30, 0, 30),
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
                                            borderRadius:
                                                new BorderRadius.circular(15.0),
                                          ),
                                          margin:
                                              EdgeInsets.fromLTRB(30, 0, 30, 0),
                                          child: new TextFormField(
                                            controller: _passwordController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      30, 0, 0, 0),
                                              hintStyle:
                                                  TextStyle(fontSize: 14),
                                              fillColor: Colors.grey,
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[350])),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[350])),
                                              enabledBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.grey[350]),
                                              ),
                                              errorBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.red),
                                              ),
                                              hintText: 'กรอกรหัสผ่าน',
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
                                        margin:
                                            EdgeInsets.fromLTRB(30, 30, 0, 30),
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
                                            borderRadius:
                                                new BorderRadius.circular(15.0),
                                          ),
                                          margin:
                                              EdgeInsets.fromLTRB(80, 0, 30, 0),
                                          child: new TextFormField(
                                            controller: _telController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      30, 0, 0, 0),
                                              hintStyle:
                                                  TextStyle(fontSize: 14),
                                              fillColor: Colors.grey,
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[350])),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey[350])),
                                              enabledBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.grey[350]),
                                              ),
                                              errorBorder:
                                                  new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        15.0),
                                                borderSide: new BorderSide(
                                                    color: Colors.red),
                                              ),
                                              hintText: 'กรอกเบอร์โทร',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 30),
                                    child: Divider(
                                      indent: 30,
                                      color: Colors.black,
                                      endIndent: 30,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(),
                                          width: 132,
                                          height: 40,
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            onPressed: () {},
                                            color: Colors.white,
                                            elevation: 5,
                                            child: Container(
                                              child: Text(
                                                "ย้อนกลับ",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xffF6A911),
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 30),
                                          width: 132,
                                          height: 40,
                                          child: RaisedButton(
                                            onPressed: () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                String url =
                                                    'http://54.151.194.224:8000/api/auth/profile';
                                                String fileImage = _isEdit
                                                    ? _image.path
                                                        .split('/')
                                                        .last
                                                    : null;
                                                SharedPreferences
                                                    sharedPreferences =
                                                    await SharedPreferences
                                                        .getInstance();
                                                String token = sharedPreferences
                                                    .getString('token');

                                                logger.d(
                                                    'data : $password  $userName  $token');
                                                FormData formData =
                                                    FormData.fromMap({
                                                  'username': userName,
                                                  'email': _emailController.text
                                                      .trim(),
                                                  'first_name':
                                                      _firstNameController.text
                                                          .trim(),
                                                  'last_name':
                                                      _lastNameController.text
                                                          .trim(),
                                                  'tel': _telController.text
                                                      .trim(),
                                                  'profile_img': _isEdit
                                                      ? await MultipartFile
                                                          .fromFile(_image.path,
                                                              filename:
                                                                  fileImage)
                                                      : null,
                                                  'confirm_password':
                                                      _passwordController.text,
                                                  '_method': 'PUT',
                                                });
                                                // logger.d('${formData.fields}');
                                                // logger.d(
                                                //     '${formData.files.toString()}');
                                                try {
                                                  var response =
                                                      await Dio().post(
                                                    url,
                                                    data: formData,
                                                    options: Options(
                                                        headers: {
                                                          "Authorization":
                                                              "Bearer $token",
                                                        },
                                                        followRedirects: false,
                                                        validateStatus:
                                                            (status) {
                                                          return status < 500;
                                                        }),
                                                  );

                                                  logger.d(response.statusCode);
                                                  if (response.statusCode ==
                                                      200) {
                                                    logger.d('success');
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  } else {
                                                    logger.e(
                                                        response.statusMessage);
                                                  }
                                                } catch (error) {
                                                  if (error.response
                                                          .statusCode ==
                                                      302) {
                                                    logger.e(error);
                                                  }
                                                }
                                              }
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            color: const Color(0xffF6A911),
                                            elevation: 5,
                                            child: Container(
                                              child: Text(
                                                "ยืนยัน",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Roboto',
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
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

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:disefood/model/accountdata.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class PaymentPage extends StatefulWidget {
  final int shopId;

  const PaymentPage({
    Key key,
    @required this.shopId,
  }) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int shopId;
  Map jsonMap;
  var accList;
  Future<AccountData> dataList;
  bool isLoading = true;
  bool isUploaded = false;
  File _image;
  @override
  void initState() {
    setState(() {
      shopId = widget.shopId;
    });
    dataList = getAccountNumber();
    super.initState();
  }

  Future<AccountData> getAccountNumber() async {
    String _url = 'http://54.151.194.224:8000/api/shop/$shopId/account-number';
    final response = await http.get(
      _url,
    );
    if (response.statusCode == 200) {
      isLoading = false;
      setState(() {
        var jsonString = response.body;
        jsonMap = json.decode(jsonString);
        accList = AccountData.fromJson(jsonMap);
      });
    } else {
      print('${response.request}');
    }
    return accList;
  }

  void showToast(String msg) {
    Toast.show(msg, context,
        textColor: Colors.white, duration: Toast.LENGTH_LONG);
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Container(
        decoration: new BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 12.0,
              spreadRadius: 5.0,
              offset: Offset(
                10.0,
                10.0,
              ),
            )
          ],
        ),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            padding: EdgeInsets.only(top: 10),
            height: 65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  width: 370,
                  height: 40,
                  child: FloatingActionButton.extended(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.orange,
                      elevation: 4.0,
                      label: Row(
                        children: [
                          Text(
                            'ยืนยันการชำระเงิน',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        if (_image == null) {
                          showToast("โปรดอัพโหลดสลิปก่อน");
                        } else {}
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: Text(
                "การชำระเงิน",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              thickness: 2,
              indent: 30,
              endIndent: 30,
            ),
            Container(
              child: FutureBuilder<AccountData>(
                future: dataList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data.data[index];
                        return Container(
                          margin: EdgeInsets.only(
                            right: 40,
                            left: 40,
                            top: 0,
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(
                                        "${data.channel} :",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Clipboard.setData(new ClipboardData(
                                            text: "${data.number}"));
                                        showToast(
                                            "คัดลอกข้อความไปยังคลิปบอร์ดแล้ว");
                                      },
                                      child: Container(
                                        child: Text(
                                          "${data.number}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: isUploaded,
                                replacement: InkWell(
                                  onTap: () {
                                    getImage(ImageSource.gallery);
                                    setState(() {
                                      isUploaded = true;
                                    });
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 130,
                                    child: Container(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Icon(
                                        Icons.image,
                                        size: 100,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    getImage(ImageSource.gallery);
                                    setState(() {
                                      isUploaded = true;
                                    });
                                  },
                                  child: Container(
                                    child: Container(
                                      child: _image == null
                                          ? Container(
                                              width: 120,
                                              height: 130,
                                              child: Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                child: Icon(
                                                  Icons.image,
                                                  size: 100,
                                                  color: Colors.grey[400],
                                                ),
                                              ),
                                            )
                                          : Container(
                                              color: Colors.grey[400],
                                              margin:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Image.file(
                                                _image,
                                                fit: BoxFit.contain,
                                                width: 270,
                                                height: 390,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 80, left: 80),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  elevation: 8,
                                  onPressed: () {
                                    getImage(ImageSource.gallery);
                                    setState(() {
                                      isUploaded = true;
                                    });
                                  },
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.file_upload,
                                        color: Colors.orange,
                                      ),
                                      Text(
                                        ' อัพโหลดรูป',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(top: 150),
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5.0,
                          valueColor:
                              AlwaysStoppedAnimation(const Color(0xffF6A911)),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/config/app_config.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditBank extends StatefulWidget {
  final String shopName;
  final int shopSlot;
  final String shopImg;
  final int shopId;
  final String bankName;
  final String bankNumber;
  final int bankId;
  const EditBank({
    Key key,
    @required this.shopName,
    @required this.shopSlot,
    @required this.shopImg,
    @required this.shopId,
    @required this.bankName,
    @required this.bankNumber,
    @required this.bankId,
  }) : super(key: key);
  @override
  _EditBankState createState() => _EditBankState();
}

class _EditBankState extends State<EditBank> {
  TextEditingController backAccount = TextEditingController();
  TextEditingController backName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var shopImg;
  String _dropDownValue;
  int shopId;
  int bankId;
  bool _isBankNameEdit = false;
  bool _isBankNumEdit = false;
  bool _isEdit = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      bankId = widget.bankId;
      shopId = widget.shopId;
      backAccount.text = '${widget.bankNumber}';
      backName.text = '${widget.bankName}';
      _dropDownValue = '${widget.bankName}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 0, top: 0, right: 120),
            child: Center(
              child: Text(
                "แก้ไขเลขบัญชี",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 0, right: 0, bottom: 10),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: CachedNetworkImage(
                          imageUrl: '${AppConfig.image}${widget.shopImg}',
                          height: 150,
                          width: 411,
                          fit: BoxFit.fitWidth,
                          placeholder: (context, url) => Container(
                            height: 150,
                            width: 400,
                            color: const Color(0xff7FC9C5),
                            child: Center(
                                child: Center(
                              child: Container(
                                  child: CircularProgressIndicator(
                                strokeWidth: 5.0,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )),
                            )),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.store,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 0, left: 10),
                          child: Text(
                            'เลขบัญชี',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 40, top: 20, right: 10),
                            child: TextFormField(
                              onChanged: (val) {
                                setState(() {
                                  _isBankNumEdit = true;
                                });
                              },
                              key: _formKey,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.length != 10) {
                                  return 'โปรดกรอกให้ครบ10หลัก';
                                }
                                if (value.isEmpty) {
                                  return 'โปรดกรอกเบอร์โทร';
                                }
                                // if(value != 9){
                                //   return 'โปรดกรอกให้ครบ10หลัก';
                                // }
                              },
                              //
                              maxLength: 10,
                              controller: backAccount,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 15),
                                hintText: 'กรอกเลขบัญชี 10 หลัก',
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    )),
                                enabledBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide: new BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                errorBorder: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide: new BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 12, left: 10),
                          child: Text(
                            'ชื่อธนาคาร',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 60,
                            margin:
                                EdgeInsets.only(left: 20, top: 10, right: 10),
                            child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                              ),
                              hint: _dropDownValue == null
                                  ? Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text('เลือกธนาคาร'),
                                    )
                                  : Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(
                                        _dropDownValue,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                              isExpanded: true,
                              iconSize: 30.0,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                              items: [
                                'ธนาคารกรุงเทพ',
                                'ธนาคารกสิกร',
                                'ธนาคารกรุงศรี',
                                'ธนาคารกรุงไทย',
                                'ธนาคารไทยพาณิชย์'
                              ].map(
                                (val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  );
                                },
                              ).toList(),
                              onChanged: (val) {
                                setState(
                                  () {
                                    _isBankNameEdit = true;
                                    _dropDownValue = val;
                                    print('bank name : $_dropDownValue');
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 210),
                        child: ButtonTheme(
                          minWidth: 380.0,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Color(0xffFF7C2C))),
                              child: Container(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: Text(
                                  'ตกลง',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              elevation: 5,
                              color: Color(0xffFF7C2C),
                              onPressed: () async {
                                ApiProvider apiProvider = ApiProvider();
                                SharedPreferences sharedPreferences =
                                    await SharedPreferences.getInstance();
                                String token =
                                    sharedPreferences.getString('token');
                                String accountNum = backAccount.text.trim();
                                String bank = _dropDownValue.toString();
                                String url =
                                    'http://54.151.194.224:8000/api/shop/account-number/update/$bankId';
                                print('edit');
                                var response = await http.post(
                                  url,
                                  body: {
                                    _isBankNumEdit == true
                                        ? 'number'
                                        : accountNum: accountNum,
                                    _isBankNameEdit == true ? 'channel' : bank:
                                        bank,
                                    '_method': 'PUT',
                                  },
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                  },
                                );
                                // var response =
                                //     await apiProvider.editBankAccount(
                                //         token, shopId, accountNum, bank);
                                Logger logger = Logger();
                                logger.d('status: ${response.statusCode}');
                                logger
                                    .d('data : $accountNum , $bank, $token, ');
                                logger.d('shop id: $bankId');

                                if (response.statusCode == 200) {
                                  showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(Duration(seconds: 3),
                                                () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                child: Container(
                                                    height: 250.0,
                                                    width: 300.0,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0)),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Stack(
                                                          children: <Widget>[
                                                            Center(
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            40),
                                                                height: 90.0,
                                                                width: 90.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                50.0),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              AssetImage('assets/images/success.png'),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 30,
                                                                    left: 10,
                                                                    right: 10,
                                                                    bottom: 0),
                                                            child: Center(
                                                              child: Text(
                                                                'แก้ไขบัญชี\nธนาคารสำเร็จ',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Aleo-Bold',
                                                                  fontSize:
                                                                      24.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            )),
                                                      ],
                                                    )));
                                          })
                                      .then((value) => Navigator.pop(context));
                                } else if (response.statusCode != 200) {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            child: Container(
                                                height: 324.0,
                                                width: 300.0,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
                                                child: Column(
                                                  children: <Widget>[
                                                    Stack(
                                                      children: <Widget>[
                                                        Center(
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 40),
                                                            height: 90.0,
                                                            width: 90.0,
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50.0),
                                                                    image:
                                                                        DecorationImage(
                                                                      image: AssetImage(
                                                                          'assets/images/red-cross.png'),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    )),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            top: 20,
                                                            left: 10,
                                                            right: 10,
                                                            bottom: 0),
                                                        child: Center(
                                                          child: Text(
                                                            'กรุณาแก้ไขฟอร์ม\nอย่างใดอย่างหนึ่ง',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Aleo-Bold',
                                                              fontSize: 24.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        )),
                                                    Container(
                                                      height: 60,
                                                      padding: EdgeInsets.only(
                                                          top: 5, bottom: 5),
                                                      margin: EdgeInsets.only(
                                                          left: 80,
                                                          right: 80,
                                                          top: 20,
                                                          bottom: 20),
                                                      child: RaisedButton(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              side: BorderSide(
                                                                  color: Color(
                                                                      0xffFF7C2C))),
                                                          color:
                                                              Color(0xffFF7C2C),
                                                          child: Center(
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      bottom:
                                                                          5),
                                                              child: Text(
                                                                'ตกลง',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                    )
                                                  ],
                                                )));
                                      });
                                }
                              }),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

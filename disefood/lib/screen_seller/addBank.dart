import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/config/app_config.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBank extends StatefulWidget {
  final String shopName;
  final int shopSlot;
  final String shopImg;
  final int shopId;

  const AddBank(
      {Key key,
      @required this.shopName,
      @required this.shopSlot,
      @required this.shopImg,
      @required this.shopId})
      : super(key: key);
  @override
  _AddBankState createState() => _AddBankState();
}

class _AddBankState extends State<AddBank> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController backAccount = TextEditingController();
  TextEditingController backName = TextEditingController();
  var shopImg;
  String _dropDownValue;
  @override
  void initState() {
    setState(() {
      shopImg = widget.shopImg;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 0, top: 0, right: 140),
            child: Center(
              child: Text(
                "เพิ่มเลขบัญชี",
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
        margin: EdgeInsets.only(left: 10, right: 0, bottom: 10),
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
                          width: 400,
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
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 0),
                          child: Text(
                            'เลขบัญชี',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 40, top: 20, right: 10),
                            child: TextFormField(
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
                                contentPadding: const EdgeInsets.only(left: 20),
                                hintText: 'กรอกเลขบัญชี 10 หลัก',
                                hintStyle: TextStyle(
                                    color: Colors.black, fontSize: 18),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 0),
                        child: Text(
                          'ชื่อธนาคาร',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: 20, top: 20, right: 10),
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
                                          fontWeight: FontWeight.normal),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40),
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
                                String bank = _dropDownValue;
                                var response =
                                    await apiProvider.createBankAccount(
                                        token, widget.shopId, accountNum, bank);
                                if (response.statusCode == 200) {
                                  showDialog(
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
                                                            // Container(height: 150.0),
                                                            // Container(
                                                            //   height: 100.0,
                                                            //   decoration: BoxDecoration(
                                                            //       borderRadius: BorderRadius.only(
                                                            //         topLeft: Radius.circular(10.0),
                                                            //         topRight: Radius.circular(10.0),
                                                            //       ),
                                                            //       color: Colors.red),
                                                            // ),
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
                                                                    top: 20,
                                                                    left: 10,
                                                                    right: 10,
                                                                    bottom: 0),
                                                            child: Center(
                                                              child: Text(
                                                                'เพิ่มรายการโปรดสำเร็จ',
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

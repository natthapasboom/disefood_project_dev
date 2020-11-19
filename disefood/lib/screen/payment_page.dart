import 'dart:convert';
import 'dart:ui';
import 'package:disefood/model/accountdata.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
  @override
  void initState() {
    dataList = getAccountNumber();
    setState(() {
      shopId = widget.shopId;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
        child: ListView(
          children: [
            Container(
              child: Text(
                "การชำระเงิน",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Container(
              child: FutureBuilder<AccountData>(
                  future: dataList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.data.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data.data[index];
                                return Container(
                                  child: Column(
                                    children: [
                                      Text("${data.number}"),
                                      Text("${data.number}"),
                                      Text("${data.number}"),
                                      Text("${data.number}"),
                                      Text("${data.number}"),
                                      Text("${data.number}"),
                                    ],
                                  ),
                                );
                              }
                              // getNameShop(data.shopId);
                              )
                          : Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 170),
                                child: Text(
                                  "ยังไม่มีประวัติการซื้อในขณะนี้",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black38,
                                      fontSize: 20),
                                ),
                              ),
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
                  }),
            ),
            Container(
              margin: EdgeInsets.only(right: 80, left: 80),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                elevation: 8,
                onPressed: () {},
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_upload,
                      color: Colors.orange,
                    ),
                    Text(
                      'อัพโหลดรูปภาพ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

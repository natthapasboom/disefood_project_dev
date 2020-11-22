import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/screen_admin/home.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopDetail extends StatefulWidget {
  final int shopId;
  final String name;
  final int shopSlot;
  final String coverImg;
  const ShopDetail(
      {Key key,
      @required this.shopId,
      @required this.name,
      @required this.shopSlot,
      @required this.coverImg})
      : super(key: key);

  @override
  _ShopDetailState createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  Logger logger = Logger();
  String name;
  String coverImg;
  int id;
  int shopSlot;
  ApiProvider apiProvider = ApiProvider();
  @override
  void initState() {
    super.initState();
    setState(() {
      name = widget.name;
      coverImg = widget.coverImg;
      shopSlot = widget.shopSlot;
      id = widget.shopId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 40, top: 30),
                child: Text(
                  "รายละเอียดร้านค้า",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      fontFamily: 'Aleo'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Divider(
                  indent: 40,
                  color: Colors.black,
                  endIndent: 40,
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, top: 10, right: 40),
                decoration: BoxDecoration(
                  color: coverImg == null ? Colors.grey[200] : Colors.white,
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://disefood.s3-ap-southeast-1.amazonaws.com/$coverImg",
                  fit: BoxFit.fitHeight,
                  height: 173,
                  width: 332,
                  placeholder: (context, url) => Container(
                      height: 173,
                      margin: EdgeInsets.only(top: 0, bottom: 0, left: 0),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.amber[900],
                        ),
                      )),
                  errorWidget: (context, url, error) => Container(
                    height: 173,
                    width: 332,
                    color: const Color(0xff7FC9C5),
                    child: Center(
                      child: Icon(
                        Icons.store,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 60, top: 60, right: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ชื่อร้าน : ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Roboto'),
                    ),
                    Text(
                      '$name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 60, top: 30, right: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'สล็อตที่ : ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Roboto'),
                    ),
                    Text(
                      '$shopSlot',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Roboto'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 60, top: 30, right: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "สถานะ :",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Roboto'),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        "ยังไม่ยืนยัน",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: const Color(0xffEC0A25),
                            fontFamily: 'Roboto'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, top: 70, right: 40),
                child: RaisedButton(
                    color: const Color(0xffF6A911),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () async {
                      String approved = '1';
                      String _method = 'PUT';
                      alertDialog(
                          context, 'ยืนยันร้านค้า ?', id, approved, _method);
                    },
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Text(
                          "ยืนยัน",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'Roboto'),
                        ),
                      ),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> alertDialog(BuildContext context, String message, int shopId,
      String approved, String _method) async {
    showDialog(
        context: context,
        builder: (context) => Container(
              child: SimpleDialog(
                title: Container(
                    child: Text(
                  message,
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: 30, top: 10, bottom: 30, right: 100),
                    child: Text(
                      'ท่านต้องการยืนยันร้านค้าใช่หรือไม่',
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xff838181)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: FlatButton(
                            onPressed: () async {
                              SharedPreferences preference =
                                  await SharedPreferences.getInstance();
                              String token = preference.getString('token');
                              print(
                                  "shop_id || approved || method : $id || $approved || $_method");
                              var response = await apiProvider.approveShopById(
                                  token, id, approved, _method);
                              print(response.statusCode);
                              if (response.statusCode == 200) {
                                logger.d('success');
                                MaterialPageRoute route = MaterialPageRoute(
                                    builder: (context) => HomeAdmin());
                                Navigator.pushAndRemoveUntil(
                                    context, route, (route) => false);
                              } else {
                                logger.e('error');
                              }
                            },
                            child: Text(
                              'ยืนยัน',
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xffFF7C2C)),
                            )),
                      ),
                      FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'ยกเลิก',
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xffFF7C2C)),
                          )),
                    ],
                  )
                ],
              ),
            ));
  }
}

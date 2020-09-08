import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/screen_admin/shop_detail.dart';
import 'package:http/http.dart' as http;
import 'package:disefood/component/sidemenu_admin.dart';
import 'package:disefood/component/sidemenu_customer.dart';
import 'package:disefood/model/shopList.dart';
import 'package:disefood/model/shop_id.dart';
import 'package:disefood/model/userById.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAdmin extends StatefulWidget {
  static const routeName = '/home_admin';
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int shopId;
  String name;
  int shopSlot;
  String coverImg;
  String nameUser;
  String lastNameUser;
  String profileImg;
  int userId;
  String email;
  final logger = Logger();
  bool isLoading = true;
  List shops = [];
  ApiProvider apiProvider = ApiProvider();

  //ถ้ามี initState จะทำงานก่อน build
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      findUser();
      getShops();
    });
  }

  Future<UserById> findUser() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    userId = preference.getInt('user_id');
    var response = await apiProvider.getUserById(userId);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map map = json.decode(response.body);
      UserById msg = UserById.fromJson(map);
      var data = msg.data.toJson();
      userId = preference.getInt('user_id');
      setState(() {
        nameUser = msg.data.firstName;
        lastNameUser = msg.data.lastName;
        profileImg = msg.data.profileImg;
        email = msg.data.email;
      });
    } else {
      logger.e("statuscode != 200");
    }
  }

  Future getShops() async {
    String _url = 'http://10.0.2.2:8080/api/shop';
    final response = await http.get(_url);
    var body = response.body;
    setState(() {
      isLoading = false;
      shops = json.decode(body)['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(),
        drawer: SideMenuAdmin(
          firstName: nameUser,
          userId: userId,
          lastName: lastNameUser,
          coverImg: profileImg,
          email: email,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 40, top: 30),
                      child: Text(
                        "ร้านค้าทั้งหมด",
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
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          var item = shops[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 4.0),
                            child: Container(
                              margin: EdgeInsets.all(20),
                              height: 260,
                              child: InkWell(
                                child: Card(
                                  elevation: 8,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CachedNetworkImage(
                                        imageUrl:
                                            "https://disefood.s3-ap-southeast-1.amazonaws.com/${item['cover_img']}",
                                        fit: BoxFit.cover,
                                        height: 121,
                                        width: 380,
                                        placeholder: (context, url) => Center(
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    top: 50, bottom: 35),
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor:
                                                      Colors.amber[900],
                                                ))),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          height: 121,
                                          width: 380,
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
                                      Transform.translate(
                                        offset: Offset(10, 0),
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 10, 0, 10),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                "ร้านที่ ${index + 1} : ${item['name']}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    fontFamily: 'Roboto'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: item['approved'] == 0 ?
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "สถานะ :",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto'),
                                            ),
                                             Container(
                                               margin: EdgeInsets.only(left: 5),
                                               child: Text(
                                                "ยังไม่ยืนยัน",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: const Color(0xffEC0A25),
                                                    fontFamily: 'Roboto'),
                                            ),
                                             ),
                                          ],
                                        ):
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              "สถานะ :",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto'),
                                            ),
                                             Container(
                                               margin: EdgeInsets.only(left: 5),
                                               child: Text(
                                                "ยืนยัน",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: const Color(0xff81CF66),
                                                    fontFamily: 'Roboto'),
                                            ),
                                             ),
                                          ],
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(2, 0),
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[
                                              ButtonBar(
                                                children: <Widget>[
                                                  RaisedButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    onPressed: () {
                                                      name = item['name'];
                                                      shopId = item['id'];
                                                      shopSlot = item['shop_slot'];
                                                      coverImg = item['cover_img'];
                                                      if(item['approved'] == 0){
                                                         Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ShopDetail(name: name, shopId: shopId, shopSlot: shopSlot, coverImg: coverImg,)),
                                                      );
                                                      }else if(item['approved'] == 1){
                                                          print('delete');
                                                            alertDialog(context, 'ลบร้านค้า ?', shopId);
                                                      }
                                                     
                                                    },
                                                    padding: EdgeInsets.only(
                                                        left: 30, right: 30),
                                                    color:
                                                        const Color(0xffF6A911),
                                                    child: item['approved'] == 0 ? Text(
                                                      "ดูรายละเอียด",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ):
                                                    Text(
                                                      "ยกเลิก",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: shops != null ? shops.length : 0,
                      ),
                    ),
                  ],
                ),
              ));
  }
  Future<void> alertDialog(BuildContext context, String message, int shopId,) async {
  showDialog(context: context, 
  builder: (context) => Container(
    
    child: SimpleDialog(
      title: Container(
        
        child: Text(message, style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold),)
        ),
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 30,top: 10,bottom: 30,right: 100),
          child: Text('ท่านต้องการลบร้านค้าใช่หรือไม่',style: TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.normal,color: const Color(0xff838181)),),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              
              child: FlatButton(
                onPressed: () async{
                  var response = await apiProvider.rejectShopByID(shopId);
                  if(response.statusCode == 200) {
                    logger.d('success');
                          MaterialPageRoute route = MaterialPageRoute(builder: (context) => HomeAdmin());
                          Navigator.pushAndRemoveUntil(context, route, (route) => false);
                  }else{
                    logger.e('status code = ${response.statusCode}');
                  }
                }
              , 
              child: Text('ยืนยัน', style: TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.bold,color: const Color(0xffFF7C2C)),)),
            ),
             FlatButton(
              onPressed: () => Navigator.pop(context)
            , 
            child: Text('ยกเลิก', style: TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.bold,color: const Color(0xffFF7C2C)),)),
          ],
        )
      ],
    ),
  ));
}
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopSellerPage extends StatefulWidget {
  @override
  _TopSellerPageState createState() => _TopSellerPageState();
}

class _TopSellerPageState extends State<TopSellerPage> {
  bool _isLoading = false;
  var result;
  Map map;
  List<dynamic> list;
  var jsonMap;
  int userId;
  ApiProvider apiProvider = ApiProvider();
  String email;
  bool isLoading = true;
  Logger logger = Logger();
  Future datasum;
  int count = 0;
  @override
  void initState() {
    _isLoading = false;
    getDataSum();
    super.initState();
    Future.microtask(() {});
  }

  Future getDataSum() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');
    int shopId = sharedPreferences.getInt('shop_id');
    logger.e('shop_id: $shopId');
    String url = 'http://54.151.194.224:8000/api/shop/owner/$shopId/dataSum';
    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    logger.d('status datasum : ${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = true;
        map = json.decode(response.body)['data'];
        for (int i = 0; i < 10; i++) {
          String parseToString = i.toString();

          var forData = map[parseToString];
          if (forData != null) {
            setState(() {
              count = count + 1;
              result = map[parseToString];
              logger.d('json decode $i : ${result.toString()}');
            });
          } else {
            setState(() {
              result = null;
              logger.d('json decode $i : ${result.toString()}');
            });
          }
        }
        logger.d('count item : $count');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            child: _isLoading == true
                ? ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: result,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: Container(
                          child: Text('$index'),
                          height: 50,
                          color: Colors.red,
                        ),
                      );
                    })
                : Center(
                    child: Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                  ),
          )
        ],
      ),
    );
  }
}
// SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.fromLTRB(0, 20, 20, 20),
//                     alignment: Alignment.centerRight,
//                     child: Container(
//                       child: RaisedButton(
//                         onPressed: () {},
//                         child: Text(
//                           "Mock filter",
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       ),
//                     ),
//                   ),
//                   //Listview Replacement //0xffE8CE00
// Container(
//   margin: EdgeInsets.only(right: 20, bottom: 10),
//   decoration: BoxDecoration(
//     //สีแถบ
//     color: const Color(0xffE8CE00),
//     borderRadius: BorderRadius.only(
//       topRight: Radius.circular(20),
//       bottomRight: Radius.circular(20),
//     ),
//   ),
//   width: double.maxFinite,
//   height: 60,
//   child: Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Container(
//         margin: EdgeInsets.only(left: 20),
//         child: Text(
//           "1",
//           style: TextStyle(
//               fontSize: 25,
//               fontWeight: FontWeight.bold,
//               color: Colors.white),
//         ),
//       ),
//       Container(
//         width: 50,
//         height: 50,
//         decoration: new BoxDecoration(
//           shape: BoxShape.circle,
//           image: DecorationImage(
//             fit: BoxFit.fill,
//             image: NetworkImage(
//                 "https://i.pinimg.com/originals/98/fe/e9/98fee9bccce67719f9f356f73124ba75.png"),
//           ),
//         ),
//       ),
//       Container(
//         width: 200,
//         padding: EdgeInsets.only(left: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               child: Text(
//                 "Menu Name",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white),
//               ),
//             ),
//             Container(
//               child: Text("Qty",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white)),
//             ),
//           ],
//         ),
//       ),
//       Container(
//         width: 80,
//         child: Text(
//           "900 บาท",
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white),
//         ),
//       )
//     ],
//   ),
// ),
//                 ],
//               ),
//             ),

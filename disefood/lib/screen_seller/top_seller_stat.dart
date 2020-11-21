import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:disefood/screen/home_customer.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopSellerPage extends StatefulWidget {
  @override
  _TopSellerPageState createState() => _TopSellerPageState();
}

class _TopSellerPageState extends State<TopSellerPage> {
  int userId;
  ApiProvider apiProvider = ApiProvider();
  String email;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return Home();
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return FadeTransition(
              opacity: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(animation),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 400),
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ListView(
          children: [],
        ),
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

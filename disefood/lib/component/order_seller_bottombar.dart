import 'package:disefood/screen_seller//order_seller_page.dart';
import 'package:disefood/screen_seller/organize_seller_page.dart';
import 'package:disefood/component/organize_seller_bottombar.dart';
import 'package:disefood/component/summary_seller_bottombar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:disefood/component/feedback_seller_bottombar.dart';

class OrderSeller extends StatefulWidget {
  OrderSeller({Key key}) : super(key : key);
  @override
  _OrderSellerState createState() => _OrderSellerState();
}

class _OrderSellerState extends State<OrderSeller> {
  int selectIndex = 0;
  final widgetOptions = [
    OrderSellerPage(),
    OrganizeSellerPage(),
    Text('Feed back'),
    Text('Summary'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(selectIndex),
      ),
      bottomNavigationBar:  BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.orange,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        iconSize: 28,
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(icon: Icon(Icons.fastfood,color: Colors.white,),title: Text('Order',style: TextStyle(color: Colors.white),),),
          BottomNavigationBarItem(icon: Icon(Icons.settings,color: Colors.white,),title: Text('Organize',style: TextStyle(color: Colors.white)),),
          BottomNavigationBarItem(icon: Icon(Icons.rate_review,color: Colors.white,),title: Text('Feedback',style: TextStyle(color: Colors.white)),),
          BottomNavigationBarItem(icon: Icon(Icons.equalizer,color: Colors.white,),title: Text('Summary',style: TextStyle(color: Colors.white)),),
        ],
        currentIndex: selectIndex,
        onTap: onItemTapped,
      ),
    );
  }
  void onItemTapped(int index){
    setState((){
      selectIndex = index;
    }
    );
  }
}


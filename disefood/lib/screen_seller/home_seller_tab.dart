
import 'package:disefood/component/feedback_seller_bottombar.dart';
import 'package:disefood/component/organize_seller_bottombar.dart';
import 'package:disefood/component/sidemenu_seller.dart';
import 'package:disefood/component/signout_process.dart';
import 'package:disefood/component/summary_seller_bottombar.dart';
import 'package:disefood/model/shop_id.dart';
import 'package:disefood/screen_seller/addmenu.dart';
import 'package:disefood/screen_seller/home_seller.dart';
import 'package:disefood/screen_seller/order_seller_page.dart';
import 'package:disefood/screen_seller/organize_seller_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  static const routeName = '/home_seller_tab';

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String nameUser;
  String lastNameUser;
  int userId;
  String coverImg;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      findUser();
    });
  }

  int _currentIndex = 0;

  List<Widget> _sellerListPage = [
    HomeSeller(),
    OrderSellerPage(),
    OrganizeSellerPage(),
    FeedbackSeller(),
    SummarySeller(),
  ];

  Future<Null> findUser() async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preference.getString('first_name');
      userId = preference.getInt('user_id');
      lastNameUser = preference.getString('last_name');
      coverImg = preference.getString('profile_img');
    });
  }

  
  



  Widget _titlePage() {
    var title = "";
    
    switch (_currentIndex) {
      case 0:
        title = "หน้าแรก";
        
        break;
      case 1:
        title = "ออเดอร์";
        break;
      case 2:
        title = "จัดการร้านค้า";
        break;
      case 3:
        title = "ความคิดเห็น";
        break;
      case 4:
        title = "สรุปยอดรวม";
        break;
      default:
    }
    return Center(child: Container(
      margin: EdgeInsets.only(right: 50),
      child: Text(title,style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _titlePage(),
        actions: <Widget>[
          
           
        ],
      ),
      drawer: SideMenuSeller(
          firstName: nameUser,
          userId: userId,
          lastName: lastNameUser,
          coverImg: coverImg),
      body: _sellerListPage[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.white,
        backgroundColor: Colors.amber[800],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('หน้าหลัก'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            title: Text('ออเดอร์'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('จัดการร้านค้า'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            title: Text('ความคิดเห็น'),
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.equalizer),
            title: Text('สรุปยอดรวม'),
            backgroundColor: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

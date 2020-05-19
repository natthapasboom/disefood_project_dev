
import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/component/signout_process.dart';
import 'package:disefood/screen_seller/home_seller_tab.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SideMenuSeller extends StatelessWidget {
  final String firstName;
  final int userId; 
  final String lastName; 
  final String coverImg;
  const SideMenuSeller({
    Key key,
    @required this.firstName,@required this.userId,@required this.lastName,@required this.coverImg
  }) : super(key: key);

  

 


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('$firstName  $lastName',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
            accountEmail: Text('nawapan2541@hotmail.com',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
            currentAccountPicture: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider('https://disefood.s3-ap-southeast-1.amazonaws.com/'+'$coverImg'),
              backgroundColor: Colors.white,
            ),
          ),
          //ส่วนที่เป็น Title ใน side  bar
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: (){
              MaterialPageRoute route = MaterialPageRoute(builder: (context)=> Homepage());
                Navigator.of(context).push(route,);
              // Navigator.pop(context
              // );
            },
          ),
          Divider(height: 2,color: Colors.grey,),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
          ),
          Divider(height: 2,color: Colors.grey,),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: (){
              signOutProcess(context);
            },
          ),
          Divider(height: 2,color: Colors.grey,),
        ],
      ),
    );
  }
}

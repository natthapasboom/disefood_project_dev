import 'package:disefood/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:disefood/screen_seller/home_seller.dart';


class SideMenuSeller extends StatelessWidget {
  final UserProfile userData;
  
  const SideMenuSeller({
    Key key,
    @required this.userData,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          UserAccountsDrawerHeader(

            accountName: Text('${userData.firstName} ${userData.lastName}',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
            accountEmail: Text('nawapan2541@hotmail.com',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://disefood.s3-ap-southeast-1.amazonaws.com/${userData.profileImg}"),
              backgroundColor: Colors.white,
            ),
          ),
          //ส่วนที่เป็น Title ใน side  bar
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: (){
            
              Navigator.pop(context
              );
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
          ),
          Divider(height: 2,color: Colors.grey,),
        ],
      ),
    );
  }
}

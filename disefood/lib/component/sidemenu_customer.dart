import 'package:disefood/component/signout_process.dart';
import 'package:disefood/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:disefood/screen/home_customer.dart';



class SideMenuCustomer extends StatelessWidget {
  final String firstName;
  final int userId; 
  final String lastName; 
  final String coverImg;
  const SideMenuCustomer({
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

            accountName: Text('$firstName $lastName',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
            accountEmail: Text('nawapan2541@hotmail.com',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://disefood.s3-ap-southeast-1.amazonaws.com/$coverImg"),
              backgroundColor: Colors.white,
            ),
          ),
          //ส่วนที่เป็น Title ใน side  bar
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: (){
              Navigator.pushNamed(context, Home.routeName);
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

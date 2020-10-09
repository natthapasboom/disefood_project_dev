import 'package:cached_network_image/cached_network_image.dart';
import 'package:disefood/component/signout_process.dart';
import 'package:disefood/screen_admin/home.dart';
import 'package:flutter/material.dart';
import 'package:disefood/screen/home_customer.dart';

import 'editProfile.dart';



class SideMenuAdmin extends StatelessWidget {
  final String firstName;
  final int userId; 
  final String lastName; 
  final String coverImg;
  final String email;
  const SideMenuAdmin({
    Key key,
    @required this.firstName,@required this.userId,@required this.lastName,@required this.coverImg,@required this.email
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
            accountEmail:
            Text('$email',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
            currentAccountPicture: coverImg == null ?
            CircleAvatar(
              backgroundColor: Colors.white,
             child: Icon(Icons.person,color: const Color(0xffFF7C2C),size:64),
            )
            
            :
            CircleAvatar(
              backgroundImage: coverImg == null ? 
              Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.amber[900],
                        ),
                      )
              :CachedNetworkImageProvider('https://disefood.s3-ap-southeast-1.amazonaws.com/'+'$coverImg'),
              backgroundColor: coverImg == null ? const Color(0xffFF7C2C):Colors.white,
            ),
          ),
          //ส่วนที่เป็น Title ใน side  bar
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: (){
              Navigator.pushNamed(context, HomeAdmin.routeName);
            },
          ),
          Divider(height: 2,color: Colors.grey,),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfile()));
            }
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

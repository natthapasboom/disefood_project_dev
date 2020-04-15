import 'package:flutter/material.dart';
import 'package:disefood/screen/home_customer.dart';



class SideMenuCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          UserAccountsDrawerHeader(

            accountName: Text('Nawapan Deeprasertkul',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
            accountEmail: Text('nawapan2541@hotmail.com',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://scontent.fbkk12-2.fna.fbcdn.net/v/t1.0-9/45926892_1046615655508482_3161250217966174208_n.jpg?_nc_cat=104&_nc_sid=85a577&_nc_ohc=W8--WZhlELEAX8G_kDm&_nc_ht=scontent.fbkk12-2.fna&oh=a4ed56493260eea2f5c854fae51a5fb2&oe=5E9FF2E0"),
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
          ),
          Divider(height: 2,color: Colors.grey,),
        ],
      ),
    );
  }
}

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
                  "https://scontent.fbkk12-2.fna.fbcdn.net/v/t1.0-9/45926892_1046615655508482_3161250217966174208_n.jpg?_nc_cat=104&_nc_sid=85a577&_nc_eui2=AeEurEYHU09PTy2q3x-bSQ7Dl3dnA7TbhRyXd2cDtNuFHE8WL7tFPsSOkUzgsaBpi_bkU2avX1IYgdRpTtpum8Hs&_nc_ohc=oXMIThBe7DMAX_x-mOs&_nc_ht=scontent.fbkk12-2.fna&oh=986f9feca93f1007fc91a4b5f9b59028&oe=5EDB4660"),
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

import 'package:disefood/component/signout_process.dart';
import 'package:disefood/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:disefood/screen/home_customer.dart';

import 'editProfile.dart';

class SideMenuCustomer extends StatelessWidget {
  final String firstName;
  final int userId;
  final String lastName;
  final String coverImg;
  final String email;
  const SideMenuCustomer(
      {Key key,
      @required this.firstName,
      @required this.userId,
      @required this.lastName,
      @required this.coverImg,
      @required this.email})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              '$firstName $lastName',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            accountEmail: email == null
                ? Text(
                    'โปรดกรอกอีเมลล์',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  )
                : Text(
                    '$email',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
            currentAccountPicture: coverImg == null
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person,
                        color: const Color(0xffFF7C2C), size: 64),
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://disefood.s3-ap-southeast-1.amazonaws.com/$coverImg"),
                    backgroundColor: coverImg == null
                        ? const Color(0xffFF7C2C)
                        : Colors.white,
                  ),
          ),
          //ส่วนที่เป็น Title ใน side  bar
          ListTile(
            leading: Icon(Icons.home),
            title: Text('หน้าหลัก'),
            onTap: () {
              Navigator.pushNamed(context, Home.routeName);
            },
          ),
          Divider(
            height: 2,
            color: Colors.grey,
          ),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('แก้ไขโปรไฟล์'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditProfile()));
              }),
          Divider(
            height: 2,
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('ออกจากระบบ'),
            onTap: () {
              signOutProcess(context);
            },
          ),
          Divider(
            height: 2,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}


import 'dart:io';
import 'package:disefood/component/sidemenu_seller.dart';
import 'package:disefood/screen_seller/addmenu_seller.dart';
import 'package:disefood/screen_seller/testaddmenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:image_picker/image_picker.dart';

class OrganizeSellerPage extends StatefulWidget {
  String valueFormAddMenu;
  String savePrice;
  OrganizeSellerPage({Key key,this.valueFormAddMenu,this.savePrice}) : super(key : key);
  @override
  _OrganizeSellerPageState createState() => _OrganizeSellerPageState();
}

class _OrganizeSellerPageState extends State<OrganizeSellerPage> {
  Future<File> imageFile;
  var foodMenu ;
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
            return  Image.file(
            snapshot.data,
            width: 150,
            height: 150,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

//Show dialog
//  void _showAlert() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        return AlertDialog(
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.all(Radius.circular(30.0)),
//          ),
//          contentPadding: EdgeInsets.only(top: 10),
//          content: Container(
//            width: 500,
//            height: 550,
//            child: Column(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.stretch,
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                Transform.translate(
//                  offset: Offset(0, -30),
//                  child: Container(
//                    margin: EdgeInsets.only(bottom: 10),
//                    padding: EdgeInsets.only(top: 15, bottom: 15),
//                    // padding: new EdgeInsets.all(10.0),
//                    decoration: new BoxDecoration(
//                      color: Colors.orange,
//                      borderRadius: BorderRadius.only(
//                          topLeft: Radius.circular(30.0),
//                          topRight: Radius.circular(30.0)),
//                    ),
//                    child: new Text(
//                      'เพิ่มเมนู',
//                      style: TextStyle(
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold,
//                        fontSize: 18.0,
//                        fontFamily: 'helvetica_neue_light',
//                      ),
//                      textAlign: TextAlign.center,
//                    ),
//                  ),
//                ),
//                Padding(
//                  padding: EdgeInsets.only(top: 0.0),
//                  child: new Stack(fit: StackFit.loose, children: <Widget>[
//                    new Row(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
//                        new Container(
//                            width: 140.0,
//                            height: 140.0,
//                            decoration: new BoxDecoration(
//                              shape: BoxShape.circle,
//                              image: new DecorationImage(
//                                image: new ExactAssetImage(
//                                    'assets/images/as.png'),
//                                fit: BoxFit.cover,
//                              ),
//                            )),
//                      ],
//                    ),
//                    Padding(
//                        padding: EdgeInsets.only(top: 90.0, right: 100.0),
//                        child: new Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            new CircleAvatar(
//                              backgroundColor: Colors.red,
//                              radius: 25.0,
//                              child: new IconButton(
//                                icon : Icon(Icons.camera_alt,
//                                  color: Colors.white,
//                                ),
//                                onPressed: (){
//                                  pickImageFromGallery(ImageSource.gallery);
//                                },
//                              ),
//                            )
//                          ],
//                        )),
//                  ]),
//                ),
//                InkWell(
//                  onTap: (){
//                    Navigator.pop(context);
//                  },
//                  child: Container(
//                    margin: EdgeInsets.only(top: 290),
//                    padding: EdgeInsets.only(top: 15, bottom: 15),
//                    decoration: BoxDecoration(
//                      color: Colors.orange,
//                      borderRadius: BorderRadius.only(
//                          bottomLeft: Radius.circular(30.0),
//                          bottomRight: Radius.circular(30.0)),
//                    ),
//                    child: Text(
//                      "ยืนยัน",
//                      style: TextStyle(color: Colors.white,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 18),
//                      textAlign: TextAlign.center,
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//        );
//      },
//    );
//  }



    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Container(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.only(left: 0, top: 0, right: 170),
              child: Center(
                child:
                Text(
                  "Organize",
                  style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ),
        drawer: SideMenuSeller(),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 40, top: 30),
              child: Text(
                "รายการอาหาร",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Divider(
                indent: 40,
                color: Colors.black,
                endIndent: 40,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 40),
                    child: widget.valueFormAddMenu == null && widget.savePrice == null?
                    Text("เพิ่มรายการอาหาร"):
                    new Text('${widget.valueFormAddMenu}          ${widget.savePrice}',),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 185),
                    child:   widget.valueFormAddMenu == null && widget.savePrice == null?
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.deepOrange,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMenu(),
                            ));
                      },
                    ):
                        Container(
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0),
              child: Divider(
                indent: 40,
                color: Colors.black,
                endIndent: 40,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 40),
                    child: widget.valueFormAddMenu == null && widget.savePrice == null?
                    Text("เพิ่มรายการอาหาร"):
                    new Text('${widget.valueFormAddMenu}          ${widget.savePrice}',),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 185),
                    child:   widget.valueFormAddMenu == null && widget.savePrice == null?
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.deepOrange,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddMenu(),
                            ));
                      },
                    ):
                    Container(
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.deepOrange,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddMenu(),
                              ));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0),
              child: Divider(
                indent: 40,
                color: Colors.black,
                endIndent: 40,
              ),
            ),
          ],
        ),
      );
    }
  }





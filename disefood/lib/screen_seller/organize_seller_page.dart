
import 'dart:io';
import 'package:disefood/component/sidemenu_seller.dart';
import 'package:disefood/screen_seller/addmenu.dart';
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
                    Text("เพิ่มรายการอาหาร 2"):
                    new Text('${widget.valueFormAddMenu}'),
                  ),
                    Row(
                      children: <Widget>[
                        Container(
                           padding: EdgeInsets.only(left: 200),
                           child: widget.valueFormAddMenu == null && widget.savePrice == null?
                         Text(""):
                         Container(
                           padding: EdgeInsets.only(left: 50),
                             child: new Text('${widget.savePrice}',),
                         ),
                         
                        ),
                      ],
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 0),
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
                            onPressed: (){
                              // if(widget.valueFormAddMenu !=null && widget.savePrice != null){
                                 
                              // }
                              Navigator.push(
                                  context,
                                 MaterialPageRoute(
                                   builder: (context) => AddMenu(),
                                 )
                              );
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





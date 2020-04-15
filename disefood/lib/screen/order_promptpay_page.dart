import 'package:disefood/component/sidemenu_customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'package:image_picker_saver/image_picker_saver.dart';



class PromptpayPage extends StatefulWidget {
  @override
  _PromptpayPageState createState() => _PromptpayPageState();
}

class _PromptpayPageState extends State<PromptpayPage> {
  File _image;

  static GlobalKey screen = new GlobalKey();

  bool noupload = true;

  void imageUploaded() {
    setState(() {
      noupload = false;
    });
  }


//  void ScreenShot() async {
//    RenderRepaintBoundary boundary = screen.currentContext.findRenderObject();
//    ui.Image image = await boundary.toImage();
//    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//    var filePath = await ImagePickerSaver.saveFile(
//        fileData: byteData.buffer.asUint8List());
//    print(filePath);
//  }

  void getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.favorite),
              onPressed: () => debugPrint('Favorite')),
          new IconButton(
              icon: Icon(Icons.archive),
              onPressed: () => debugPrint("archieve")),
        ],
      ),
      drawer: SideMenuCustomer(),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(45, 30, 0, 0),
                child: Text(
                  "การชำระเงิน",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Divider(
                thickness: 3,
                indent: 45,
                endIndent: 45,
              ),
              RepaintBoundary(
                key: screen,
                child: Container(
                  height: 400,
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 150,
                          margin: EdgeInsets.only(top: 30),
                          child: Image.network(
                              "https://www.thaiload.com/wp-content/uploads/2018/01/image.jpeg"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("ร้าน 000001"),
                            Text(" # 999999 Baht"),
                          ],
                        ),
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(top: 10),
                          child: Image.network(
                              "https://boofcv.org/images/thumb/3/35/Example_rendered_qrcode.png/400px-Example_rendered_qrcode.png"),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          width: 200,
                          child: FlatButton(
                            onPressed: (){
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.file_download,
                                  color: Colors.orange,
                                ),
                                Text(
                                  " บันทืกรูปภาพ",
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(45, 20, 0, 0),
                child: Text(
                  "อัพโหลดสลิปการโอน",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              Divider(
                thickness: 3,
                indent: 45,
                endIndent: 45,
              ),
              Container(
                width: 330,
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Visibility(
                        visible: noupload,
                        child: Container(
                          width: 300,
                          child : _image == null?
                          Image.network(
                              "https://wakarusaag.com/wp-content/plugins/oem-showcase-inventory/assets/images/noimage-found.png"):
                              SizedBox(
                                height: 480,
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
                                  height: 360,
                                  width: 300,
                                  child: Container(
                                    height: 500,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Image.file(_image),
                                  ),
                                ),
                              )
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onLongPress: (){
                                getImage();
                                setState(() {
                                  _image;
                                });
                              },
                              color: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.file_upload,
                                    color: Colors.orange,
                                  ),
                                  Text(
                                    "เลือกรูปภาพ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange),
                                  )
                                ],
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 150,
                    margin: EdgeInsets.fromLTRB(0, 10, 20, 20),
                    child: RaisedButton(
                      elevation: 5,
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "ย้อนกลับ",
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                    child: RaisedButton(
                      elevation: 5,
                      color: Colors.orange,
                      onPressed: () {},
                      child: Text(
                        "ยืนยัน",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.orange, width: 2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

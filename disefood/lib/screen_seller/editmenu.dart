import 'dart:io';

import 'package:disefood/component/sidemenu_seller.dart';
import 'package:disefood/model/foods_list.dart';
import 'package:disefood/services/foodservice.dart';
import 'package:flutter/material.dart';
import 'package:disefood/screen_seller/organize_seller_page.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class EditMenuPage extends StatefulWidget {
   final FoodsList foodslist;
  EditMenuPage({Key key, this.foodslist}):super(key:key);
  @override
  _EditMenuPageState createState() => _EditMenuPageState();
}

class _EditMenuPageState extends State<EditMenuPage> {

  
  
  var selectOnStock;
  var selectOutOfStock;
  TextEditingController _nameController =  TextEditingController() ;
   
  TextEditingController _priceController =  TextEditingController();
  
  
  

  
  


  final _formKey = GlobalKey<FormState>();
  File _image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
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
              child: Text(
                "EditMenu",
                style: TextStyle(
                    color: Colors.white,
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
              padding: EdgeInsets.only(top: 60, bottom: 0),
              child: Center(
                child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                       widget.foodslist.coverImage == null
                    ? CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        radius: 75,
                        child: Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        radius: 75,
                        child: ClipOval(
                          child: Image(
                            image : NetworkImage(
                              '${widget.foodslist.coverImage}',
                              
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                      
                        child: FloatingActionButton(  
                          onPressed: (){
                            getImage();
                            setState(() {
                              Image.file(_image);
                            });
                          }, 
                          child: Icon(
                            Icons.add_a_photo
                          )),
                        ),
                    ],
                ),
              
              ),
            ),
           
            Container(
              margin: EdgeInsets.only(top: 40,left: 10,right: 10,bottom: 40),
              child: Card(
                elevation: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Builder(
                    builder: (context) => Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 0.0),
                            child: Text("ชื่อ"),
                          ),
                          TextFormField(
                            
                            decoration: InputDecoration(
                              
                              labelText: '${widget.foodslist.name}',
                             
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'โปรดใส่ชื่ออาหาร';
                              }
                            },   
                            controller: _nameController,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text("ราคา"),
                          ),
                          TextFormField(
                            
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '${widget.foodslist.price}'
                              ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'โปรดใส่ราคา';
                              }
                            },
                           
                            controller: _priceController,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 10.0, left: 25, bottom: 10),
                            child: Text(
                              "Choose Status",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                         
                              Column(
                                children: <Widget>[
                             RadioListTile(
                                title:Text("พร้อมขาย"),
                                value: 0, 
                                groupValue: selectedRadio, 
                                
                                onChanged: (val){
                                    print("Radio $val");
                                     selectOnStock= setSelectedRadio(val);    
                                      
                                },
                                selected: selectedRadio == 0,
                                activeColor: Colors.green,
                                ),
                              RadioListTile(
                                title:Text("ของหมด"),
                                value: 1, 
                                groupValue: selectedRadio, 
                                onChanged: (val){
                                    print("Radio $val");
                                    selectOutOfStock = setSelectedRadio(val);
                                },
                                selected: selectedRadio == 1,
                                activeColor: Colors.red,   
                                ),
                                ],
                              ),
                               Padding(
                            padding:
                                EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: RaisedButton(
                                      color: Colors.green,
                                      onPressed: () {
                                        
                                        final form = _formKey.currentState;
                                        if (form.validate()) {
                                          form.save();
                                          
                                          var addMenuRoute = new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                OrganizeSellerPage(
                                                  
                                            ),
                                          );
                                          Navigator.of(context).push(addMenuRoute);
                                        }
                                      },
                                      child: Text(
                                        'Save',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 30),
                                ),
                                Expanded(
                                  child: RaisedButton(
                                    color: Colors.red,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],                        
                      ),
                    ),
                  ),
                ),
              ),

              
            ),
            
          ],
        ),
    );
  }
  int  selectedRadio;
  void initState() {
    selectedRadio = widget.foodslist.status;
    _nameController.text = '${widget.foodslist.name}';
    _priceController.text = '${widget.foodslist.price}';
    super.initState();

  }

  setSelectedRadio(int val){
    setState(() {
      selectedRadio = val;
    });
  }

}
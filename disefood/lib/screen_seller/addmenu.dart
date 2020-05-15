import 'dart:io';
import 'dart:async';

import 'package:disefood/component/sidemenu_seller.dart';
import 'package:disefood/model/foodinsert.dart';
import 'package:disefood/services/foodservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

class AddMenu extends StatefulWidget {
 final Future<FoodsInsert> foodsInsert ;
  AddMenu({Key key, @required this.foodsInsert}):super(key:key);

  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  

  var selectOnStock;
  var selectOutOfStock;
  String  CREATE_POST_URL = 'http://10.0.2.2:8000/api/foods/';
  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  int groupValue;
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  



  
  final _formKey = GlobalKey<FormState>();
  bool newValue = true;
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
                        "Add Menu",
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
                       _image == null
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
                          child: Image.file(
                            _image,
                            fit: BoxFit.cover,
                            height: 150,
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
                              _image;
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
                              
                              labelText: 'ชื่ออาหาร',
                             
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'โปรดใส่ชื่ออาหาร';
                              }
                            },   
                            controller: nameController,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text("ราคา"),
                          ),
                          TextFormField(
                            
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'ราคา'
                              ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'โปรดใส่ราคา';
                              }
                            },
                           
                            controller: priceController,
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
                                      onPressed: () async{
                                        
                                        final form = _formKey.currentState;
                                        if (form.validate()) {
                                          form.save();
                                          int price = int.parse(priceController.text);
                                          FoodsInsert foodInsert = new FoodsInsert(
                                          foodId: null, shopId: null, name: nameController.text, price: price, status: selectedRadio, coverImage: null);
                                          FoodsInsert f = await createFood1(CREATE_POST_URL,body: foodInsert.toJson());
                                          print(f.name);
                                          
                                          
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


            // Container(
            //   margin: EdgeInsets.all(10),
            //   child: Card(
            //     elevation: 8,
            //     child: Container(
            //       padding:
            //           const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            //       child: Builder(
            //         builder: (context) => Form(
            //           key: _formKey,
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.stretch,
            //             children: <Widget>[
            //               Container(
            //                 padding: EdgeInsets.only(top: 0.0),
            //                 child: Text("ชื่อ"),
            //               ),
            //               TextFormField(
            //                 decoration: InputDecoration(
            //                   labelText: 'ใส่ชื่ออาหาร',
                             
            //                 ),
            //                 validator: (value) {
            //                   if (value.isEmpty) {
            //                     return 'โปรดใส่ชื่ออาหาร';
            //                   }
            //                 },
            //                 onSaved: (val) =>
            //                     setState(() => _addFood.foodName = val),
            //                 controller: saveName,
            //               ),
            //               Container(
            //                 padding: EdgeInsets.only(top: 20.0),
            //                 child: Text("ราคา"),
            //               ),
            //               TextFormField(
            //                 keyboardType: TextInputType.number,
            //                 decoration: InputDecoration(labelText: 'ใส่ราคา'),
            //                 validator: (value) {
            //                   if (value.isEmpty) {
            //                     return 'โปรดใส่ราคา';
            //                   }
            //                 },
            //                 onSaved: (val) => setState(() => _addFood.price = int.parse(val)),
            //                 controller: savePrice,
            //               ),
            //               Container(
            //                 padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            //               ),
            //               Container(
            //                 padding:
            //                     EdgeInsets.only(top: 10.0, left: 25, bottom: 10),
            //                 child: Text(
            //                   "Choose Status",
            //                   style: TextStyle(fontSize: 18),
            //                 ),
            //               ),
                         
            //                   Column(
            //                     children: <Widget>[
            //                  RadioListTile(
            //                     title:Text("พร้อมขาย"),
            //                     value: 1, 
            //                     groupValue: selectedRadio, 
                                
            //                     onChanged: (val){
            //                         print("Radio $val");
            //                          selectOnStock= setSelectedRadio(val);    
                                      
            //                     },
            //                     selected: selectedRadio == 1,
            //                     activeColor: Colors.green,
            //                     ),
            //                   RadioListTile(
            //                     title:Text("ของหมด"),
            //                     value: 2, 
            //                     groupValue: selectedRadio, 
            //                     onChanged: (val){
            //                         print("Radio $val");
            //                         selectOutOfStock = setSelectedRadio(val);
            //                     },
            //                     selected: selectedRadio == 2,
            //                     activeColor: Colors.red,   
            //                     ),
            //                     ],
            //                   ),
            //                    Padding(
            //                 padding:
            //                     EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
            //                 child: new Row(
            //                   mainAxisSize: MainAxisSize.max,
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   children: <Widget>[
            //                     Expanded(
            //                       child: Container(
            //                         child: RaisedButton(
            //                           color: Colors.green,
            //                           onPressed: () {
            //                             final form = _formKey.currentState;
            //                             if (form.validate()) {
            //                               form.save();
            //                               _addFood.save();
            //                               _showDialog(context);
                                          
            //                               var addMenuRoute = new MaterialPageRoute(
            //                                 builder: (BuildContext context) =>
            //                                     OrganizeSellerPage(
            //                                   valueFormAddMenu: saveName.text,
            //                                   savePrice: savePrice.text,
            //                                 ),
            //                               );
            //                               Navigator.of(context).push(addMenuRoute);
            //                             }
            //                           },
            //                           child: Text(
            //                             'Save',
            //                             style: TextStyle(
            //                                 fontSize: 18, color: Colors.white),
            //                           ),
            //                         ),
            //                       ),
            //                     ),
            //                     Container(
            //                       padding: EdgeInsets.only(left: 30),
            //                     ),
            //                     Expanded(
            //                       child: RaisedButton(
            //                         color: Colors.red,
            //                         onPressed: () {
            //                           Navigator.pop(context);
            //                         },
            //                         child: Text(
            //                           'Cancel',
            //                           style: TextStyle(
            //                               fontSize: 18, color: Colors.white),
            //                         ),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ],                        
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),

              
            // ),
            
          ],
        ),
        );
  }

  int  selectedRadio;
  void initState() {
    selectedRadio = 0;
    super.initState();
  }

  setSelectedRadio(int val){
    setState(() {
      selectedRadio = val;
    });
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Add menu finish')));
  }
}

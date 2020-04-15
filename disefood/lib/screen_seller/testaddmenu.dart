import 'dart:io';

import 'package:disefood/component/sidemenu_seller.dart';
import 'package:disefood/screen_seller/organize_seller_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:disefood/model/food.dart';
import 'package:image_picker/image_picker.dart';

class AddMenu extends StatefulWidget {
  @override
  _AddMenuState createState() => _AddMenuState();
}




class _AddMenuState extends State<AddMenu> {
var saveName = new TextEditingController();
var savePrice = new TextEditingController();
int groupValue;
  File _image ;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
  final _addFood = Food();
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
                style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      drawer: SideMenuSeller(),
      body : ListView(
        children: <Widget>[
          Container(
            padding:EdgeInsets.only(top: 60,bottom: 0),
            child: Center(
              child: _image == null ?
               CircleAvatar(
                 backgroundColor: Colors.orangeAccent,
                 radius: 75,
                 child: Icon(Icons.image,size: 80,color: Colors.white,),
               )
                  : CircleAvatar(
                    radius: 75,
                    child: ClipOval(
                      child:
                      Image.file(_image
                        ,fit: BoxFit.cover
                        , height: 150,
                      ),
                    ),

              ),
//                  : Image.file(_image),
            ),
          ),
          Transform.translate(
            offset: Offset(245, -45),
            child: Row(
              children: <Widget>[
                Container(
                   child: FloatingActionButton(
                      elevation: 5,
                      onPressed: (){
                        getImage();
                        setState(() {
                          _image;
                        });
                      },
                      tooltip: 'choose image',
                      child: Icon(Icons.add_a_photo,size: 30,),
                    )
                ),
              ],
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(vertical: 16.0,horizontal: 16.0),
            child: Builder(
              builder: (context) => Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Text("Name"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Please enter your food name';
                        }
                      },
                      onSaved: (val) =>
                          setState(()=>_addFood.foodName = val),
                          controller: saveName,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text("Price"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                      ),
                      validator: (value){
                        if(value.isEmpty){
                          return 'Please enter your price';
                        }
                      },
                      onSaved: (val) =>
                      setState(()=> _addFood.price = val),
                      controller: savePrice,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0,0,0,20),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10.0,left: 25,bottom: 10),
                      child: Text("Choose Status",style: TextStyle(fontSize: 18),),
                    ),
                    RadioListTile(
                        title: const Text("พร้อมขาย",style: TextStyle(fontWeight: FontWeight.bold),),
                        value: _addFood.status[Food.InStock] ,
                        onChanged: (value) {
                          setState(() =>
                          _addFood.status[Food.InStock] = value);
                        },
                            groupValue: groupValue,
                            activeColor: Colors.green,
                            controlAffinity: ListTileControlAffinity.leading,
                    ),
                    RadioListTile(
                        title: const Text("ของหมด",style: TextStyle(fontWeight: FontWeight.bold),),
                        value: _addFood.status[Food.OutOfStock] ,
                        onChanged: (value) {
                          setState(() =>
                          _addFood.status[Food.OutOfStock] = value);
                        },
                      groupValue: groupValue,
                      activeColor: Colors.red,
                      controlAffinity: ListTileControlAffinity.leading,
                     ),
                        Padding(
                            padding:EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 20.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: RaisedButton(
                                      color: Colors.green,
                                      onPressed:(){
                                        final form = _formKey.currentState;
                                        if(form.validate()){
                                          form.save();
                                          _addFood.save();
                                          _showDialog(context);
                                          var addMenuRoute = new MaterialPageRoute(
                                              builder: (BuildContext context) => OrganizeSellerPage(
                                               valueFormAddMenu: saveName.text , savePrice: savePrice.text,
                                              ),
                                          );
                                          Navigator.of(context).push(addMenuRoute);
                                        }
                                      },
                                    child: Text('Save',style: TextStyle(fontSize: 18,color: Colors.white),),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 30),
                              ),
                              Expanded(
                                child: RaisedButton(
                                    color: Colors.red,
                                    onPressed:(){
                                      Navigator.pop(context);
                                    },
                                  child: Text('Cancel',style: TextStyle(fontSize: 18,color: Colors.white),),
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
        ],
      )

    );
  }

  _showDialog(BuildContext context){
    Scaffold.of(context)
      .showSnackBar(SnackBar(content: Text('Add menu finish')));
  }
}



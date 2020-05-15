
import 'package:disefood/model/foods_list.dart';
import 'package:flutter/material.dart';

class OrganizePage extends StatefulWidget {
  OrganizePage({Key key, this.foodsList}) : super(key: key);
  final List<FoodsList> foodsList;
  @override
  _OrganizePageState createState() => _OrganizePageState(foodsList);
}

class _OrganizePageState extends State<OrganizePage> {
   List<FoodsList> foodsList;
  _OrganizePageState(this.foodsList) {
    foodsList = this.foodsList;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
             ListView.builder(
               itemCount: foodsList.length,
               itemBuilder: (context,position){
                 return Container(
                   padding: EdgeInsets.only(top: 0),
                   child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 40),
                                child: 
                                Text('${foodsList[position].name}'),
                              ),
                            ]
                   ),
                 );
               } 
               ),
           
        
    );
  }
}



// class OrganizePage extends StatefulWidget {
//   final List<FoodsList> foodslist;
  
//   const OrganizePage({
//      Key key,
//      @required this.foodslist,    
//   }) : super(key:key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//          child:  Column(
//            children: <Widget>[
//              ListView.builder(
//                itemCount: foodslist.length,
//                itemBuilder: (context,position){
//                  return Container(
//                    padding: EdgeInsets.only(top: 0),
//                    child: Row(
//                             children: <Widget>[
//                               Container(
//                                 padding: EdgeInsets.only(left: 40),
//                                 child: 
//                                 Text('${foodslist[position].name}'),
//                               ),
//                             ]
//                    ),
//                  );
//                } 
//                ),
//            ],
//            ),
//     );
//   }
// }
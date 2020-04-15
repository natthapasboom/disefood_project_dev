import 'package:disefood/screen/menu_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:disefood/component/sidemenu_customer.dart';



class Home extends StatefulWidget {
  static const routeName = '/screen/home_customer';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.favorite),
                onPressed: () => debugPrint('favorite')),
            new IconButton(
                icon: Icon(Icons.archive),
                onPressed: () => debugPrint("archive")),
          ],
        ),
        drawer: SideMenuCustomer(), //EndAppbar
        body: ListView(children: <Widget>[
          searchBox,
          headerSection,
          Divider(
            indent: 40,
            color: Colors.black,
            endIndent: 40,
          ),
        //  card1,
//          card2,
//          card3,
//          card4,
//          card5,
          //card1
          InkWell(
          onTap: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => MenuPage()),);
          },
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              color: Colors.white70,
              margin: EdgeInsets.only(top: 15,bottom: 15,left: 40,right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                      'https://www.prachachat.net/wp-content/uploads/2018/05/3-1024x704-728x501.jpg',width: 380,height: 210,fit: BoxFit.cover
                  ),
                  ListTile(
                    title: Text(
                      "Restaurant 1",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.star,color: Colors.orange,),
                        Text("  4.2 Review(20 Review)")
                      ],
                    ),
                  ),
                ],
//          crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ),
          InkWell(
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              color: Colors.white70,
              margin: EdgeInsets.only(top: 15,bottom: 15,left: 40,right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                      'https://food.mthai.com/app/uploads/2016/02/iStock_000081406371_Small.jpg',width: 380,height: 210,fit: BoxFit.cover
                  ),
                  ListTile(
                    title: Text(
                      "Restaurant 2",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.star,color: Colors.orange,),
                        Text("  4.2 Review(20 Review)")
                      ],
                    ),
                  ),
                ],
//          crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ),
          InkWell(
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              color: Colors.white70,
              margin: EdgeInsets.only(top: 15,bottom: 15,left: 40,right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                      'https://s.isanook.com/mn/0/rp/r/w728/ya0xa0m1w0/aHR0cHM6Ly9zLmlzYW5vb2suY29tL21uLzAvdWQvMTE2LzU4NDQ3My9pc3RvY2stODQzODIwNTYwLmpwZw==.jpg',width: 380,height: 210,fit: BoxFit.cover
                  ),
                  ListTile(
                    title: Text(
                      "Restaurant 3",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.star,color: Colors.orange,),
                        Text("  4.2 Review(20 Review)")
                      ],
                    ),
                  ),
                ],
//          crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ),
          InkWell(
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              color: Colors.white70,
              margin: EdgeInsets.only(top: 15,bottom: 15,left: 40,right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                      'https://www.halalroute.in.th/wp-content/uploads/2016/06/IMG_1579-1024x682.jpg',width: 380,height: 210,fit: BoxFit.cover
                  ),
                  ListTile(
                    title: Text(
                      "Restaurant 4",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.star,color: Colors.orange,),
                        Text("  4.2 Review(20 Review)")
                      ],
                    ),
                  ),
                ],
//          crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ),
          InkWell(
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              color: Colors.white70,
              margin: EdgeInsets.only(top: 15,bottom: 15,left: 40,right: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Image.network(
                      'https://www.prachachat.net/wp-content/uploads/2018/05/3-1024x704-728x501.jpg',width: 380,height: 210,fit: BoxFit.cover
                  ),
                  ListTile(
                    title: Text(
                      "Restaurant 5",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(Icons.star,color: Colors.orange,),
                        Text("  4.2 Review(20 Review)")
                      ],
                    ),
                  ),
                ],
//          crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          )




        ]));
  }
}


Widget searchBox = new Material(
    child: new Container (
        padding: const EdgeInsets.all(30.0),
        child: new Container(
          child: new Center(
              child: new Column(
                  children : [
                    TextFormField(
                      decoration: new InputDecoration(
                        prefixIcon: Icon(Icons.search,color: Colors.black,),
                        labelText: "Enter Restaurant",
                        filled: true,
                        fillColor: Colors.white10,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                        //fillColor: Colors.green
                      ),
                    ),
                  ]
              )
          ),
        )
    )
);





Widget headerSection = Row(
  children: <Widget>[
    Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 40),
      child: Text(
        "Reatuarants",
        style: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
  ],
);
//
//
//Widget card1 = InkWell(
//  child: Card(
//    semanticContainer: true,
//    clipBehavior: Clip.antiAliasWithSaveLayer,
//    elevation: 5,
//    color: Colors.white70,
//    margin: EdgeInsets.only(top: 10,bottom: 10,left: 40,right: 40),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Image.network(
//              'https://www.prachachat.net/wp-content/uploads/2018/05/3-1024x704-728x501.jpg',width: 380,height: 210,fit: BoxFit.cover
//            ),
//            ListTile(
//              title: Text(
//                "Restaurant 1",
//                style: TextStyle(
//                    fontSize: 24,
//                    color: Colors.black,
//                    fontWeight: FontWeight.bold),
//              ),
//              subtitle: Row(
//              children: <Widget>[
//                Icon(Icons.star,color: Colors.orange,),
//                Text("  4.2 Review(20 Review)")
//              ],
//            ),
//            ),
//          ],
////          crossAxisAlignment: CrossAxisAlignment.start,
//        ),
//      ),
//  );
//
//
//Widget card2 = Card(
//  elevation: 5,
//  color: Colors.white70,
//  margin: EdgeInsets.only(top: 10,bottom: 10,left: 40,right: 40),
//  child: Column(
//    children: <Widget>[
//      Container(
//        width: 500,
//        padding: EdgeInsets.all(0.0),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Image.network(
//              'https://food.mthai.com/app/uploads/2016/02/iStock_000081406371_Small.jpg',width: 380,height: 210,fit: BoxFit.cover,
//            ),
//            ListTile(
//              title: Text(
//                "Restaurant 1",
//                style: TextStyle(
//                    fontSize: 24,
//                    color: Colors.black,
//                    fontWeight: FontWeight.bold),
//              ),
//              subtitle: Row(
//                children: <Widget>[
//                  Icon(Icons.star,color: Colors.orange,),
//                  Text("  4.2 Review(20 Review)")
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    ],
//    crossAxisAlignment: CrossAxisAlignment.start,
//  ),
//);
//
//Widget card3 = Card(
//  elevation: 5,
//  color: Colors.white70,
//  margin: EdgeInsets.only(top: 10,bottom: 10,left: 40,right: 40),
//  child: Column(
//    children: <Widget>[
//      Container(
//        width: 500,
//        padding: EdgeInsets.all(0.0),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Image.network(
//              'https://s.isanook.com/mn/0/rp/r/w728/ya0xa0m1w0/aHR0cHM6Ly9zLmlzYW5vb2suY29tL21uLzAvdWQvMTE2LzU4NDQ3My9pc3RvY2stODQzODIwNTYwLmpwZw==.jpg',width: 380,height: 210,fit: BoxFit.cover,
//            ),
//            ListTile(
//              title: Text(
//                "Restaurant 1",
//                style: TextStyle(
//                    fontSize: 24,
//                    color: Colors.black,
//                    fontWeight: FontWeight.bold),
//              ),
//              subtitle: Row(
//                children: <Widget>[
//                  Icon(Icons.star,color: Colors.orange,),
//                  Text("  4.2 Review(20 Review)")
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    ],
//    crossAxisAlignment: CrossAxisAlignment.start,
//  ),
//);
//
//Widget card4 = Card(
//  elevation: 5,
//  color: Colors.white70,
//  margin: EdgeInsets.only(top: 10,bottom: 10,left: 40,right: 40),
//  child: Column(
//    children: <Widget>[
//      Container(
//        padding: EdgeInsets.all(0.0),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Image.network(
//              'https://www.halalroute.in.th/wp-content/uploads/2016/06/IMG_1579-1024x682.jpg',width: 380,height: 210,fit: BoxFit.cover,
//            ),
//            ListTile(
//              title: Text(
//                "Restaurant 1",
//                style: TextStyle(
//                    fontSize: 24,
//                    color: Colors.black,
//                    fontWeight: FontWeight.bold),
//              ),
//              subtitle: Row(
//                children: <Widget>[
//                  Icon(Icons.star,color: Colors.orange,),
//                  Text("  4.2 Review(20 Review)")
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    ],
//    crossAxisAlignment: CrossAxisAlignment.start,
//  ),
//);
//
//Widget card5 = Card(
//  elevation: 5,
//  color: Colors.white70,
//  margin: EdgeInsets.only(top: 10,bottom: 10,left: 40,right: 40),
//  child: Column(
//    children: <Widget>[
//      Container(
//        padding: EdgeInsets.all(0.0),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Image.network(
//              'https://www.prachachat.net/wp-content/uploads/2018/05/3-1024x704-728x501.jpg',width: 380,height: 210,fit: BoxFit.cover,
//            ),
//            ListTile(
//              title: Text(
//                "Restaurant 1",
//                style: TextStyle(
//                    fontSize: 24,
//                    color: Colors.black,
//                    fontWeight: FontWeight.bold),
//              ),
//              subtitle: Row(
//                children: <Widget>[
//                  Icon(Icons.star,color: Colors.orange,),
//                  Text("  4.2 Review(20 Review)")
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    ],
//    crossAxisAlignment: CrossAxisAlignment.start,
//  ),
//);
//
////navigateTosecondPage(BuildContext context){
////  Navigator.push(context, MaterialPageRoute(
////    builder: (card1){
////     return Order();
////    }
////  ));
////}
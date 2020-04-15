import 'package:disefood/component/sidemenu_seller.dart';
import 'package:flutter/material.dart';


class OrderSellerPage extends StatefulWidget {
  OrderSellerPage({Key key}) : super(key : key);
  @override
  _OrderSellerPageState createState() => _OrderSellerPageState();
}

class _OrderSellerPageState extends State<OrderSellerPage> {
  List<String> items = List<String>.generate(7, (index) {
    return "Item + $index";
  });

  List<Card> carditem = new List<Card>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.only(left: 0,top: 0,right: 170),
            child : Center(
              child: Text(
                "Check Order",
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      drawer: SideMenuSeller(),
      body: new ListView.builder(
        itemCount: items.length ,
        itemBuilder: (context,int index){
          final item = items[index];
          return new Dismissible(
            key:  new Key(items[index]),
            child: Container(
              margin: EdgeInsets.all(20),
              height: 335,
              child: InkWell(
                child: Card(
                  elevation: 8,
                  color:  Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network("https://sifu.unileversolutions.com/image/th-TH/recipe-topvisual/2/1260-709/%E0%B8%81%E0%B9%8B%E0%B8%A7%E0%B8%A2%E0%B9%80%E0%B8%95%E0%B8%B5%E0%B9%8B%E0%B8%A2%E0%B8%A7%E0%B8%95%E0%B9%89%E0%B8%A1%E0%B8%A2%E0%B8%B3%E0%B8%AA%E0%B8%B8%E0%B9%82%E0%B8%82%E0%B8%97%E0%B8%B1%E0%B8%A2-50357483.jpg",fit: BoxFit.cover,height: 150,width: 380,),
                      Transform.translate(
                        offset:  Offset(10.0, -140.0),
                        child: Container(
                          margin: EdgeInsets.only(left: 0),
                          padding: EdgeInsets.fromLTRB(5, 4, 5, 5),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "คิวที่ $index",style: TextStyle(fontSize: 14 ,fontWeight: FontWeight.w600,color: Colors.white),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(10, -20),
                        child : Row(
                          children: <Widget>[
                            Text("รายการอาหาร",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(10, -20),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child:  Text("ก๋วยเตี๋ยวต้มยำพิเศษ"),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5,top: 2),
                                child:  Text("2"),
                              ),
                              Container(
                                height: 15,
                                padding: EdgeInsets.only(right: 5,top: 2),
                                child:  VerticalDivider(
                                  color: Colors.black54,
                                  thickness: 2,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child:  Text("ก๋วยเตี๋ยวเย็นตาโฟ"),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5,top: 2),
                                child:  Text("1"),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(10, -20),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                    "ราคา"
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 0,top: 3),
                                child: Text(
                                  "135",style: TextStyle(
                                  color: Colors.green,fontWeight: FontWeight.bold,
                                ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5,top: 2),
                                child: Icon(
                                  Icons.attach_money,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(10, -20),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child :Text(
                                    "เวลาที่จะมารับ"
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Text(
                                    "11.30 AM"
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(2, -15),
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              ButtonBar(
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed:(){
                                      setState(() {
                                        items.removeAt(index);
                                      });
                                    },
                                    padding: EdgeInsets.only(left: 20,right: 20),
                                    color: Colors.orange,
                                    child: Text(
                                      "เสร็จสิ้น",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: ()=> {},
                                    padding: EdgeInsets.only(left: 20,right: 20),
                                    color: Colors.white,
                                    child: Text(
                                      "แก้ไข",style: TextStyle(color: Colors.orangeAccent,fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
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


          );

        },),

    );
  }
}





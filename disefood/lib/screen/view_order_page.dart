import 'package:disefood/component/dialogcomponents/dialog_helper.dart';
import 'package:flutter/material.dart';

class ViewOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 310),
              child: new IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            new IconButton(
              icon: new Icon(Icons.favorite),
              onPressed: () => debugPrint('Favorite'),
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(30, 20, 0, 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "คำสั่งซื้ออาหาร",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                thickness: 3,
                indent: 30,
                endIndent: 30,
              ),
              InkWell(
                onTap: () {
                  DialogHelper.status(context);
                },
                child: Container(
                  //Card ของแต่ละ Order
                  width: 360,
                  height: 80,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          child: Column(
                            children: <Widget>[
                              Text("คิวที่..."),
                              Text("วันที่..."),
                              Text("เวลา..."),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            "ชื่อร้าน...",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          width: 130,
                          padding: EdgeInsets.only(right: 15),
                          child: Text(
                            "ยังไม่ได้รับออเดอร์",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

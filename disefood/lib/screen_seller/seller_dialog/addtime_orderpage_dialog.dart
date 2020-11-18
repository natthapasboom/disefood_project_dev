import 'package:flutter/material.dart';

class AddTimeOrderPage extends StatefulWidget {
  final int qty;
  final VoidCallback add;
  final VoidCallback remove;
  const AddTimeOrderPage({
    Key key,
    @required this.qty,
    @required this.add,
    @required this.remove,
  }) : super(key: key);
  @override
  _AddTimeOrderPageState createState() => _AddTimeOrderPageState();
}

class _AddTimeOrderPageState extends State<AddTimeOrderPage> {
  int qty;
  int timeAddQty;
  VoidCallback add;
  VoidCallback remove;
  @override
  void initState() {
    super.initState();
    setState(() {
      qty = widget.qty;
      timeAddQty = qty;
      add = widget.add;
      remove = widget.remove;
    });
    Future.microtask(() {});
  }

  void addTime() {
    timeAddQty++;
    // checkButtonRemove();
    setState(() {});
  }

  void removeTime() {
    if (timeAddQty > 0) {
      timeAddQty--;
      // checkButtonRemove();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Card(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  height: 100,
                  color: Colors.green,
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.more_time,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "เพิ่มเวลา (นาที)",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: FloatingActionButton(
                          backgroundColor: Colors.orange,
                          onPressed: () {
                            remove();
                            removeTime();
                          },
                          child: Icon(
                            Icons.remove,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: new Text(
                          '$timeAddQty',
                          style: new TextStyle(fontSize: 20.0),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: FloatingActionButton(
                          backgroundColor: Colors.orange,
                          onPressed: () {
                            add();
                            addTime();
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 140,
                        child: RaisedButton(
                          elevation: 8,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          padding: EdgeInsets.only(left: 20, right: 20),
                          color: Colors.white,
                          child: Text(
                            "ยกเลิก",
                            style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        width: 140,
                        child: RaisedButton(
                          elevation: 8,
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          padding: EdgeInsets.only(left: 20, right: 20),
                          color: Colors.orange,
                          child: Text(
                            "ตกลง",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

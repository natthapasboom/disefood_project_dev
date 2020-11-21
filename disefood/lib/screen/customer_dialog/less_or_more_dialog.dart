import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LessOrMoreDialog extends StatefulWidget {
  final String msg;
  const LessOrMoreDialog({
    @required this.msg,
    Key key,
  }) : super(key: key);
  @override
  _LessOrMoreDialogState createState() => _LessOrMoreDialogState();
}

class _LessOrMoreDialogState extends State<LessOrMoreDialog> {
  String msg;

  @override
  void initState() {
    setState(() {
      msg = widget.msg;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Card(
        child: Container(
          height: 170,
          width: 400.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: msg == "more"
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          top: 10, left: 20, right: 10, bottom: 5),
                      child: Text(
                        'จำนวนเงินที่ชำระไม่ถูกต้อง!',
                        style: TextStyle(
                          fontFamily: 'Aleo-Bold',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          top: 0, left: 20, right: 0, bottom: 0),
                      child: Text(
                        'สลิปที่ท่านอัพโหลดมีจำนวนมากเกินไป',
                        style: TextStyle(
                          fontFamily: 'Aleo-Bold',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          top: 0, left: 20, right: 0, bottom: 0),
                      child: Text(
                        'โปรดนำสลิปไปยืนยันกับร้านค้า ',
                        style: TextStyle(
                          fontFamily: 'Aleo-Bold',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          top: 0, left: 20, right: 0, bottom: 10),
                      child: Text(
                        'เพื่อรับเงินส่วนต่างในขณะรับอาหาร',
                        style: TextStyle(
                          fontFamily: 'Aleo-Bold',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 290,
                            child: RaisedButton(
                              elevation: 8,
                              onPressed: () {
                                Navigator.of(context).pop();
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
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(height: 0.0),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          top: 10, left: 20, right: 10, bottom: 5),
                      child: Text(
                        'จำนวนเงินที่ชำระไม่ถูกต้อง!',
                        style: TextStyle(
                          fontFamily: 'Aleo-Bold',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          top: 0, left: 20, right: 0, bottom: 0),
                      child: Text(
                        'สลิปที่ท่านอัพโหลดมีจำนวนน้อยเกินไป',
                        style: TextStyle(
                          fontFamily: 'Aleo-Bold',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          top: 0, left: 20, right: 0, bottom: 0),
                      child: Text(
                        'โปรดชำระเงินเพิ่มให้เท่ากับราคา ',
                        style: TextStyle(
                          fontFamily: 'Aleo-Bold',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          top: 0, left: 20, right: 0, bottom: 10),
                      child: Text(
                        'แล้วนำสลิปไปยืนยันกับร้านค้า',
                        style: TextStyle(
                          fontFamily: 'Aleo-Bold',
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 290,
                            child: RaisedButton(
                              elevation: 8,
                              onPressed: () {
                                Navigator.of(context).pop();
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
      );
}

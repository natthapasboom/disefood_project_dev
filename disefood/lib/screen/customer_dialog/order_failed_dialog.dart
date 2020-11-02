import 'package:flutter/material.dart';

class OrderFailed extends StatefulWidget {
  @override
  _OrderFailedState createState() => _OrderFailedState();
}

class _OrderFailedState extends State<OrderFailed> {
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
          height: 300.0,
          width: 200.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(height: 150.0),
                  // Container(
                  //   height: 100.0,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.only(
                  //         topLeft: Radius.circular(10.0),
                  //         topRight: Radius.circular(10.0),
                  //       ),
                  //       color: Colors.red),
                  // ),
                  Positioned(
                      top: 30.0,
                      left: 94.0,
                      child: Container(
                        height: 90.0,
                        width: 90.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Cross_red_circle.svg/1024px-Cross_red_circle.svg.png'),
                              fit: BoxFit.cover,
                            )),
                      ))
                ],
              ),
              SizedBox(height: 0.0),
              Container(
                  margin:
                      EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0),
                  child: Center(
                    child: Text(
                      'ไม่สามารถทำรายการได้',
                      style: TextStyle(
                        fontFamily: 'Aleo-Bold',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              Container(
                  margin:
                      EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 5),
                  child: Center(
                    child: Text(
                      'กรุณาสั่งซื้อทีละร้านเท่านั้น',
                      style: TextStyle(
                        fontFamily: 'Aleo-Bold',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.only(top: 10, left: 20.0, right: 20.0),
                child: RaisedButton(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: const Color(0xffF6A911))),
                    child: Center(
                      child: Text(
                        'ตกลง',
                        style: TextStyle(
                            fontFamily: 'Aleo-Bold',
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: const Color(0xffF6A911)),
              )
            ],
          ),
        ),
      );
}

import 'package:disefood/screen_seller//order_seller_page.dart';
import 'package:disefood/screen_seller//organize_seller_page.dart';
import 'package:disefood/screen_seller/donut_chart.dart';
import 'package:flutter/material.dart';

class FeedbackSeller extends StatefulWidget {
  @override
  _FeedbackSellerState createState() => _FeedbackSellerState();
}

class _FeedbackSellerState extends State<FeedbackSeller> {
  int rate;
  int _currentIndex = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            child: PieChartSample2(),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(left: 250, right: 40),
            width: 120,
            height: 45,
            child: RaisedButton(
              elevation: 5,
              onPressed: () {
                _displayDialog(context).then((val) {
                  setState(() {
                    rate = val;
                  });
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: rate == null
                        ? Text(
                            'ทั้งหมด',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          )
                        : Text(
                            '$rate ดาว',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.filter_list),
                ],
              ),
              color: Color(0xffE8E8E8),
            ),
          ),
        ],
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 250.0),
            child: AlertDialog(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rating',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text('จำนวนดาว',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Color(0xff838181))),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                      thickness: 2,
                      indent: 1.0, // Starting Space
                      endIndent: 1.0 // Ending Space
                      ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile(
                    dense: true,
                    activeColor: Colors.black,
                    title: Text(
                      "1 ดาว",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    groupValue: _currentIndex,
                    value: 1,
                    onChanged: (val) {
                      setState(() {
                        _currentIndex = val;
                        Navigator.pop(context, _currentIndex);
                      });
                    },
                  ),
                  RadioListTile(
                    activeColor: Colors.black,
                    title: Text(
                      "2 ดาว",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    groupValue: _currentIndex,
                    value: 2,
                    onChanged: (val) {
                      setState(() {
                        _currentIndex = val;
                        Navigator.pop(context, _currentIndex);
                      });
                    },
                  ),
                  RadioListTile(
                    activeColor: Colors.black,
                    title: Text(
                      "3 ดาว",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    groupValue: _currentIndex,
                    value: 3,
                    onChanged: (val) {
                      setState(() {
                        _currentIndex = val;
                        Navigator.pop(context, _currentIndex);
                      });
                    },
                  ),
                  RadioListTile(
                    activeColor: Colors.black,
                    title: Text(
                      "4 ดาว",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    groupValue: _currentIndex,
                    value: 4,
                    onChanged: (val) {
                      setState(() {
                        _currentIndex = val;
                        Navigator.pop(context, _currentIndex);
                      });
                    },
                  ),
                  RadioListTile(
                    activeColor: Colors.black,
                    title: Text(
                      "5 ดาว",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    groupValue: _currentIndex,
                    value: 5,
                    onChanged: (val) {
                      setState(() {
                        _currentIndex = val;
                        Navigator.pop(context, _currentIndex);
                      });
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context, _currentIndex);
                  },
                )
              ],
            ),
          );
        });
  }
}

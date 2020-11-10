import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:disefood/component/star.dart';
import 'package:disefood/model/feedback.dart';
import 'package:disefood/screen_seller//order_seller_page.dart';
import 'package:disefood/screen_seller//organize_seller_page.dart';
import 'package:disefood/screen_seller/donut_chart.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackSeller extends StatefulWidget {
  @override
  _FeedbackSellerState createState() => _FeedbackSellerState();
}

class _FeedbackSellerState extends State<FeedbackSeller> {
  int rate;
  int _currentIndex = 0;
  Logger logger = Logger();
  ApiProvider apiProvider = ApiProvider();
  var feedbacks;
  bool isLoading = false;
  bool isFilter = false;
  Future<Feedbacks> _feedbacks;
  @override
  void initState() {
    isFilter = false;

    _feedbacks = getFeedback();
    isLoading = false;
    // TODO: implement initState
    super.initState();
  }

  Future<Feedbacks> getFeedback() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int _shopId = sharedPreferences.getInt('shop_id');
    String token = sharedPreferences.getString('token');

    var response = await apiProvider.getFeedback(token, _shopId);
    logger.d('status feedback: ${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
        var jsonString = response.body;
        Map jsonMap = json.decode(jsonString);
        feedbacks = Feedbacks.fromJson(jsonMap);
      });
    }
    return feedbacks;
  }

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
        Container(
            child: FutureBuilder<Feedbacks>(
          future: _feedbacks,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.data.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data.data[index];
                    int star = int.parse(data.rating);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 35, bottom: 5),
                          child: Text(
                            'ความคิดเห็นที่: ${index + 1}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: 30, top: 5, bottom: 10, right: 30),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 10,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: Container(
                                      height: 50,
                                      width: 50,
                                      margin: EdgeInsets.only(top: 10),
                                      child: CircleAvatar(
                                        radius: 100,
                                        child: ClipOval(
                                          child: Image.network(
                                            'https://scontent.fbkk12-1.fna.fbcdn.net/v/t1.0-9/122219506_1629765710526804_3970435939360635059_o.jpg?_nc_cat=106&ccb=2&_nc_sid=09cbfe&_nc_eui2=AeG-06TOd9Eumc8zZJEyOlsxA6wP6IFC7EQDrA_ogULsRGiPjcv5ml7SJViHD7ToTxUWz-jchtyTHkOX2tfX7juW&_nc_ohc=r7QeRyebQ_gAX8fBuhB&_nc_ht=scontent.fbkk12-1.fna&oh=8aae713f272479995919a5de87201a11&oe=5FCF6D86',
                                            fit: BoxFit.fill,
                                            width: 50,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: Text(
                                          'Heart Shaker',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        )),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: 5,
                                          ),
                                          child: IconTheme(
                                            data: IconThemeData(
                                              color: Color(0xffF7BA1C),
                                            ),
                                            child: StarDisplay(value: star),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 10),
                                          child: Text(
                                            data.comment,
                                            style: TextStyle(
                                                color: Color(0xff7C7C7C),
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    );
                  });
            } else {
              logger.d(snapshot.connectionState);
              return Container(
                margin: EdgeInsets.only(top: 150),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                    valueColor: AlwaysStoppedAnimation(const Color(0xffF6A911)),
                  ),
                ),
              );
            }
          },
        )),
      ],
    ));
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

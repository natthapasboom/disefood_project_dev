import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:disefood/component/star.dart';
import 'package:disefood/model/feedback.dart';
import 'package:disefood/model/userById.dart';
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
  Future<Feedbacks> _feedbacks1;
  Future<Feedbacks> _feedbacks2;
  Future<Feedbacks> _feedbacks3;
  Future<Feedbacks> _feedbacks4;
  Future<Feedbacks> _feedbacks5;
  List<Feedbacks> _feedbackLists = new List<Feedbacks>();
  var star1;

  var star2;
  var star3;
  var star4;
  var star5;
  String nameUser;
  String profileImg;
  @override
  void initState() {
    isFilter = false;
    logger.d('initail rate filter : $rate');
    // _feedbacks1 = getValue1();
    // _feedbacks2 = getValue2();
    // _feedbacks3 = getValue3();
    // _feedbacks4 = getValue4();
    // _feedbacks5 = getValue5();
    _feedbacks = getFeedback();
    isLoading = false;
    // TODO: implement initState
    super.initState();
  }

  Future<Feedbacks> getFeedback() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int _shopId = sharedPreferences.getInt('shop_id');
    String token = sharedPreferences.getString('token');
    if (rate == null) {
      var response = await apiProvider.getFeedback(token, _shopId);
      logger.d('status feedback: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          var jsonString = response.body;
          Map jsonMap = json.decode(jsonString);
          feedbacks = Feedbacks.fromJson(jsonMap);
        });
      }
    } else if (rate == 1) {
      var response = await apiProvider.getFeedback1(token, _shopId);
      logger.d('status feedback 1: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          var jsonString = response.body;
          Map jsonMap = json.decode(jsonString);
          feedbacks = Feedbacks.fromJson(jsonMap);
        });
        return feedbacks;
      }
    } else if (rate == 2) {
      var response = await apiProvider.getFeedback2(token, _shopId);
      logger.d('status feedback 2: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          var jsonString = response.body;
          Map jsonMap = json.decode(jsonString);
          feedbacks = Feedbacks.fromJson(jsonMap);
        });
        return feedbacks;
      }
    } else if (rate == 3) {
      var response = await apiProvider.getFeedback3(token, _shopId);
      logger.d('status feedback 3: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          var jsonString = response.body;
          Map jsonMap = json.decode(jsonString);
          feedbacks = Feedbacks.fromJson(jsonMap);
          logger.d('feedback 3 star: ${jsonString.toString()}');
        });
        return feedbacks;
      }
    } else if (rate == 4) {
      var response = await apiProvider.getFeedback4(token, _shopId);
      logger.d('status feedback 4: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          var jsonString = response.body;
          Map jsonMap = json.decode(jsonString);
          feedbacks = Feedbacks.fromJson(jsonMap);
        });
        return feedbacks;
      }
    } else if (rate == 5) {
      var response = await apiProvider.getFeedback5(token, _shopId);
      logger.d('status feedback 5: ${response.statusCode}');
      if (response.statusCode == 200) {
        setState(() {
          var jsonString = response.body;
          Map jsonMap = json.decode(jsonString);
          feedbacks = Feedbacks.fromJson(jsonMap);
        });
        return feedbacks;
      }
    }

    return feedbacks;
  }

  // Future<Feedbacks> getValue1() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   int _shopId = sharedPreferences.getInt('shop_id');
  //   String token = sharedPreferences.getString('token');

  //   var response = await apiProvider.getFeedback1(token, _shopId);
  //   // logger.d('status feedback: ${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     List values = [];
  //     values = json.decode(response.body)['data'];
  //     setState(() {
  //       var jsonString = response.body;
  //       Map jsonMap = json.decode(jsonString);

  //       for (int i = 0; i < values.length; i++) {
  //         if (values[i] != null) {
  //           Map map = values[i];
  //           _feedbackLists.add(Feedbacks.fromJson(map));
  //           debugPrint('Id-------${map.length}');
  //           setState(() {
  //             star1 = values.length.toDouble();
  //             logger.d(star1);
  //           });
  //         }
  //       }
  //       // feedbacks = Feedbacks.fromJson(jsonMap);
  //       // return FutureBuilder<Feedbacks>(
  //       //   future: _feedbacks1,
  //       //   builder: (context, snapshot) {
  //       //     if (snapshot.hasData) {
  //       //       setState(() {
  //       //         star1 = snapshot.data.data.length.round();
  //       //         // logger.d('star1 : $star1');
  //       //       });
  //       //     }
  //       //   },
  //       // );
  //     });
  //   }
  //   return feedbacks;
  // }

  // Future<Feedbacks> getValue2() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   int _shopId = sharedPreferences.getInt('shop_id');
  //   String token = sharedPreferences.getString('token');

  //   var response = await apiProvider.getFeedback2(token, _shopId);
  //   // logger.d('status feedback: ${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       var jsonString = response.body;
  //       Map jsonMap = json.decode(jsonString);
  //       feedbacks = Feedbacks.fromJson(jsonMap);
  //       return FutureBuilder<Feedbacks>(
  //         future: _feedbacks2,
  //         builder: (context, snapshot) {
  //           if (snapshot.hasData) {
  //             setState(() {
  //               star2 = snapshot.data.data.length.toDouble();
  //             });
  //           }
  //         },
  //       );
  //     });
  //   }
  //   return feedbacks;
  // }

  // Future<Feedbacks> getValue3() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   int _shopId = sharedPreferences.getInt('shop_id');
  //   String token = sharedPreferences.getString('token');

  //   var response = await apiProvider.getFeedback3(token, _shopId);
  //   // logger.d('status feedback: ${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       var jsonString = response.body;
  //       Map jsonMap = json.decode(jsonString);
  //       feedbacks = Feedbacks.fromJson(jsonMap);
  //       return FutureBuilder<Feedbacks>(
  //         future: _feedbacks3,
  //         builder: (context, snapshot) {
  //           if (snapshot.hasData) {
  //             setState(() {
  //               star3 = snapshot.data.data.length.toDouble();
  //             });
  //           }
  //         },
  //       );
  //     });
  //   }
  //   return feedbacks;
  // }

  // Future<Feedbacks> getValue4() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   int _shopId = sharedPreferences.getInt('shop_id');
  //   String token = sharedPreferences.getString('token');

  //   var response = await apiProvider.getFeedback4(token, _shopId);
  //   // logger.d('status feedback: ${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       var jsonString = response.body;
  //       Map jsonMap = json.decode(jsonString);
  //       feedbacks = Feedbacks.fromJson(jsonMap);
  //       return FutureBuilder<Feedbacks>(
  //         future: _feedbacks4,
  //         builder: (context, snapshot) {
  //           if (snapshot.hasData) {
  //             setState(() {
  //               star4 = snapshot.data.data.length.toDouble();
  //             });
  //           }
  //         },
  //       );
  //     });
  //   }
  //   return feedbacks;
  // }

  // Future<Feedbacks> getValue5() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   int _shopId = sharedPreferences.getInt('shop_id');
  //   String token = sharedPreferences.getString('token');

  //   var response = await apiProvider.getFeedback5(token, _shopId);
  //   // logger.d('status feedback: ${response.statusCode}');
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       var jsonString = response.body;
  //       Map jsonMap = json.decode(jsonString);
  //       feedbacks = Feedbacks.fromJson(jsonMap);
  //       return FutureBuilder<Feedbacks>(
  //         future: _feedbacks5,
  //         builder: (context, snapshot) {
  //           if (snapshot.hasData) {
  //             setState(() {
  //               star5 = snapshot.data.data.length.toDouble();
  //             });
  //           }
  //         },
  //       );
  //     });
  //   }
  //   return feedbacks;
  // }

  // getUserById(int userId) async {
  //   var response = await apiProvider.getUserById(userId);
  //   if (response.statusCode == 200) {
  //     Map jsonMap = json.decode(response.body);
  //     UserById msg = UserById.fromJson(jsonMap);
  //     setState(() {
  //       nameUser = '${msg.data.firstName}  ${msg.data.lastName}';
  //       profileImg = msg.data.profileImg;
  //       var data = {
  //         'name': nameUser,
  //         'profileImg': profileImg,
  //       };
  //       logger.e('profile user : ${data.toString()}');
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      shrinkWrap: true,
      children: [
        Container(
          child: PieChartSample2(
            star1: star1,
            star2: star2,
            star3: star3,
            star4: star4,
            star5: star5,
          ),
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
                  _feedbacks = getFeedback();
                  logger.d('rate filter = $rate');
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
              return snapshot.data.data.length != 0
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
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
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://disefood.s3-ap-southeast-1.amazonaws.com/${data.user.profileImg}',
                                                fit: BoxFit.fill,
                                                width: 50,
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 50, bottom: 35),
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 5.0,
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                              const Color(
                                                                  0xffF6A911)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        title: Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                              '${data.user.firstName}  ${data.user.lastName}',
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
                                                    fontWeight:
                                                        FontWeight.normal),
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
                      })
                  : Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Text(
                          'ยังไม่มีรีวิวของร้านค้านี้',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black38,
                              fontSize: 20),
                        ),
                      ),
                    );
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

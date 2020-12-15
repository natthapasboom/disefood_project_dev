import 'dart:convert';

import 'package:disefood/model/feedback.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'indicator.dart';

class PieChartSample2 extends StatefulWidget {
  final double star1;
  final double star2;
  final double star3;
  final double star4;
  final double star5;

  const PieChartSample2(
      {Key key,
      @required this.star1,
      @required this.star2,
      @required this.star3,
      @required this.star4,
      @required this.star5})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex;
  Logger logger = Logger();
  ApiProvider apiProvider = ApiProvider();
  Future<Feedbacks> _feedbacks1;
  Future<Feedbacks> _feedbacks2;
  Future<Feedbacks> _feedbacks3;
  Future<Feedbacks> _feedbacks4;
  Future<Feedbacks> _feedbacks5;
  List<Feedbacks> _feedbackLists = new List<Feedbacks>();
  var feedbacks;
  var star1;
  var star2;
  var star3;
  var star4;
  var star5;
  @override
  void initState() {
    setState(() {});

    Future.microtask(() {
      get3Star();
      get1Star();
      get2Star();
      get4Star();
      get5Star();
    });

    super.initState();
  }

  Future<double> get3Star() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int _shopId = sharedPreferences.getInt('shop_id');
    String token = sharedPreferences.getString('token');
    logger.e('shopId now : $_shopId');
    var response = await apiProvider.getFeedback3(token, _shopId);
    logger.d('response 3 star: ${response.body}');
    logger.d('response 3 star statusCode: ${response.statusCode}');
    String star = '3';
    int count = 0;
    if (response.statusCode == 200) {
      Map jsonMap = json.decode(response.body);
      Feedbacks feedbacks = Feedbacks.fromJson(jsonMap);
      for (var e in feedbacks.data) {
        var text1 = utf8.encode(star).toString();
        var text2 = utf8.encode(e.rating).toString();
        if (star.contains(e.rating)) {
          setState(() {
            star3 = count.toDouble() + 1.0;
            logger.e('result 3 star: $star3');
          });
        } else {
          star3 = null;
        }
      }

      logger
          .d('lenght of feedback 3 star: ${feedbacks.data.length.toDouble()}');
    }
    return star3;
  }

  Future<double> get1Star() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int _shopId = sharedPreferences.getInt('shop_id');
    String token = sharedPreferences.getString('token');
    logger.e('shopId now : $_shopId');
    var response = await apiProvider.getFeedback1(token, _shopId);
    logger.d('response 1 star: ${response.body}');
    logger.d('response 1 star statusCode: ${response.statusCode}');
    String star = '1';
    int count = 0;
    if (response.statusCode == 200) {
      Map jsonMap = json.decode(response.body);
      Feedbacks feedbacks = Feedbacks.fromJson(jsonMap);
      for (var e in feedbacks.data) {
        if (star.contains(e.rating)) {
          setState(() {
            count = count + 1;
            star1 = count.toDouble();
            logger.e('result 1 star: $star1');
          });
        } else {
          star1 = null;
        }
      }

      logger
          .d('lenght of feedback 3 star: ${feedbacks.data.length.toDouble()}');
    }
    return star1;
  }

  Future<double> get2Star() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int _shopId = sharedPreferences.getInt('shop_id');
    String token = sharedPreferences.getString('token');
    logger.e('shopId now : $_shopId');
    var response = await apiProvider.getFeedback2(token, _shopId);
    logger.d('response 2 star: ${response.body}');
    logger.d('response 2 star statusCode: ${response.statusCode}');
    String star = '2';
    int count = 0;
    if (response.statusCode == 200) {
      Map jsonMap = json.decode(response.body);
      Feedbacks feedbacks = Feedbacks.fromJson(jsonMap);
      for (var e in feedbacks.data) {
        if (star.contains(e.rating)) {
          setState(() {
            count = count + 1;
            star2 = count.toDouble();
            logger.e('result 2 star: $star2');
          });
        } else {
          star2 = null;
        }
      }

      logger
          .d('lenght of feedback 2 star: ${feedbacks.data.length.toDouble()}');
    }
    return star2;
  }

  Future<double> get4Star() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int _shopId = sharedPreferences.getInt('shop_id');
    String token = sharedPreferences.getString('token');
    logger.e('shopId now : $_shopId');
    var response = await apiProvider.getFeedback4(token, _shopId);
    logger.d('response 4 star: ${response.body}');
    logger.d('response 4 star statusCode: ${response.statusCode}');
    String star = '4';
    int count = 0;
    if (response.statusCode == 200) {
      Map jsonMap = json.decode(response.body);
      Feedbacks feedbacks = Feedbacks.fromJson(jsonMap);
      for (var e in feedbacks.data) {
        if (star.contains(e.rating)) {
          setState(() {
            count = count + 1;
            star4 = count.toDouble();
            logger.e('result 4 star: $star4');
          });
        } else {
          star4 = null;
        }
      }

      logger
          .d('lenght of feedback 4 star: ${feedbacks.data.length.toDouble()}');
    }
    return star4;
  }

  Future<double> get5Star() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int _shopId = sharedPreferences.getInt('shop_id');
    String token = sharedPreferences.getString('token');
    logger.e('shopId now : $_shopId');
    var response = await apiProvider.getFeedback5(token, _shopId);
    logger.d('response 5 star: ${response.body}');
    logger.d('response 5 star statusCode: ${response.statusCode}');
    String star = '5';
    int count = 0;
    if (response.statusCode == 200) {
      Map jsonMap = json.decode(response.body);
      Feedbacks feedbacks = Feedbacks.fromJson(jsonMap);
      for (var e in feedbacks.data) {
        if (star.contains(e.rating)) {
          setState(() {
            count = count + 1;
            star5 = count.toDouble();
            logger.e('result 5 star: $star5');
          });
        } else {
          star5 = null;
        }
      }
      // star3 = feedbacks.data.length.toDouble();
      logger
          .d('lenght of feedback 5 star: ${feedbacks.data.length.toDouble()}');
    }
    return star5;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Card(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 0,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 5,
                      centerSpaceRadius: 40,
                      sections: showingSections()),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Indicator(
                    color: Color(0xff4C7286),
                    text: '5',
                    isSquare: true,
                    text2: 'ดีเยี่ยม',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Indicator(
                    color: Color(0xff7FC9C5),
                    text: '4',
                    isSquare: true,
                    text2: 'ดีมาก',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Indicator(
                    color: Color(0xff749591),
                    text: '3',
                    isSquare: true,
                    text2: 'ปานกลาง',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Indicator(
                    color: Color(0xffE8CE00),
                    text: '2',
                    isSquare: true,
                    text2: 'พอใช้ได้',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Indicator(
                    color: Color(0xffDFB60B),
                    text: '1',
                    isSquare: true,
                    text2: 'ควรปรับปรุง',
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return star1 != null ||
            star2 != null ||
            star3 != null ||
            star4 != null ||
            star5 != null
        ? List.generate(5, (i) {
            final isTouched = i == touchedIndex;
            final double fontSize = isTouched ? 25 : 16;
            final double radius = isTouched ? 80 : 60;
            switch (i) {
              case 0:
                return PieChartSectionData(
                  color: const Color(0xff4C7286),
                  value: star5 == null ? 0.0 : star5,
                  title: star5 == null ? '' : '$star5',
                  showTitle: true,
                  radius: radius,
                  titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff)),
                );
              case 1:
                return PieChartSectionData(
                  color: const Color(0xff7FC9C5),
                  value: star4 == null ? 0.0 : star4,
                  title: star4 == null ? '' : '$star4',
                  radius: radius,
                  showTitle: true,
                  titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff)),
                );
              case 2:
                return PieChartSectionData(
                  color: const Color(0xff749591),
                  value: star3 != null ? star3 : 0.0,
                  title: star3 == null ? '' : '$star3',
                  radius: radius,
                  showTitle: true,
                  titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff)),
                );
              case 3:
                return PieChartSectionData(
                  color: const Color(0xffE8CE00),
                  value: star2 == null ? 0.0 : star2,
                  title: star2 == null ? '' : '$star2',
                  radius: radius,
                  showTitle: true,
                  titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff)),
                );
              case 4:
                return PieChartSectionData(
                  color: const Color(0xffDFB60B),
                  value: star1 == null ? 0.0 : star1,
                  title: star1 == null ? '' : '$star1',
                  radius: radius,
                  showTitle: true,
                  titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff)),
                );
              default:
                return null;
            }
          })
        : List.generate(0, (index) => null);
  }
}

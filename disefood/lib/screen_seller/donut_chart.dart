import 'dart:convert';

import 'package:disefood/model/feedback.dart';
import 'package:disefood/services/api_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'indicator.dart';

class PieChartSample2 extends StatefulWidget {
  // final double star1;
  final double star2;
  final double star3;
  final double star4;
  final double star5;

  const PieChartSample2(
      {Key key,
      // @required this.star1,
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
    _feedbacks1 = getValue1();
    _feedbacks2 = getValue2();
    _feedbacks3 = getValue3();
    _feedbacks4 = getValue4();
    _feedbacks5 = getValue5();

    // logger.d('star 1 na: ${widget.star1}');
    // TODO: implement initState
    super.initState();
  }

  Future<Feedbacks> getValue1() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int _shopId = sharedPreferences.getInt('shop_id');
    String token = sharedPreferences.getString('token');
    logger.d('shop id update: $_shopId');
    var response = await apiProvider.getFeedback1(token, _shopId);
    // logger.d('status feedback: ${response.statusCode}');
    if (response.statusCode == 200) {
      List values = [];
      values = json.decode(response.body)['data'];
      setState(() {
        var jsonString = response.body;
        Map jsonMap = json.decode(jsonString);

        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map map = values[i];
            _feedbackLists.add(Feedbacks.fromJson(map));
            debugPrint('Id-------${map.length}');

            sharedPreferences.setDouble('star1', values.length.toDouble());
            star1 = sharedPreferences.getDouble('star1');
            logger.d("star 1: $star1");
          } else {
            star1 = 0;
            logger.d(" star 1: $star1");
          }
        }
      });
    }
    return feedbacks;
  }

  Future<Feedbacks> getValue2() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int _shopId = sharedPreferences.getInt('shop_id');
    String token = sharedPreferences.getString('token');

    var response = await apiProvider.getFeedback2(token, _shopId);
    // logger.d('status feedback: ${response.statusCode}');
    if (response.statusCode == 200) {
      List values = [];
      values = json.decode(response.body)['data'];
      setState(() {
        var jsonString = response.body;
        Map jsonMap = json.decode(jsonString);

        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map map = values[i];
            _feedbackLists.add(Feedbacks.fromJson(map));
            debugPrint('Id-------${map.length}');

            sharedPreferences.setDouble('star2', values.length.toDouble());
            star2 = sharedPreferences.getDouble('star2');
            logger.d(" star 2: $star2");
          } else {
            star2 = 0;
            logger.d(" star 2: $star2");
          }
        }
      });
    }
    return feedbacks;
  }

  Future<Feedbacks> getValue3() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int _shopId = sharedPreferences.getInt('shop_id');
    String token = sharedPreferences.getString('token');
    logger.d('shop id 3: $_shopId');
    var response = await apiProvider.getFeedback3(token, _shopId);
    logger.d('shop id 3: ${response.body}');
    // logger.d('status feedback: ${response.statusCode}');
    if (response.statusCode == 200) {
      List values = [];
      values = json.decode(response.body)['data'];
      setState(() {
        var jsonString = response.body;
        Map jsonMap = json.decode(jsonString);

        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map map = values[i];
            _feedbackLists.add(Feedbacks.fromJson(map));
            debugPrint('Id-------${map.length}');

            sharedPreferences.setDouble('star3', values.length.toDouble());
            star3 = sharedPreferences.getDouble('star3');
            logger.d(" star 3: $star3");
            logger.d('shopId : $_shopId');
          } else {
            star3 = 0;
            logger.d(" star 3: $star3");
          }
        }
      });
    }
    return feedbacks;
  }

  Future<Feedbacks> getValue4() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int _shopId = sharedPreferences.getInt('shop_id');
    String token = sharedPreferences.getString('token');

    var response = await apiProvider.getFeedback4(token, _shopId);
    // logger.d('status feedback: ${response.statusCode}');
    if (response.statusCode == 200) {
      List values = [];
      values = json.decode(response.body)['data'];
      setState(() {
        var jsonString = response.body;
        Map jsonMap = json.decode(jsonString);

        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map map = values[i];
            _feedbackLists.add(Feedbacks.fromJson(map));
            debugPrint('Id-------${map.length}');

            sharedPreferences.setDouble('star4', values.length.toDouble());
            star4 = sharedPreferences.getDouble('star4');
            logger.d(" star 4: $star4");
          } else {
            star4 = 0;
            logger.d(" star 4: $star4");
          }
        }
      });
    }
    return feedbacks;
  }

  Future<Feedbacks> getValue5() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int _shopId = sharedPreferences.getInt('shop_id');
    String token = sharedPreferences.getString('token');

    var response = await apiProvider.getFeedback5(token, _shopId);
    // logger.d('status feedback: ${response.statusCode}');
    if (response.statusCode == 200) {
      List values = [];
      values = json.decode(response.body)['data'];
      setState(() {
        var jsonString = response.body;
        Map jsonMap = json.decode(jsonString);

        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map map = values[i];
            _feedbackLists.add(Feedbacks.fromJson(map));
            debugPrint('Id-------${map.length}');

            sharedPreferences.setDouble('star5', values.length.toDouble());
            star5 = sharedPreferences.getDouble('star5');
            logger.d(" star 5: $star5");
          } else {
            star5 = 0;
            logger.d(" star 5: $star5");
          }
        }
      });
    }
    return feedbacks;
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
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 80 : 60;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff4C7286),
            value: star5 == null ? 0.0 : star5,
            showTitle: false,
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
            title: '30%',
            radius: radius,
            showTitle: false,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff749591),
            value: star3 == null ? 0.0 : star3,
            title: '15%',
            radius: radius,
            showTitle: false,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xffE8CE00),
            value: star2 == null ? 0.0 : star2,
            title: '15%',
            radius: radius,
            showTitle: false,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xffDFB60B),
            value: star1 == null ? 0.0 : star1,
            title: '5%',
            radius: radius,
            showTitle: false,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}

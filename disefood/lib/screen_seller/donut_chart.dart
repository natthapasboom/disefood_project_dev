import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'indicator.dart';

class PieChartSample2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State {
  int touchedIndex;

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
            value: 40,
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
            value: 30,
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
            value: 15,
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
            value: 10,
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
            value: 5,
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

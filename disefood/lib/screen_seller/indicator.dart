import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;
  final String text2;
  const Indicator({
    Key key,
    this.text2,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        ),
        const SizedBox(
          width: 4,
        ),
        Container(
          child: Icon(
            Icons.star,
            color: Color(0xffF7BA1C),
            size: 15,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Container(
          child: Text(
            text2,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.normal, color: textColor),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}

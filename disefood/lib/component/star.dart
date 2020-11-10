import 'package:flutter/material.dart';

class StarDisplay extends StatelessWidget {
  final int value;
  const StarDisplay({Key key, @required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return index < value
            ? Icon(Icons.star)
            : Icon(
                Icons.star,
                color: Color(0xffC4C4C4),
              );
      }),
    );
  }
}

unfilledStar() {
  return Icons.star;
}

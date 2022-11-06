import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String text;
  double fontSize;
  FontWeight fontWeight;
  Color color;

  CustomText({
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: 'Nunito',
        color: color,
      ),
    );
  }
}

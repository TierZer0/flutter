import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  String text;
  double fontSize;
  FontWeight fontWeight;
  Color color;
  String fontFamily;

  EdgeInsets padding;

  TextStyle textStyle;
  bool overrideStyle;

  CustomText({
    this.text = "",
    this.fontSize = 0.0,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.fontFamily = "",
    this.textStyle = const TextStyle(),
    this.overrideStyle = false,
    this.padding = const EdgeInsets.all(0.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text,
        style: overrideStyle
            ? textStyle
            : TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontFamily: fontFamily,
                color: color,
              ),
      ),
    );
  }
}

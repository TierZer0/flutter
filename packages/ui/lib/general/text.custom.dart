import 'package:flutter/material.dart';

enum EText { title, title2, subtitle, body, button, dangerbutton, caption, custom }

class CText extends StatelessWidget {
  final EText? textLevel;
  final String text;
  final FontWeight weight;
  final TextStyle textStyle;

  final double scaleFactor;
  final ThemeData? theme;

  const CText(
    this.text, {
    Key? key,
    this.textLevel,
    this.weight = FontWeight.normal,
    this.scaleFactor = 1.0,
    this.theme,
    this.textStyle = const TextStyle(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (textLevel) {
      case EText.title:
        return Text(
          text,
          textScaleFactor: 1.5,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: weight,
          ),
        );
      case EText.title2:
        return Text(
          text,
          textScaleFactor: 1.2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: weight,
          ),
        );
      case EText.subtitle:
        return Text(
          text,
          textScaleFactor: .95,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: weight,
          ),
        );
      case EText.body:
        return Text(
          text,
          textScaleFactor: 1.1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: weight,
          ),
        );
      case EText.button:
        return Text(
          text,
          textScaleFactor: 1.1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: weight,
          ),
        );
      case EText.dangerbutton:
        return Text(
          text,
          textScaleFactor: 1.1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: weight,
            color: theme!.colorScheme.onError,
          ),
        );
      case EText.caption:
        return Text(
          text,
          textScaleFactor: .8,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: weight,
          ),
        );
      case EText.custom:
        return Text(
          text,
          style: textStyle,
          overflow: TextOverflow.ellipsis,
        );
      default:
        return Text(
          text,
          textScaleFactor: scaleFactor,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: weight,
          ),
        );
    }
  }
}

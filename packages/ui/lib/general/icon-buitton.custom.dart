import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  EdgeInsets padding;
  BorderRadius radius;
  Icon icon;
  double iconSize;
  Color color;
  Color buttonColor;
  VoidCallback onPressed;

  CustomIconButton({
    this.padding = const EdgeInsets.all(1.0),
    this.radius = const BorderRadius.all(Radius.circular(20.0)),
    required this.icon,
    required this.onPressed,
    this.iconSize = 20.0,
    required this.color,
    this.buttonColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Material(
        color: buttonColor,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          color: color,
          icon: icon,
          iconSize: iconSize,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

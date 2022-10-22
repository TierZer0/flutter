import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  BorderRadius borderRadius;
  double elevation;
  Color color;
  Widget child;

  CustomCard({
    required this.borderRadius,
    required this.elevation,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      elevation: elevation,
      color: color,
      child: child,
    );
  }
}

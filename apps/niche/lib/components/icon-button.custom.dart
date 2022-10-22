import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  EdgeInsets externalPadding;
  EdgeInsets internalPadding;
  Color backgroundColor;
  Color iconColor;
  VoidCallback onTap;
  double iconSize;
  IconData icon;

  CustomIconButton({
    required this.externalPadding,
    required this.internalPadding,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
    required this.iconSize,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: externalPadding,
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: internalPadding,
              child: Icon(
                icon,
                size: iconSize,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

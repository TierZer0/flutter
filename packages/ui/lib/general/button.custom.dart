import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  EdgeInsets externalPadding;
  EdgeInsets internalPadding;
  Color buttonColor;
  TextStyle textStyle;
  List<BoxShadow> boxShadows;

  VoidCallback onTap;
  String label;

  CustomButton({
    this.externalPadding = const EdgeInsets.all(1.0),
    this.internalPadding = const EdgeInsets.all(1.0),
    required this.buttonColor,
    required this.onTap,
    this.label = "",
    required this.textStyle,
    this.boxShadows = const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 12.0,
      )
    ],
  });

  BorderRadius borderRadius = const BorderRadius.all(
    Radius.circular(10.0),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: externalPadding,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: borderRadius,
          boxShadow: boxShadows,
        ),
        child: Material(
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: internalPadding,
              child: Center(
                child: Text(
                  label,
                  style: textStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

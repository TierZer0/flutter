import 'package:flutter/material.dart';
import 'package:ui/general/text.custom.dart';

class CustomActionChip extends StatelessWidget {
  EdgeInsets margin;
  EdgeInsets internalPadding;
  Color backgroundColor;
  Color borderColor;
  Color textColor;
  Color activeTextColor;
  Color activeColor;
  bool active;
  String label;
  VoidCallback onTap;

  CustomActionChip({
    this.margin = const EdgeInsets.all(1.0),
    this.internalPadding = const EdgeInsets.all(1.0),
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.activeTextColor,
    required this.activeColor,
    this.active = false,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: internalPadding,
      margin: const EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        right: 15.0,
      ),
      height: 100,
      width: 125,
      duration: const Duration(
        milliseconds: 100,
      ),
      decoration: BoxDecoration(
        color: active ? activeColor : backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            30.0,
          ),
        ),
        border: Border.all(
          color: borderColor,
          width: 2.0,
        ),
      ),
      child: Material(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            30.0,
          ),
        ),
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: CustomText(
              text: label,
              fontSize: 18.0,
              color: active ? activeTextColor : textColor,
              fontWeight: FontWeight.w500,
              fontFamily: 'Lato',
            ),
          ),
        ),
      ),
    );
  }
}

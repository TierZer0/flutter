import 'dart:math';

import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  String label;
  TextEditingController controller;
  TextInputType type;
  VoidCallback onTap;
  bool obscure;
  String? errorText;
  Widget icon;
  double fontSize;

  EdgeInsets padding;
  EdgeInsets contentPadding;
  Color focusColor;
  Color textColor;

  CustomInput({
    this.label = '',
    this.padding = const EdgeInsets.all(1.0),
    this.contentPadding = const EdgeInsets.all(25.0),
    required this.controller,
    this.type = TextInputType.text,
    required this.onTap,
    required this.focusColor,
    required this.textColor,
    this.obscure = false,
    required this.errorText,
    this.icon = const SizedBox(
      height: 0,
      width: 0,
    ),
    this.fontSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: icon,
          errorText: errorText,
          labelText: label,
          labelStyle: TextStyle(
            fontSize: fontSize + 2,
            color: focusColor,
          ),
          contentPadding: contentPadding,
        ),
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
        ),
        cursorColor: focusColor,
        controller: controller,
        keyboardType: type,
        onTap: onTap,
        obscureText: obscure,
      ),
    );
  }
}

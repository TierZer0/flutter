import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  String label;
  TextEditingController controller;
  TextInputType type;
  VoidCallback onTap;
  bool obscure;

  EdgeInsets padding;
  Color focusColor;
  Color textColor;

  CustomInput({
    this.label = '',
    this.padding = const EdgeInsets.all(1.0),
    required this.controller,
    this.type = TextInputType.text,
    required this.onTap,
    required this.focusColor,
    required this.textColor,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 20.0,
            color: focusColor,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          contentPadding: const EdgeInsets.all(25.0),
        ),
        style: TextStyle(
          fontSize: 18,
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

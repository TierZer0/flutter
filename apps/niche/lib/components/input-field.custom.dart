import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  TextEditingController controller;
  String hint;
  Color textColor;
  Color focusColor;
  Color backgroundColor;
  bool obscureText;
  bool isElevated;

  InputField({
    required this.controller,
    required this.hint,
    required this.textColor,
    required this.focusColor,
    required this.backgroundColor,
    required this.obscureText,
    required this.isElevated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.only(
        top: 10,
        left: 5,
        right: 5,
        bottom: 15,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            5,
          ),
        ),
        border: Border.all(
          color: textColor,
          width: 0.1,
        ),
        boxShadow: [
          isElevated
              ? const BoxShadow(blurRadius: 1, color: Colors.black26)
              : const BoxShadow(blurRadius: 0, color: Colors.transparent)
        ],
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: focusColor,
        decoration: InputDecoration(
          focusColor: focusColor,
          floatingLabelStyle: TextStyle(
            color: focusColor,
          ),
          alignLabelWithHint: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          labelText: hint,
        ),
        validator: (String? value) {
          return (value != null && !value.contains('@'))
              ? 'Must be email format'
              : 'test';
        },
      ),
    );
    // return Material(
    //   color: backgroundColor,
    //   elevation: isElevated ? 5.0 : 0.0,
    //   child: TextField(
    //     controller: controller,
    //     style: TextStyle(
    //       color: textColor,
    //       fontSize: 15.0,
    //     ),
    //     cursorColor: focusColor,
    //     obscureText: obscureText,
    //     decoration: InputDecoration(
    //       hintText: hint,
    //       hintStyle: TextStyle(
    //         color: textColor,
    //         fontSize: 15.0,
    //       ),
    //     ),
    //   ),
    // );
  }
}

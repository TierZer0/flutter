import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomReactiveInput<T> extends StatelessWidget {
  String formControlName;
  Map<String, String Function(Object)> validationMessages;
  TextInputAction inputAction;
  int? maxLines;
  TextInputType keyboardType;

  String label;
  Color? textColor;
  double fontSize;
  bool readonly;
  bool obscureText;
  IconData? prefixIcon;

  void Function(FormControl<T>)? onTap;

  CustomReactiveInput({
    super.key,
    required this.inputAction,
    required this.formControlName,
    this.validationMessages = const {},
    required this.label,
    this.textColor,
    this.fontSize = 20.0,
    this.maxLines = 1,
    this.onTap,
    this.readonly = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<T>(
      keyboardType: keyboardType,
      onTap: onTap,
      maxLines: maxLines,
      formControlName: formControlName,
      validationMessages: validationMessages,
      textInputAction: inputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        icon: prefixIcon != null ? Icon(prefixIcon) : null,
        labelText: label,
        helperStyle: const TextStyle(height: 0.7),
        errorStyle: const TextStyle(height: 0.7),
        filled: true,
      ),
      // style: TextStyle(
      //   color: textColor,
      //   fontSize: fontSize,
      // ),
      readOnly: readonly,
    );
  }
}

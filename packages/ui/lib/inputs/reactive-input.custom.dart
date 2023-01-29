import 'dart:math';

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomReactiveInput<T> extends StatelessWidget {
  String formName;
  Map<String, String Function(Object)> validationMessages;
  TextInputAction inputAction;
  int? maxLines;

  String label;
  Color textColor;
  double fontSize;
  bool readonly;
  bool obscureText;

  void Function(FormControl<T>)? onTap;

  CustomReactiveInput({
    super.key,
    required this.inputAction,
    required this.formName,
    this.validationMessages = const {},
    required this.label,
    required this.textColor,
    this.fontSize = 20.0,
    this.maxLines = 1,
    this.onTap,
    this.readonly = false,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<T>(
      onTap: onTap,
      maxLines: maxLines,
      formControlName: formName,
      validationMessages: validationMessages,
      textInputAction: inputAction,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        helperStyle: const TextStyle(height: 0.7),
        errorStyle: const TextStyle(height: 0.7),
      ),
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
      ),
      readOnly: readonly,
    );
  }
}

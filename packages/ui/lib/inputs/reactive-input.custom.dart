import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomReactiveInput<T> extends StatelessWidget {
  String formName;
  Map<String, String Function(Object)> validationMessages;
  TextInputAction inputAction;

  String label;
  Color textColor;
  double fontSize;

  CustomReactiveInput({
    super.key,
    required this.inputAction,
    required this.formName,
    this.validationMessages = const {},
    required this.label,
    required this.textColor,
    this.fontSize = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<T>(
      formControlName: formName,
      validationMessages: validationMessages,
      textInputAction: inputAction,
      decoration: InputDecoration(
        labelText: label,
        helperStyle: const TextStyle(height: 0.7),
        errorStyle: const TextStyle(height: 0.7),
      ),
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
      ),
    );
  }
}

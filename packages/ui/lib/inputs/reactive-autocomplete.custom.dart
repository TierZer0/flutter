import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reactive_raw_autocomplete/reactive_raw_autocomplete.dart';

class CustomReactiveAutocomplete<T> extends StatelessWidget {
  String formName;
  String label;
  FutureOr<Iterable<String>> Function(TextEditingValue) optionsBuilder;
  Color backgroundColor;
  Color textColor;
  double dropdownHeight;

  CustomReactiveAutocomplete({
    super.key,
    required this.formName,
    required this.optionsBuilder,
    required this.backgroundColor,
    required this.textColor,
    this.dropdownHeight = 200.0,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveRawAutocomplete(
      formControlName: formName,
      style: TextStyle(color: textColor, fontSize: 20.0),
      decoration: InputDecoration(
        labelText: label,
        helperStyle: const TextStyle(height: 0.7),
        errorStyle: const TextStyle(height: 0.7),
      ),
      optionsBuilder: optionsBuilder,
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: backgroundColor,
            elevation: 4,
            child: SizedBox(
              height: dropdownHeight,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: options.length,
                itemBuilder: (context, int index) {
                  final String option = options.elementAt(index);
                  return GestureDetector(
                    onTap: () => onSelected(option),
                    child: ListTile(
                      title: Text(
                        option,
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

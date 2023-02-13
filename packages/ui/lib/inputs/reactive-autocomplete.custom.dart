import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_raw_autocomplete/reactive_raw_autocomplete.dart';
import 'package:ui/ui.dart';

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
      // fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
      //   return ReactiveTextField(
      //     formControlName: formName,
      //     onSubmitted: (value) => onFieldSubmitted(),
      //   );
      // },
      optionsBuilder: optionsBuilder,
      optionsViewBuilder: (context, AutocompleteOnSelected<String> onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                height: dropdownHeight,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: options.length,
                  itemBuilder: (context, int index) {
                    final String option = options.elementAt(index);
                    return Material(
                      child: ListTile(
                        tileColor: Colors.red,
                        onTap: () => onSelected(option),
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
          ),
        );
      },
    );
  }
}

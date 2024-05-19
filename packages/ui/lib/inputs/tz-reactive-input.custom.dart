import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:reactive_raw_autocomplete/reactive_raw_autocomplete.dart';

class TZ_ReactiveAutocomplete extends StatelessWidget {
  String? formControlName;
  FormControl? formControl;
  String label;
  FutureOr<Iterable<String>> Function(TextEditingValue) optionsBuilder;
  double dropdownHeight;
  double widthFactor;

  TZ_ReactiveAutocomplete({
    Key? key,
    this.formControlName,
    this.formControl,
    required this.label,
    required this.optionsBuilder,
    this.dropdownHeight = 200.0,
    this.widthFactor = 1.0,
  }) : super(key: key) {
    assert(formControlName != null || formControl != null);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: ReactiveRawAutocomplete(
        formControlName: formControlName,
        formControl: formControl,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
        ),
        optionsBuilder: optionsBuilder,
        optionsViewBuilder: (context, onSelected, options) {
          final theme = Theme.of(context).colorScheme;

          return Align(
            alignment: Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                color: theme.background,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadow.withOpacity(.5),
                    blurRadius: 10.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.transparent,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .85,
                  height: 200,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: options.length,
                    itemBuilder: (context, int index) {
                      final String option = options.elementAt(index);
                      return Material(
                        child: ListTile(
                          onTap: () => onSelected(option),
                          title: Text(
                            option,
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
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/models.dart';
import 'package:reactive_raw_autocomplete/reactive_raw_autocomplete.dart';
import 'package:recipe_book/providers/grocery/grocery.providers.dart';
import 'package:ui/ui.dart';

class RecipeFormIngredientsPart extends ConsumerStatefulWidget {
  final Recipe? recipe;
  final FormGroup formGroup;

  RecipeFormIngredientsPart({this.recipe, required this.formGroup});

  @override
  _RecipeFormIngredientsPartState createState() => _RecipeFormIngredientsPartState();
}

class _RecipeFormIngredientsPartState extends ConsumerState<RecipeFormIngredientsPart> {
  late Recipe? _recipe;
  late FormGroup _formGroup;

  List<String> options = [];

  @override
  void initState() {
    super.initState();

    _recipe = widget.recipe;
    _formGroup = widget.formGroup;

    if (_recipe != null) {
      _formGroup.control('items').value = _recipe!.ingredients;
      _formGroup.markAsPristine();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Wrap(
          spacing: 38,
          runSpacing: 25,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Text(
                'Ingredients',
                textScaler: TextScaler.linear(
                  1.3,
                ),
              ),
            ),
            TZ_ReactiveAutocomplete(
              label: 'Ingredient',
              formControlName: 'ingredients.name',
              optionsBuilder: (search) async {
                if (search.text.isEmpty) return [] as List<String>;

                return (await ref.read(searchGroceryAutocompleteProvider(search.text).future)).payload ?? [];
              },
            ),
            FractionallySizedBox(
              widthFactor: .4,
              child: ReactiveTextField(
                formControlName: 'ingredients.quantity',
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  filled: true,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: ReactiveDropdownField(
                formControlName: 'ingredients.unit',
                decoration: InputDecoration(
                  labelText: 'Unit',
                  filled: true,
                ),
                items: [
                  DropdownMenuItem(
                    child: Text('Cup'),
                    value: 'Cup',
                  ),
                  DropdownMenuItem(
                    child: Text('Tbsp'),
                    value: 'Tbsp',
                  ),
                  DropdownMenuItem(
                    child: Text('Tsp'),
                    value: 'Tsp',
                  ),
                  DropdownMenuItem(
                    child: Text('Oz'),
                    value: 'Oz',
                  ),
                  DropdownMenuItem(
                    child: Text('Lb'),
                    value: 'Lb',
                  ),
                  DropdownMenuItem(
                    child: Text('G'),
                    value: 'G',
                  ),
                  DropdownMenuItem(
                    child: Text('Kg'),
                    value: 'Kg',
                  ),
                ],
              ),
            ),
            ReactiveFormConsumer(
              builder: (context, form, child) {
                final FormGroup _form = form.control('ingredients') as FormGroup;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: () {
                        if (_form.valid) {
                          _form.control('items').value.add(
                                Ingredient(
                                  item: _form.control('name').value,
                                  quantity: _form.control('quantity').value.toString(),
                                  unit: _form.control('unit').value,
                                ),
                              );
                          _form.control('name').reset();
                          _form.control('quantity').reset();
                          _form.control('unit').reset();
                        }
                      },
                      child: Text('Add Ingredient'),
                    ),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        itemCount: _form.control('items').value?.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_form.control('items').value[index].item),
                            subtitle: Text(_form.control('items').value[index].quantity + ' ' + _form.control('items').value[index].unit),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _form.control('items').value.removeAt(index);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

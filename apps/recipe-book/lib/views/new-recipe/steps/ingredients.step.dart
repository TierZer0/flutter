import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/resources.service.dart';
import 'package:recipe_book/shared/table.shared.dart';
import 'package:ui/ui.dart';

class IngredientsStep extends StatefulWidget {
  FormGroup formGroup;
  VoidCallback tapForward;
  VoidCallback tapBack;

  IngredientsStep({
    super.key,
    required this.formGroup,
    required this.tapForward,
    required this.tapBack,
  });

  @override
  IngredientsStepState createState() => IngredientsStepState();
}

class IngredientsStepState extends State<IngredientsStep> {
  List<IngredientModel> _ingredients = [];

  final fields = ['Item', 'Quantity', 'Unit'];
  List<String> _units = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _ingredients = widget.formGroup.control('ingredients.items').value;
    });

    resourcesService.units.then(
      (results) => setState(() {
        _units = List<String>.from(results['Units'] as List);
      }),
    );
  }

  Future<void> _addIngredientDialogBuilder(BuildContext context) {
    widget.formGroup.control('ingredients.item').reset();
    widget.formGroup.control('ingredients.quantity').reset();
    widget.formGroup.control('ingredients.unit').reset();
    return showDialog(
      context: context,
      builder: (context) {
        var theme = Theme.of(context);
        return ReactiveForm(
          formGroup: widget.formGroup,
          child: AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            title: CText(
              "Add Ingredient",
              textLevel: EText.subtitle,
            ),
            content: Wrap(
              spacing: 15.0,
              runSpacing: 20.0,
              children: [
                CustomReactiveInput(
                  formName: 'ingredients.item',
                  inputAction: TextInputAction.next,
                  label: 'Ingredient',
                  textColor: theme.colorScheme.onBackground,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'The Ingredient must not be empty',
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .35,
                  child: CustomReactiveInput(
                    formName: 'ingredients.quantity',
                    inputAction: TextInputAction.next,
                    label: 'Quanity',
                    textColor: theme.colorScheme.onBackground,
                    validationMessages: {
                      ValidationMessage.required: (_) => 'The Quantity must not be empty',
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .35,
                  child: ReactiveDropdownField(
                    decoration: InputDecoration(
                      labelText: "Unit",
                      filled: true,
                    ),
                    formControlName: 'ingredients.unit',
                    dropdownColor: theme.colorScheme.surface,
                    elevation: 2,
                    items: _units
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: CText(
                              item,
                              textLevel: EText.body,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: CText(
                  "Cancel",
                  textLevel: EText.button,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ReactiveFormConsumer(
                builder: (context, formGroup, child) {
                  return FilledButton(
                    child: CText(
                      "Submit",
                      textLevel: EText.button,
                    ),
                    onPressed: formGroup.control('ingredients').invalid
                        ? null
                        : () {
                            final value = formGroup.control('ingredients').value;

                            setState(() {
                              _ingredients.add(IngredientModel(
                                item: value['item'],
                                quantity: value['quantity'],
                                unit: value['unit'],
                              ));
                              widget.formGroup
                                  .control('ingredients.items')
                                  .patchValue(_ingredients);
                            });
                            Navigator.of(context).pop();
                          },
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            TableShared<IngredientModel>(fields: fields, data: _ingredients),
            ReactiveFormConsumer(builder: (context, form, child) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Wrap(
                  spacing: 30,
                  children: [
                    ElevatedButton(
                      onPressed: widget.tapBack,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                        child: CText(
                          "Prior Step",
                          textLevel: EText.button,
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () => _addIngredientDialogBuilder(context),
                      child: Icon(
                        Icons.playlist_add,
                        size: 30,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (form.control('ingredients') as FormGroup)
                                  .control('items')
                                  .value
                                  .length ==
                              0
                          ? null
                          : widget.tapForward,
                      // onPressed: widget.tapForward,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                        child: CText(
                          "Next Step",
                          textLevel: EText.button,
                        ),
                      ),
                    )
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

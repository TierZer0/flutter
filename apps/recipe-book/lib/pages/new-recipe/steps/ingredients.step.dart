import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';

class IngredientsStep extends StatelessWidget {
  FormGroup formGroup;

  IngredientsStep(this.formGroup);

  List<String> units = ['oz', 'grams', 'lb', 'count', 'tbls', 'tsp', 'cup', 'gallon'];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
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
        const SizedBox(
          height: 25.0,
        ),
        Row(
          children: [
            SizedBox(
              height: 75.0,
              width: MediaQuery.of(context).size.width * .45,
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
            const SizedBox(
              width: 10.0,
            ),
            SizedBox(
              height: 80.0,
              width: MediaQuery.of(context).size.width * .35,
              child: ReactiveDropdownField(
                decoration: InputDecoration(
                  label: CustomText(
                    text: "Unit",
                    fontSize: 20.0,
                    fontFamily: "Lato",
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                formControlName: 'ingredients.unit',
                dropdownColor: theme.colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                elevation: 2,
                items: units
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: CustomText(
                          text: item,
                          fontSize: 20.0,
                          fontFamily: "Lato",
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        ReactiveFormConsumer(builder: (context, form, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: form.control('ingredients').invalid
                    ? null
                    : () {
                        form.markAsUntouched();
                        AbstractControl<dynamic> group = form.control('ingredients');
                        if (group.invalid) {
                          group.markAllAsTouched();
                          return;
                        }
                        List<IngredientModel> items = group.value['items'] ?? [];
                        items.add(IngredientModel(
                          item: group.value['item'],
                          quantity: group.value['quantity'],
                          unit: group.value['unit'],
                        ));
                        group.patchValue({'item': null, 'quantity': null, 'unit': null});
                        form.control('ingredients').patchValue({'items': items});
                      },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                  child: CustomText(
                    text: "Add Ingredient",
                    fontSize: 20.0,
                    fontFamily: "Lato",
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              SizedBox(
                height: 200.0,
                child: ListView(
                  children: form
                      .control('ingredients')
                      .value['items']
                      .map<Widget>(
                        (IngredientModel item) => CustomText(
                          text: item.toString(),
                          fontSize: 20.0,
                          fontFamily: "Lato",
                          color: theme.colorScheme.onBackground,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

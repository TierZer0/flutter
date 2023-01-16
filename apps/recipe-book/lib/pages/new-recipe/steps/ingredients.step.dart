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
          textColor: (theme.textTheme.titleLarge?.color)!,
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
                textColor: (theme.textTheme.titleLarge?.color)!,
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
                    color: (theme.textTheme.titleLarge?.color)!,
                  ),
                ),
                formControlName: 'ingredients.unit',
                dropdownColor: theme.backgroundColor,
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
                          color: (theme.textTheme.titleLarge?.color)!,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        CustomButton(
          buttonColor: primaryColor,
          onTap: () {
            formGroup.markAsUntouched();
            AbstractControl<dynamic> group = formGroup.control('ingredients');
            if (group.invalid) {
              group.markAllAsTouched();
              return;
            }
            List<Ingredient> items = group.value['items'] ?? [];
            items
                .add(Ingredient(group.value['item'], group.value['quantity'], group.value['unit']));
            formGroup.control('ingredients').patchValue({'items': items});
          },
          label: "Add Ingredient",
          externalPadding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * .5, top: 10.0, bottom: 10.0),
          internalPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 15.0,
          ),
          textStyle: GoogleFonts.lato(
            color: darkThemeTextColor,
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
          ),
        ),
        SizedBox(
          height: 200.0,
          child: ListView(
            children: formGroup
                .control('ingredients')
                .value['items']
                .map<Widget>(
                  (Ingredient item) => CustomText(
                    text: item.toString(),
                    fontSize: 20.0,
                    fontFamily: "Lato",
                    color: (theme.textTheme.titleLarge?.color)!,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

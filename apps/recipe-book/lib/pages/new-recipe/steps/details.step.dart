import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:ui/ui.dart';

class DetailsStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomReactiveInput<String>(
          inputAction: TextInputAction.next,
          formName: 'details.name',
          label: 'Name',
          textColor: (theme.textTheme.titleLarge?.color)!,
          validationMessages: {
            ValidationMessage.required: (_) => 'The name must not be empty',
          },
        ),
        const SizedBox(
          height: 25.0,
        ),
        CustomReactiveInput(
          inputAction: TextInputAction.next,
          formName: 'details.description',
          label: 'Description',
          textColor: (theme.textTheme.titleLarge?.color)!,
        ),
        const SizedBox(
          height: 25.0,
        ),
        CustomReactiveAutocomplete(
          formName: 'details.category',
          optionsBuilder: (TextEditingValue value) {
            return [];
            // return _options.where((String option) {
            //   return option.contains(value.text.toLowerCase());
            // });
          },
          backgroundColor: theme.backgroundColor,
          textColor: (theme.textTheme.titleLarge?.color)!,
          label: "Category",
        ),
        const SizedBox(
          height: 25.0,
        ),
        CustomReactiveInput<RecipeBook>(
          inputAction: TextInputAction.next,
          formName: 'details.book',
          label: 'Select Recipe Book',
          textColor: (theme.textTheme.titleLarge?.color)!,
          onTap: (p0) => context.push('/newRecipeBook'),
          readonly: true,
        ),
      ],
    );
  }
}

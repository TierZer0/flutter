import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:ui/ui.dart';

class DetailsStep extends StatefulWidget {
  const DetailsStep({super.key});

  @override
  DetailsStepState createState() => DetailsStepState();
}

class DetailsStepState extends State<DetailsStep> {
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    userService.categories.then((result) => setState(() => categories = result));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CustomReactiveInput<String>(
          inputAction: TextInputAction.next,
          formName: 'details.name',
          label: 'Name',
          textColor: theme.colorScheme.onBackground,
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
          textColor: theme.colorScheme.onBackground,
        ),
        const SizedBox(
          height: 25.0,
        ),
        ReactiveDropdownField(
          formControlName: 'details.category',
          dropdownColor: theme.colorScheme.surface,
          decoration: InputDecoration(
            label: CustomText(
              text: "Category",
              fontSize: 20.0,
              fontFamily: "Lato",
              color: theme.colorScheme.onBackground,
            ),
          ),
          borderRadius: BorderRadius.circular(10.0),
          elevation: 2,
          items: categories
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: CustomText(
                    text: e,
                    fontSize: 20.0,
                    fontFamily: "Lato",
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(
          height: 25.0,
        ),
        CustomReactiveInput<String>(
          inputAction: TextInputAction.next,
          formName: 'details.book',
          label: 'Select Recipe Book',
          textColor: theme.colorScheme.onBackground,
          onTap: (p0) => context.push('/newRecipeBook'),
          readonly: true,
        ),
      ],
    );
  }
}

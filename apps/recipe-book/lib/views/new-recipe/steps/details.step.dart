import 'package:flutter/material.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:ui/ui.dart';

class DetailsStep extends StatefulWidget {
  VoidCallback onTap;

  DetailsStep({super.key, required this.onTap});

  @override
  DetailsStepState createState() => DetailsStepState();
}

class DetailsStepState extends State<DetailsStep> {
  List<String> categories = [];
  List<RecipeBookModel> recipeBooks = [];

  @override
  void initState() {
    super.initState();
    userService.categories.then((result) => setState(() => categories = result));
    userService
        .myRecipeBooks()
        .then((result) => setState(() => recipeBooks = result.docs.map((e) => e.data()).toList()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 25.0,
          vertical: 25.0,
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Wrap(
              spacing: 20,
              runSpacing: 25,
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
                CustomReactiveInput(
                  inputAction: TextInputAction.next,
                  formName: 'details.description',
                  label: 'Description',
                  textColor: theme.colorScheme.onBackground,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .42,
                  child: ReactiveDropdownField(
                    formControlName: 'details.category',
                    dropdownColor: theme.colorScheme.surface,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Category',
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 2,
                    items: categories
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: CText(
                              e,
                              textLevel: EText.body,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .42,
                  child: ReactiveDropdownField(
                    formControlName: 'details.book',
                    dropdownColor: theme.colorScheme.surface,
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'Recipe Book',
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 2,
                    selectedItemBuilder: (context) {
                      return recipeBooks
                          .map(
                            (e) => CText(
                              e.name!,
                              textLevel: EText.body,
                            ),
                          )
                          .toList();
                    },
                    items: recipeBooks
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CText(
                                  e.name!,
                                  textLevel: EText.body,
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width * .42,
                      child: CustomReactiveInput(
                        inputAction: TextInputAction.next,
                        formName: 'details.prepTime',
                        label: 'Prep Time',
                        textColor: theme.colorScheme.onBackground,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(
                      width: width * .42,
                      child: CustomReactiveInput(
                        inputAction: TextInputAction.next,
                        formName: 'details.cookTime',
                        label: 'Cook Time',
                        textColor: theme.colorScheme.onBackground,
                        keyboardType: TextInputType.number,
                      ),
                    )
                  ],
                ),
                CustomReactiveInput(
                  inputAction: TextInputAction.next,
                  formName: 'details.servings',
                  label: 'Servings',
                  textColor: theme.colorScheme.onBackground,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: ReactiveFormConsumer(
                builder: (context, formGroup, child) => ElevatedButton(
                  onPressed: formGroup.control('details').invalid ? null : widget.onTap,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: CText(
                      "Next Step",
                      textLevel: EText.body,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

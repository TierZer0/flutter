import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/recipes.service.dart';
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
    userService.recipeBooks.then((result) => setState(() => recipeBooks = result));
  }

  Future<void> _recipeBookSelection(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [],
        );
      },
    );
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
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .42,
                  child: ReactiveDropdownField(
                    formControlName: 'details.book',
                    dropdownColor: theme.colorScheme.surface,
                    decoration: InputDecoration(
                      filled: true,
                      label: CustomText(
                        text: "Recipe Book",
                        fontSize: 20.0,
                        fontFamily: "Lato",
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    elevation: 2,
                    selectedItemBuilder: (context) {
                      return recipeBooks
                          .map(
                            (e) => CustomText(
                              text: e.name,
                              fontSize: 20.0,
                              fontFamily: "Lato",
                              color: theme.colorScheme.onBackground,
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
                                CustomText(
                                  text: e.name,
                                  fontSize: 20.0,
                                  fontFamily: "Lato",
                                  color: theme.colorScheme.onBackground,
                                ),
                                CustomText(
                                  text: e.category,
                                  fontSize: 15.0,
                                  fontFamily: "Lato",
                                  color: theme.colorScheme.onBackground,
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
                    child: CustomText(
                      text: "Next Step",
                      fontSize: 20.0,
                      fontFamily: "Lato",
                      color: theme.colorScheme.onBackground,
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

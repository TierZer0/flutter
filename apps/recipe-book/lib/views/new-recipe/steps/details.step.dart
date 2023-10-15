import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/services/user/profile.service.dart';
import 'package:recipe_book/services/user/recipe-books.service.dart';
import 'package:ui/ui.dart';

import '../../../models/models.dart';

class DetailsStep extends StatefulWidget {
  DetailsStep({super.key});

  @override
  DetailsStepState createState() => DetailsStepState();
}

class DetailsStepState extends State<DetailsStep> {
  List<String> categories = [];
  List<RecipeBookModel> recipeBooks = [];

  @override
  void initState() {
    super.initState();
    profileService.myCategories.then((result) => setState(() => categories = result));
    recipeBookService
        .getRecipeBooks()
        .then((result) => setState(() => recipeBooks = result.docs.map((e) {
              RecipeBookModel recipe = e.data();
              recipe.id = e.id;
              return recipe;
            }).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  Widget buildDesktop(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 15.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CText(
            'Recipe Info',
            textLevel: EText.title,
          ),
          SizedBox(height: 15.0),
          Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: [
              sized(
                CustomReactiveInput<String>(
                  inputAction: TextInputAction.next,
                  formName: 'details.name',
                  label: 'Name',
                  textColor: theme.colorScheme.onBackground,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'The name must not be empty',
                  },
                ),
                scale: .4,
              ),
              sized(
                CustomReactiveInput(
                  inputAction: TextInputAction.next,
                  formName: 'details.description',
                  label: 'Description',
                  textColor: theme.colorScheme.onBackground,
                ),
                scale: .4,
              ),
              sized(
                ReactiveDropdownField(
                  formControlName: 'details.category',
                  dropdownColor: theme.colorScheme.surface,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Category',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.25,
                      horizontal: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 18),
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
              sized(
                ReactiveDropdownField(
                  formControlName: 'details.book',
                  dropdownColor: theme.colorScheme.surface,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Recipe Book',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.25,
                      horizontal: 10.0,
                    ),
                  ),
                  style: TextStyle(fontSize: 18),
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
            ],
          ),
          SizedBox(height: 15.0),
          CText(
            'Recipe Prep Details',
            textLevel: EText.title,
          ),
          SizedBox(height: 15.0),
          Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            children: [
              sized(
                CustomReactiveInput(
                  inputAction: TextInputAction.next,
                  formName: 'details.prepTime',
                  label: 'Prep Time',
                  textColor: theme.colorScheme.onBackground,
                  keyboardType: TextInputType.number,
                ),
              ),
              sized(
                CustomReactiveInput(
                  inputAction: TextInputAction.next,
                  formName: 'details.cookTime',
                  label: 'Cook Time',
                  textColor: theme.colorScheme.onBackground,
                  keyboardType: TextInputType.number,
                ),
              ),
              sized(
                CustomReactiveInput(
                  inputAction: TextInputAction.next,
                  formName: 'details.servings',
                  label: 'Servings',
                  textColor: theme.colorScheme.onBackground,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          )
        ],
      ),
      // child: Wrap(
      //   spacing: 20,
      //   runSpacing: 20,
      //   children: [
      // sized(
      //   CustomReactiveInput(
      //     inputAction: TextInputAction.next,
      //     formName: 'details.prepTime',
      //     label: 'Prep Time',
      //     textColor: theme.colorScheme.onBackground,
      //     keyboardType: TextInputType.number,
      //   ),
      // )
      //   ],
      // ),
    );
  }

  Widget sized(Widget item, {double scale = .25}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * scale,
      child: item,
    );
  }

  Widget buildMobile(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}

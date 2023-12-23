import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/shared/page-view.shared.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/inputs/reactive-input.custom.dart';
import 'package:recipe_book/assets.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

import '../../../models/models.dart';

class RecipeBooksStep extends StatelessWidget {
  final FormGroup formGroup;

  RecipeBooksStep({super.key, required this.formGroup});

  final formGroupName = 'RecipeBooks';
  Future<void> _recipeBookDialogBuilder({required BuildContext context}) {
    return showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return LayoutBuilder(
          builder: (context, constraints) {
            final width;
            if (constraints.maxWidth >= 1200) {
              width = MediaQuery.of(context).size.width * .3;
            } else {
              width = MediaQuery.of(context).size.width;
            }

            return AlertDialog(
              title: CText(
                'Add Recipe Book',
                textLevel: EText.title2,
              ),
              content: SizedBox(
                width: width,
                child: ReactiveForm(
                  formGroup: formGroup,
                  child: Wrap(
                    runSpacing: 20.0,
                    children: [
                      CustomReactiveInput(
                        formName: 'Name',
                        label: 'Recipe Book Name',
                        textColor: theme.colorScheme.onBackground,
                        inputAction: TextInputAction.next,
                      ),
                      CustomReactiveInput(
                        formName: 'Description',
                        label: 'Recipe Book Description',
                        textColor: theme.colorScheme.onBackground,
                        inputAction: TextInputAction.done,
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: CText('Cancel'),
                ),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(theme.colorScheme.secondary),
                  ),
                  onPressed: () {
                    formGroup.control('items').value.add(
                          new RecipeBookModel(
                              name: formGroup.control('Name').value,
                              description: formGroup.control('Description').value),
                        );
                    formGroup.control('Name').reset();
                    formGroup.control('Description').reset();
                    Navigator.of(context).pop();
                  },
                  child: CText(
                    'Add',
                    textLevel: EText.button,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: PageViewShared(
        title: 'Create some Recipe Books',
        subtitle:
            'Create at least 3 Recipe Books to get started, these are used to store and organize your Recipes',
        imageWidget: Image.asset(
          ASSETS.RecipeBookLogo,
          height: 75,
        ),
        spacingWidget: SizedBox(
          height: 30.0,
        ),
        bodyWidget: SizedBox(
          width: MediaQuery.of(context).size.width * .3,
          child: Wrap(
            children: [
              ElevatedButton(
                onPressed: () => _recipeBookDialogBuilder(context: context),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                  ),
                ),
                child: CText(
                  'Create Recipe Book',
                  textLevel: EText.button,
                ),
              ),
              ReactiveFormConsumer(
                builder: (context, _formGroup, child) {
                  return SizedBox(
                    height: _formGroup.control('${formGroupName}.items').value.length * 100,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _formGroup.control('${formGroupName}.items').value.length,
                      itemBuilder: (context, index) {
                        RecipeBookModel value =
                            _formGroup.control('${formGroupName}.items').value[index];
                        return ListTile(
                          title: CText(
                            value.name!,
                            textLevel: EText.body,
                          ),
                          subtitle: CText(
                            value.description ?? '',
                            textLevel: EText.subtitle,
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              _formGroup.control('${formGroupName}.items').value.removeAt(index);
                              _formGroup.control('${formGroupName}.items').markAsDirty();
                            },
                            icon: Icon(Icons.delete),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      mobileScreen: PageViewShared(
        title: 'Create some Recipe Books',
        subtitle:
            'Create at least 3 Recipe Books to get started, these are used to store and organize your Recipes',
        imageWidget: Container(
          height: 75,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ASSETS.RecipeBookLogo),
            ),
          ),
        ),
        bodyWidget: Wrap(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () => _recipeBookDialogBuilder(context: context),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                  ),
                ),
                child: CText(
                  'Create Recipe Book',
                  textLevel: EText.button,
                ),
              ),
            ),
            ReactiveFormConsumer(
              builder: (context, _formGroup, child) {
                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _formGroup.control('${formGroupName}.items').value.length,
                    itemBuilder: (context, index) {
                      RecipeBookModel value =
                          _formGroup.control('${formGroupName}.items').value[index];
                      return ListTile(
                        title: CText(
                          value.name!,
                          textLevel: EText.body,
                        ),
                        subtitle: CText(
                          value.description ?? '',
                          textLevel: EText.subtitle,
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            _formGroup.control('${formGroupName}.items').value.removeAt(index);
                            _formGroup.control('${formGroupName}.items').markAsDirty();
                          },
                          icon: Icon(Icons.delete),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

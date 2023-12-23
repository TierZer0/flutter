import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/shared/page-view.shared.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/inputs/reactive-input.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';
import 'package:recipe_book/assets.dart';

class CategoriesStep extends StatefulWidget {
  final FormGroup formGroup;

  const CategoriesStep({super.key, required this.formGroup});

  @override
  State<CategoriesStep> createState() => _CategoriesStepState();
}

class _CategoriesStepState extends State<CategoriesStep> {
  Future<void> _categoryDialogBuilder({
    required BuildContext context,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final width;
            if (constraints.maxWidth >= 1200) {
              width = MediaQuery.of(context).size.width * .3;
            } else {
              width = MediaQuery.of(context).size.width;
            }

            final theme = Theme.of(context);
            return AlertDialog(
              title: CText(
                'Add Category',
                textLevel: EText.title2,
              ),
              content: SizedBox(
                width: width,
                child: ReactiveForm(
                  formGroup: widget.formGroup,
                  child: Wrap(
                    children: [
                      CustomReactiveInput(
                        formName: 'Category',
                        label: 'Category',
                        textColor: theme.colorScheme.onBackground,
                        inputAction: TextInputAction.done,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: CText(
                    'Cancel',
                    textLevel: EText.button,
                  ),
                ),
                FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(theme.colorScheme.secondary),
                  ),
                  onPressed: () {
                    widget.formGroup
                        .control('items')
                        .value
                        .add(widget.formGroup.control('Category').value);
                    widget.formGroup.control('Category').reset();
                    setState(() {});
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

  final formGroupName = 'Categories';

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: PageViewShared(
        title: 'Add Your Favorite Categories',
        subtitle:
            'Create at least 3 Categories to get started, these are used to categorize your recipes',
        spacingWidget: SizedBox(
          height: 30.0,
        ),
        imageWidget: Image.asset(
          ASSETS.RecipeBookLogo,
          height: 75,
        ),
        bodyWidget: SizedBox(
          width: MediaQuery.of(context).size.width * .3,
          child: Wrap(
            runSpacing: 20,
            children: [
              ElevatedButton(
                onPressed: () => _categoryDialogBuilder(context: context),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                  ),
                ),
                child: CText(
                  'Add Category',
                  textLevel: EText.button,
                ),
              ),
              ReactiveFormConsumer(
                builder: (context, _formGroup, child) {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: _formGroup.control('${formGroupName}.items').value.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: CText(
                            _formGroup.control('${formGroupName}.items').value[index],
                            textLevel: EText.body,
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
        title: 'Add Your Favorite Categories',
        subtitle:
            'Create at least 3 Categories to get started, these are used to categorize your recipes',
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
          runSpacing: 20,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () => _categoryDialogBuilder(context: context),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                  ),
                ),
                child: CText(
                  'Add Category',
                  textLevel: EText.button,
                ),
              ),
            ),
            ReactiveFormConsumer(
              builder: (context, _formGroup, child) {
                return SizedBox(
                  // height: 200,
                  child: ListView.builder(
                    itemCount: _formGroup.control('${formGroupName}.items').value.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: CText(
                          _formGroup.control('${formGroupName}.items').value[index],
                          textLevel: EText.body,
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

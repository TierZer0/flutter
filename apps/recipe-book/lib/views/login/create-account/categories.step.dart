import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/shared/page-view.shared.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/inputs/reactive-input.custom.dart';

class CategoriesStep extends StatelessWidget {
  final FormGroup formGroup;

  const CategoriesStep({super.key, required this.formGroup});

  Future<void> _categoryDialogBuilder({
    required BuildContext context,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        final theme = Theme.of(context);
        return AlertDialog(
          title: CText(
            'Add Category',
            textLevel: EText.title2,
          ),
          content: SizedBox(
            width: width,
            child: ReactiveForm(
              formGroup: formGroup,
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
                backgroundColor: MaterialStateProperty.all<Color>(
                    theme.colorScheme.secondary),
              ),
              onPressed: () {
                formGroup
                    .control('items')
                    .value
                    .add(formGroup.control('Category').value);
                formGroup.control('Category').reset();
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
  }

  final formGroupName = 'Categories';
  @override
  Widget build(BuildContext context) {
    return PageViewShared(
      title: 'Add Your Favorite Categories',
      subtitle:
          'Create at least 3 Categories to get started, these are used to categorize your recipes',
      imageWidget: Container(
        height: 75,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/recipebook-logo.png"),
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
                height: 200,
                child: ListView.builder(
                  itemCount:
                      _formGroup.control('${formGroupName}.items').value.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: CText(
                        _formGroup
                            .control('${formGroupName}.items')
                            .value[index],
                        textLevel: EText.body,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _formGroup
                              .control('${formGroupName}.items')
                              .value
                              .removeAt(index);
                          _formGroup
                              .control('${formGroupName}.items')
                              .markAsDirty();
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
    );
  }
}

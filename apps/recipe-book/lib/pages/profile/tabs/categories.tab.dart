import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/user.models.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:ui/ui.dart';

class CategoriesTab extends StatefulWidget {
  UserModel user;

  CategoriesTab({super.key, required this.user});

  CategoriesTabState createState() => CategoriesTabState();
}

class CategoriesTabState extends State<CategoriesTab> {
  final formGroup = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'prevName': FormControl<String>(value: ''),
  });

  reload() {
    setState(() {});
  }

  Future<void> _categoryDialogBuilder({
    required BuildContext context,
    required UserModel user,
    int? index = null,
  }) {
    if (index != null) {
      formGroup.control('name').value = user.categories![index];
      formGroup.control('prevName').value = user.categories![index];
    } else {
      formGroup.reset();
    }

    return showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: CText(
            'Add Category',
            textLevel: EText.title2,
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ReactiveForm(
              formGroup: formGroup,
              child: Wrap(
                children: [
                  CustomReactiveInput(
                    formName: 'name',
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
            index != null
                ? FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(theme.colorScheme.error),
                    ),
                    onPressed: () => {
                      userService.deleteCategory(
                        formGroup.control('name').value,
                      ),
                      Navigator.of(context).pop(),
                      formGroup.reset(),
                      reload(),
                    },
                    child: CText(
                      'Delete',
                      theme: theme,
                      textLevel: EText.dangerbutton,
                    ),
                  )
                : SizedBox.shrink(),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(theme.colorScheme.secondary),
              ),
              onPressed: () async {
                if (formGroup.valid) {
                  await userService.createCategory(
                    category: formGroup.control('name').value,
                    oldCategory: formGroup.control('prevName').value,
                  );
                  Navigator.of(context).pop();
                  formGroup.reset();
                  reload();
                }
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 660) {
        return buildDesktop(context);
      } else {
        return buildMobile(context);
      }
    });
  }

  Widget buildDesktop(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: widget.user.categories!.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return DottedBorder(
            dashPattern: [6, 6],
            borderType: BorderType.RRect,
            color: theme.colorScheme.onSurfaceVariant,
            child: ListTile(
              title: CText(
                'New Category',
                textLevel: EText.title2,
              ),
              trailing: Icon(Icons.add),
              onTap: () => _categoryDialogBuilder(
                context: context,
                user: widget.user,
              ),
            ),
          );
        }
        index -= 1;
        return ListTile(
          title: CText(
            widget.user.categories![index],
            textLevel: EText.body,
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _categoryDialogBuilder(
              context: context,
              user: widget.user,
              index: index,
            ),
          ),
        );
      },
    );
  }

  Widget buildMobile(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: widget.user.categories!.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return DottedBorder(
            dashPattern: [6, 6],
            borderType: BorderType.RRect,
            color: theme.colorScheme.onSurfaceVariant,
            child: ListTile(
              title: CText(
                'New Category',
                textLevel: EText.title2,
              ),
              trailing: Icon(Icons.add),
              onTap: () => _categoryDialogBuilder(
                context: context,
                user: widget.user,
              ),
            ),
          );
        }
        index -= 1;
        return ListTile(
          title: CText(
            widget.user.categories![index],
            textLevel: EText.body,
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _categoryDialogBuilder(
              context: context,
              user: widget.user,
              index: index,
            ),
          ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/user.models.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:ui/ui.dart';

class CategoriesTab extends StatefulWidget {
  CategoriesTabState createState() => CategoriesTabState();
}

class CategoriesTabState extends State<CategoriesTab> {
  final formGroup = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'prevName': FormControl<String>(),
  });

  reload() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: userService.getUser,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          var data = UserModel.fromFirestore(snapshot.data!, SnapshotOptions());
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .5,
                    child: ListView(
                      children: data.categories!
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                  horizontal: 15.0,
                                ),
                                tileColor: theme.colorScheme.surface,
                                title: CText(
                                  e,
                                  textLevel: EText.body,
                                ),
                                trailing: SizedBox(
                                  width: 50.0,
                                  child: Row(
                                    children: [
                                      PopupMenuButton(
                                        elevation: 5.0,
                                        itemBuilder: (context) => <PopupMenuEntry>[
                                          PopupMenuItem(
                                            // child: Text(
                                            //   'Edit',
                                            // ),
                                            child: CText(
                                              'Edit',
                                              textLevel: EText.button,
                                            ),
                                            onTap: () {
                                              formGroup.patchValue({
                                                'name': e,
                                                'prevName': e,
                                              });
                                            },
                                          ),
                                          PopupMenuItem(
                                            child: CText(
                                              'Delete',
                                              textLevel: EText.button,
                                            ),
                                            onTap: () {
                                              userService.deleteCategory(e);
                                              reload();
                                            },
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  ReactiveForm(
                    formGroup: formGroup,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25.0,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: CText(
                            'New Category',
                            textLevel: EText.title,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: CustomReactiveInput(
                            inputAction: TextInputAction.done,
                            formName: 'name',
                            label: 'Name',
                            textColor: theme.colorScheme.onBackground,
                          ),
                        ),
                        ReactiveFormConsumer(
                          builder: (context, form, child) {
                            return ElevatedButton(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                                child: CText(
                                  'Create Category',
                                  textLevel: EText.button,
                                ),
                              ),
                              onPressed: form.invalid
                                  ? null
                                  : () {
                                      userService.createCategory(
                                        category: form.control('name').value,
                                      );
                                      form.reset();
                                      reload();
                                    },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.only(
            top: 20.0,
          ),
          color: theme.scaffoldBackgroundColor,
          height: MediaQuery.of(context).size.height - 90.0,
          width: MediaQuery.of(context).size.width,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

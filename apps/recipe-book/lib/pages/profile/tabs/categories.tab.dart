import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/user.models.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';

class CategoriesTab extends StatelessWidget {
  CategoriesTab({super.key});

  FormGroup buildCategoryForm() => fb.group(
        <String, Object>{
          'name': FormControl<String>(validators: [Validators.required])
        },
      );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: userService.getUser,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          var data = UserFB.fromJson(snapshot.data!.data()!);
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .5,
                    child: ListView(
                      children: data.categories
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                              child: ListTile(
                                tileColor: theme.backgroundColor,
                                title: CustomText(
                                  text: e,
                                  fontSize: 25.0,
                                  fontFamily: "Lato",
                                  color: (theme.textTheme.titleLarge?.color)!,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  ReactiveFormBuilder(
                    form: buildCategoryForm,
                    builder: (context, formGroup, child) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 25.0,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: "New Category",
                              fontSize: 25.0,
                              fontFamily: "Lato",
                              color: (theme.textTheme.titleLarge?.color)!,
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                bottom: 20.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: CustomReactiveInput(
                              inputAction: TextInputAction.next,
                              formName: 'name',
                              label: 'Name',
                              textColor: (theme.textTheme.titleLarge?.color)!,
                            ),
                          ),
                          CustomButton(
                            buttonColor: formGroup.valid ? primaryColor : Colors.grey,
                            onTap: formGroup.valid
                                ? () {
                                    userService.createCategory(
                                      formGroup.control('name').value,
                                    );
                                    formGroup.reset();
                                  }
                                : null,
                            label: "Create Category",
                            internalPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                            externalPadding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 60.0,
                            ),
                            textStyle: GoogleFonts.lato(
                              color: darkThemeTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      );
                    },
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';

class NewRecipeBookShared extends StatelessWidget {
  List<RecipeBook> books;
  FormGroup Function() formBuilder;

  NewRecipeBookShared({required this.books, required this.formBuilder});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .42,
              child: ListView(
                children: books.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                    child: ListTile(
                      tileColor: theme.backgroundColor,
                      title: CustomText(
                        text: e.name,
                        fontSize: 30.0,
                        fontFamily: "Lato",
                        color: (theme.textTheme.titleLarge?.color)!,
                      ),
                      subtitle: CustomText(
                        text: e.category,
                        fontSize: 15.0,
                        fontFamily: "Lato",
                        color: (theme.textTheme.titleLarge?.color)!,
                      ),
                      trailing: SizedBox(
                        width: 50.0,
                        child: Row(
                          children: [
                            CustomText(
                              text: e.likes.toString(),
                              fontSize: 18.0,
                              fontFamily: "Lato",
                              color: (theme.textTheme.titleLarge?.color)!,
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ),
                            ),
                            const Icon(
                              Icons.favorite,
                              size: 25.0,
                              color: tertiaryColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            ReactiveFormBuilder(
              form: formBuilder,
              builder: (context, formGroup, child) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 25.0,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: CustomText(
                        text: "New Recipe Book",
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: CustomReactiveInput(
                        inputAction: TextInputAction.next,
                        formName: 'name',
                        label: 'Name',
                        textColor: (theme.textTheme.titleLarge?.color)!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: CustomReactiveInput(
                        inputAction: TextInputAction.next,
                        formName: 'category',
                        label: 'Category',
                        textColor: (theme.textTheme.titleLarge?.color)!,
                      ),
                    ),
                    CustomButton(
                      buttonColor: formGroup.valid ? primaryColor : Colors.grey,
                      onTap: formGroup.valid
                          ? () {
                              userService.createRecipeBook(
                                RecipeBook(
                                  '',
                                  formGroup.control('name').value,
                                  formGroup.control('category').value,
                                  [],
                                  authService.user.uid,
                                  0,
                                ),
                              );
                              formGroup.reset();
                            }
                          : null,
                      label: "Create Recipe Book",
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
            )
          ],
        ),
      ),
    );
  }
}

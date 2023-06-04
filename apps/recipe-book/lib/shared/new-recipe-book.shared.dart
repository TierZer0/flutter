import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:ui/ui.dart';

class NewRecipeBookShared extends StatefulWidget {
  List<RecipeBookModel> books;
  FormGroup form;
  Function(dynamic) onTap;

  NewRecipeBookShared({super.key, required this.books, required this.form, required this.onTap});

  @override
  NewRecipeBookSharedState createState() => NewRecipeBookSharedState();
}

class NewRecipeBookSharedState extends State<NewRecipeBookShared> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .42,
              child: ListView(
                children: widget.books.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                    child: ListTile(
                      onTap: () => widget.onTap(e),
                      tileColor: theme.colorScheme.surface,
                      title: CustomText(
                        text: e.name,
                        fontSize: 30.0,
                        fontFamily: "Lato",
                        color: theme.colorScheme.onBackground,
                      ),
                      subtitle: CustomText(
                        text: e.category,
                        fontSize: 15.0,
                        fontFamily: "Lato",
                        color: theme.colorScheme.onBackground,
                      ),
                      trailing: SizedBox(
                        width: 100.0,
                        child: Row(
                          children: [
                            CustomText(
                              text: e.likes.toString(),
                              fontSize: 18.0,
                              fontFamily: "Lato",
                              color: theme.colorScheme.onBackground,
                              padding: const EdgeInsets.only(
                                right: 10.0,
                              ),
                            ),
                            Icon(
                              Icons.favorite,
                              size: 25.0,
                              color: theme.colorScheme.secondary,
                            ),
                            PopupMenuButton(
                              elevation: 5.0,
                              itemBuilder: (context) => <PopupMenuEntry>[
                                PopupMenuItem(
                                  child: Text(
                                    'Edit',
                                  ),
                                  onTap: () {
                                    widget.form.patchValue({
                                      'name': e.name,
                                      'category': e.category,
                                      'id': e.id,
                                    });
                                  },
                                ),
                                PopupMenuItem(
                                  child: Text(
                                    'Delete',
                                  ),
                                  onTap: () {
                                    userService.deleteRecipeBook(e.id!);
                                    // userService.deleteCategory(e);
                                    // reload();
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            ReactiveForm(
              formGroup: widget.form,
              child: Column(
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
                      color: theme.colorScheme.onBackground,
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
                      textColor: theme.colorScheme.onBackground,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: CustomReactiveInput(
                      inputAction: TextInputAction.next,
                      formName: 'category',
                      label: 'Category',
                      textColor: theme.colorScheme.onBackground,
                    ),
                  ),
                  ReactiveFormConsumer(
                    builder: (context, form, child) {
                      return ElevatedButton(
                        onPressed: form.invalid
                            ? null
                            : () {
                                userService.createRecipeBook(
                                  RecipeBookModel(
                                    id: form.control('id').value ?? null,
                                    name: form.control('name').value,
                                    category: form.control('category').value,
                                    recipes: [],
                                    createdBy: authService.user!.uid,
                                    likes: 0,
                                  ),
                                );
                                form.reset();
                              },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                          child: CustomText(
                            text: "Create Recipe Book",
                            fontSize: 20.0,
                            fontFamily: "Lato",
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
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
}

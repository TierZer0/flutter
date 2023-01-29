import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';

class NewRecipeBookPage extends StatefulWidget {
  const NewRecipeBookPage({super.key});

  @override
  NewRecipeBookPageState createState() => NewRecipeBookPageState();
}

class NewRecipeBookPageState extends State<NewRecipeBookPage> {
  @override
  void initState() {
    super.initState();
  }

  FormGroup buildForm() => fb.group(
        <String, Object>{
          'name': FormControl<String>(validators: [Validators.required]),
          'category': FormControl<String>()
        },
      );

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: CustomText(
          text: "Create or Select a Recipe Book",
          fontSize: 25.0,
          fontWeight: FontWeight.w500,
          color: (theme.textTheme.titleLarge?.color)!,
        ),
        leading: CustomIconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            size: 30,
          ),
          onPressed: () => context.pop(),
          color: (theme.textTheme.titleLarge?.color)!,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
        color: theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: userService.userBooksStream.cast(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  }

                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  var items = snapshot.data!.docs;
                  List<RecipeBook> books = [];
                  for (var e in items) {
                    books.add(
                      RecipeBook(
                        e.id,
                        e['name'],
                        e['category'],
                        e['recipes'],
                        authService.user.uid,
                        e['likes'],
                      ),
                    );
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * .45,
                    child: ListView(
                      children: books.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Material(
                            elevation: 5.0,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                10.0,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              onTap: () {
                                recipesService.recipeBook = e;
                                context.pop();
                              },
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
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              ReactiveFormBuilder(
                form: buildForm,
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
                            bottom: 20.0,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          CustomReactiveInput(
                            inputAction: TextInputAction.next,
                            formName: 'name',
                            label: 'Name',
                            textColor: (theme.textTheme.titleLarge?.color)!,
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          CustomReactiveInput(
                            inputAction: TextInputAction.next,
                            formName: 'category',
                            label: 'Category',
                            textColor: (theme.textTheme.titleLarge?.color)!,
                          ),
                          CustomButton(
                            buttonColor: primaryColor,
                            onTap: () => userService.createRecipeBook(
                              RecipeBook(
                                '',
                                formGroup.control('name').value,
                                formGroup.control('category').value,
                                [],
                                authService.user.uid,
                                0,
                              ),
                            ),
                            label: "Create Recipe Book",
                            internalPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                            externalPadding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 30.0,
                            ),
                            textStyle: GoogleFonts.lato(
                              color: darkThemeTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

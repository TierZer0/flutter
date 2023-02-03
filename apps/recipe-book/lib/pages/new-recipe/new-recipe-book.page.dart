import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/shared/new-recipe-book.shared.dart';
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
          child: StreamBuilder<QuerySnapshot>(
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
                    authService.user!.uid,
                    e['likes'],
                  ),
                );
              }
              return NewRecipeBookShared(
                books: books,
                formBuilder: buildForm,
              );
            },
          ),
        ),
      ),
    );
  }
}

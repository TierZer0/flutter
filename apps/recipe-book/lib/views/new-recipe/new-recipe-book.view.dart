import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/app_model.dart';
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

  final form = FormGroup({
    'name': FormControl<String>(value: '', validators: [Validators.required]),
    'category': FormControl<String>(value: ''),
    'id': FormControl<String>(),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final appModel = Provider.of<AppModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: CustomText(
          text: "Create or Select a Recipe Book",
          fontSize: 25.0,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onBackground,
        ),
        leading: CustomIconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            size: 30,
          ),
          onPressed: () => context.pop(),
          color: theme.colorScheme.onBackground,
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
              List<RecipeBookModel> books = [];
              for (var e in items) {
                books.add(
                  RecipeBookModel(
                    id: e.id,
                    name: e['name'],
                    category: e['category'],
                    recipes: e['recipes'],
                    createdBy: authService.user!.uid,
                    likes: e['likes'],
                  ),
                );
              }
              return NewRecipeBookShared(
                onTap: (item) {
                  context.read<AppModel>().recipeBook = item;
                  context.pop();
                },
                books: books,
                form: form,
              );
            },
          ),
        ),
      ),
    );
  }
}
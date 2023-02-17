import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/shared/new-recipe-book.shared.dart';

class BooksTab extends StatelessWidget {
  BooksTab({super.key});

  final form = FormGroup({
    'name': FormControl<String>(value: '', validators: [Validators.required]),
    'category': FormControl<String>(value: '')
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return StreamBuilder(
      stream: userService.userBooksStream.cast(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
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
            onTap: (item) => {},
            books: books,
            // formBuilder: buildRecipeBookForm,
            form: form,
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

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/shared/new-recipe-book.shared.dart';

class BooksTab extends StatelessWidget {
  BooksTab({super.key});

  FormGroup buildRecipeBookForm() => fb.group(
        <String, Object>{
          'name': FormControl<String>(validators: [Validators.required]),
          'category': FormControl<String>()
        },
      );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return StreamBuilder(
      stream: userService.userBooksStream.cast(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
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
          return NewRecipeBookShared(
            books: books,
            formBuilder: buildRecipeBookForm,
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

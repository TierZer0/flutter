import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/shared/recipe-book-card.shared.dart';
import 'package:ui/general/card.custom.dart';

class MyRecipeBooksTab extends StatefulWidget {
  final search;

  const MyRecipeBooksTab({super.key, this.search = ''});

  @override
  State<MyRecipeBooksTab> createState() => _MyRecipeBooksTabState();
}

class _MyRecipeBooksTabState extends State<MyRecipeBooksTab> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 660) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: content(),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: content(),
        );
      }
    });
  }

  Widget content() {
    return StreamBuilder(
      stream: userService.userBooksStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var recipeBooks = snapshot.data!.docs;
          List<dynamic> _recipeBooks = recipeBooks.map((e) => e.data()).toList();
          _recipeBooks = _recipeBooks
              .where((element) => (element.name! as String).toLowerCase().contains(
                    widget.search.toLowerCase(),
                  ))
              .toList();
          return GridView.builder(
            itemCount: _recipeBooks.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1.25 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final RecipeBookModel recipeBook = _recipeBooks[index];
              final String recipeBookId = recipeBooks[index].id;
              return RecipeBookCard(
                recipeBook: recipeBook,
                cardType: ECard.elevated,
                onTap: () => context.push('/recipeBook/${recipeBookId}'),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

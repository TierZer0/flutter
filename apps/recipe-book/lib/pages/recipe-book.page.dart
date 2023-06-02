import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';

class RecipeBookPage extends StatefulWidget {
  final String recipeBookId;

  const RecipeBookPage({
    super.key,
    required this.recipeBookId,
  });

  @override
  State<RecipeBookPage> createState() => _RecipeBookPageState();
}

class _RecipeBookPageState extends State<RecipeBookPage> {
  RecipeBookModel recipeBook = RecipeBookModel();

  @override
  void initState() {
    super.initState();

    getRecipeBook();
  }

  getRecipeBook() {
    userService.getRecipeBook(widget.recipeBookId).then((result) {
      setState(() {
        recipeBook = result;
      });
    });
  }

  final PageController recipeCtrl = PageController(viewportFraction: 0.9);
  int currentItem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipeBook.name ?? '',
              textScaleFactor: 1.2,
            ),
            Text(recipeBook.category ?? ''),
          ],
        ),
        elevation: 5,
        toolbarHeight: 100,
      ),
      body: StreamBuilder(
        stream: recipesService.getRecipesInBook(recipeBook.recipes ?? []),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var recipes = snapshot.data!.docs;
            if (recipes.length == 0) {
              return Center(
                child: Text('No Recipes in this book'),
              );
            }
            List<dynamic> _recipes = recipes.map((e) => e.data()).toList();
            return PageView.builder(
              itemCount: _recipes.length,
              onPageChanged: (next) {
                if (currentItem != next) {
                  setState(() {
                    currentItem = next;
                  });
                }
              },
              controller: recipeCtrl,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int currentIndex) {
                // bool active = currentIndex == currentItem;
                return RecipeCard(
                  recipe: _recipes[currentIndex],
                  onTap: () => {},
                  useImage: true,
                );
              },
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Center(
              child: Text('No Recipes in this book'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/user/recipes.service.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';
import 'package:ui/general/card.custom.dart';

class MyRecipesTab extends StatefulWidget {
  final search;

  const MyRecipesTab({super.key, this.search = ''});

  @override
  State<MyRecipesTab> createState() => _MyRecipesTabState();
}

class _MyRecipesTabState extends State<MyRecipesTab> {
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
      stream: recipesService.myRecipesStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var recipes = snapshot.data!.docs;
          List<dynamic> _recipes = recipes.map((e) => e.data()).toList();
          _recipes = _recipes
              .where((element) => (element.title! as String).toLowerCase().contains(
                    widget.search.toLowerCase(),
                  ))
              .toList();
          return GridView.builder(
            itemCount: _recipes.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 3 / 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 0,
            ),
            itemBuilder: (context, index) {
              final RecipeModel recipe = _recipes[index];
              final String recipeId = recipes[index].id;
              return RecipeCard(
                recipe: recipe,
                cardType: ECard.none,
                onTap: () => context.push('/recipe/${recipeId}'),
                useImage: true,
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

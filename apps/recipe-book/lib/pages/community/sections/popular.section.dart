import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/services/recipes/recipes.service.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';

class ByPopularitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          child: CText(
            'By Popularity',
            textLevel: EText.title,
          ),
        ),
        Gap(5),
        Expanded(
          child: FutureBuilder(
            future: recipesService.getRecipesFuture(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!.docs;
                List<RecipeModel> _recipes = data.map((e) => e.data()).toList();

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _recipes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final RecipeModel recipe = _recipes[index];
                    final String recipeId = data[index].id;
                    return RecipeCard(
                      recipe: recipe,
                      useImage: true,
                      cardType: ECard.elevated,
                      onTap: () => context.push('/recipe/${recipeId}'),
                    );
                  },
                );
              }
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }
}

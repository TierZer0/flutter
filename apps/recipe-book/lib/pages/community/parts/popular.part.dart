import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/models/recipe/recipe.model.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';

class PopularPart extends ConsumerStatefulWidget {
  @override
  PopularPartState createState() => PopularPartState();
}

class PopularPartState extends ConsumerState<PopularPart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recipesProvider = ref.watch(getRecipesProvider);

    return switch (recipesProvider) {
      AsyncData(:final value) => switch (value.success) {
          true => GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5 / 4,
                crossAxisSpacing: 30,
                mainAxisSpacing: 5,
              ),
              itemCount: value.payload!.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final _recipes = value.payload!;

                final RecipeModel recipe = _recipes[index];
                return RecipeCard(
                  recipe: recipe,
                  useImage: true,
                  cardType: ECard.elevated,
                  onTap: () => context.push('/recipe/${recipe.id}'),
                );
              },
            ),
          false => CText(
              'No recipes found.',
              textLevel: EText.subtitle,
            ),
        },
      AsyncLoading() => Center(child: CircularProgressIndicator()),
      AsyncError(:final error) => Center(
          child: CText(
            error.toString(),
            textLevel: EText.subtitle,
          ),
        ),
      _ => Center(
          child: CircularProgressIndicator(),
        ),
    };
  }
}

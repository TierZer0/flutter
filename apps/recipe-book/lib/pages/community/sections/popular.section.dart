import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/models/recipe/recipe.model.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart' show getRecipesProvider;
import 'package:recipe_book/shared/recipe-card.shared.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';

class ByPopularitySection extends ConsumerStatefulWidget {
  const ByPopularitySection({Key? key}) : super(key: key);

  @override
  _ByPopularitySectionState createState() => _ByPopularitySectionState();
}

class _ByPopularitySectionState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    final recipesProvider = ref.watch(getRecipesProvider);

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
          child: switch (recipesProvider) {
            AsyncData(:final value) => switch (value.success) {
                true => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: value.payload!.length,
                    scrollDirection: Axis.horizontal,
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
                    value.message!,
                    textLevel: EText.title2,
                  ),
              },
            AsyncLoading() => Center(
                child: CircularProgressIndicator(),
              ),
            _ => CText(
                'Something went wrong',
                textLevel: EText.title2,
              ),
          },
        ),
      ],
    );
  }
}

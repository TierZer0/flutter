import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/services/user/profile.service.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';

import '../../../models/recipe.models.dart';
import '../../../shared/recipe-card.shared.dart';

class NotMadeFavoritesTab extends StatefulWidget {
  const NotMadeFavoritesTab({super.key});

  @override
  State<NotMadeFavoritesTab> createState() => _NotMadeFavoritesTabState();
}

class _NotMadeFavoritesTabState extends State<NotMadeFavoritesTab> {
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
    return FutureBuilder(
      future: profileService.myLikes(false),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var recipes = snapshot.data!.docs;
          List<dynamic> _recipes = recipes.map((e) => e.data()).toList();
          return GridView.builder(
            itemCount: _recipes.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (context, index) {
              final RecipeModel recipe = _recipes[index];
              final String recipeId = recipes[index].id;
              return RecipeCard(
                recipe: recipe,
                cardType: ECard.elevated,
                onTap: () => context.push('/recipe/${recipeId}'),
                // onLongPress: () =>
                //     _previewDialog(context, recipe, recipeId, isMobile: false),
                useImage: true,
              );
            },
          );
        } else if (snapshot.error == null) {
          return Center(
            child: CText(
              'No recipes found.',
              textLevel: EText.subtitle,
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

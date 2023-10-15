import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/services/user/profile.service.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

import '../../../models/models.dart';
import '../../../shared/recipe-card.shared.dart';

class MadeFavoritesTab extends StatefulWidget {
  const MadeFavoritesTab({super.key});

  @override
  State<MadeFavoritesTab> createState() => _MadeFavoritesTabState();
}

class _MadeFavoritesTabState extends State<MadeFavoritesTab> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: content(),
      mobileScreen: content(),
    );
  }

  Widget content() {
    return FutureBuilder(
      future: profileService.myLikes(true),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var recipes = snapshot.data!.docs;
          List<dynamic> _recipes = recipes.map((e) => e.data()).toList();
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
                cardType: ECard.elevated,
                onTap: () => context.push('/recipe/${recipeId}'),
                // onLongPress: () =>
                //     _previewDialog(context, recipe, recipeId, isMobile: false),
                useImage: true,
              );
            },
          );
        } else if (snapshot.error == null || snapshot.data == null) {
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

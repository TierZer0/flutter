import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

import '../../../models/models.dart';
import '../../../shared/recipe-card.shared.dart';

class MadeFavoritesTab extends ConsumerStatefulWidget {
  const MadeFavoritesTab({super.key});

  @override
  _MadeFavoritesTabState createState() => _MadeFavoritesTabState();
}

class _MadeFavoritesTabState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: Container(),
      mobileScreen: buildMobile(),
    );
  }

  Widget buildMobile() {
    final authProvider = ref.read(firebaseAuthProvider);
    final myMadeFavoritesProvider = ref.watch(getMyMadeFavoritesProvider(authProvider.currentUser!.uid));

    return switch (myMadeFavoritesProvider) {
      AsyncLoading() => Center(child: CircularProgressIndicator()),
      AsyncError(:final error) => Center(
          child: CText(
            error.toString(),
            textLevel: EText.subtitle,
          ),
        ),
      AsyncData(:final value) => switch (value.success) {
          true => switch (value.payload.length == 0) {
              true => Center(
                  child: CText(
                    'No recipes found.',
                    textLevel: EText.subtitle,
                  ),
                ),
              false => ListView.builder(
                  itemCount: value.payload!.length,
                  itemBuilder: (context, index) {
                    final _recipes = value.payload!;
                    final RecipeModel recipe = _recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      cardType: ECard.elevated,
                      onTap: () => context.push('/recipe/${recipe.id}'),
                      useImage: true,
                    );
                  },
                ),
            },
          false => Center(
              child: CText(
                'No recipes found.',
                textLevel: EText.subtitle,
              ),
            ),
        },
      _ => Center(
          child: CText(
            'No recipes found.',
            textLevel: EText.subtitle,
          ),
        )
    };
  }

  // Widget content() {
  //   return FutureBuilder(
  //     future: profileService.myLikes(true),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasData) {
  //         var recipes = snapshot.data!.docs;
  //         List<dynamic> _recipes = recipes.map((e) => e.data()).toList();
  //         return GridView.builder(
  //           itemCount: _recipes.length,
  //           gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
  //             maxCrossAxisExtent: 300,
  //             childAspectRatio: 3 / 3,
  //             crossAxisSpacing: 10,
  //             mainAxisSpacing: 0,
  //           ),
  //           itemBuilder: (context, index) {
  //             final RecipeModel recipe = _recipes[index];
  //             final String recipeId = recipes[index].id;
  //             return RecipeCard(
  //               recipe: recipe,
  //               cardType: ECard.elevated,
  //               onTap: () => context.push('/recipe/${recipeId}'),
  //               // onLongPress: () =>
  //               //     _previewDialog(context, recipe, recipeId, isMobile: false),
  //               useImage: true,
  //             );
  //           },
  //         );
  //       } else if (snapshot.error == null || snapshot.data == null) {
  //         return Center(
  //           child: CText(
  //             'No recipes found.',
  //             textLevel: EText.subtitle,
  //           ),
  //         );
  //       }
  //       return Center(child: CircularProgressIndicator());
  //     },
  //   );
  // }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:recipe_book/services/user/profile.service.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

import '../../../models/models.dart';
import '../../../shared/recipe-card.shared.dart';

class NotMadeFavoritesTab extends ConsumerStatefulWidget {
  const NotMadeFavoritesTab({super.key});

  @override
  _NotMadeFavoritesTabState createState() => _NotMadeFavoritesTabState();
}

class _NotMadeFavoritesTabState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: Container(),
      mobileScreen: buildMobile(),
    );
  }

  Widget buildMobile() {
    final authProvider = ref.read(firebaseAuthProvider);
    final myNotMadeFavoritesProvider = ref.watch(getMyNotMadeFavoritesProvider(authProvider.currentUser!.uid));

    return switch (myNotMadeFavoritesProvider) {
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
              false => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: value.payload!.length,
                        itemBuilder: (context, index) {
                          final _recipes = value.payload!;
                          final RecipeModel recipe = _recipes[index];
                          return Card(
                            child: CText(recipe.title!),
                          );
                          // return RecipeCard(
                          //   recipe: recipe,
                          //   cardType: ECard.elevated,
                          //   onTap: () => context.push('/recipe/${recipe.id}'),
                          //   useImage: true,
                          // );
                        },
                      ),
                    )
                  ],
                ),
            },
          false => Center(
              child: CText(
                value.message!,
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
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

import '../../../models/models.dart';

class MyRecipesTab extends ConsumerStatefulWidget {
  final search;

  const MyRecipesTab({super.key, this.search = ''});

  @override
  _MyRecipesTabState createState() => _MyRecipesTabState();
}

class _MyRecipesTabState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  Widget buildDesktop(BuildContext context) {
    return Container();
    // return StreamBuilder(
    //   stream: recipesService.myRecipesStream(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       var recipes = snapshot.data!.docs;
    //       List<dynamic> _recipes = recipes.map((e) => e.data()).toList();
    //       _recipes = _recipes
    //           .where((element) => (element.title as String).toLowerCase().contains(
    //                 context.read<AppModel>().search.toLowerCase(),
    //               ))
    //           .toList();
    //       return GridView.builder(
    //         itemCount: _recipes.length,
    //         gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //           maxCrossAxisExtent: 450,
    //           childAspectRatio: 4 / 1.5,
    //           crossAxisSpacing: 20,
    //           mainAxisSpacing: 10,
    //         ),
    //         itemBuilder: (context, index) {
    //           final RecipeModel recipe = _recipes[index];
    //           final String recipeId = recipes[index].id;
    //           return RecipeCard(
    //             recipe: recipe,
    //             cardType: ECard.elevated,
    //             onTap: () => context.push('/recipe/${recipeId}'),
    //             // onLongPress: () => _previewDialog(context, recipe, recipeId, isMobile: false),
    //             useImage: true,
    //           );
    //         },
    //       );
    //     }
    //     return Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );
  }

  Widget buildMobile(BuildContext context) {
    final authProvider = ref.read(firebaseAuthProvider);
    final myRecipesProvider = ref.watch(getMyRecipesProvider(authProvider.currentUser!.uid));

    return switch (myRecipesProvider) {
      AsyncData(:final value) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: value.payload!.length,
                itemBuilder: (context, index) {
                  final _recipes = value.payload!;

                  final RecipeModel recipe = _recipes[index];
                  return ListTile(
                    leading: CircleAvatar(
                      maxRadius: 40,
                      foregroundImage: NetworkImage(recipe.image!),
                    ),
                    title: CText(recipe.title!),
                    subtitle: CText(recipe.description!),
                    onTap: () => context.push('/recipe/${recipe.id}'),
                  );
                },
              ),
            ),
          ],
        ),
      AsyncLoading() => Center(child: CircularProgressIndicator()),
      _ => Center(child: Text('Error')),
    };
  }
}

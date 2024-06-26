import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:recipe_book/shared/card.shared.dart';

class MyRecipesPart extends ConsumerStatefulWidget {
  @override
  MyRecipesPartState createState() => MyRecipesPartState();
}

class MyRecipesPartState extends ConsumerState<MyRecipesPart> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void refreshMyRecipes() => ref.refresh(getMyRecipesProvider(ref.read(firebaseAuthProvider).currentUser!.uid));

  void _onRefresh() async {
    refreshMyRecipes();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final getMyRecipes = ref.watch(getMyRecipesProvider(ref.read(firebaseAuthProvider).currentUser!.uid));

    return SmartRefresher(
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      header: WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: getMyRecipes.when(
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        data: (data) {
          if (data.payload.isEmpty) {
            return Center(
              child: Text('No recipes found'),
            );
          }
          return ListView.builder(
            itemCount: data.payload.length,
            itemBuilder: (context, index) {
              final _recipes = data.payload!;
              final Recipe recipe = _recipes[index];
              return CardShared(
                recipe: recipe,
                onTap: () => context.push('/recipe/${recipe.id}'),
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                height: 200,
              );
            },
          );
        },
      ),
    );
  }
}

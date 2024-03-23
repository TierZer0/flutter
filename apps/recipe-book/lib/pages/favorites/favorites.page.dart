import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:recipe_book/shared/card.shared.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends ConsumerState<FavoritesPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void refreshFavoriteRecipes() => ref.refresh(getFavoritesByUserId(ref.read(firebaseAuthProvider).currentUser!.uid));

  void _onRefresh() async {
    refreshFavoriteRecipes();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final getFavorites = ref.watch(getFavoritesByUserId(ref.read(firebaseAuthProvider).currentUser!.uid));

    return SmartRefresher(
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      header: WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: getFavorites.when(
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        data: (data) {
          if (data.payload == null || data.payload.isEmpty) {
            return Center(
              child: Text('No favorite recipes found'),
            );
          }
          return ListView.builder(
            itemCount: data.payload.length,
            itemBuilder: (context, index) {
              final _recipes = data.payload!;
              final recipe = _recipes[index];
              return CardShared(
                recipe: recipe,
                onTap: () => context.go('/recipe/${recipe.id}'),
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                height: 200,
                width: 200,
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recipe_book/pages/search/shared/expansion-list.shared.dart';
import 'package:recipe_book/providers/recipe-books/recipe-books.providers.dart';

class RecipeBookSearchPart extends ConsumerStatefulWidget {
  @override
  RecipeBookSearchPartState createState() => RecipeBookSearchPartState();
}

class RecipeBookSearchPartState extends ConsumerState<RecipeBookSearchPart> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() async {
    _refreshController.refreshCompleted();
    return ref.refresh(getRecipeBooksProvider);
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final getRecipeBooks = ref.watch(getRecipeBooksProvider);

    return SmartRefresher(
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      header: WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: switch (getRecipeBooks) {
        AsyncData(:final value) => switch (value.payload!.isNotEmpty as bool) {
            true => Builder(
                builder: (context) {
                  final _recipeBooks = value.payload!;

                  final books = _recipeBooks.map((e) {
                    return {
                      ...e.toFirestore(),
                      'expanded': false,
                    };
                  }).toList();

                  return SearchExpansionList(
                    recipeBooks: books,
                  );
                },
              ),
            false => Center(child: Text('No recipe books found.')),
          },
        AsyncLoading() => Center(child: CircularProgressIndicator()),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => Center(child: Text('No data')),
      },
    );
  }
}

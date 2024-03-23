import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recipe_book/models/recipe/recipe.model.dart';
import 'package:recipe_book/shared/card.shared.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:intl/intl.dart';

import 'package:ui/general/card.custom.dart';

class PastWeekSearchPart extends ConsumerStatefulWidget {
  @override
  PastWeekSearchPartState createState() => PastWeekSearchPartState();
}

class PastWeekSearchPartState extends ConsumerState<PastWeekSearchPart> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final String week = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)));

  @override
  void initState() {
    super.initState();
  }

  void refreshRecipesByDate() => ref.refresh(getRecipesByDateProvider(week));
  void _onRefresh() async {
    refreshRecipesByDate();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final getRecipesByDate = ref.watch(getRecipesByDateProvider(week));

    return SmartRefresher(
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      header: WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: switch (getRecipesByDate) {
        AsyncData(:final value) => switch ((value.payload!.isNotEmpty as bool)) {
            true => ListView.builder(
                itemCount: value.payload!.length,
                itemBuilder: (context, index) {
                  final _recipes = value.payload!;
                  final RecipeModel recipe = _recipes[index];
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
              ),
            false => Center(child: Text('No recipes found.')),
          },
        AsyncLoading() => Center(child: CircularProgressIndicator()),
        AsyncError(:final error) => Text('Error: $error'),
        _ => Text('No data'),
      },
    );
  }
}

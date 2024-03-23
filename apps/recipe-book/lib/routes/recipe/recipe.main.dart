import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';

class RecipeMain extends ConsumerStatefulWidget {
  final String recipeId;

  RecipeMain({
    required this.recipeId,
  });

  @override
  _RecipeMainState createState() => _RecipeMainState();
}

class _RecipeMainState extends ConsumerState<RecipeMain> {
  @override
  Widget build(BuildContext context) {
    final recipeProvider = ref.watch(getRecipeProvider(widget.recipeId));

    return recipeProvider.when(
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: Text('Error: $error'),
          ),
        );
      },
      loading: () {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      data: (data) {
        final recipe = data.payload!;
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title!,
                  textScaler: TextScaler.linear(1.1),
                ),
                Text(
                  recipe.description!,
                  textScaler: TextScaler.linear(0.7),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          body: Center(
            child: Text(recipe.description!),
          ),
        );
      },
    );
  }
}

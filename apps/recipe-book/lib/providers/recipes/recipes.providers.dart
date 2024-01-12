import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/providers/auth/providers.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipes/providers.dart';
import 'package:recipe_book/providers/recipes/recipes.datasource.dart';

final recipesDataSource = StateProvider((ref) => RecipesDataSource(ref: ref, firebaseFirestore: ref.read(firebaseFirestoreProvider)));

final getRecipeProvider = FutureProvider.family<FirestoreResult<RecipeModel>, String>((ref, recipeId) {
  return Future.value(ref.read(recipesDataSourceProvider.notifier).state.getRecipe(recipeId: recipeId));
});

final getRecipesProvider = FutureProvider((ref) {
  return Future.value(ref.read(recipesDataSourceProvider.notifier).state.getRecipes());
});

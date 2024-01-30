import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipes/recipes.datasource.dart';

final recipesDataSource = StateProvider((ref) => RecipesDataSource(ref: ref, firebaseFirestore: ref.read(firebaseFirestoreProvider)));

final getRecipeProvider = FutureProvider.family<FirestoreResult<RecipeModel>, String>((ref, recipeId) {
  return Future.value(ref.read(recipesDataSource.notifier).state.getRecipe(recipeId: recipeId));
});

final getRecipesProvider = FutureProvider((ref) {
  return Future.value(ref.read(recipesDataSource.notifier).state.getRecipes());
});

final getMyRecipesProvider = FutureProvider.family<FirestoreResult<dynamic>, String>((ref, uid) {
  return Future.value(ref.read(recipesDataSource.notifier).state.getMyRecipes(uid));
});

final getRecipesInBookProvider = FutureProvider.family<FirestoreResult<dynamic>, String>((ref, bookId) {
  return Future.value(ref.read(recipesDataSource.notifier).state.getRecipesInBook(bookId));
});

final getMyMadeFavoritesProvider = FutureProvider.family<FirestoreResult<dynamic>, String>((ref, uid) {
  return Future.value(ref.read(recipesDataSource.notifier).state.getMyMadeFavorites(uid));
});

final getMyNotMadeFavoritesProvider = FutureProvider.family<FirestoreResult<dynamic>, String>((ref, uid) {
  return Future.value(ref.read(recipesDataSource.notifier).state.getMyNotMadeFavorites(uid));
});

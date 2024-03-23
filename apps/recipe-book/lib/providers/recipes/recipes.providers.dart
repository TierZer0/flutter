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

final getRecipesByIdsProvider = FutureProvider.family<FirestoreResult<dynamic>, List<String>>((ref, ids) {
  return Future.value(ref.read(recipesDataSource.notifier).state.getRecipesByIds(ids));
});

final getFavoritesByUserId = FutureProvider.family<FirestoreResult<dynamic>, String>((ref, userId) {
  return Future.value(ref.read(recipesDataSource.notifier).state.getFavoritesByUserId(userId));
});

final getRecipesByCategoryProvider = FutureProvider.family<FirestoreResult<dynamic>, String>((ref, category) {
  return Future.value(ref.read(recipesDataSource.notifier).state.getRecipesByCategory(category));
});

final getRecipesByDateProvider = FutureProvider.family<FirestoreResult<dynamic>, String>((ref, date) {
  return Future.value(ref.read(recipesDataSource.notifier).state.getRecipesByDate(date));
});

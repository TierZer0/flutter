import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/firebase/firebase_result.model.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/user/user.datasource.dart';

final userDataSource = StateProvider((ref) => UserDataSource(ref: ref, firebaseFirestore: ref.read(firebaseFirestoreProvider)));

final getUserLikesProvider = FutureProvider.family<FirestoreResult<List<dynamic>>, String>((ref, uid) {
  return Future.value(ref.read(userDataSource.notifier).state.getLikedRecipes(uid));
});

final getHasUserLikedRecipeProvider = FutureProvider.family<FirestoreResult<bool>, String>((ref, recipeId) {
  return Future.value(ref.read(userDataSource.notifier).state.getHasLikedRecipe(recipeId, ref.read(firebaseAuthProvider).currentUser!.uid));
});

final setUserLikedRecipeProvider = FutureProvider.family<void, String>((ref, recipeId) {
  return Future.value(ref.read(userDataSource.notifier).state.setLikedRecipe(recipeId, ref.read(firebaseAuthProvider).currentUser!.uid));
});

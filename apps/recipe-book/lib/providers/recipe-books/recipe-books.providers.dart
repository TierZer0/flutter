import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipe-books/recipe-books.datasource.dart';

final recipeBooksDataSource = StateProvider((ref) => RecipeBooksDataSource(ref: ref, firebaseFirestore: ref.read(firebaseFirestoreProvider)));

final getRecipeBooksProvider = FutureProvider((ref) {
  return Future.value(ref.read(recipeBooksDataSource.notifier).state.getRecipeBooks());
});

final getRecipeBooksByUserIdProvider = FutureProvider.family((ref, String userId) {
  return Future.value(ref.read(recipeBooksDataSource.notifier).state.getRecipeBooksByUserId(userId));
});

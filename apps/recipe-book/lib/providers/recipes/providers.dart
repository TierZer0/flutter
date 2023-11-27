import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipes/recipes.datasource.dart';

final recipesDataSourceProvider = StateProvider<RecipesDataSource>(
  (ref) => RecipesDataSource(
    firebaseFirestore: ref.read(firebaseFirestoreProvider),
    ref: ref,
  ),
);

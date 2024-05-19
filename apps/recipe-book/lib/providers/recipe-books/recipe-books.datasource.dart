import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipes/recipes.datasource.dart';

class RecipeBooksDataSource {
  final FirebaseFirestore firebaseFirestore;
  final Ref ref;

  var authProvider;
  RecipeBooksDataSource({
    required this.firebaseFirestore,
    required this.ref,
  }) {
    authProvider = ref.read(firebaseAuthProvider);
  }

  get _recipeBooksRef => this.firebaseFirestore.collection('recipeBooks').withConverter(
        fromFirestore: RecipeBook.fromFirestore,
        toFirestore: (RecipeBook recipeBook, _) => recipeBook.toFirestore(),
      );

  Future<FirestoreResult<dynamic>> getRecipeBooks() async {
    try {
      final results = (await _recipeBooksRef.get()).docs.map((e) => e.data()).toList();

      for (var result in results) {
        final recipeIds = result.recipeIds as List<String>;
        if (recipeIds.isEmpty) {
          result.recipes = [];
          continue;
        }
        final recipeDataSource = RecipesDataSource(firebaseFirestore: firebaseFirestore, ref: ref);
        final recipes = (await recipeDataSource.getRecipesByIds(recipeIds));

        result.recipes = recipes.payload;
      }
      return FirestoreResult<dynamic>(
        results,
        success: true,
      );
    } catch (e) {
      return FirestoreResult(
        null,
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<FirestoreResult<dynamic>> getRecipeBooksByUserId(String userId) async {
    try {
      final results = (await _recipeBooksRef.where('createdBy', isEqualTo: userId).get()).docs.map((e) => e.data()).toList();

      for (var result in results) {
        final recipeIds = result.recipeIds as List<String>;
        if (recipeIds.isEmpty) {
          result.recipes = [];
          continue;
        }
        final recipeDataSource = RecipesDataSource(firebaseFirestore: firebaseFirestore, ref: ref);
        final recipes = (await recipeDataSource.getRecipesByIds(recipeIds));

        result.recipes = recipes.payload;
      }
      return FirestoreResult<dynamic>(
        results,
        success: true,
      );
    } catch (e) {
      return FirestoreResult(
        null,
        success: false,
        message: e.toString(),
      );
    }
  }
}

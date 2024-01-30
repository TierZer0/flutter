import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/preferences/app_preferences.dart';
import 'package:recipe_book/providers/user/user.providers.dart';

class RecipesDataSource {
  final FirebaseFirestore firebaseFirestore;
  final Ref ref;

  RecipesDataSource({
    required this.firebaseFirestore,
    required this.ref,
  });

  get _recipesRef => this.firebaseFirestore.collection('recipes').withConverter(
        fromFirestore: RecipeModel.fromFirestore,
        toFirestore: (RecipeModel recipe, _) => recipe.toFirestore(),
      );

  Future<FirestoreResult<RecipeModel>> getRecipe({
    required String recipeId,
  }) async {
    try {
      final RecipeModel recipe = (await _recipesRef.doc(recipeId).get()).data();
      return FirestoreResult<RecipeModel>(
        recipe,
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

  // TODO: switch from List<dynamic> to List<RecipeModel>
  Future<FirestoreResult<List<dynamic>>> getRecipes() async {
    try {
      final recipes = (await _recipesRef.get()).docs.map((e) => e.data()).toList();
      return FirestoreResult<List<dynamic>>(
        recipes,
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

  Future<FirestoreResult<List<dynamic>>> getMyRecipes(String uid) async {
    try {
      final recipes = (await _recipesRef.where('createdBy', isEqualTo: uid).get()).docs.map((e) => e.data()).toList();
      return FirestoreResult<List<dynamic>>(
        recipes,
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

  Future<FirestoreResult<List<dynamic>>> getRecipesInBook(String bookId) async {
    try {
      final recipes = (await _recipesRef.where('recipeBook', isEqualTo: bookId).get()).docs.map((e) => e.data()).toList();
      return FirestoreResult<List<dynamic>>(
        recipes,
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

  // Future<FirestoreResult<RecipeModel>> myFavorites() {}

  Future<FirestoreResult<List<dynamic>>> getMyMadeFavorites(String uid) async {
    try {
      final likes = await ref.read(userDataSource).getLikedRecipes(uid);

      if (!likes.success) return FirestoreResult([], success: false, message: likes.message!);

      final madeRecipeIds = likes.payload!.where((element) => element.hasMade).map((e) => e.recipeId).toList();

      if (madeRecipeIds.isEmpty) return FirestoreResult([], success: true, message: 'No recipes marked as made yet.');

      final recipes = (await _recipesRef.where(FieldPath.documentId, whereIn: madeRecipeIds).get()).docs.map((e) => e.data()).toList();

      return FirestoreResult<List<dynamic>>(
        recipes,
        success: true,
      );
    } catch (e) {
      return FirestoreResult([], success: false, message: e.toString());
    }
  }

  Future<FirestoreResult<List<dynamic>>> getMyNotMadeFavorites(String uid) async {
    try {
      final likes = await ref.read(userDataSource).getLikedRecipes(uid);

      if (!likes.success) return FirestoreResult([], success: false, message: likes.message!);

      final madeRecipeIds = likes.payload!.where((element) => !element.hasMade).map((e) => e.recipeId).toList();

      if (madeRecipeIds.isEmpty) return FirestoreResult([], success: true, message: 'No recipes marked as not made yet.');

      final recipes = (await _recipesRef.where(FieldPath.documentId, whereIn: madeRecipeIds).get()).docs.map((e) => e.data()).toList();

      return FirestoreResult<List<dynamic>>(
        recipes,
        success: true,
      );
    } catch (e) {
      return FirestoreResult([], success: false, message: e.toString());
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/preferences/app_preferences.dart';

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
}

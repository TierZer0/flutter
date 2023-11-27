import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/models.dart';

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
      final recipe = (await _recipesRef.doc(recipeId).get()).data();
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
}

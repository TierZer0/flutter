import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/providers/storage/storage.providers.dart';
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
      print(e);
      return FirestoreResult(
        [],
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

  Future<FirestoreResult<List<dynamic>>> getRecipesByIds(List<String> ids) async {
    try {
      final recipes = (await _recipesRef.where(FieldPath.documentId, whereIn: ids).get()).docs.map((e) => e.data()).toList();
      return FirestoreResult<List<dynamic>>(
        recipes,
        success: true,
      );
    } catch (e) {
      return FirestoreResult(
        [],
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

  Future<FirestoreResult<List<dynamic>>> getFavoritesByUserId(String uid) async {
    try {
      final likedRecipes = await ref.read(userDataSource).getLikedRecipes(uid);

      return FirestoreResult<List<dynamic>>(
        likedRecipes.payload,
        success: true,
      );
    } catch (e) {
      return FirestoreResult(null, success: false, message: e.toString());
    }
  }

  Future<FirestoreResult<List<dynamic>>> getRecipesByCategory(String category) async {
    try {
      final recipes = (await _recipesRef.where('category', isEqualTo: category).get()).docs.map((e) => e.data()).toList();
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

  Future<FirestoreResult<List<dynamic>>> getRecipesByDate(String date) async {
    try {
      final recipes = (await _recipesRef.where('created', isGreaterThanOrEqualTo: date).get()).docs.map((e) => e.data()).toList();
      return FirestoreResult(
        recipes,
        success: true,
      );
    } catch (e) {
      print(e);
      return FirestoreResult(
        [],
        success: false,
        message: e.toString(),
      );
    }
  }

  Future<void> setRecipeReview(String recipeId, ReviewModel review) async {
    try {
      await _recipesRef.doc(recipeId).update({
        'reviews': FieldValue.arrayUnion([review.toMap()]),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> setRecipe(RecipeModel recipe, dynamic photo) async {
    try {
      final result = await ref.read(uploadFileProvider(photo).future);
      recipe.image = result.toString();
      await _recipesRef.add(recipe);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateRecipe(RecipeModel recipe) async {
    try {
      await _recipesRef.doc(recipe.id).update(recipe.toFirestore());
    } catch (e) {
      print(e);
    }
  }
}

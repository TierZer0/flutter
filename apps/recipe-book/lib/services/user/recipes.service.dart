import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/services/storage.service.dart';
import 'package:recipe_book/services/user/authentication.service.dart';
import 'package:recipe_book/services/user/recipe-books.service.dart';

import '../../models/recipe.models.dart';
import '../db.service.dart';

class _RecipesService {
  get recipesRef => db.recipeCollection.withConverter(
        fromFirestore: RecipeModel.fromFirestore,
        toFirestore: (RecipeModel recipe, _) => recipe.toFirestore(),
      );

  Future<RecipeModel> getRecipe(String id) async {
    return (await recipesRef.doc(id).get()).data();
  }

  Future<void> updateRecipe(String id, RecipeModel recipe) {
    return recipesRef.doc(id).update(recipe.toFirestore());
  }

  Future<void> deleteRecipe(String id, RecipeModel recipe) {
    recipeBookService.removeRecipeFromRecipeBook(id, recipe.recipeBook!);
    return recipesRef.doc(id).delete();
  }

  Future<void> createRecipe(RecipeModel recipe, dynamic photo) async {
    final result = await firebaseStorageService.uploadFile(photo);
    recipe.image = result;
    final postResult = recipesRef.add(recipe);
    recipeBookService.addRecipeToRecipeBook(postResult.id, recipe.recipeBook!);
  }

  Stream<QuerySnapshot<RecipeModel>> getRecipesStream({filters, sort, search}) {
    Query<RecipeModel> query = recipesRef;

    if (filters != null) {
      query = _buildFilterQuery(query, filters);
    }

    if (sort != null) {
      query = query.orderBy(sort);
    } else {
      query = query.orderBy('created');
    }
    return recipesRef.snapshots();
  }

  Stream<QuerySnapshot<RecipeModel>> recipesInBookStream({List<dynamic> recipeIds = const []}) {
    if (recipeIds.isEmpty) return Stream.empty();
    return recipesRef.where('id', whereIn: recipeIds).snapshots();
  }

  Future<QuerySnapshot<RecipeModel>> recipesInBookFuture({List<dynamic> recipeIds = const []}) {
    if (recipeIds.isEmpty) return Future.error(Exception('No recipes in book'));
    return recipesRef.where('id', whereIn: recipeIds).get();
  }

  Stream<QuerySnapshot<RecipeModel>> myRecipesStream({filters}) {
    Query<RecipeModel> query = _buildFilterQuery(recipesRef, filters);
    return query
        .where('createdBy', isEqualTo: authenticationService.userUid)
        .orderBy('created')
        .snapshots();
  }

  Future<QuerySnapshot<RecipeModel>> myRecipesFuture({filters}) {
    Query<RecipeModel> query = _buildFilterQuery(recipesRef, filters);
    return query
        .where('createdBy', isEqualTo: authenticationService.userUid)
        .orderBy('created')
        .get();
  }

  Stream<DocumentSnapshot<dynamic>> recipeReviews(id) {
    return recipesRef.doc(id).snapshots();
  }

  Future<void> addReview(id, review) {
    return recipesRef.doc(id).update({
      'reviews': FieldValue.arrayUnion([review])
    });
  }

  Future<void> deleteReview(id, review) {
    return recipesRef.doc(id).update({
      'reviews': FieldValue.arrayRemove([review])
    });
  }

  incrementViews(String id) {
    return recipesRef.doc(id).update({'views': FieldValue.increment(1)});
  }

  updateLikes(String id, bool liked) {
    if (liked) {
      recipesRef.doc(id).update({'likes': FieldValue.increment(1)});
    } else {
      recipesRef.doc(id).update({'likes': FieldValue.increment(-1)});
    }
  }

  _buildFilterQuery(Query query, filters) {
    if (filters == null) return query;

    for (String key in filters.keys) {
      if (filters[key] != null && filters[key] != '') {
        var value;
        if (key.contains('Time')) {
          value = int.parse(filters[key]);
        } else {
          value = filters[key];
        }

        if (key.contains('ingredient')) {
          query = query.where('ingredientsList', arrayContains: value);
        } else {
          query = query.where(key, isEqualTo: value);
        }
      }
    }
    return query;
  }
}

final _RecipesService recipesService = _RecipesService();
